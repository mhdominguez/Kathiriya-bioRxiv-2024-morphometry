
library(ggplot2)
library(readODS)
library(tidyverse)
library(dplyr)
library(extrafont)
loadfonts()

#source data location
setwd("Figure Data/")

#get data in
basic_measurements <-read_ods(path="Basic measurements.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)


#==============
#generate per-heart boxplots
#==============
x_labels <- c("/fl","/+")
p1 <- basic_measurements %>%
  ggplot( aes(x=Genotype, y=Value, fill=Genotype, alpha=0.4)) +
  geom_boxplot( outlier.shape = NA, lwd=2, color="black" ) +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(aes(color=Genotype), size=8, alpha=0.8) +
  facet_wrap(~Measurement, scale="fixed") +
  ylab("fraction of apical-basal length") +
  #ggtitle(paste(expression(italic("Rosa26"^{"Ai66"})), " per Heart"))) +
  ggtitle("basic linear ratios, by heart") + 
  theme_light() +
  #scale_y_continuous(trans='sqrt') +
  scale_x_discrete(labels= x_labels, limits = rev) +
  #scale_color_brewer(palette="YlOrRd") +
  #scale_fill_brewer(palette="YlOrRd") +
  scale_color_manual(values=c("black", "black")) +
  scale_fill_manual(values=c("dark gray", "light gray")) +
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

ggsave( plot = p1, height=10, width=20, filename = "Heart basic measurements.png", units = "in",dpi = 100 )


#==============
#exit
#==============
exit()



