#install.packages('readODS')
#font_import()
library(ggplot2)
library(readODS)
library(tidyverse)
library(viridis)
library(dplyr)
library(extrafont)
library(ggridges)
loadfonts()
setwd("Figure Data/")

#==============
#generate boxplots for directionality results
#==============
tdT_0 <-read_ods(path="ctrl mut 0 and 90 degree directionality scores.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)
tdT_90 <-read_ods(path="ctrl mut 0 and 90 degree directionality scores.ods", sheet=2, formula_as_formula=FALSE, verbose=FALSE)
tdT_0$Range <- "0"
tdT_90$Range <- "90"
tdT_90$Genotype <- sub("MutantNinety", "Mut", tdT_90$Genotype)
tdT_90$Genotype <- sub("CtrlNinety", "Ctrl", tdT_90$Genotype)
tdT_0$Genotype <- sub("MutantZero", "Mut", tdT_0$Genotype)
tdT_0$Genotype <- sub("CtrlZero", "Ctrl", tdT_0$Genotype)
tdT_90$Score <- tdT_90$Score * 1000
tdT_0$Score <- tdT_0$Score * 1000

zsG_0 <-read_ods(path="ctrl mut 0 and 90 degree directionality scores.ods", sheet=3, formula_as_formula=FALSE, verbose=FALSE)
zsG_90 <-read_ods(path="ctrl mut 0 and 90 degree directionality scores.ods", sheet=4, formula_as_formula=FALSE, verbose=FALSE)
zsG_0$Range <- "0"
zsG_90$Range <- "90"
zsG_90$Genotype <- sub("MutantNinety", "Mut", zsG_90$Genotype)
zsG_90$Genotype <- sub("CtrlNinety", "Ctrl", zsG_90$Genotype)
zsG_0$Genotype <- sub("MutantZero", "Mut", zsG_0$Genotype)
zsG_0$Genotype <- sub("CtrlZero", "Ctrl", zsG_0$Genotype)
zsG_90$Score <- zsG_90$Score * 1000
zsG_0$Score <- zsG_0$Score * 1000

tdT_65 <-read_ods(path="ctrl mut 0 and 90 degree directionality scores.ods", sheet=5, formula_as_formula=FALSE, verbose=FALSE)
zsG_65 <-read_ods(path="ctrl mut 0 and 90 degree directionality scores.ods", sheet=6, formula_as_formula=FALSE, verbose=FALSE)
tdT_65$Range <- "65"
zsG_65$Range <- "65"
tdT_65$Genotype <- sub("MutantFortyfive", "Mut", tdT_65$Genotype)
tdT_65$Genotype <- sub("CtrlFortyfive", "Ctrl", tdT_65$Genotype)
zsG_65$Genotype <- sub("MutantFortyfive", "Mut", zsG_65$Genotype)
zsG_65$Genotype <- sub("CtrlFortyfive", "Ctrl", zsG_65$Genotype)
tdT_65$Score <- tdT_65$Score * 1000
zsG_65$Score <- zsG_65$Score * 1000

tdTomato_data <- rbind(tdT_90,tdT_0,tdT_65)
zsGreen_data <- rbind(zsG_90,zsG_0,zsG_65)


# Plot
#x_labels <- c(expression(italic("Tbx5"^{"CreERT2/+"})), expression(italic("Tbx5"^{"CreERT2/fl"})), expression(italic("Tbx5"^{"CreERT2/+"})), expression(italic("Tbx5"^{"CreERT2/fl"})))
#x_labels <- c("/+","/fl","/+","/fl","/+","/fl")
x_labels <- c("/+","/fl")
new_xy_labels <- c("0" = "", "65" = "", "90"="")

tdTomato_data %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.9)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #geom_boxplot() + 
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  #scale_x_discrete(limits=c("CtrlZero","MutantZero","CtrlFortyfive","MutantFortyfive", "CtrlNinety","MutantNinety"), labels= x_labels) +
  scale_x_discrete(limits=c("Ctrl","Mut"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=1.0, alpha=0.5) +
  facet_wrap(vars(Range),labeller = labeller(Range = new_xy_labels), scales = "free") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  #scale_y_continuous(limits=c(0,15)) +
  #scale_color_manual(values=c("red", "red","red","dark red","dark red", "dark red")) +
  #scale_fill_manual(values=c("red", "red","red","dark red","dark red", "dark red")) +
  scale_fill_manual(values=c("red", "dark red")) +
  scale_color_manual(values=c("red", "dark red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

x_labels <- c("/+","/fl")
tdT_90 %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #geom_boxplot() + 
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  #scale_x_discrete(limits=c("CtrlZero","MutantZero","CtrlFortyfive","MutantFortyfive", "CtrlNinety","MutantNinety"), labels= x_labels) +
  scale_x_discrete(limits=c("Ctrl","Mut"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=1.5, alpha=0.7) +
  #facet_wrap(vars(Range),labeller = labeller(Range = new_xy_labels), scales = "free") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  scale_y_continuous(limits=c(1,7.5)) +
  #scale_color_manual(values=c("red", "red","red","dark red","dark red", "dark red")) +
  #scale_fill_manual(values=c("red", "red","red","dark red","dark red", "dark red")) +
  scale_fill_manual(values=c("red", "dark red")) +
  scale_color_manual(values=c("red", "dark red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

tdT_0 %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #geom_boxplot() + 
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  #scale_x_discrete(limits=c("CtrlZero","MutantZero","CtrlFortyfive","MutantFortyfive", "CtrlNinety","MutantNinety"), labels= x_labels) +
  scale_x_discrete(limits=c("Ctrl","Mut"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=1.5, alpha=0.7) +
  #facet_wrap(vars(Range),labeller = labeller(Range = new_xy_labels), scales = "free") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  scale_y_continuous(limits=c(1,15.5)) +
  #scale_color_manual(values=c("red", "red","red","dark red","dark red", "dark red")) +
  #scale_fill_manual(values=c("red", "red","red","dark red","dark red", "dark red")) +
  scale_fill_manual(values=c("red", "dark red")) +
  scale_color_manual(values=c("red", "dark red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

tdT_65 %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #geom_boxplot() + 
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  #scale_x_discrete(limits=c("CtrlZero","MutantZero","CtrlFortyfive","MutantFortyfive", "CtrlNinety","MutantNinety"), labels= x_labels) +
  scale_x_discrete(limits=c("Ctrl","Mut"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=1.0, alpha=0.5) +
  #facet_wrap(vars(Range),labeller = labeller(Range = new_xy_labels), scales = "free") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  scale_y_continuous(limits=c(1,8.5)) +
  #scale_color_manual(values=c("red", "red","red","dark red","dark red", "dark red")) +
  #scale_fill_manual(values=c("red", "red","red","dark red","dark red", "dark red")) +
  scale_fill_manual(values=c("red", "dark red")) +
  scale_color_manual(values=c("red", "dark red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

# Plot
zsGreen_data %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #geom_violin() +
  #geom_boxplot() + 
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_x_discrete(limits=c("CtrlZero","MutantZero","CtrlNinety","MutantNinety"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=1.5, alpha=0.8) +
  #facet_wrap(~Region, scale="fixed") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  scale_y_continuous(limits=c(0,15)) +
  scale_color_manual(values=c("green", "green","dark green", "dark green")) +
  scale_fill_manual(values=c("green", "green","dark green", "dark green")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

zsG_90 %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #geom_boxplot() + 
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  #scale_x_discrete(limits=c("CtrlZero","MutantZero","CtrlFortyfive","MutantFortyfive", "CtrlNinety","MutantNinety"), labels= x_labels) +
  scale_x_discrete(limits=c("Ctrl","Mut"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=1.5, alpha=0.7) +
  #facet_wrap(vars(Range),labeller = labeller(Range = new_xy_labels), scales = "free") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  scale_y_continuous(limits=c(1,7.5)) +
  #scale_color_manual(values=c("green", "green","green","dark green","dark green", "dark green")) +
  #scale_fill_manual(values=c("green", "green","green","dark green","dark green", "dark green")) +
  scale_fill_manual(values=c("green", "dark green")) +
  scale_color_manual(values=c("green", "dark green")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

zsG_0 %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #geom_boxplot() + 
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  #scale_x_discrete(limits=c("CtrlZero","MutantZero","CtrlFortyfive","MutantFortyfive", "CtrlNinety","MutantNinety"), labels= x_labels) +
  scale_x_discrete(limits=c("Ctrl","Mut"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=1.5, alpha=0.7) +
  #facet_wrap(vars(Range),labeller = labeller(Range = new_xy_labels), scales = "free") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  scale_y_continuous(limits=c(1,15.5)) +
  #scale_color_manual(values=c("green", "green","green","dark green","dark green", "dark green")) +
  #scale_fill_manual(values=c("green", "green","green","dark green","dark green", "dark green")) +
  scale_fill_manual(values=c("green", "dark green")) +
  scale_color_manual(values=c("green", "dark green")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

zsG_65 %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #geom_boxplot() + 
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  #scale_x_discrete(limits=c("CtrlZero","MutantZero","CtrlFortyfive","MutantFortyfive", "CtrlNinety","MutantNinety"), labels= x_labels) +
  scale_x_discrete(limits=c("Ctrl","Mut"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=1.0, alpha=0.5) +
  #facet_wrap(vars(Range),labeller = labeller(Range = new_xy_labels), scales = "free") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  scale_y_continuous(limits=c(1,8.5)) +
  #scale_color_manual(values=c("green", "green","green","dark green","dark green", "dark green")) +
  #scale_fill_manual(values=c("green", "green","green","dark green","dark green", "dark green")) +
  scale_fill_manual(values=c("green", "dark green")) +
  scale_color_manual(values=c("green", "dark green")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")


#t-test tdT
Mut90 <- tdT_90[which(tdT_90$Genotype=="Mut"),]
Ctl90 <- tdT_90[which(tdT_90$Genotype=="Ctrl"),]
Mut0 <- tdT_0[which(tdT_0$Genotype=="Mut"),]
Ctl0 <- tdT_0[which(tdT_0$Genotype=="Ctrl"),]
Mut65 <- tdT_65[which(tdT_65$Genotype=="Mut"),]
Ctl65 <- tdT_65[which(tdT_65$Genotype=="Ctrl"),]
wilcox.test(Mut0$Score,Ctl0$Score)
wilcox.test(Mut90$Score,Ctl90$Score)
wilcox.test(Mut65$Score,Ctl65$Score)

#t-test zsG
Mut90 <- zsG_90[which(zsG_90$Genotype=="Mut"),]
Ctl90 <- zsG_90[which(zsG_90$Genotype=="Ctrl"),]
Mut0 <- zsG_0[which(zsG_0$Genotype=="Mut"),]
Ctl0 <- zsG_0[which(zsG_0$Genotype=="Ctrl"),]
Mut65 <- zsG_65[which(zsG_65$Genotype=="Mut"),]
Ctl65 <- zsG_65[which(zsG_65$Genotype=="Ctrl"),]
wilcox.test(Mut0$Score,Ctl0$Score)
wilcox.test(Mut90$Score,Ctl90$Score)
wilcox.test(Mut65$Score,Ctl65$Score)

#==============
#generate boxplots for coherency results
#==============
tdT <-read_ods(path="ctrl mut coherency scores.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)
zsG <-read_ods(path="ctrl mut coherency scores.ods", sheet=2, formula_as_formula=FALSE, verbose=FALSE)

x_labels <- c("/+","/fl")
tdT %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_x_discrete(limits=c("Control","Mutant"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=4, alpha=0.9) +
  #facet_wrap(~Region, scale="fixed") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  #scale_y_continuous(limits=c(0,15)) +
  scale_color_manual(values=c("red", "dark red")) +
  scale_fill_manual(values=c("red", "dark red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

zsG %>%
  ggplot( aes(x=Genotype, y=Score, alpha=0.4)) +
  geom_crossbar(stat = "summary", fun=mean) +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_x_discrete(limits=c("Control","Mutant"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=4, alpha=0.9) +
  #facet_wrap(~Region, scale="fixed") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  #scale_y_continuous(limits=c(2.5,12.5),trans='sqrt') +
  #scale_y_continuous(limits=c(0,15)) +
  scale_color_manual(values=c("green", "dark green")) +
  scale_fill_manual(values=c("green", "dark green")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank()
    #rect = element_rect( color="white", size=1)   
  ) +  
  xlab("")

#t-test tdT
Mut <- tdT[which(tdT$Genotype=="Mutant"),]
Ctl <- tdT[which(tdT$Genotype=="Control"),]
wilcox.test(Mut$Score,Ctl$Score)

#t-test zsG
Mut <- zsG[which(tdT$Genotype=="Mutant"),]
Ctl <- zsG[which(tdT$Genotype=="Control"),]
wilcox.test(Mut$Score,Ctl$Score)




#==============
#exit
#==============
exit()







#==============
#unused code
#==============
# Most basic violin chart
ggplot(newdata, aes(x=name, y=value, fill=name)) + # fill=name allow to automatically dedicate a color for each group
  geom_violin() +
  scale_y_continuous(trans='sqrt')

newdata %>%
  ggplot( aes(x=value, y=name, fill=name)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none") +
  scale_x_continuous(trans='sqrt')


#t-tests
test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"LV") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"LV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"RV") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"RV") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"LA") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"LA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"RA") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"RA") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"IVS") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"IVS") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(Genotype,"WT"), str_detect(Region,"AVCplx") )
test_2  <- filter(tdTomato_data, str_detect(Genotype,"Mut"), str_detect(Region,"AVCplx") )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)


test_1 <- filter(tdTomato_data, str_detect(name,"^ZsGreen-LV-WT") )
test_2  <- filter(tdTomato_data, str_detect(name,"^ZsGreen-LV-Mut") )
t.test(test_1$value, test_2$value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(name,"^ZsGreen-RV-WT") )
test_2  <- filter(tdTomato_data, str_detect(name,"^ZsGreen-RV-Mut") )
t.test(test_1$value, test_2$value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(name,"^ZsGreen-LA-WT") )
test_2  <- filter(tdTomato_data, str_detect(name,"^ZsGreen-LA-Mut") )
t.test(test_1$value, test_2$value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(name,"^ZsGreen-RA-WT") )
test_2  <- filter(tdTomato_data, str_detect(name,"^ZsGreen-RA-Mut") )
t.test(test_1$value, test_2$value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(name,"^ZsGreen-IVS-WT") )
test_2  <- filter(tdTomato_data, str_detect(name,"^ZsGreen-IVS-Mut") )
t.test(test_1$value, test_2$value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)

test_1 <- filter(tdTomato_data, str_detect(name,"^ZsGreen-AVCplx-WT") )
test_2  <- filter(tdTomato_data, str_detect(name,"^ZsGreen-AVCplx-Mut") )
t.test(test_1$value, test_2$value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)


