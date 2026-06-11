devtools::install_github('marvinschmitt/ggsimplex')

library(tidyverse)
library(ggsimplex)

ggplot() +
  coord_fixed(ratio=1, xlim=c(0, 1), ylim=c(0, 1))+
  theme_void() +
  geom_simplex_canvas()

library(brms)
data = rdirichlet(n = 100, alpha = c(1,2,3))
data = as.data.frame(data)
colnames(data) = c("pmp_1", "pmp_2", "pmp_3")

data$pmp = with(data, make_list_column(pmp_1, pmp_2, pmp_3))

ggplot() +
  coord_fixed(ratio=1, xlim=c(0, 1), ylim=c(0, 1))+
  theme_void() +
  geom_simplex_canvas() + 
  geom_simplex_point(data = data, aes(pmp = pmp),
                     size = 0.7, color = "firebrick", alpha = 0.8)

df_dirichlet = data.frame(true_model = 1)
df_dirichlet$Alpha = list(c(1, 2, 3))

ggplot() +
  coord_fixed(ratio=1, xlim=c(0, 1), ylim=c(0, 1))+
  theme_void() +
  geom_simplex_canvas() + 
  stat_simplex_density(data=df_dirichlet, fun = ddirichlet,
                       args = alist(Alpha=Alpha))

ggplot() +
  coord_fixed(ratio=1, xlim=c(0, 1), ylim=c(0, 1))+
  theme_void() +
  geom_simplex_canvas() + 
  stat_simplex_density(data=df_dirichlet, fun = ddirichlet,
                       args = alist(Alpha=Alpha)) +
  geom_simplex_point(data = data, aes(pmp = pmp),
                     size = 0.7, color = "firebrick", alpha = 0.8)

#-------------------------------------------------------------------------

mu_1 = c(0, 0)
Sigma_1 = matrix(c(1, 0, 0, 1), nrow=2, byrow=TRUE)
data_1 = data.frame(true_model = 1, 
                    rlogistic_normal(n = 100, mu = mu_1, Sigma = Sigma_1))

mu_2 = c(0, 0)
Sigma_2 = matrix(c(0.3, 0, 0, 0.3), nrow=2, byrow=TRUE)
data_2 = data.frame(true_model = 2, 
                    rlogistic_normal(n = 100, mu = mu_2, Sigma = Sigma_2))

mu_3 = c(0, 0)
Sigma_3 = matrix(c(0.5, 0.3, 0.3, 1), nrow=2, byrow=TRUE)
data_3 = data.frame(true_model = 3, 
                    rlogistic_normal(n = 100, mu = mu_3, Sigma = Sigma_3))

data = rbind(data_1, data_2, data_3)
colnames(data) = c("true_model", "pmp_1", "pmp_2", "pmp_3")
data$pmp = with(data, make_list_column(pmp_1, pmp_2, pmp_3))

df_logistic_normal = data.frame(true_model = 1:3)
df_logistic_normal$mu = list(mu_1, mu_2, mu_3)
df_logistic_normal$Sigma = list(Sigma_1, Sigma_2, Sigma_3)

#--------

ggplot() +
  coord_fixed(ratio=1, xlim=c(0, 1), ylim=c(0, 1))+
  theme_void() +
  geom_simplex_canvas() + 
  stat_simplex_density(data=df_logistic_normal, fun = dlogistic_normal,
                       args = alist(mu = mu, Sigma = Sigma)) +
  geom_simplex_point(data = data, aes(pmp = pmp),
                     size = 0.7, color = "firebrick", alpha = 0.3) +
  facet_grid(~true_model, labeller=label_both)
