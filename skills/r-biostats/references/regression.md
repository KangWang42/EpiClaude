# 回归分析

## 核心包

```r
library(tidymodels)
library(broom)
library(gtsummary)
library(car)  # VIF
```

## 线性回归

```r
model <- lm(outcome ~ exposure + cov1 + cov2, data = data)

tbl_regression(model) |>
  add_global_p() |>
  add_glance_table(include = c(r.squared, nobs))

# VIF
vif(model)  # < 5
```

## 逻辑回归

```r
model <- glm(outcome ~ exposure + age + sex, 
             data = data, family = binomial)

tbl_regression(model, exponentiate = TRUE) |>  # OR
  add_global_p() |>
  bold_p()
```

## Poisson 回归

```r
model <- glm(count ~ exposure + offset(log(person_years)),
             data = data, family = poisson)

tbl_regression(model, exponentiate = TRUE)  # RR
```

## 趋势检验

```r
data$exposure_num <- as.numeric(data$exposure)
model <- glm(outcome ~ exposure_num, family = binomial, data = data)
# P for trend = exposure_num 的 P 值
```

## 模型诊断

```r
# 线性: 残差图
plot(model, which = 1:3)

# 逻辑: ROC
library(pROC)
roc(data$outcome, fitted(model)) |> auc()
```

## 森林图

```r
tidy(model, exponentiate = TRUE, conf.int = TRUE) |>
  ggplot(aes(estimate, term, xmin = conf.low, xmax = conf.high)) +
  geom_point() +
  geom_errorbarh(height = 0.2) +
  geom_vline(xintercept = 1, linetype = "dashed") +
  scale_x_log10()
```
