library(tidyverse)

# 建立核苷酸和氨基酸的字典
nt_dict <- list(TTT="F", TTC="F", TTA="L", TTG="L",
                CTT="L", CTC="L", CTA="L", CTG="L",
                ATT="I", ATC="I", ATA="I", ATG="M",
                GTT="V", GTC="V", GTA="V", GTG="V",
                TCT="S", TCC="S", TCA="S", TCG="S",
                CCT="P", CCC="P", CCA="P", CCG="P",
                ACT="T", ACC="T", ACA="T", ACG="T",
                GCT="A", GCC="A", GCA="A", GCG="A",
                TAT="Y", TAC="Y", TAA="*", TAG="*",
                CAT="H", CAC="H", CAA="Q", CAG="Q",
                AAT="N", AAC="N", AAA="K", AAG="K",
                GAT="D", GAC="D", GAA="E", GAG="E",
                TGT="C", TGC="C", TGA="*", TGG="W",
                CGT="R", CGC="R", CGA="R", CGG="R",
                AGT="S", AGC="S", AGA="R", AGG="R",
                GGT="G", GGC="G", GGA="G", GGG="G")

# 将核苷酸序列转换为氨基酸序列
translate_dna <- function(dna_seq) {
  nts <- strsplit(dna_seq, "")[[1]]
  codons <- paste0(nts[c(T, F, F)], nts[c(F, T, F)], nts[c(F, F, T)])
  aa_seq <- sapply(codons, function(codon) nt_dict[[codon]])
  return(paste(aa_seq, collapse=""))
}

# 测试代码
dna_seq <- "ATGGTCTGCTGTGAC"
translate_dna(dna_seq)

#------
library(Biostrings)
seqs <- readDNAStringSet("HvOSCA.cds.fa")

# 翻译核酸序列为氨基酸序列
aa_seqs <- translate(seqs)
writeXStringSet(aa_seqs, "output_aa_seqs.fasta")


#------------------------------------------------------------
# 读取FASTA文件
fasta_file <- readLines("HvOSCA.cds.fa")

# 从FASTA文件中提取序列
seqs <- list()
for (i in 1:length(fasta_file)) {
  if (startsWith(fasta_file[i], ">")) {
    header <- gsub(">", "", fasta_file[i])
    seqs[[header]] <- ""
  } else {
    seqs[[header]] <- paste0(seqs[[header]], fasta_file[i])
  }
}

# 核酸翻译表
codon_table <- list(
  "TTT" = "F", "TTC" = "F", "TTA" = "L", "TTG" = "L",
  "TCT" = "S", "TCC" = "S", "TCA" = "S", "TCG" = "S",
  "TAT" = "Y", "TAC" = "Y", "TAA" = "*", "TAG" = "*",
  "TGT" = "C", "TGC" = "C", "TGA" = "*", "TGG" = "W",
  "CTT" = "L", "CTC" = "L", "CTA" = "L", "CTG" = "L",
  "CCT" = "P", "CCC" = "P", "CCA" = "P", "CCG" = "P",
  "CAT" = "H", "CAC" = "H", "CAA" = "Q", "CAG" = "Q",
  "CGT" = "R", "CGC" = "R", "CGA" = "R", "CGG" = "R",
  "ATT" = "I", "ATC" = "I", "ATA" = "I", "ATG" = "M",
  "ACT" = "T", "ACC" = "T", "ACA" = "T", "ACG" = "T",
  "AAT" = "N", "AAC" = "N", "AAA" = "K", "AAG" = "K",
  "AGT" = "S", "AGC" = "S", "AGA" = "R", "AGG" = "R",
  "GTT" = "V", "GTC" = "V", "GTA" = "V", "GTG" = "V",
  "GCT" = "A", "GCC" = "A", "GCA" = "A", "GCG" = "A",
  "GAT" = "D", "GAC" = "D", "GAA" = "E", "GAG" = "E",
  "GGT" = "G", "GGC" = "G", "GGA" = "G", "GGG" = "G"
)

# 翻译核酸序列为氨基酸序列
translate_seq <- function(dna_seq) {
  n_codons <- floor(nchar(dna_seq) / 3)
  codons <- substring(dna_seq, seq(1, n_codons * 3, 3), seq(3, n_codons * 3, 3))

  aa_seq <- ""
  for (codon in codons) {
    aa <- codon_table[[codon]]
    aa_seq <- paste0(aa_seq, aa)
  }
  return(aa_seq)
}

