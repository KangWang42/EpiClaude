# ============================================================
# 配图函数库 —— 流程图 / 示意图 / 谱系图（大字号，适配 PPT 嵌入）
# 用法：source 本文件后调用各 make_* 函数生成 PNG；再用 sysu_add_image* 嵌入。
# 关键：按"接近嵌入尺寸"渲染 + 字号放大，嵌入后才清晰。
# ============================================================
suppressPackageStartupMessages({
  library(ggplot2); library(showtext); library(sysfonts)
})
font_add("simhei", regular = "C:/Windows/Fonts/simhei.ttf")
showtext_auto()

GREEN <- "#006D5B"; BLUE <- "#0072B2"; ORANGE <- "#B8860B"
RED <- "#B22222"; PURPLE <- "#6a4caf"
gG <- "#E3EFEA"; gB <- "#DCEAF6"; gO <- "#FBEAD6"; gP <- "#ECE6F6"

# 流程图基元 ---------------------------------------------------
# 方框：中心(cx,cy)、宽高(w,h)、文字、底色、边框色
flow_box <- function(cx, cy, w, h, label, fill = gB, col = BLUE, tcol = "#1A1A1A", size = 6.4) list(
  annotate("rect", xmin = cx-w/2, xmax = cx+w/2, ymin = cy-h/2, ymax = cy+h/2,
           fill = fill, color = col, linewidth = 0.8),
  annotate("text", x = cx, y = cy, label = label, family = "simhei",
           size = size, color = tcol, lineheight = 0.95))
# 菱形判断框
flow_diamond <- function(cx, cy, w, h, label, fill = gO, col = ORANGE, size = 6.2) list(
  annotate("polygon", x = c(cx, cx+w/2, cx, cx-w/2), y = c(cy+h/2, cy, cy-h/2, cy),
           fill = fill, color = col, linewidth = 0.8),
  annotate("text", x = cx, y = cy, label = label, family = "simhei",
           size = size, color = "#5a4a00", lineheight = 0.95))
# 箭头
flow_arrow <- function(x1, y1, x2, y2, col = "#555555") annotate(
  "segment", x = x1, y = y1, xend = x2, yend = y2,
  arrow = arrow(length = unit(0.22, "cm"), type = "closed"), linewidth = 0.8, color = col)
# 画布主题（无坐标轴）
flow_canvas <- function(xlim = c(0,10), ylim = c(0,10)) list(
  scale_x_continuous(limits = xlim), scale_y_continuous(limits = ylim), theme_void())

# 示例：决策流程图（是/否分叉）
# 用法：ggsave("decision.png", make_decision(), width=5.8, height=5.0, dpi=200, bg="white")
make_decision <- function(q = "满足条件？", yes = "走 A", no = "走 B") {
  ggplot() +
    flow_box(5, 9, 4.5, 1.1, "输入", gG, GREEN, "#005825") +
    flow_diamond(5, 6.4, 4.4, 1.9, q) +
    flow_box(2.4, 3.2, 4.0, 1.3, no, gB, BLUE) +
    flow_box(7.6, 3.2, 4.0, 1.3, yes, gO, ORANGE) +
    flow_arrow(5, 8.45, 5, 7.4) +
    flow_arrow(3.0, 5.7, 2.4, 3.9) + flow_arrow(7.0, 5.7, 7.6, 3.9) +
    annotate("text", x = 2.5, y = 5.0, label = "否", family = "simhei", size = 7, color = BLUE, fontface = 2) +
    annotate("text", x = 7.5, y = 5.0, label = "是", family = "simhei", size = 7, color = ORANGE, fontface = 2) +
    flow_canvas(c(0,10), c(2.2,10))
}

# 示例：二维谱系散点（信息×灵活性之类）
# items: data.frame(name, x, y, grp)；用法见下
# 注意：图内不放标题——标题/解释写进 PPT 正文或 sysu_add_image*(caption="图N …")。
make_spectrum <- function(items, xlab = "X →", ylab = "Y →", pal = c(BLUE, RED)) {
  suppressPackageStartupMessages(library(ggrepel))
  ggplot(items, aes(x, y, color = grp)) +
    geom_point(size = 6) +
    geom_text_repel(aes(label = name), family = "simhei", size = 7,
                    box.padding = 0.7, seed = 1, segment.color = "grey70") +
    scale_color_manual(values = pal, name = NULL) +
    labs(x = xlab, y = ylab) +
    theme_minimal(base_family = "simhei", base_size = 20) +
    theme(legend.position = "top", legend.text = element_text(size = 20),
          panel.grid.minor = element_blank())
}

# 渲染口诀：嵌入右栏(≈5.5")→ ggsave width≈5.5-6.2；整图(≈9.8")→ width≈8.6-9.8。
# 字号已偏大；如仍小，调高 base_size / size。嵌入用 sysu_add_image*，比例自动适配。
# 图内只画坐标轴/图例/数据标签，不写标题与解释句；每图在 PPT 中用 caption="图N …" 配题注。
