
library(ggplot2)
library(readODS)
library(tidyverse)
library(dplyr)
library(extrafont)
library(patchwork)
loadfonts()


#source data location
setwd("Figure Data/")
x_labels <- c("/+","/fl")

#==============
#generate per-heart boxplots
#==============
tdTomato_data <-read_ods(path="Ai6-Ai66 regional signal by heart.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)
zsGreen_data <-read_ods(path="Ai6-Ai66 regional signal by heart.ods", sheet=2, formula_as_formula=FALSE, verbose=FALSE)

# Plot
p1 <- tdTomato_data %>%
  ggplot( aes(x=Genotype, y=Value, fill=Genotype, alpha=0.4)) +
  geom_boxplot( outlier.shape = NA, lwd=2, color="black" ) +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(aes(color=Genotype), size=10, alpha=0.9) +
  facet_wrap(~Region, scale="fixed") +
  ylab("Recombination-Normalized Fluoresence") +
  ggtitle("Ai66 per Heart") +
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " per heart")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  scale_x_discrete(labels= x_labels, limits = rev) +
  #scale_color_brewer(palette="YlOrRd") +
  #scale_fill_brewer(palette="YlOrRd") +
  scale_color_manual(values=c("dark red", "red")) +
  scale_fill_manual(values=c("dark red", "red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,color="black",vjust=1,hjust=0.5,family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", face="bold", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    panel.border = element_rect(color = "dark gray", linetype="solid", size = 5), 
    rect = element_rect( color="black", size=5)
  ) +  
  xlab("")

p2 <- zsGreen_data %>%
  ggplot( aes(x=Genotype, y=Value, fill=Genotype, alpha=0.4)) +
  geom_boxplot( outlier.shape = NA, lwd=2, color="black" ) +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(aes(color=Genotype), size=10, alpha=0.9) +
  facet_wrap(~Region, scale="fixed") +
  ylab("Recombination-Normalized Fluoresence") +
  ggtitle("Ai6 per Heart") +
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai6"}), " per heart")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  scale_x_discrete(labels= x_labels, limits = rev) +
  #scale_color_brewer(palette="YlOrRd") +
  #scale_fill_brewer(palette="YlOrRd") +
  scale_color_manual(values=c("dark green", "green")) +
  scale_fill_manual(values=c("dark green", "green")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,color="black",vjust=1,hjust=0.5,family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", face="bold", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    panel.border = element_rect(color = "dark gray", linetype="solid", size = 5), 
    rect = element_rect( color="black", size=5)
  ) +  
  xlab("")

ggsave( plot = p1, height=20, width=14, filename = "Ai66 boxplot by heart.png", units = "in",dpi = 100 )
ggsave( plot = p2, height=20, width=14, filename = "Ai6 boxplot by heart.png", units = "in",dpi = 100 )



#==============
# AV-complex only boxplot, per heart
#==============
p1a <- tdTomato_data %>% filter( Region == 'AVCplx') %>%
  ggplot( aes(x=Genotype, y=Value, fill=Genotype, alpha=0.4)) +
  geom_boxplot( outlier.shape = NA, lwd=2, color="black" ) +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(aes(color=Genotype), size=10, alpha=0.9) +
  ylab("Normalized Ai66 by heart") +
  ggtitle("AV Complex") +
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " per heart")))) +
  theme_light() +
  scale_y_continuous( limits=c(0.008,0.033)) + #trans='sqrt') +
  scale_x_discrete(labels= x_labels, limits = rev) +
  #scale_color_brewer(palette="YlOrRd") +
  #scale_fill_brewer(palette="YlOrRd") +
  scale_color_manual(values=c("dark red", "red")) +
  scale_fill_manual(values=c("dark red", "red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,color="black",vjust=1,hjust=0.5,family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", face="bold", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    panel.border = element_rect(color = "dark gray", linetype="solid", size = 5), 
    rect = element_rect( color="black", size=5)
  ) +  
  xlab("")

ggsave( plot = p1a, height=12, width=7, filename = "Ai66 per-heart AVCplx.png", units = "in",dpi = 100 )




#==============
#generate per-supervoxel boxplots
#==============
tdTomato_data1 <-read_ods(path="Ai6-Ai66 regional signal by volume.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)
zsGreen_data1 <-read_ods(path="Ai6-Ai66 regional signal by volume.ods", sheet=2, formula_as_formula=FALSE, verbose=FALSE)

# Plot
#x_labels <- c(expression(italic("Tbx5"^{"CreERT2/+"})), expression(italic("Tbx5"^{"CreERT2/fl"})))
p3 <- tdTomato_data1 %>%
  ggplot( aes(x=Genotype, y=Value, fill=Genotype, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean, lwd=2, color="black") +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_x_discrete(labels= x_labels, limits = rev) +  
  geom_jitter(aes(color=Genotype), size=4.5, alpha=0.9) +
  facet_wrap(~Region, scale="fixed") +
  ylab("Integrated Fluoresence") +  
  ggtitle("Ai66 by 3d region") +
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  scale_y_continuous(trans='sqrt') +
  scale_color_manual(values=c("dark red", "red")) +
  scale_fill_manual(values=c("dark red", "red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,color="black",vjust=1,hjust=0.5,family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", face="bold", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    panel.border = element_rect(color = "dark gray", linetype="solid", size = 5), 
    rect = element_rect( color="black", size=5)   
  ) +  
  xlab("")

# Plot
p4 <- zsGreen_data1 %>%
  ggplot( aes(x=Genotype, y=Value, fill=Genotype, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean, lwd=2, color="black") +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_x_discrete(labels= x_labels, limits = rev) +  
  geom_jitter(aes(color=Genotype), size=4.5, alpha=0.9) +
  facet_wrap(~Region, scale="fixed") +
  ylab("Integrated Fluoresence") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai6"}), " by 3d region")))) +
  ggtitle("Ai6 by 3d region") +
  theme_light() +
  scale_y_continuous(trans='sqrt') +
  scale_color_manual(values=c("dark green", "green")) +
  scale_fill_manual(values=c("dark green", "green")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,color="black",vjust=1,hjust=0.5,family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", face="bold", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    panel.border = element_rect(color = "dark gray", linetype="solid", size = 5), 
    rect = element_rect( color="black", size=5)   
  ) +  
  xlab("")

ggsave( plot = p3, height=20, width=14, filename = "Ai66 jitter all volumes.png", units = "in",dpi = 100 )
ggsave( plot = p4, height=20, width=14, filename = "Ai6 jitter all volumes.png", units = "in",dpi = 100 )



#==============
# AV-complex only boxplot, per heart
#==============
tdTomato_data1$Region <- gsub('AVCplx', 'AV Complex', tdTomato_data1$Region)
p3a <- tdTomato_data1 %>% filter( Region == 'AV Complex' | Region == 'LV' ) %>%
  ggplot( aes(x=Genotype, y=Value, fill=Genotype, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean, lwd=2, color="black") +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_boxplot( outlier.shape = NA, lwd=2, color="black", fatten = NULL ) +
  scale_x_discrete(labels= x_labels, limits = rev) +  
  geom_jitter(aes(color=Genotype), size=4.5, alpha=0.9) +
  facet_wrap(~Region, scale="fixed") +
  ylab("Ai66 signal by ") +  
  #ggtitle("Ai66 by 3d region") +
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  scale_y_continuous(trans='sqrt') +
  scale_color_manual(values=c("dark red", "red")) +
  scale_fill_manual(values=c("dark red", "red")) +
  theme(
    legend.position="none",
    plot.title = element_blank(), #element_text(size=52,color="black",vjust=1,hjust=0.5,family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", face="bold", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    panel.border = element_rect(color = "dark gray", linetype="solid", size = 5), 
    rect = element_rect( color="black", size=5)   
  ) +  
  xlab("")
tdTomato_data1$Region <- gsub('AV Complex', 'AVCplx', tdTomato_data1$Region)

ggsave( plot = p3a, height=12, width=12, filename = "Ai66 volumes AVCplx-LV.png", units = "in",dpi = 100 )



#t-tests: Ai66
sink( 'Ai66 signal by heart tests.txt' )

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"LV") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"LV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"RV") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"RV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"LA") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"LA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"RA") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"RA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"IVS") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"IVS") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"AVCplx") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"AVCplx") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

