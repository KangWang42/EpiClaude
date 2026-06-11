library(survival)
library(survminer)
library(tidyverse)
library(purrr)

result.cox <- coxph(Surv(time, status) ~ sex, data =  lung)
summary(result.cox)


data <- lung
response <- data[,c("time", "status")]
covariates <- c("age", "sex", "ph.karno", "ph.ecog", "wt.loss")

results <- data.frame(covariate = character(0),
                      beta = numeric(0),
                      HR.confint.upper=numeric(0),
                      HR.confint.upper=numeric(0),
                      wald.test = numeric(0),
                      p.value = numeric(0))

for (covariate in covariates) {
  formula <- as.formula(paste("Surv(time, status) ~", covariate))
  model <- coxph(formula, data = data)
  summary <- summary(model)
  p.value <- signif(summary$wald["pvalue"], digits = 2)
  wald.test <- signif(summary$wald["test"], digits = 2)
  beta <- signif(summary$coef[1], digits = 2)
  HR.confint.lower <- signif(summary$conf.int[,"lower .95"], 2)
  HR.confint.upper <- signif(summary$conf.int[,"upper .95"], 2)
  results <- rbind(results, data.frame(covariate = covariate,
                                       beta = beta,
                                       HR.confint.lower=HR.confint.lower,
                                       HR.confint.upper=HR.confint.upper,
                                       wald.test= wald.test,
                                       p.value = p.value))
}

results
#----------------------------------------------------------------------
data <- lung

covariates <- c("age", "sex", "ph.karno", "ph.ecog", "wt.loss")

univ_models <- map(covariates, function(covariate) {
  formula <- as.formula(paste("Surv(time, status) ~", covariate))
  model <- coxph(formula, data = data)
  summary <- summary(model)
  p.value <- signif(summary$wald["pvalue"], digits = 2)
  wald.test <- signif(summary$wald["test"], digits = 2)
  beta <- signif(summary$coef[1], digits = 2)
  HR.confint.lower <- signif(summary$conf.int[,"lower .95"], 2)
  HR.confint.upper <- signif(summary$conf.int[,"upper .95"], 2)
  HR <- paste0(signif(exp(summary$coef[2]), digits = 2), " (", HR.confint.lower, "-", HR.confint.upper, ")")
  
  return(list(covariate = covariate,
              beta = beta,
              HR = HR,
              wald.test = wald.test,
              p.value = p.value))
})


results <- reduce(univ_models, rbind)


results <- do.call(rbind, univ_models) 