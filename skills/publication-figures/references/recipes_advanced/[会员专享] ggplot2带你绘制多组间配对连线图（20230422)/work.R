library(tidyverse)
library(ggtext)
library(grid)

# 读取数据
df <- read_tsv("data-2.xls")

# 设置变量名称
variable_names <- c("gdp_per_cap" = "GDP per<br>capita", 
                    "access_clean_fuels" = "Access to<br>clean fuels", 
                    "deaths_household_air_pollution" = "Share of deaths due to<br>indoor air pollution")

# 数据预处理
df_filter <- df %>% filter(continent != "Oceania") %>%   # 过滤掉大洋洲数据
  select(-population) %>%    # 删除人口列
  na.omit() %>%   # 去除缺失值
  group_by(country) %>%   # 按国家分组
  filter(year == max(year)) %>%  #  # 选取每个国家年份最大的数据
  ungroup() %>%  # 取消分组
  mutate(gdp_per_cap = log(gdp_per_cap))   # 对 gdp_per_cap 列进行对数变换

# 获取最小和最大分组间隔的函数
get_min_max_breaks <- function(x, breaks = seq(0, 1, 0.25), accuracy = c(1, 0.1, 0.01)) {
  # 计算数据范围
  range <- diff(range(x))   # 计算分组间隔值
  round(breaks * range, 0)
}

# 计算分组间隔数据框
breaks_df <- map_dfr(
  # 需要计算分组间隔的变量列表
  c("access_clean_fuels", "gdp_per_cap", "deaths_household_air_pollution"),
  # 对每个变量应用 get_min_max_breaks 函数
  ~ data.frame(
    variable = .x,
    step = seq(0, 1, 0.25),
    value = get_min_max_breaks(df_filter[[.x]])
  )) %>%
  mutate(
    # 修改变量名称为预设的名称
    variable = factor(variable_names[variable], levels = variable_names),
    # 根据不同变量类型格式化值
    value = case_when(
      # 百分比类型的变量
      variable %in% variable_names[c("access_clean_fuels", "deaths_household_air_pollution")] ~ paste0(value, "%"),
      # 其他类型的变量（如GDP）
      TRUE ~ scales::number(value, accuracy = 1, big.mark = ",")
    ))


df_filter%>% 
  # 对除国家、代码、年份、洲际之外的列进行归一化处理
  mutate(across(-c(country, code, year, continent),
                function(x) (x - min(x)) / (max(x) - min(x))))  %>% 
  # 将宽格式数据转换为长格式数据
  pivot_longer(cols = -c(country, code, year, continent), names_to = "variable") %>% 
  # 修改变量名并设置因子级别
  mutate(variable = variable_names[variable],
         variable = factor(variable, levels = variable_names)) %>% 
  # 绘制图形
  ggplot(aes(variable, value, group = country)) +   # 添加垂直线
  
  geom_vline(aes(xintercept = variable), color = "black", size = 0.8) +
  # 添加分组标签
  geom_text(data = breaks_df, aes(variable, step, label = value),
            inherit.aes = FALSE, color = "black", size = 2.5, hjust = 1,
            vjust = 0, nudge_x = -0.05) +
  # 添加连字符标签
  geom_text(data = breaks_df, aes(variable, step, label = "-"), inherit.aes = FALSE,
            size = 4, hjust = 1, color = "black") +
  geom_line(size = 0.2, alpha = 0.9, col = "#709AE1FF") + # 添加折线图
  geom_point(size = 0.2, col = "#709AE1FF") +   # 添加散点图
  scale_x_discrete(position = "bottom") +   # 设置x轴
  scale_y_continuous(expand = expansion(mult = c(0.1,0.1))) +   # 设置y轴
  facet_wrap(vars(continent), scales = "free_x") +   # 按大洲分面展示
  # 自定义主题
  theme(plot.background = element_rect(color = NA, fill = "white"),
        panel.background = element_blank(),
        axis.text.x.bottom = element_markdown(hjust = 0.5, halign = 0.5, size = 8, color = "black"),
        strip.text = element_text(size = 10, color = "black"),
        strip.background = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_blank(),
        panel.grid = element_blank(),
        panel.spacing.y = unit(8, "mm"),
        text = element_text(color = "black"))