aa_seqs <- list()
for (header in names(seqs)) {
  dna_seq <- seqs[[header]]
  aa_seq <- translate_seq(dna_seq)
  aa_seqs[[header]] <- aa_seq
}

output_file <- file("HvOSCA.fasta", "w")
for (header in names(aa_seqs)) {
  aa_seq <- aa_seqs[[header]]
  cat(">", header, "\n", aa_seq, "\n", file = output_file)
}
close(output_file)

output_file <- file("HvOSCA.fasta", "w")
for (header in names(aa_seqs)) {
  aa_seq <- aa_seqs[[header]]
  cat(">", header, "\n", aa_seq, "\n", file = output_file, sep = "")
}
close(output_file)

#-----------------------------------------------------------------

translate_fasta_dna_to_aa <- function(file_in, file_out) {
  # 读取FASTA文件
  fasta_file <- readLines(file_in)
  
  # 从FASTA文件中提取序列
  seqs <- list()
  for (i in 1:length(fasta_file)) {
    if (startsWith(fasta_file[i], ">")) {
      header <- gsub(">", "", fasta_file[i])
      seqs[[header]] <- ""
    } else {
      seqs[[header]] <- paste0(seqs[[header]], fasta_file[i])
    }
  }
  
  # 核酸翻译表
  codon_table <- list(
    "TTT" = "F", "TTC" = "F", "TTA" = "L", "TTG" = "L",
    "TCT" = "S", "TCC" = "S", "TCA" = "S", "TCG" = "S",
    "TAT" = "Y", "TAC" = "Y", "TAA" = "*", "TAG" = "*",
    "TGT" = "C", "TGC" = "C", "TGA" = "*", "TGG" = "W",
    "CTT" = "L", "CTC" = "L", "CTA" = "L", "CTG" = "L",
    "CCT" = "P", "CCC" = "P", "CCA" = "P", "CCG" = "P",
    "CAT" = "H", "CAC" = "H", "CAA" = "Q", "CAG" = "Q",
    "CGT" = "R", "CGC" = "R", "CGA" = "R", "CGG" = "R",
    "ATT" = "I", "ATC" = "I", "ATA" = "I", "ATG" = "M",
    "ACT" = "T", "ACC" = "T", "ACA" = "T", "ACG" = "T",
    "AAT" = "N", "AAC" = "N", "AAA" = "K", "AAG" = "K",
    "AGT" = "S", "AGC" = "S", "AGA" = "R", "AGG" = "R",
    "GTT" = "V", "GTC" = "V", "GTA" = "V", "GTG" = "V",
    "GCT" = "A", "GCC" = "A", "GCA" = "A", "GCG" = "A",
    "GAT" = "D", "GAC" = "D", "GAA" = "E", "GAG" = "E",
    "GGT" = "G", "GGC" = "G", "GGA" = "G", "GGG" = "G"
  )
  
  # 翻译核酸序列为氨基酸序列
  translate_seq <- function(dna_seq) {
    n_codons <- floor(nchar(dna_seq) / 3)
    codons <- substring(dna_seq, seq(1, n_codons * 3, 3), seq(3, n_codons * 3, 3))
    aa_seq <- ""
    for (codon in codons) {
      aa <- codon_table[[codon]]
      aa_seq <- paste0(aa_seq, aa)
    }
    return(aa_seq)
  }  
  #对每条序列进行翻译
  aa_seqs <- list()
  for (header in names(seqs)) {
    dna_seq <- seqs[[header]]
    aa_seq <- translate_seq(dna_seq)
    aa_seqs[[header]] <- aa_seq
  }
  
  # 将氨基酸序列输出到FASTA文件
  output_file <- file(file_out, "w")
  for (header in names(aa_seqs)) {
    aa_seq <- aa_seqs[[header]]
    cat(">", header, "\n", aa_seq, "\n", file = output_file, sep = "")
  }
  close(output_file)
}


translate_fasta_dna_to_aa("HvOSCA.cds.fa", "output_aa_seqs.fasta")



dna_seq <- DNAString("ATGGGTTCTCTCAACGAAATCGGCGTTGCTGCGGGAATAAACATATCATCGGCATTGGGTTTTCTTCTAG")
#将核酸序列转换为AAString对象
aa_seq <- translate(dna_seq)
#将AAString对象转换为字符串
aa_seq_str <- as.character(aa_seq)
#输出氨基酸序列
cat(aa_seq_str)
















