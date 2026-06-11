# 可视化规范

## 配色

```r
library(ggsci)

# 分类 ≤5
scale_fill_lancet()
scale_color_lancet()

# 分类 >5
scale_fill_npg()

# 连续
scale_fill_viridis_c()
```

## 中文字体 (PDF)

```r
theme_cn <- theme_bw(base_size = 11) +
  theme(
    text = element_text(family = "SimSun"),
    plot.title = element_text(hjust = 0.5, family = "SimSun"),
    axis.title = element_text(family = "SimSun"),
    axis.text = element_text(family = "SimSun"),
    legend.text = element_text(family = "SimSun")
  )
```

## 导出

```r
# PNG (推荐中文)
ggsave("Fig.png", plot, dpi = 300, device = ragg::agg_png)

# PDF
ggsave("Fig.pdf", plot, device = cairo_pdf)
```

## 常用图表

### 森林图

```r
ggplot(data, aes(x = estimate, y = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
  geom_vline(xintercept = 1, linetype = "dashed") +
  scale_x_log10() +
  theme_bw()
```

### KM 曲线

```r
ggsurvplot(fit, palette = "lancet", risk.table = TRUE)
```

### 箱线图

```r
ggplot(data, aes(x = group, y = value, fill = group)) +
  geom_boxplot() +
  scale_fill_lancet() +
  theme_bw()
```

## 标题规范

- 只用 `labs(title = "...")`, 居中
- 禁止 subtitle/caption
