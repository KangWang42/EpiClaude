library(tidyverse)
install.packages("schtools")
library(schtools)
library(ggtext)

shared_dat <- read_tsv(system.file("extdata", "test.shared", package = "schtools"))

shared_dat %>% calc_relabun() %>% 
  pivot_wider(names_from = "otu", values_from = "rel_abun")

tax_dat <- read_tax("test.taxonomy")

shared_dat %>% calc_relabun() %>%
  mutate(sample_num = stringr::str_remove(sample, "p") %>%
           as.integer(), treatment = case_when(sample_num%%2 == 1 ~ "A", TRUE ~ "B")) %>%
  inner_join(tax_dat, by = "otu") %>%
  ggplot(aes(x = rel_abun, y = label_html, color = treatment)) + 
  geom_jitter(alpha = 0.7,height = 0.2) + labs(x = "Relative abundance",y=NULL) +
  theme_minimal() + theme(axis.text.y = element_markdown())


tax_dat <- read_tax(system.file("extdata", "test.taxonomy", package = "schtools"))
shared_dat <- readr::read_tsv(system.file("extdata", "test.shared", package = "schtools")) %>% view()
pool_taxon_counts(shared_dat, tax_dat, "genus")
pool_taxon_counts(shared_dat, tax_dat, "phylum")

dist_filepath <- system.file("extdata", "sample.final.thetayc.0.03.lt.ave.dist",
                             package = "schtools")

read_dist(dist_filepath)
