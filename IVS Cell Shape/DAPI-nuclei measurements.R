
library(ggplot2)
library(patchwork)
library(rlang)
library(readODS)
library(tidyverse)
library(dplyr)
library(extrafont)
loadfonts()

# source data location
setwd("Figure Data/")

# set microns per pixel resolution
microns_per_pixel = 0.2075665

# callable function
darken_hex <- function(hex, factor = 0.2) {
  # Apply the darkening operation to each color in the vector
  darkened_colors <- sapply(hex, function(color) {
    # Convert hex to RGB
    rgb_vals <- col2rgb(color) / 255
    
    # Darken the color by multiplying the RGB values
    darkened_rgb <- rgb_vals * (1 - factor)
    
    # Convert back to hex
    rgb(darkened_rgb[1], darkened_rgb[2], darkened_rgb[3], maxColorValue = 1)
  })

  return(unname(darkened_colors))
}

# get data in
DAPI_measurements <-read_ods(path="DAPI_areas_summary.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)

#==============
# generate per-section boxplots
#==============
x_labels <- c("CreERT2/+","CreERT2/flox")
colors_use <- c("#758ddf","#47568a")

common_plot <- function( y_name, plot_name = y_name ) {
  pX <- DAPI_measurements %>%
    ggplot( aes(x=Genotype, y=!!sym(y_name), fill=Genotype))+
    geom_violin(lwd=2,trim=FALSE,color="black", ) +
    geom_crossbar(stat = "summary", fun=mean, lwd=2, color="black") +
    geom_jitter(aes(color=Genotype), size=6, alpha=0.55) +
    ylab(plot_name) +
    ggtitle("") +
    theme_light() +
    scale_x_discrete(labels= x_labels ) + #, limits = rev) +
    scale_color_manual(values=darken_hex(colors_use,0.5)) +
    scale_fill_manual(values=colors_use) + #"dark gray", "light gray")) +
    theme(
      legend.position="none",
      plot.title = element_text(size=48,color="black",vjust=1,hjust=0.5,family="Arial", face="bold"),
      axis.text.y = element_text(size=44,color="black",family="Arial"),
      axis.title.y = element_text(size=44,color="black",family="Arial", face="plain"),
      axis.text.x = element_text(size=34,color="black",family="Arial", face="bold.italic", angle=60, vjust=1.1, hjust=1.1),
      axis.title.x = element_text(size=32,color="black",family="Arial", face="bold" ),
      strip.text.x = element_text(size=40,color="black",family="Arial", face="bold"),
      panel.grid = element_blank(),
      rect = element_rect( color="white", size=0)
    ) +  
    xlab("")
  
  return( pX)
}


p1 <- common_plot("Mean nucleus area um^2","Mean Area (μm²)")
p2 <- common_plot("kNuclei per mm2","Density (1000/mm²)")

ggsave( plot = (p1|plot_spacer()|p2) + plot_layout(widths=c(1,0.4,1)), height=10, width=10, filename = "DAPI cell measurements.png", units = "in",dpi = 100 )


sink( 'DAPI cell measurements test.txt' ) #, append = TRUE )
test_1 <- filter(DAPI_measurements, str_detect(Genotype,"Cre_\\+") )
test_2  <- filter(DAPI_measurements, str_detect(Genotype,"Cre_flox") )
print( t.test(test_1$`Mean nucleus area um^2`, test_2$`Mean nucleus area um^2`, alternative = "two.sided", paired = FALSE, var.equal = FALSE) )
print( t.test(test_1$`kNuclei per mm2`, test_2$`kNuclei per mm2`, alternative = "two.sided", paired = FALSE, var.equal = FALSE) )
sink()

#==============
#exit
#==============
exit()



