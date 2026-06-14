# 配方检索目录（recipes_catalog）—— 出图前 grep 这里按意图定位

> 自动生成（scripts/build_catalog.R），共 169 条。库更新后重跑重生成。
> 用法：按意图关键词（热图/森林/云雨/桑基/网络/生存/ROC/火山…）grep 本表 → 命中行的「路径」开 work.R（进阶配方同目录常有 .md 教程 + 渲染预览，先 Read 预览看效果再借鉴）。
> 落地仍按 SKILL.md §1–§12 重写为发表级（原脚本多为教程风，不达发表级）。

| 区 | 图型 | 关键包 | 技法 | 资料 | 路径 |
|---|---|---|---|---|---|
| 常用 | GO圈图 | clusterProfiler, org.Hs.eg.db, enrichplot, ggplot2, GOplot |  | 代码 | `recipes_common_50/31GO圈图.R` |
| 常用 | KEGG圈图 | clusterProfiler, org.Hs.eg.db, enrichplot, ggplot2, GOplot |  | 代码 | `recipes_common_50/32KEGG圈图.R` |
| 常用 | PCA图 | ggplot2 |  | 代码 | `recipes_common_50/45PCA图.R` |
| 常用 | ROC曲线 | pROC |  | 代码 | `recipes_common_50/40ROC曲线.R` |
| 常用 | UpSet图 | UpSetR |  | 代码 | `recipes_common_50/21UpSet图.R` |
| 常用 | venn图 | VennDiagram |  | 代码 | `recipes_common_50/20venn图.R` |
| 常用 | 棒棒糖图 | ggpubr |  | 代码 | `recipes_common_50/30棒棒糖图.R` |
| 常用 | 饼图 |  |  | 代码 | `recipes_common_50/28饼图.R` |
| 常用 | 差异箱线图 | ggpubr |  | 代码 | `recipes_common_50/07差异箱线图.R` |
| 常用 | 成对差异分析 |  |  | 代码 | `recipes_common_50/14成对差异分析.R` |
| 常用 | 堆积百分比柱状图 |  |  | 代码 | `recipes_common_50/04堆积百分比柱状图.R` |
| 常用 | 多GSEA富集图 | plyr, ggplot2, grid, gridExtra |  | 代码 | `recipes_common_50/33多GSEA富集图.R` |
| 常用 | 多基因差异箱线图 | reshape2, ggpubr |  | 代码 | `recipes_common_50/08多基因差异箱线图.R` |
| 常用 | 多基因小提琴图 | reshape2, ggpubr |  | 代码 | `recipes_common_50/12多基因小提琴图.R` |
| 常用 | 多时间点生存ROC曲线 | survival, survminer, timeROC |  | 代码 | `recipes_common_50/43多时间点生存ROC曲线.R` |
| 常用 | 多指标ROC曲线 | pROC |  | 代码 | `recipes_common_50/41多指标ROC曲线.R` |
| 常用 | 多指标生存ROC曲线 | survival, survminer, timeROC |  | 代码 | `recipes_common_50/44多指标生存ROC曲线.R` |
| 常用 | 多组差异箱线图 | ggpubr |  | 代码 | `recipes_common_50/09多组差异箱线图.R` |
| 常用 | 分类柱状图 | ggpubr |  | 代码 | `recipes_common_50/05分类柱状图.R` |
| 常用 | 火山图 | ggplot2 |  | 代码 | `recipes_common_50/19火山图.R` |
| 常用 | 基因组可视化 | karyoploteR |  | 代码 | `recipes_common_50/48基因组可视化.R` |
| 常用 | 解剖图 | devtools, gganatogram, dplyr, viridis, gridExtra |  | 代码 | `recipes_common_50/51解剖图.R` |
| 常用 | 雷达图 | fmsb |  | 代码 | `recipes_common_50/26雷达图.R` |
| 常用 | 离散变量生存曲线 | survival, survminer |  | 代码 | `recipes_common_50/34离散变量生存曲线.R` |
| 常用 | 连续变量生存曲线 | survival, survminer |  | 代码 | `recipes_common_50/35连续变量生存曲线.R` |
| 常用 | 联系变量生存曲线(最优cutoff) | survival, survminer |  | 代码 | `recipes_common_50/36联系变量生存曲线(最优cutoff).R` |
| 常用 | 列线图 | rms |  | 代码 | `recipes_common_50/39列线图.R` |
| 常用 | 临床相关性热图 | pheatmap |  | 代码 | `recipes_common_50/18临床相关性热图.R` |
| 常用 | 排序箱线图 | plyr, ggpubr |  | 代码 | `recipes_common_50/06排序箱线图.R` |
| 常用 | 偏差图 | ggpubr |  | 代码 | `recipes_common_50/16偏差图.R` |
| 常用 | 瀑布图 | maftools |  | 代码 | `recipes_common_50/50瀑布图.R` |
| 常用 | 气泡图 | ggpubr |  | 代码 | `recipes_common_50/15气泡图.R` |
| 常用 | 圈图 | circlize |  | 代码 | `recipes_common_50/47圈图.R` |
| 常用 | 热图 | pheatmap |  | 代码 | `recipes_common_50/17热图.R` |
| 常用 | 三维PCA图 | scatterplot3d |  | 代码 | `recipes_common_50/46三维PCA图.R` |
| 常用 | 桑基图 | ggalluvial, ggplot2, dplyr |  | 代码 | `recipes_common_50/27桑基图.R` |
| 常用 | 森林图 |  |  | 代码 | `recipes_common_50/38森林图.R` |
| 常用 | 生存ROC曲线 | survival, survminer, timeROC |  | 代码 | `recipes_common_50/42生存ROC曲线.R` |
| 常用 | 树形图 |  |  | 代码 | `recipes_common_50/49树形图.R` |
| 常用 | 双基因生存曲线 | survival, survminer |  | 代码 | `recipes_common_50/37双基因生存曲线.R` |
| 常用 | 显著性气泡图 | ggplot2 |  | 代码 | `recipes_common_50/29显著性气泡图.R` |
| 常用 | 显著性柱状图 | ggplot2 |  | 代码 | `recipes_common_50/03显著性柱状图.R` |
| 常用 | 相关性圈图 | corrplot, circlize |  | 代码 | `recipes_common_50/24相关性圈图.R` |
| 常用 | 相关性热图 | corrplot |  | 代码 | `recipes_common_50/23相关性热图.R` |
| 常用 | 相关性散点图 | ggplot2, ggpubr, ggExtra |  | 代码 | `recipes_common_50/22相关性散点图.R` |
| 常用 | 相关性网络图 | igraph, reshape2 |  | 代码 | `recipes_common_50/25相关性网络图.R` |
| 常用 | 箱线图分面 | ggplot2, reshape2 |  | 代码 | `recipes_common_50/10箱线图分面.R` |
| 常用 | 小提琴图 | ggpubr |  | 代码 | `recipes_common_50/11小提琴图.R` |
| 常用 | 小提琴图分面 | ggplot2, reshape2 |  | 代码 | `recipes_common_50/13小提琴图分面.R` |
| 常用 | 柱状图 |  |  | 代码 | `recipes_common_50/02柱状图.R` |
| 进阶 |  | cropcircles, dplyr, ggimage, magick |  | 预览 | `recipes_advanced/20230218` |
| 进阶 |  |  |  |  | `recipes_advanced/20230425` |
| 进阶 | circlize绘制复杂基因组图 | circlize, ComplexHeatmap |  | 预览 | `recipes_advanced/[会员专享] circlize绘制复杂基因组图(20230210)` |
| 进阶 | ComplexHeatmap优雅的绘制相关性热图 | ComplexHeatmap, Hmisc, circlize | 本节来介绍如何使用ComplexHeatmap包来自定义函数绘制相关性热图并添加显著性标记，使用R内置数据集，有兴趣的观众老爷欢迎分享转发。 | 教程 | `recipes_advanced/ComplexHeatmap优雅的绘制相关性热图(20230301)` |
| 进阶 | DrugSim2DR优雅的绘制化合物结构图 | DrugSim2DR, ChemmineR, rvest | 本节来介绍一款R包DrugSim2DR，可以计算DEscore、药物功能相似性、绘制化合物的化学结构等功能;下面来介绍该R包的一个小例子 | 教程+预览 | `recipes_advanced/DrugSim2DR优雅的绘制化合物结构图(20230116)` |
| 进阶 | eyedroppeR精准获取图片中的颜色代码 | eyedroppeR |  | 预览 | `recipes_advanced/eyedroppeR精准获取图片中的颜色代码（20230623)` |
| 进阶 | funkyheatmap优雅的可视化数据框 | funkyheatmap | 本节来分享一个R包funkyheatmap，其主要可用来将数据框可视化热图的形式来进行展示，功能很是强大，更多详细的内容请阅读funkyhe… | 教程+预览 | `recipes_advanced/funkyheatmap优雅的可视化数据框(20230115)` |
| 进阶 | ggbrick绘制砖块风柱状图 | ggbrick | 之前介绍过ggbrick绘制砖块华夫图的案例，小编突然想到由于砖块可对应数值因此用其来展示柱状图也是很形象生动，下面小编就通过一个案例来进行… | 教程 | `recipes_advanced/ggbrick绘制砖块风柱状图(20230715)` |
| 进阶 | ggcorr函数带你绘制不一样的相关系数图 | GGally | 本节来介绍如何使用GGally包自带的函数来绘制相关性系数图，虽然corrplot很是强大但是相关的R包也算有一定的可取之处。下面就来通过一… | 教程 | `recipes_advanced/ggcorr函数带你绘制不一样的相关系数图（20230606)` |
| 进阶 | ggeadar高度自定义你的雷达图 | ggtext, ggradar | 春节假期已经结束该开始认真更新内容，本节来介绍如何使用ggeadar来高度自定义绘制雷达图，绘图过程比较简单主要还是数据清洗及细节的把握。数… | 教程+预览 | `recipes_advanced/ggeadar高度自定义你的雷达图(20230129)` |
| 进阶 | ggflowchart优雅的绘制流程图 | ggflowchart, rcartocolor |  | 预览 | `recipes_advanced/ggflowchart优雅的绘制流程图(20230514)` |
| 进阶 | ggforce优雅的绘制多组椭圆图 | ggforce, PrettyCols | 本节来介绍如何使用ggforce包来自定义绘制多组椭圆图，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅作图形展示用，希望各位观… | 教程 | `recipes_advanced/ggforce优雅的绘制多组椭圆图(20230705)` |
| 进阶 | ggforce优雅的绘制线圈棒棒糖图 | janitor, ggtext, ggforce, ggfx, colorspace | 本节来介绍如何使用ggforce包来自定义画线圈来绘制棒棒糖图，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅作图形展示用，希望… | 教程 | `recipes_advanced/ggforce优雅的绘制线圈棒棒糖图` |
| 进阶 | gggibbous带你绘制月亮散点图 | data.table, ggforce, ggtext, ggnewscale, paletteer, packcircles |  | 预览 | `recipes_advanced/gggibbous带你绘制月亮散点图20230725` |
| 进阶 | ggplot2带你绘制多组间配对连线图 | ggtext, grid | 以往介绍的配对线图基本都是两组之间，那么多组之间该如何进行操作。本节来介绍三组数据间进行配对连线并添加不同的Y轴刻度，代码部分小编做了详细的… | 教程+预览 | `recipes_advanced/[会员专享] ggplot2带你绘制多组间配对连线图（20230422)` |
| 进阶 | ggplot2带你绘制旭日图- | ggtext |  |  | `recipes_advanced/ggplot2带你绘制旭日图-20230807` |
| 进阶 | ggplot2带你组合绘制桑基图+富集分析图 | ggsankey, RColorBrewer, cowplot |  | 预览 | `recipes_advanced/ggplot2带你组合绘制桑基图+富集分析图(20230114)` |
| 进阶 | ggplot2高度自定义绘制游泳图 |  | 本节来介绍如何使用ggplot2来绘制一张游泳图,图形结构比较简洁但主要还是局部细节的调控，下面来通过代码详细介绍一下，当然此图还有不完美的… | 教程+预览 | `recipes_advanced/[会员专享]ggplot2高度自定义绘制游泳图(20230308)` |
| 进阶 | ggplot2给柱状图部分区域添加阴影布局 | xlsx, janitor, ggpattern, shadowtext, camcorder |  | 预览 | `recipes_advanced/ggplot2给柱状图部分区域添加阴影布局(20230320)` |
| 进阶 | ggplot2给柱状图添加logo标记 | ggtext | 本节来介绍如何使用ggplot2将常规的柱状图绘制的更加丰富多彩，如果物种有图标进行添加那此段代码实在是非常的合适，下面小编就通过一个案例来… | 教程 | `recipes_advanced/[会员专享] ggplot2给柱状图添加logo标记（20230728)` |
| 进阶 | ggplot2构建图层注释拟合曲线 | gapminder, ggsci, ggpmisc, patchwork |  | 预览 | `recipes_advanced/[会员专享]ggplot2构建图层注释拟合曲线` |
| 进阶 | ggplot2构建误差线组图并添加组间显著性标记 | ggsci, rstatix, ggpubr, cowplot | 本节来复现nature上的一张小图介绍如何使用ggplot2构建误差线组图并添加组间显著性标记， | 教程 | `recipes_advanced/ggplot2构建误差线组图并添加组间显著性标记（20230813)` |
| 进阶 | ggplot2绘图添加特殊标记符 | ggtext, showtext | 本节来介绍如何使用ggplot2绘图时使用showtext添加特殊字符集合，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅作图形… | 教程 | `recipes_advanced/[会员专享]ggplot2绘图添加特殊标记符20230727` |
| 进阶 | ggplot2绘制Apple Watch表带风格图- | truchet, MetBrewer, ggtext, camcorder | 本节来通过ggplot2包来绘制Apple Watch表带风格的可视化图表，非常的有趣，数据+代码已经上传2023 | 教程+预览 | `recipes_advanced/[会员专享]ggplot2绘制Apple Watch表带风格图-20230501` |
| 进阶 | ggplot2绘制logo版环状条形图- | countrycode, ggflags, ggtext | 本节来介绍如何使用ggplot2结合ggflags来给环状条形图添加地理图标注释，下面小编通过一个案例来进行展示，图形仅供展示用，希望各位观… | 教程 | `recipes_advanced/ggplot2绘制logo版环状条形图-20230905` |
| 进阶 | ggplot2绘制半透明云雨图- | ggtext, camcorder, scales, ggsci, ggdist, gghalves | 本节来介绍如何使用ggplot2来批量绘制云雨图，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅作图形展示用，希望各位观众老爷能… | 教程 | `recipes_advanced/ggplot2绘制半透明云雨图-20230821` |
| 进阶 | ggplot2绘制多年份配对连线表 | ggplot2, dplyr, bstfun, patchwork, gt, scales | 本节来介绍如何使用ggplot2对表格之间进行数据的配对连线，发现有一款R包bstfun可以将gt绘制的表格转化为ggplot格式，通过其来… | 教程 | `recipes_advanced/[会员专享] ggplot2绘制多年份配对连线表(20230718)` |
| 进阶 | ggplot2绘制多重注释热图 | ggh4x, patchwork, readxl, scales | 1.如何对X轴文本添加分组线条即文本 | 教程 | `recipes_advanced/[会员专享] ggplot2绘制多重注释热图(20230529)` |
| 进阶 | ggplot2绘制多组趋势变化图 | patchwork, janitor, glue, ggtext | 本节来介绍如何绘制多组面积线图来展示趋势变化，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅作图形展示用，希望各位观众老爷能够喜… | 教程 | `recipes_advanced/ggplot2绘制多组趋势变化图（20230707)` |
| 进阶 | ggplot2绘制个性化注释哑铃图 | ggforce | 本节来介绍如何使用ggplot2来优化细节来丰富注释哑铃图，数据为随意构建无任何意义仅供参考。整张图均使用R代码进行绘制，数据+代码已经上传… | 教程+预览 | `recipes_advanced/[会员专享] ggplot2绘制个性化注释哑铃图(20230318)` |
| 进阶 | ggplot2绘制各大洲人类发展指数概率密度分布图 | ungeviz, broom, emmeans | 本节来通过ungeviz包介绍如何对各大洲人类发展指数变化趋势进行分析与可视化，主要分析了1990年和2021年各大洲的人类发展指数（HDI… | 教程 | `recipes_advanced/ggplot2绘制各大洲人类发展指数概率密度分布图（20230429)` |
| 进阶 | ggplot2绘制局部放大柱状图 | scales, patchwork, ggsci | 本节来介绍如何使用ggplot2来对柱状图局部进行放大，，数据为随意构建无任何意义仅供参考。整张图均使用R代码进行绘制，数据+代码已经上传2… | 教程 | `recipes_advanced/[会员专享] ggplot2绘制局部放大柱状图(20230324)` |
| 进阶 | ggplot2绘制矩形比例图 | janitor, MetBrewer | 本节来介绍一个可视化案例，将常见的饼图通过矩形的方式来进行比例的展示，有合适的数据可以尝试此案例。数据+代码已经上传2023 | 教程 | `recipes_advanced/[会员专享] ggplot2绘制矩形比例图(20230525)` |
| 进阶 | ggplot2绘制热图标准化从0-1 | vegan, scico | 最近有朋友询问绘制热图时如何使刻度条展示为从0-1，这就涉及对数据进行标准化的特殊处理，通常对数据进行处理无外乎取log或者直接使用scal… | 教程 | `recipes_advanced/ggplot2绘制热图标准化从0-1（20230624)` |
| 进阶 | ggplot2绘制哑铃图进行趋势展示 | ggh4x | 本节来介绍如何使用ggplot2来绘制哑铃图并通过线段的连接来进行趋势变化展示，数据无实际意义仅作图形展示用，希望各位观众老爷能够喜欢。数据… | 教程 | `recipes_advanced/[会员专享] ggplot2绘制哑铃图进行趋势展示(20230713)` |
| 进阶 | ggplot2可视化全球气候变化 | ggtext | 本节来介绍如何使用ggplot2来展示全球气温变化情况，通过绘制连续型线段的形式来进行数据的展示，数据无实际意义仅作图形展示用，希望各位观众… | 教程 | `recipes_advanced/[会员专享] ggplot2可视化全球气候变化(20230712)` |
| 进阶 | ggplot2批量绘制物种环状图 | camcorder, ggtext, scales | 本节来介绍一个案例批量绘制环状条形图，涉及众多的数据清洗步骤，数据+代码已经上传2023 | 教程 | `recipes_advanced/[会员专享]ggplot2批量绘制物种环状图（20230506)` |
| 进阶 | ggplot2轻松绘制误差线点图与箱线图 | gapminder, ggsci, patchwork |  | 教程 | `recipes_advanced/ggplot2轻松绘制误差线点图与箱线图(20230616)` |
| 进阶 | ggplot2优雅的绘制多彩折线图 | ggforce, ggtext | 本节来介绍使用ggplot2来通过添加背景色的方式来展示数据，主要使用ggforce包来绘制圆圈ggrect函数来绘制背景。 | 教程 | `recipes_advanced/ggplot2优雅的绘制多彩折线图(20230720)` |
| 进阶 | ggplot2优雅的绘制发光点图- | janitor, ggtext, ggforce, ggfx | 本节来介绍如何使用ggplot2结合ggfx来绘制发光点图，下面小编通过一个案例来进行展示，图形仅供展示用，希望各位观众老爷能够喜欢。数据代… | 教程 | `recipes_advanced/ggplot2优雅的绘制发光点图-20230908` |
| 进阶 | ggplot2优雅的绘制箭头表格图- | ggfittext, ggtext, scales | 本节来介绍如何使用ggplot2来绘制箭头表格，主要使用geom_segment函数来实现，下面小编通过一个案例来进行展示，图形仅供展示用，… | 教程 | `recipes_advanced/ggplot2优雅的绘制箭头表格图-20230901` |
| 进阶 | ggplot2优雅的批量绘制圆形地图 | maps, sf, tidygeocoder, camcorder, scico, rnaturalearth | 本节来介绍如何使用sf包来批量绘制圆形地图，主要展示如何使用分面的功能来绘制多个。结果仅供参考，下面小编就通过一个基础案例来进行展示，希望各… | 教程 | `recipes_advanced/ggplot2优雅的批量绘制圆形地图(20230625)` |
| 进阶 | ggplot2优雅的修改图例大小 | ggpubr, ggprism, patchwork, ggsci |  | 预览 | `recipes_advanced/ggplot2优雅的修改图例大小(20230213)` |
| 进阶 | ggplot2优雅绘制pro版常规图 | lubridate, camcorder, ggtext, glue, sf, lwgeom | 还在绘制常规的折线图吗，本节来介绍如何使用R代码来绘制一个风格迥异的折线图，使你的图形更加丰富多彩。数据+代码已经上传2023 | 教程 | `recipes_advanced/[会员专享] ggplot2优雅绘制pro版常规图(20230415)` |
| 进阶 | ggplot2优雅绘制pro版柱状图 | ggforce, janitor, data.table, patchwork | 还在绘制常规的柱状图吗，本节来介绍如何使用R代码来绘制一个风格迥异的柱状图，使你的图形更加丰富多彩。数据+代码已经上传2023 | 教程 | `recipes_advanced/[会员专享] ggplot2优雅绘制pro版柱状图(20230418)` |
| 进阶 | ggplot2优雅绘制别致条形图- | ggtext, ggforce | 本节来介绍如何使用ggplot2结合ggforce来绘制一个别具一格的条形图，下面小编通过一个案例来进行展示，图形仅供展示用，希望各位观众老… | 教程 | `recipes_advanced/ggplot2优雅绘制别致条形图-20230909` |
| 进阶 | ggplot2优雅绘制分布棒棒糖图 | magrittr, ggprism, MetBrewer, ggh4x, cowplot | 最近在交流群内看到一张图觉得挺有美感的，本节来进行复现一下希望对各位有所帮助。数据结果仅供参考,绘图过程倒也容易主要是细节的掌控。数据+代码… | 教程+预览 | `recipes_advanced/[会员专享] ggplot2优雅绘制分布棒棒糖图（20230214)` |
| 进阶 | ggplot2优雅绘制轨迹趋势散点 | ggforce, janitor | 本节来介绍如何使用使用ggplot2来绘制带有轨迹的散点图。整张图均使用R代码进行绘制，数据+代码已经上传2023 | 教程+预览 | `recipes_advanced/ggplot2优雅绘制轨迹趋势散点(20230331)` |
| 进阶 | ggplot2优雅绘制环状堆砌条形图- | ggtext, showtext | 本节来介绍如何使用ggplot2来绘制环状堆砌条形图，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅作图形展示用，希望各位观众老… | 教程 | `recipes_advanced/ggplot2优雅绘制环状堆砌条形图-20230817` |
| 进阶 | ggplot2优雅绘制极坐标气泡图 | ggsci | 最近在交流群中看到有朋友询问如何在极坐标上绘制气泡图，其原理跟绘制散点图也类似只是将坐标换为了极坐标，下面通过R代码构建数据来进行展示，直接… | 教程 | `recipes_advanced/ggplot2优雅绘制极坐标气泡图(20230401)` |
| 进阶 | ggplot2优雅绘制金子塔图- | ggtext, patchwork, showtext | 本节来介绍如何使用ggplot2来绘制年龄分布金子塔图，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅作图形展示用，希望各位观众… | 教程 | `recipes_advanced/ggplot2优雅绘制金子塔图-20230814` |
| 进阶 | ggplot2优雅绘制进阶版配对点图 | ggtext, glue | 本节再来介绍一个如何使用ggplot2绘制进阶版的配对点图，代码部分小编做了详细的注释， | 教程+预览 | `recipes_advanced/ggplot2优雅绘制进阶版配对点图（20230404)` |
| 进阶 | ggplot2优雅绘制热图添加双箭头注释- | readxl, magrittr, grid, cowplot | 本节来介绍如何使用ggplot2来绘制热图并添加双向箭头添加注释，下面小编通过一个案例来进行展示，图形仅供展示用，希望各位观众老爷能够喜欢。… | 教程 | `recipes_advanced/ggplot2优雅绘制热图添加双箭头注释-20230904` |
| 进阶 | ggplot2优雅绘制山脊图(进阶版 | ggsci, ggridges, ggtext, ggh4x, magick | 本节来介绍一个ggplot2绘制山脊的小栗子，在以往的细节上做了微调使得图形更加富有美感，感兴趣的朋友也可尝试进行更进一步的优化；希望对各位… | 教程+预览 | `recipes_advanced/ggplot2优雅绘制山脊图(进阶版20230208)` |
| 进阶 | ggplot2展示不同年份数据间增长率 | tidytuesdayR, lubridate, scales, ggimage, ggbump, ggtext | 本节再来介绍一个如何如何组合绘制哑铃图与条形图来展示不同年份之间数据间的增长率，代码部分小编做了详细的注释， | 教程 | `recipes_advanced/[会员专享] ggplot2展示不同年份数据间增长率(20230407)` |
| 进阶 | ggplot2自定义调整分面图形布局 | ggsci | 本节来介绍一个常见的绘图案例，调节分面图形的布局提高图形的观赏性，非常简单的一个小案例，喜欢的观众老爷欢迎收藏转发。 | 教程+预览 | `recipes_advanced/ggplot2自定义调整分面图形布局(20230303)` |
| 进阶 | ggplot2自定义绘制多彩热图 | glue, ggtext, janitor | 本节来介绍使用ggplot2绘制热图，通过自定义细节添加折线来展示数据的变化趋势，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅… | 教程 | `recipes_advanced/[会员专享] ggplot2自定义绘制多彩热图（20230721)` |
| 进阶 | ggplot2自构函数批量绘制蜂窝图- | janitor, glue, ggtext, forcats, ggbeeswarm, emojifont | 本节来介绍如何使用ggplot2结合ggbeeswarm来自定义函数批量绘制蜂窝图，下面小编通过一个案例来进行展示，图形仅供展示用，希望各位… | 教程 | `recipes_advanced/ggplot2自构函数批量绘制蜂窝图-20230912` |
| 进阶 | ggplot2组合绘制相关性箱线图 | ggsci, ggprism, rstatix, ggpubr, magrittr, MetBrewer | 关于如何计算组内相关性及绘图请继续往后看，有需要学习个性化数据可视化的朋友，欢迎到小编的 | 教程 | `recipes_advanced/[会员专享] ggplot2组合绘制相关性箱线图（20230701)` |
| 进阶 | ggraph带你绘制网络饼图- | igraph, ggraph, graphlayouts, ggforce, scatterpie, ggsci |  |  | `recipes_advanced/ggraph带你绘制网络饼图-20230809` |
| 进阶 | ggraph带你轻松绘制简版网络图 | janitor, ggtext, igraph, ggraph, ggsci | 本节再来介绍一个如何通过ggraph来轻松绘制一个简版的网络图 代码部分小编做了详细的注释， | 教程+预览 | `recipes_advanced/[会员专享] ggraph带你轻松绘制简版网络图（20230408)` |
| 进阶 | ggraph带你轻松绘制网络图的案例 | igraph, ggraph, widyr | 可以看到非常的简单，好了今天的介绍到此结束；喜欢的观众老爷欢迎分享转发，有学习需求者欢迎到小编 | 教程+预览 | `recipes_advanced/ggraph带你轻松绘制网络图的案例(20230428)` |
| 进阶 | ggraph绘制网络流程图 | tidygraph, ggraph, ggtext, glue | 本节来介绍如何使用ggraph包来绘制网络流程图，下面小编就通过一个案例来进行展示数据为随意构建无实际意义仅作图形展示用，添加了详细的注释希… | 教程 | `recipes_advanced/ggraph绘制网络流程图(20230802)` |
| 进阶 | ggraph轻松绘制网络图 | "tidyverse", "glue", "ggtext", "sf", "tidygraph", "ggraph" | 本节再来介绍一个如何使用ggraph绘制网络图的案例，相较以往做了一些详细的注释，数据+代码已经上传2023 | 教程+预览 | `recipes_advanced/[会员专享]ggraph轻松绘制网络图(20230403)` |
| 进阶 | ggsankey绘制精美的sankey流程图 | ggsankey, ggtext | 之前介绍了如何使用networkD3包来绘制交互式桑基图，本节再来介绍如何使用ggsankey绘制有多个分类变量的桑基图。下面就来通过一个小… | 教程 | `recipes_advanced/ggsankey绘制精美的sankey流程图(20230605)` |
| 进阶 | ggsimplex优雅的绘制三角密度图2) | ggsimplex, brms | 本节来介绍一款R包ggsimplex主要用来绘制三角形密度图及点图，此包的介绍文档很是详细作者有丰富的案例，详细的文档请参考作者的官方文档。… | 教程+预览 | `recipes_advanced/ggsimplex优雅的绘制三角密度图(202230212)` |
| 进阶 | ggtools轻松转换RGB颜色值 | ggtools |  |  | `recipes_advanced/ggtools轻松转换RGB颜色值(20230202)` |
| 进阶 | ggtools一款简化数据分析的多用途R包 | ggtools | 本次介绍此R包的第一个函数如何批量修改字符串 | 教程 | `recipes_advanced/ggtools一款简化数据分析的多用途R包(20230131)` |
| 进阶 | ggtree绘制带有图像轮廓的系统发育树 | rotl, ggtree, ggimage, extrafont | 本节来介绍如何使用ggtree绘制动物之间的系统发育树并添加动物轮廓。图形的绘制过程比较简单，主要是数据的整理。数据已经上传2023 | 教程+预览 | `recipes_advanced/ggtree绘制带有图像轮廓的系统发育树(20230203)` |
| 进阶 | ggtrendline优雅的添加多模型拟合曲线 | ggtrendline | 本节来介绍一款R包ggtrendline可以向图形添加线性或非线性回归模型的趋势线及置信区间包含众多的模型，并可简单地向ggplot添加方程… | 教程 | `recipes_advanced/ggtrendline优雅的添加多模型拟合曲线(20230402)` |
| 进阶 | imeta图表复现之相关性组合热图 | readxl, linkET, RColorBrewer, ggtext, magrittr, ggnewscale | 本节来复现imeta上的一张图相关性组合热图该图相关的表现形式小编以前有做过介绍，但是此图也有些许的不同，此篇论文中的绝大多数图表小编以前都… | 教程+预览 | `recipes_advanced/[会员专享] imeta图表复现之相关性组合热图` |
| 进阶 | ISME图表复现之PCA分析图添加统计信息 | ggrepel, FactoMineR, magrittr, factoextra, RColorBrewer, ggh4x | 本节来复现ISME上的一张CCA分析的图，作者在常规CCA分析图上加上了一下新的元素使得整体看来有些许特别之处；下面小编就来简单复现一下，数… | 教程 | `recipes_advanced/[会员专享]ISME图表复现之PCA分析图添加统计信息(20230612)` |
| 进阶 | metanetwork带你优雅的绘制特色网络图 | devtools, metanetwork, igraph, ggimage |  | 预览 | `recipes_advanced/metanetwork带你优雅的绘制特色网络图` |
| 进阶 | nature biotechnology图表复现高端个性化合图 | readxl, ggprism, ggtree, cowplot, patchwork | 本节来复现nature biotechnology上一篇新文章的图表整体还是非常美观的作者细节处理非常的到位，下面来进行复现过程，由于未找到… | 教程+预览 | `recipes_advanced/[会员专享] nature biotechnology图表复现高端个性化合图(20220221)` |
| 进阶 | nature communications图表复现之个性化地图绘制 | tidygeocoder, sf, camcorder, scico, rnaturalearth, terra | 本节来复现nature communications上一篇文章中地图的绘制方法，下面来进行复现过程，由于未找到作者提供的数据信息，小编自己构… | 教程+预览 | `recipes_advanced/[会员专享] nature communications图表复现之个性化地图绘制(20230311)` |
| 进阶 | nature medicine图表复现值热图叠加多种注释 | grid, pBrackets | 本节来复现nature medicine上的一张图；其本质还是热图的绘制只不过在常规热图的基础上介绍如何添加方括号及文本注释，由于原数据过大… | 教程 | `recipes_advanced/nature medicine图表复现值热图叠加多种注释（20230531)` |
| 进阶 | nature microbiology图表复现之创新热图绘制技巧 | readxl, ggsci, patchwork, ggnewscale | 本节来复现nature microbiology 上一篇文章中的热图，常见的数据类型小编在原图的基础上做了一些优化；将离散型变量与连续型变量… | 教程+预览 | `recipes_advanced/[会员专享] nature microbiology图表复现之创新热图绘制技巧(20230510)` |
| 进阶 | nature microbiology图表复现之基因丰度图 | readxl, ggtree, cowplot, patchwork, ggh4x, magrittr | 本节来复现NC上的一张图，绘制带阴影的箱线图；整体看起来图形比较基础但是细节也是比较多的，下面来通过代码详细介绍一下，数据+代码已经上传20… | 教程 | `recipes_advanced/[会员专享] nature microbiology图表复现之基因丰度图(20230228)` |
| 进阶 | nature microbiology图表复现之简洁版热图 | ggsci, cowplot, patchwork | 本节来复现nature microbiology上的一张图，由于作者为提供绘图数据小编自己构建了数据仅供参考。下面来进行代码介绍过程，数据+… | 教程+预览 | `recipes_advanced/nature microbiology图表复现之简洁版热图(20230322)` |
| 进阶 | nature图表复现-区域热图绘制 | readxl, magrittr, ggtree, ggmagnify, grid, patchwork | 本节来模仿nature上的一篇文章来绘制一张局部放大的热图，其主要是通过ggmagnify包来实现，由于原文没有提供数据小编自己找了一份数据… | 教程 | `recipes_advanced/[会员专享] nature图表复现-区域热图绘制-0230902` |
| 进阶 | Nature图表复现｜方差分析误差线图- | ggtext, ggprism, ggsignif, rstatix, ggpubr | 本节来复现nature communications中的一张论文图，进行单向方差分析并做数据可视化。由于作者为提供原始数据，因此结果会有所不… | 教程 | `recipes_advanced/Nature图表复现｜方差分析误差线图-20230921` |
| 进阶 | Nature图表复现｜双轴柱状和折线图｜- | patchwork | 本节来复现nature communications中的一张论文图，此图不算复杂只是在细节处要做颇多的调整。下面小编通过一个案例来进行展示，… | 教程 | `recipes_advanced/Nature图表复现｜双轴柱状和折线图｜-20230917` |
| 进阶 | Nature图表复现｜组合绘制个性化热图- | readxl, magrittr | 本节来复现npj biofilms and microbiomes中的一张论文图，主要来绘制热图但是由于添加了多个几何对象，过程会显得繁琐些… | 教程 | `recipes_advanced/Nature图表复现｜组合绘制个性化热图-20230911` |
| 进阶 | Nature图表解读｜系统发育树循环添加背景- | treeio, ape, magrittr, ggtree | 本节来解决npj biofilms and microbiomes中的一张论文图的绘制问题，下方代码不会对图形进行复现，旨在介绍一下如何根据… | 教程 | `recipes_advanced/Nature图表解读｜系统发育树循环添加背景-20230914` |
| 进阶 | NC图表复现ggplot2绘制漂亮阴影图 | readxl, ggpattern, ggsci, ggthemes, ggprism | 本节来复现NC上的一张图，绘制带阴影的箱线图；整体看起来图形比较基础但是细节也是比较多的，下面来通过代码详细介绍一下，数据+代码已经上传20… | 教程+预览 | `recipes_advanced/NC图表复现ggplot2绘制漂亮阴影图(20230225)` |
| 进阶 | NC图表复现之cirzlize绘制基因组图 | circlize | 本节来复现nature communications上的一张图circos基因组图由于作者为公开数据小编通过UCSC数据库检索构建了数据，结… | 教程+预览 | `recipes_advanced/[会员专享] NC图表复现之cirzlize绘制基因组图(20230117)` |
| 进阶 | NC图表复现之华夫热图 | readxl, patchwork | 本节来复现nature communications上的一张图热图组合条形图数据+代码已经上传2023 | 教程+预览 | `recipes_advanced/[会员专享] NC图表复现之华夫热图(20230112)` |
| 进阶 | pheatmap带你轻松绘制聚类相关性热图 | psych, pheatmap, magrittr, scico | 最近有朋友询问如何使用pheatmap绘制相关性热图，小编之前已经写过各种ggplot2风格的热图，但是对于pheatmap却是很少涉及，这… | 教程 | `recipes_advanced/pheatmap带你轻松绘制聚类相关性热图（20230619)` |
| 进阶 | phytools优雅的给进化树节点添加热图信息 | phytools, grid |  | 预览 | `recipes_advanced/phytools优雅的给进化树节点添加热图信息(20230316)` |
| 进阶 | reactablefmtr包绘制高端交互式表格 | reactablefmtr, scico | 本节再来介绍一款交互式可视化数据表格的R包reactablefmtr，经过作者的不断开发现在功能更加的丰富多元化了，更多详细的内容请参考作者… | 教程 | `recipes_advanced/reactablefmtr包绘制高端交互式表格(20230313)` |
| 进阶 | R可视化混合效应模型 | cowplot, lme4, sjPlot, sjmisc, effects, sjstats |  |  | `recipes_advanced/R可视化混合效应模型（20230513)` |
| 进阶 | R优雅的给环状热图添加显著性标记 | ggtreeExtra, ggtree, treeio, ggnewscale | 本节回答观众老爷的一个问题，如何在R中使用ggtreeExtra绘制环状热图并添加显著性标记星号，由于官方文档没有写出很多具体的案例因此大家… | 教程 | `recipes_advanced/R优雅的给环状热图添加显著性标记(20230603)` |
| 进阶 | R优雅的给图表添加背景图 | ggforce, cowplot, magick, ggbeeswarm, ggtext, ggh4x | 本节来介绍如何使用使用R代码来对图片添加背景，使用经典的企鹅数据集。整张图均使用R代码进行绘制，数据+代码已经上传2023 | 教程+预览 | `recipes_advanced/R优雅的给图表添加背景图(20230325)` |
| 进阶 | R优雅的绘制交互式桑基图 | networkD3 | 最近 | 教程 | `recipes_advanced/R优雅的绘制交互式桑基图(20230601)` |
| 进阶 | R优雅的向云雨图添加曲线文本 | geomtextpath, ggsci | 本节来介绍如何使用geomtextpath包来给图形添加曲线文本，通过云雨图的形式来进行展示,数据及代码已经上传2023 | 教程 | `recipes_advanced/[会员专享] R优雅的向云雨图添加曲线文本（20230515)` |
| 进阶 | R语言进行时间序列分析和预测- | stringr, janitor, tsibble, ggtext, bsts, tidybayes | 本节来介绍如何使用tidyverse与bsts包来处理数据并进行时间序列分析及预测，下面小编通过一个案例来进行展示，图形仅供展示用，希望各位… | 教程 | `recipes_advanced/R语言进行时间序列分析和预测-20230924` |
| 进阶 | R语言统计分析批量单变量Cox回归分析 | survival, survminer, purrr | 上一节介绍了如何使用单基因Cox的分析结果通过ggplot2来绘制森林图，本节来介绍如何使用R语言进行Cox分析。本次使用R内置的公共数据，… | 教程 | `recipes_advanced/R语言统计分析批量单变量Cox回归分析(20230105)` |
| 进阶 | R语言优雅的绘制交互式物种组成图 | plotly, glue | 本节来分享一个案例如何使用plotly包来绘制交互式微生物物种组成图，虽然此图在论文中出现不太合适，但是用于组会汇报那是在合适不过了。下面来… | 教程 | `recipes_advanced/R语言优雅的绘制交互式物种组成图（20230319)` |
| 进阶 | R中轻松绘制南丁格尔图- | ggtext | 本节通过一个小案例来简单介绍如何绘制南丁格尔图，过程很是简洁图形过程仅供展示用，希望各位观众老爷能够喜欢，数据代码已经整合上传到2023 | 教程 | `recipes_advanced/R中轻松绘制南丁格尔图-20230928` |
| 进阶 | R中如何计算效应值与无缝拼图 | magrittr, patchwork, aplot, cowplot | 本节来介绍回答 | 教程 | `recipes_advanced/R中如何计算效应值与无缝拼图(20230627)` |
| 进阶 | R中优雅的绘制冲积图 | ggsci, magrittr, reshape, RColorBrewer, ggalluvial | 最近有朋友问R中绘制冲积图的代码，其本质仍然是条形图只是添加了样本间的连线；案例要求按列计算每个样本的相对丰度跟往常有所不同。下面小编就来简… | 教程 | `recipes_advanced/R中优雅的绘制冲积图(20230610)` |
| 进阶 | R中优雅的绘制环状sina图- | lubridate, scico, ggforce | 本节来介绍如何使用ggforce包来绘制sina图，下面小编通过一个案例来进行展示，图形仅供展示用，希望各位观众老爷能够喜欢。数据代码已经整… | 教程 | `recipes_advanced/R中优雅的绘制环状sina图-20230926` |
| 进阶 | R自定义函数进行核酸序列格式转换 | Biostrings |  |  | `recipes_advanced/R自定义函数进行核酸序列格式转换(20230325)` |
| 进阶 | schtools轻松处理微生物数据的利器 | schtools, ggtext | 本节来介绍一款R包schtools主要用来处理微生物的数据，此包包含若干实用的功能具有实际应用性，也许能满足某些朋友的特殊需求;下面来介绍该… | 教程 | `recipes_advanced/schtools轻松处理微生物数据的利器` |
| 进阶 | 丰富多彩绘热图 | showtext, ggimage, scales | 还在绘制常规的热图吗，本节来介绍如何自定义绘制非常规热图，使你的热图更加丰富多彩。数据+代码已经上传2023 | 教程 | `recipes_advanced/[会员专享] 丰富多彩绘热图(20230412)` |
| 进阶 | 跟着iMeta学绘图之NMDS分析图 | vegan, NST, ggsci, patchwork | 本节继续来介绍iMeta文章中的代码，NMDS分析图的绘制；作者给出了可执行的完整代码小编对其进行了注释，此外此代码还可以继续进行优化感兴趣… | 教程+预览 | `recipes_advanced/跟着iMeta学绘图之NMDS分析图(20230421)` |
| 进阶 | 跟着iMeta学绘图之详谈进化树绘制 |  | 本节来分享iMeta一篇文章中的代码，ggtree绘制进化树；作者给出了可执行的完整代码小编对其进行了注释，数据+代码可以直接去原文中下载,… | 教程+预览 | `recipes_advanced/跟着iMeta学绘图之详谈进化树绘制(20230419)` |
| 进阶 | 跟着NC学绘图ggplot2组合展示误差线点图与柱状图 | readxl, ggsci, cowplot | 本节来绘制一张NC中的图表，组合了误差点图及柱状图，原文有原始数据提供，小编进行了些许修改后进行数据可视化,小编整理后的数据+代码已经上传2… | 教程+预览 | `recipes_advanced/跟着NC学绘图ggplot2组合展示误差线点图与柱状图(20230424)` |
| 进阶 | 跟着NC学绘图之绘制广义线性混合模型图 | data.table, rworldmap, maps, lme4, emmeans, multcomp | 本节来分享NC一篇文章中的代码，拟合广义线性混合模型绘图，作者给出了可执行的完整代码小编对其进行了整理，有需要的可以去原文中下载，整理后的数… | 教程 | `recipes_advanced/跟着NC学绘图之绘制广义线性混合模型图(20230413)` |
| 进阶 | 跟着NC学基础绘图(1) 正负分布条形图 | readxl, ggprism, cowplot | 最近有很多朋友询问如何，才能快速的学习掌握R语言用于自己论文，绝大多数论文中还是以基础图形为主偶尔有1-2张炫酷的主图，考虑到之前出的文档难… | 教程 | `recipes_advanced/跟着NC学基础绘图(1) 正负分布条形图(20230524)` |
| 进阶 | 跟着PNAS学绘图｜树状地图- | ggtext, glue, rcartocolor, VoronoiPlus | 本节来尝试绘制PNAS中的一张论文图，树状地图由于作者为提供原始数据，小编自己导入数据进行了图形绘制，过程仅参考，希望各位观众老爷能够喜欢。… | 教程 | `recipes_advanced/跟着PNAS学绘图｜树状地图-20230925` |
| 进阶 | 会员专享_再谈ggplot2绘制森林图 | gt, patchwork | 本节来介绍如何使用ggplot2绘制完美的森林图，小编以前也给过一个ggplot2版本的森林图但是该图细节调整不到位，这次小编在原有基础上进… | 教程+预览 | `recipes_advanced/会员专享_再谈ggplot2绘制森林图` |
| 进阶 | 绘制炫彩环形梯度条形图：基于R的数据可视化实践 | scico, geomtextpath | 本节来通过ggplot2包来绘制炫彩环形梯度条形图，数据+代码已经上传2023 | 教程+预览 | `recipes_advanced/绘制炫彩环形梯度条形图：基于R的数据可视化实践(20230502)` |
| 进阶 | 揭开R中一些神奇操作的面纱 | ggforce, ggbeeswarm, ggtext, palmerpenguins | 本节来介绍一个新的R知识，如何将可视化结果打包进数据框，这样后续就可以直接调用图表了非常完美的操作；下面来看具体案例介绍。 | 教程 | `recipes_advanced/揭开R中一些神奇操作的面纱（20230423）` |
| 进阶 | 如何向图形添加曲形文本 | scales, ggtext, ggp, geomtextpath | 本节来介绍如何在绘制图形中添加曲形文本，以往都是都是通过调整文本角度来展示看起来非常别扭但是使用geomtextpath包就显得丝滑了很多。… | 教程+预览 | `recipes_advanced/如何向图形添加曲形文本(20230714)` |
| 进阶 | 三行代码将系统发育树映射给地图 | mapdata, viridis, phytools, RColorBrewer, ggtree | 本节来介绍如何使用phytools包将地图与物种发育树组合起来，phytools包目前作者已经更新有兴趣的小伙伴可以去参考官方文档学习更多内… | 教程+预览 | `recipes_advanced/[会员专享] 三行代码将系统发育树映射给地图（20230315)` |
| 进阶 | 图表复现再谈个性化热图绘制 | linkET, RColorBrewer, ggtext, magrittr, psych, reshape |  | 教程 | `recipes_advanced/[会员专享]图表复现再谈个性化热图绘制（20230609）` |
| 进阶 | 详谈ggplot2绘制火山图 | ggrepel | 最近 | 教程 | `recipes_advanced/详谈ggplot2绘制火山图（20230722)` |
| 进阶 | 优雅绘制组合版circos图- | circlize, ggplotify, grid, cowplot, patchwork | 本节来介绍如何使用circlize,绘制一张组合版circos图,图形结构比较简洁但主要还是局部细节的调控，下面来通过代码详细介绍一下，数据… | 教程+预览 | `recipes_advanced/[会员专享] 优雅绘制组合版circos图-20230305` |