sink()

sink( 'Ai66 signal by volume tests.txt' )

test_1 <- filter(tdTomato_data1, str_detect(Genotype,"WT"), str_detect(Region,"LV") )
test_2  <- filter(tdTomato_data1, str_detect(Genotype,"Mut"), str_detect(Region,"LV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data1, str_detect(Genotype,"WT"), str_detect(Region,"RV") )
test_2  <- filter(tdTomato_data1, str_detect(Genotype,"Mut"), str_detect(Region,"RV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data1, str_detect(Genotype,"WT"), str_detect(Region,"LA") )
test_2  <- filter(tdTomato_data1, str_detect(Genotype,"Mut"), str_detect(Region,"LA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data1, str_detect(Genotype,"WT"), str_detect(Region,"RA") )
test_2  <- filter(tdTomato_data1, str_detect(Genotype,"Mut"), str_detect(Region,"RA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data1, str_detect(Genotype,"WT"), str_detect(Region,"IVS") )
test_2  <- filter(tdTomato_data1, str_detect(Genotype,"Mut"), str_detect(Region,"IVS") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(tdTomato_data1, str_detect(Genotype,"WT"), str_detect(Region,"AVCplx") )
test_2  <- filter(tdTomato_data1, str_detect(Genotype,"Mut"), str_detect(Region,"AVCplx") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

sink()


#t-tests Ai6
sink( 'Ai6 signal by heart tests.txt' )

test_1 <- filter(zsGreen_data, str_detect(Genotype,"WT"), str_detect(Region,"LV") )
test_2  <- filter(zsGreen_data, str_detect(Genotype,"Mut"), str_detect(Region,"LV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data, str_detect(Genotype,"WT"), str_detect(Region,"RV") )
test_2  <- filter(zsGreen_data, str_detect(Genotype,"Mut"), str_detect(Region,"RV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data, str_detect(Genotype,"WT"), str_detect(Region,"LA") )
test_2  <- filter(zsGreen_data, str_detect(Genotype,"Mut"), str_detect(Region,"LA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data, str_detect(Genotype,"WT"), str_detect(Region,"RA") )
test_2  <- filter(zsGreen_data, str_detect(Genotype,"Mut"), str_detect(Region,"RA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data, str_detect(Genotype,"WT"), str_detect(Region,"IVS") )
test_2  <- filter(zsGreen_data, str_detect(Genotype,"Mut"), str_detect(Region,"IVS") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data, str_detect(Genotype,"WT"), str_detect(Region,"AVCplx") )
test_2  <- filter(zsGreen_data, str_detect(Genotype,"Mut"), str_detect(Region,"AVCplx") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

sink()

sink( 'Ai6 signal by volume tests.txt' )

test_1 <- filter(zsGreen_data1, str_detect(Genotype,"WT"), str_detect(Region,"LV") )
test_2  <- filter(zsGreen_data1, str_detect(Genotype,"Mut"), str_detect(Region,"LV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data1, str_detect(Genotype,"WT"), str_detect(Region,"RV") )
test_2  <- filter(zsGreen_data1, str_detect(Genotype,"Mut"), str_detect(Region,"RV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data1, str_detect(Genotype,"WT"), str_detect(Region,"LA") )
test_2  <- filter(zsGreen_data1, str_detect(Genotype,"Mut"), str_detect(Region,"LA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data1, str_detect(Genotype,"WT"), str_detect(Region,"RA") )
test_2  <- filter(zsGreen_data1, str_detect(Genotype,"Mut"), str_detect(Region,"RA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data1, str_detect(Genotype,"WT"), str_detect(Region,"IVS") )
test_2  <- filter(zsGreen_data1, str_detect(Genotype,"Mut"), str_detect(Region,"IVS") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

test_1 <- filter(zsGreen_data1, str_detect(Genotype,"WT"), str_detect(Region,"AVCplx") )
test_2  <- filter(zsGreen_data1, str_detect(Genotype,"Mut"), str_detect(Region,"AVCplx") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
wilcox.test(test_1$Value, test_2$Value)

sink()



#==============
#exit
#==============
exit()

