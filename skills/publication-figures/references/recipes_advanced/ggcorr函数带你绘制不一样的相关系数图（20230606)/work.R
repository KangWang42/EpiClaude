library(tidyverse)
library(GGally)

df <- read_tsv("data.xls")

df_named <- df[,11:22] %>% 
  dplyr::rename("HomeShots"=HS,
         "AwayShots"=AS,
         "HomeShots-on-Target"=HST,
         "AwayShots-on-Target"=AST,
         "HomeFouls"=HF,
         "AwayFouls"=AF,
         "HomeCorners"=HC,
         "AwayCorners"=AC,
         "HomeYellowCards"=HY,
         "AwayYellowCards"=AY,
         "HomeRedCards"=HR,
         "AwayRedCards"=AR)

ggcorr(df_named, method = c("pairwise"),  # 使用pairwise方法计算相关系数矩阵
       geom = "tile", max_size = 15,  # 使用圆形表示相关系数
       min_size = 5, nbreaks = 6,  # 设置相关系数的大小范围和分段数
       angle = 0,  # 设置圆形的角度
       palette = "RdYlBu",  # 设置调色板为红黄蓝
       hjust = 1, size = 4, color = "grey50",  # 设置相关系数标签的位置、大小和颜色
       layout.exp = 0.5,  # 设置相关系数标签的位置展示方式
       name = expression(rho)) +  # 设置相关系数标签的名称为ρ
  geom_point(size = 10, aes(color = coefficient > 0, 
                            alpha = abs(coefficient) > 0.5)) +  # 使用点表示系数大于0且绝对值大于0.5的相关系数，设置点的大小和颜色
  scale_alpha_manual(values = c("TRUE" = 0.25, "FALSE" = 0)) +  # 设置alpha值的映射关系，当系数满足条件时设置透明度为0.25，否则为0
  guides(alpha = FALSE) +  # 不显示alpha的图例
  theme(plot.margin = margin(0, 0, 0, 0, "pt"),  # 设置图的边距
        legend.background = element_blank(),  # 不显示图例的背景
        legend.spacing.x = unit(0, "cm"))  # 设置图例水平间距为0cm



