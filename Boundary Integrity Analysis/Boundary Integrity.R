
library(ggplot2)
library(readODS)
library(tidyverse)
library(dplyr)
library(extrafont)
loadfonts()

#source data location
setwd("Figure Data/")

#get data in
tdTomato_linear_position <-read_ods(path="Ai66 IVS boundary.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)

#==============
#generate boxplots for boundary integrity results
#==============
x_labels <- c("/fl","/+")
p1 <- tdTomato_linear_position %>%
  ggplot( aes(x=Genotype, y=Value, alpha=0.4, fill=Genotype)) +
  coord_flip() +
  geom_violin(lwd=2,trim=FALSE,color="black" ) +
  geom_crossbar(stat = "summary", fun=mean,lwd=2,color="black") +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  #geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_x_discrete(limits=c("Mutant","Control"), labels= x_labels) +  
  geom_jitter(aes(color=Genotype), size=4, alpha=0.6) +
  #facet_wrap(~Region, scale="fixed") +
  #ylab("Integrated Fluoresence Density") +  
  ylab("") +  
  #ggtitle(expression(bold(paste(bolditalic("Rosa26"^{"Ai66"}), " by 3d region")))) +
  theme_light() +
  #scale_y_continuous(trans='log2') +
  scale_y_continuous(limits=c(0,1.0)) +
  #scale_y_continuous(limits=c(0,15)) +
  #scale_color_manual(values=c("red", "dark red")) +
  scale_color_manual(values=c("black", "black")) +
  scale_fill_manual(values=c("red", "dark red")) +
  theme(
    legend.position="none",
    plot.title = element_text(size=52,vjust=1,hjust=0.5,color="black",family="Liberation Sans", face="bold"),
    axis.text.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.title.y = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    axis.text.x = element_text(size=56,color="black",family="Liberation Sans", angle=0, vjust=0.65),
    axis.title.x = element_text(size=52,color="black",family="Liberation Sans", face="bold" ),
    strip.text.x = element_text(size=52,color="black",family="Liberation Sans", face="bold"),
    panel.grid = element_blank(),
    rect = element_blank(),
    axis.ticks.x = element_line( color="black", size=1)   
  ) +  
  xlab("")

ggsave( plot = p1, height=4, width=16, filename = "Ai66 IVS boundary integrity.png", units = "in",dpi = 100 )


test_1 <- filter(tdTomato_linear_position, str_detect(Genotype,"Control") )
test_2  <- filter(tdTomato_linear_position, str_detect(Genotype,"Mutant") )

sink( 'boundary integrity test.txt' )
t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE)
var.test(test_1$Value, test_2$Value,  alternative = "two.sided", paired = FALSE)
#leveneTest(Genotype ~ Mut, data = test_1$Value)
sink()


#==============
#exit
#==============
exit()



