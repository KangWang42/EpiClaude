library(data.table)
library(tidyverse)
library(ggforce)
library(ggtext)
library(ggnewscale)
library(paletteer)
library(packcircles)
library(gggibbous)


detectors <- fread("detectors.csv")
detectors$native = ifelse(detectors$native == "Yes", TRUE, FALSE)
df = detectors[, by = .(detector, kind, `.pred_class`, native), .N]
df = df[, by = .(detector, kind, `.pred_class`), c("Freq", "N2") := list(N / sum(N), sum(N))]
df$kind = df$kind |> factor(levels = c("Human", "AI"))
df$.pred_class = df$.pred_class |> factor(levels = c("AI", "Human"))


max_value = max(df$N2)
df$class = paste0(df$kind, " - ", df$.pred_class)
df = df |> split(df$class)

packing <-  lapply(df, function(x) {
  x = x[order(detector)]
  radius = x[, c("detector", "N2"), with = FALSE] |> unique()
  out = circleProgressiveLayout( (radius$N2 / max_value) / 20 )
  out = setDT(out)
  index = match(x$detector, radius$detector)
  x$x0 = out[index]$x + x$kind |> as.numeric()
  x$y0 = out[index]$y + x$`.pred_class` |> as.numeric()
  x$r  = out[index]$radius
  return(x)
})

packing <- rbindlist(packing)


ggplot() +
  geom_point(
    data = packing[which(is.na(native))],
    aes(x = x0, y = y0, size = r), fill = "#00A087",
    color = "white", shape = 21, stroke = .25)+
  geom_moon(data = packing[which(!is.na(native))],
    aes(x0, y0, ratio = Freq, right = native, fill = native, size = r),
    color = "white", stroke = .25) +
  scale_size_continuous(range = c(5,15)) +
  new_scale("size") +
  scale_size_continuous(range = c(.75, 3)) +
  geom_vline(xintercept = 1.5, linetype = "dashed", linewidth = .3) +
  geom_hline(yintercept = 1.5, linetype = "dashed", linewidth = .3) +
  scale_x_continuous(breaks = c(1,2), labels = c("Human", "AI"), position = "top") +
  scale_y_continuous(breaks = c(1,2), labels = c("AI", "Human")) +
  scale_fill_manual(values = paletteer_d("ggsci::nrc_npg"),
    guide = guide_legend(title.position = "top",
      title.theme = element_text(face = "bold",size = 10),nrow = 2)) +
  labs(x=NULL,y=NULL)+
  theme_minimal()+
  theme(
    panel.grid = element_blank(),
    axis.text.x.top = element_text(size = 10, margin = margin(b = 5),color="black"),
    axis.text.y = element_text(size = 10, margin = margin(r = 5),color="black"),
    plot.background = element_rect(fill = "#f5f5f5", color = NA),
    plot.margin = margin(10,2,2,2))




