library(rotl)
library(ggtree)  
library(tidyverse)
library(ggimage) 
library(extrafont)

taxa <- tnrs_match_names(names = c("Ornithorhynchus anatinus", 
                                   "Tachyglossus aculeatus",  
                                   "Phascolarctos cinereus",   
                                   "Macropus giganteus",        
                                   "Ailuropoda melanoleuca",   
                                   "Carcharodon carcharias",  
                                   "Megaptera novaeangliae",   
                                   "Eudyptula minor",         
                                   "Tiliqua scincoides",      
                                   "Notechis scutatus",       
                                   "Dromaius novaehollandiae",
                                   "Dacelo novaeguineae",    
                                   "Myrmecia gulosa",         
                                   "Musca domestica"          
))


tree_data <- tol_induced_subtree(ott_ids = ott_id(taxa))


# 动物所对应的轮廓图像ID信息可从https://beta.phylopic.org/网站检索得到，一一对应整理成如下数据框即可。

phylopic_info <- data.frame(node = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14),
                            common_name = c('Humpback Whale','Panda','Kangaroo', 'Koala','Echidna','Platypus',
                                            'Kookaburra','Little Penguin','Emu','Tiger Snake',
                                            'Blue Tongue Lizard','Great White Shark','House Fly','Bull Ant'),
                            phylopic = c("ce70490a-79a5-47fc-afb9-834e45803ab4",
                                         "3d259941-f8c2-48cb-843b-af4a178031e9",
                                         "c306572a-fae1-41e3-8208-c2bce972e0ef",
                                         "7fb9bea8-e758-4986-afb2-95a2c3bf983d",
                                         "6885c062-5deb-4ebf-a481-752186819108",
                                         "61932f57-1fd2-49d9-bb86-042d6005581a",
                                         "2a330379-b5e6-4132-aca4-cb19ff7b88d0",
                                         "00cccd9b-0cd7-4677-9918-eddeac5cf1c6",
                                         "35947c43-1e5c-4003-bbaa-d352530b5af7",
                                         "5d0b92da-001a-4014-8bfa-05eb457b8e40",
                                         "83ba27dd-ad53-45e4-acf4-d75bf74105a6",
                                         "36d54b94-35a6-4a66-a41e-b8f28534e70c",
                                         "7252c46a-6bf1-42dd-ac5a-1018f404dfc8",
                                         "e5330b43-bd85-43af-b5bf-4e960975cd55"))

# 绘制进化树
ggtree(tree_data) %<+% phylopic_info +
  geom_tiplab(aes(image=phylopic),geom="phylopic", alpha=.5, color='#3CB2EC', offset=.1) +
  geom_tiplab(aes(label=common_name),offset = .75, col="black") + 
  xlim(NA,10) +
  theme(plot.caption=element_text(size=10, face='italic'))
