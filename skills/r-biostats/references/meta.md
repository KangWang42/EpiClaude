# Meta 分析

## 核心包

```r
library(meta)
library(metafor)
```

## 效应量合并 (二分类)

```r
m <- metabin(
  event.e, n.e, event.c, n.c,
  studlab = study, data = data,
  sm = "OR",        # OR/RR/RD
  random = TRUE
)
summary(m)
```

## 效应量合并 (连续)

```r
m <- metacont(
  n.e, mean.e, sd.e, n.c, mean.c, sd.c,
  studlab = study, data = data,
  sm = "SMD"        # MD/SMD
)
```

## 森林图

```r
forest(m,
  leftcols = c("studlab", "event.e", "n.e"),
  rightcols = c("effect", "ci", "w.random")
)
```

## 异质性

```r
# I² > 50%: 中度; > 75%: 高度
summary(m)  # 查看 I², Q, tau²
```

## 发表偏倚

```r
funnel(m)
metabias(m, method.bias = "Egger")
```

## 亚组分析

```r
m <- metabin(..., subgroup = region)
forest(m, subgroup = TRUE)
```

## Meta 回归

```r
metareg(m, ~ year + quality)
```
