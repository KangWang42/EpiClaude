library(tidyverse)
# install.packages("reactablefmtr")
library(reactablefmtr)
library(scico)


# 读取文件static_list.txt，并将其赋值给变量static_list
static_list <- readr::read_csv('static_list.txt') 

# 使用scico函数，创建一个颜色比例尺pal1，参数30，色调为grayC
pal1 = scico::scico(30, palette = 'grayC')
### 数据清洗即绘图

static_list %>% 
  filter(Company != "Grand Total") %>%
  rename("Donated to Pride"="Pride?") %>%
  mutate(`Donated to Pride`=case_when(`Donated to Pride`==TRUE~"Yes", TRUE~"No"),
         `HRC Business Pledge`=case_when(`HRC Business Pledge`==TRUE~"Yes", TRUE~"No"),
         color_don = case_when(`Donated to Pride`=="Yes"~"#E1AF00", TRUE~"grey95"),
         color_hrc = case_when(`HRC Business Pledge`=="Yes"~"#E1AF00", TRUE~"grey95")) %>%
  reactable(defaultPageSize = 20,theme = fivethirtyeight(),
            defaultColDef = colDef(maxWidth = 150,format=colFormat(digits = 0)),
            columns=list(
              "Company"=colDef(maxWidth = 500),
              "Amount Contributed Across States" = colDef(format=colFormat(digits=2, prefix = "$ ", separators = TRUE),
                                                          style=color_scales(.,colors=pal1)),
              "Donated to Pride"=colDef(maxWidth = 100, align="center",
                                        cell=pill_buttons(.,color_ref = "color_don", opacity = 0.8)),
              "HRC Business Pledge"=colDef(maxWidth = 100, align="center",
                                           cell=pill_buttons(.,color_ref = "color_hrc", opacity = 0.8),
                                           style = list(borderRight = "1px solid #777")),
              color_don = colDef(show=FALSE),
              color_hrc = colDef(show=FALSE),
              "# of States Where Contributions Made"=colDef(align="center", cell=icon_assign(.,fill_color = "black")),
              "# of Politicians Contributed to"=colDef(align="center",cell=data_bars(.,force_outside = c(0,30)))
            ))

