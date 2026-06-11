
library(tidyverse)  
library(camcorder)  
library(ggtext)     
library(scales)   

# 读取CSV文件
plots <- readr::read_csv('plots.csv')      # 读取地块数据
species <- readr::read_csv('species.csv')  # 读取物种数据
surveys <- readr::read_csv('surveys.csv')  # 读取调查数据


survey <- surveys %>%
  left_join(species , by='species') %>%            # 将调查数据和物种数据连接
  group_by(commonname , month , sex ,  pregnant) %>% # 按物种名、月份、性别、怀孕状态分组
  count() %>%                                       # 计算每组的数量
  mutate(pregnant = ifelse(is.na(pregnant) , 'z' , pregnant) , # 处理空值，将空值设为'z'
         month = as.factor(month))                    # 将月份转换为因子类型

# 筛选出雌性动物的数据，并计算每个物种的总数
survey_f <- survey %>%
  filter(sex=='F') %>%                                # 筛选出雌性动物
  group_by(commonname) %>%                            # 按物种名分组
  summarise(n=sum(n))                                 # 计算每个物种的总数

# 计算雌性动物每个物种在每个月份的百分比
survey_plt_f <- survey %>%
  filter(sex=='F') %>%                                # 筛选出雌性动物
  left_join(survey_f %>% rename(tot_n = n), by='commonname') %>% # 连接雌性动物物种总数
  mutate(percent_n = n/tot_n)                         # 计算每个月份的百分比

# 按物种和月份分组，计算每个月份的百分比总和
survey_plt_f_mon <- survey_plt_f %>%
  group_by(commonname , month) %>%                    # 按物种名和月份分组
  summarise(mont_per = sum(percent_n) , .groups = 'drop') # 计算每个月份的百分比总和

# 计算每个物种在所有月份中的最小和最大百分比
survey_plt_f_mon_min_max <- survey_plt_f_mon %>%
  group_by(commonname) %>%                            # 按物种名分组
  summarise(min_mon = min(mont_per) , max_mon = max(mont_per) ) # 计算最小和最大百分比

# 计算每个物种在每个月份的权重

survey_plt_f_mon <- survey_plt_f_mon %>%
  left_join(survey_plt_f_mon_min_max , by='commonname') %>% # 连接最小和最大百分比数据
mutate(mon_wt = (mont_per - min_mon) / (max_mon - min_mon), # 计算权重1，归一化每个月的百分比
       mon_wt2 = (((mon_wt - 0) * (1 - 0.5)) / (1 - 0)) + 0.5 ) # 计算权重2，将权重1的范围调整为0.5到1将所有处理过的数据整合为一个数据集

sur_plt_f <- survey_plt_f %>%
  left_join(survey_plt_f_mon , by=c('commonname','month')) %>% # 连接每个月份的权重数据
  mutate(plt_n = percent_n / mont_per * mon_wt2)



# 利用筛选出的雌性动物数据绘制堆叠柱状图
survey %>%
  filter(sex=='F') %>%                                      # 筛选出雌性动物
  ggplot(aes(x=month , y=n , fill=pregnant)) +              # 使用ggplot绘图，x轴为月份，y轴为数量，按怀孕状态填充颜色
  geom_bar(position="fill" , stat = 'identity', show.legend = FALSE) + # 画堆叠柱状图，不显示图例
  facet_wrap(~commonname , ncol = 3 ) +                     # 按物种名进行分面展示，每行3个图
  scale_fill_manual(values=c("#0D2149", "#83C5BE")) +       # 手动设置填充颜色
  labs(x=NULL,y=NULL) +                                     # 不显示x轴和y轴的标签
  theme(
    panel.grid.major = element_blank(),                     # 去除主要网格线
    panel.grid.minor = element_blank(),                     # 去除次要网格线
    strip.background = element_blank())                     # 去除分面背景

survey %>% 
  filter(sex=='F') %>%                                      # 筛选出雌性动物
  ggplot(aes(x=month , y=n , fill=pregnant)) +              # 使用ggplot绘图，x轴为月份，y轴为数量，按怀孕状态填充颜色
  geom_bar(stat = 'identity', position = 'fill' ,  show.legend = FALSE) + # 画堆叠柱状图，不显示图例
  coord_polar() +                                           # 使用极坐标系（环形图）
  facet_wrap(~commonname , ncol = 6) +                      # 按物种名进行分面展示，每行6个图
  geom_point(data=survey_f , aes(x=1,y=0 ) , inherit.aes = FALSE , size = 10 , color='white')+ # 添加一个点，显示每个物种的总数
  geom_text(data=survey_f , aes(x=1,y=0 , label=comma(n)) , inherit.aes = FALSE , size=2.5)+ # 添加文本，显示每个物种的总数
  scale_fill_manual(values=c("#0D2149", "#83C5BE")) +       # 手动设置填充颜色
  labs(x=NULL,y=NULL) +                                     # 不显示x轴和y轴的标签
  theme_minimal() +                                         # 使用简约主题
  theme(
    panel.grid.major = element_blank(),                     # 去除主要网格线
    panel.grid.minor = element_blank(),                     # 去除次要网格线
    axis.text.x = element_text(size=6),                     # 设置x轴文本大小
    axis.text.y = element_blank(),                          # 不显示y轴文本
    strip.text = element_text(size = 6))                    # 设置分面标题文本大小


sur_plt_f %>%
  ggplot(aes(x=month , y=plt_n , fill=pregnant)) +          # 使用ggplot绘图，x轴为月份，y轴为plt_n，按怀孕状态填充颜色
  geom_bar(stat = 'identity',  show.legend = FALSE) +       # 画堆叠柱状图，不显示图例
  coord_polar() +                                           # 使用极坐标系（环形图）
  geom_point(data=survey_f , aes(x=1,y=0 ) , inherit.aes = FALSE , size = 4 , color='white' , alpha=0.75) + # 添加一个点，显示每个物种的总数
  geom_text(data=survey_f , aes(x=1,y=0 , label=comma(n)) , inherit.aes = FALSE , size=1.5) + # 添加文本，显示每个物种的总
  facet_wrap(~commonname, ncol = 6) + # 按物种名进行分面展示，每行6个图
  scale_fill_manual(values=c("#0D2149", "#83C5BE")) + # 手动设置填充颜色
  labs(x=NULL, y=NULL) + # 不显示x轴和y轴的标签
  theme_minimal() + # 使用简约主题
  theme(
    panel.grid.major = element_blank(), # 去除主要网格线
    panel.grid.minor = element_blank(), # 去除次要网格线
    axis.text.x = element_text(size=6,color="black"), # 设置x轴文本大小
    axis.text.y = element_blank(), # 不显示y轴文本
    strip.text = element_text(size = 6, face="bold", color="black")) # 设置分面标题文本大小，并加粗显示，黑色字体





