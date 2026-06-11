library(tidyverse)
# remotes::install_local("ggsankey-main.zip",upgrade = F,dependencies = T)
library(ggsankey)
library(ggtext)


frogs <- read_csv("frogs.txt") %>%        # 从"frogs.txt"文件中读取数据，并将结果保存到变量frogs中
  arrange(Ordinal) %>%                   # 按照Ordinal列的值对数据进行排序
  mutate(SurveyDate = as.Date(SurveyDate, format = "%m/%d/%Y"),   # 将SurveyDate列转换为日期格式
         Gender = if_else(Female == 0, "Male", "Female")) %>%      # 根据Female列的值判断Gender
  group_by(Subsite) %>%                  # 按照Subsite列进行分组
  mutate(total = n()) %>%                # 计算每个分组中的观测数量，并将结果保存到total列中
  ungroup() %>%                          # 取消分组
  mutate(Subsite2 = glue::glue("<b>{Subsite}</b> ({total} frogs)"))  # 创建新的列Subsite2，包含HTML格式的文本

dt2 <- make_long(frogs, HabType, Water, Type, Structure, Substrate, value = "Subsite2")  # 使用make_long()函数对数据进行重塑，结果保存到dt2变量中

ggplot(dt2,aes(x = x, next_x = next_x, 
               node = node, next_node = next_node)) +                  # 创建一个ggplot对象，并指定数据和映射关系
  geom_sankey(flow.alpha = 0.5,node.fill = "#f5ccae",                  # 添加sankey流程图层，设置外观参数
              flow.fill = "#aeb4f5",node.color = "#aef5ef",
              flow.color = "#aef5ef",flow.size = 0.25,node.size = 0.25) +
  geom_sankey_text(aes(label = node), size = 3) +                      # 添加sankey流程图文本标签层
  facet_wrap(vars(value), scales = "free",ncol = 3) +                  # 按照value列进行分面，每行显示3个图形
  coord_cartesian(expand = TRUE, clip = "off") +                        # 设置坐标系，展开绘图范围并关闭裁剪
  theme_minimal() +                                                     # 使用最简主题
  theme(legend.position = "bottom",                                     # 设置主题参数
        panel.grid = element_blank(),
        panel.spacing = unit(1,"lines"),
        plot.background = element_rect(fill = "#f5faf8", color = "#f5faf8"),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        strip.text = element_markdown(margin = margin(t = 10, b = 5),face="bold",color="black"))
