library(tidyverse)
install.packages("ggtools_1.0.tar.gz",repos = NULL)
library(ggtools)

read_tsv("ID.txt",col_names = F)

ggtools::replace_fasta_ids("ID.txt","HvOSCA.pep.fa","HvOSCA.pep.rename.fa")

replace_chars(file, char_pairs, output_file)

# 该函数使用三个参数：

# file：要替换的文件
# char_pairs：字符对的数据帧，包含两列："old"（需要替换的旧字符）和"new"（新字符）
# output_file：替换后的文件

ggtools::replace_chars("original_file.txt",
                       data.frame(old = c("old_char1", "old_char2", "old_char3"),
                                  new = c("new_char1", "new_char2", "new_char3")),
                       "replaced_file.txt")


id <- read_tsv("ID.txt",col_names = F)

replace_chars("HvOSCA.pep.fa",id,"rename.fa")



