# 导入所需的库
library(tidyverse) 
library(cowplot)
library(lme4) # 用于拟合混合效应模型
library(sjPlot) # 用于创建可视化模型
library(sjmisc) # 用于处理数据
library(effects) # 用于计算模型效应
library(sjstats) # 用于统计模型

# 读取数据
me_data <- read_csv("mixedeff_herbivore.txt") # 从"mixedeff_herbivore.txt"中读取数据，将其赋值给me_data

# 拟合混合效应模型
mod <- lme4::lmer(log(elkhorn_LAI) ~ c.urchinden + c.fishmass +c.maxD + (1|site), 
                  REML= FALSE, data= subset(me_data, LAI_nonzero ==1)) # 使用lme4库的lmer函数拟合混合效应模型，模型公式为：log(elkhorn_LAI) ~ c.urchinden + c.fishmass + c.maxD + (1|site)

# 查看模型摘要
summary(mod) # 查看拟合模型的摘要

# 可视化模型
sjPlot::plot_model(mod) # 使用sjPlot库的plot_model函数可视化模型

# 自定义可视化模型
sjPlot::plot_model(mod, 
                   axis.labels=c("Urchin", "Depth", "Fish"),
                   show.values=TRUE, show.p=TRUE,
                   title="Effect of Herbivores on Coral Cover") # 自定义模型可视化，包括轴标签、显示值、显示p值和标题

# 生成模型表格
sjPlot::tab_model(mod) # 使用sjPlot库的tab_model函数生成模型表格

# 自定义模型表格
sjPlot::tab_model(mod, 
                  show.re.var= TRUE, 
                  pred.labels =c("(Intercept)", "Urchins", "Fish", "Depth"),
                  dv.labels= "Effects of Herbivores on Coral Cover") # 自定义模型表格，包括显示随机效应方差、预测标签和因变量标签

# 计算模型效应
effects_urchin <- effects::effect(term= "c.urchinden", mod= mod) # 使用effects库的effect函数计算模型中c.urchinden的效应
summary(effects_urchin) # 查看计算出的效应摘要

# 计算模型中 c.fishmass 的效应
effects_fishmass <- effects::effect(term= "c.fishmass", mod= mod)
summary(effects_fishmass) # 查看计算出的效应摘要

# 计算模型中 c.maxD 的效应
effects_maxD <- effects::effect(term= "c.maxD", mod= mod)
summary(effects_maxD) # 查看计算出的效应摘要

# 验证模型假设
# 残差诊断图
plot(mod) # 绘制模型的残差图，以检查模型诊断

# 模型选择和比较
# AIC (赤池信息准则) 和 BIC (贝叶斯信息准则) 比较
AIC(mod) # 计算模型的 AIC 值
BIC(mod) # 计算模型的 BIC 值

# 计算置信区间和预测区间
confint(mod) # 计算模型参数的置信区间
predict(mod, interval="confidence") # 计算模型的预测区间

# 将结果与现有研究或实际情况进行对比
# 在此处讨论您的研究结果与现有研究或实际情况的关系
















