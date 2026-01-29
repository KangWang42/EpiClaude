# 中介与调节效应

## 核心包

```r
library(mediation)
library(lavaan)
library(interactions)
```

## 中介效应 (Bootstrap)

```r
med_fit <- lm(mediator ~ exposure + cov, data = data)
out_fit <- lm(outcome ~ exposure + mediator + cov, data = data)

result <- mediate(med_fit, out_fit, 
                  treat = "exposure", mediator = "mediator",
                  boot = TRUE, sims = 5000)
summary(result)
```

## 中介效应 (SEM)

```r
model <- '
  outcome ~ c*exposure + b*mediator
  mediator ~ a*exposure
  indirect := a*b
  total := c + a*b
'
fit <- sem(model, data = data, se = "bootstrap", bootstrap = 5000)
parameterEstimates(fit, boot.ci.type = "bca.simple")
```

## 调节效应

```r
model <- lm(outcome ~ exposure * moderator + cov, data = data)

# 简单斜率
sim_slopes(model, pred = exposure, modx = moderator)

# 交互图
interact_plot(model, pred = exposure, modx = moderator)
```

## 结果报告

```markdown
| 效应 | 值 | 95% CI | 中介比例 |
|------|-----|--------|----------|
| 总效应 | X.XX | [X,X] | - |
| 直接效应 | X.XX | [X,X] | - |
| 间接效应 | X.XX | [X,X] | XX% |
```
