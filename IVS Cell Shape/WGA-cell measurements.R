
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
WGA_measurements <-read_ods(path="WGA_quantified_cells.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)
WGA_measurements$Diameter <- WGA_measurements$Diameter * microns_per_pixel
WGA_measurements$Area <- WGA_measurements$Area * microns_per_pixel * microns_per_pixel

#==============
# generate per-cell boxplots
#==============
x_labels <- c("CreERT2/+","CreERT2/flox")
colors_use <- c("#cc75df","#85478a")

common_plot <- function( y_name, plot_name = y_name ) {
  pX <- WGA_measurements %>%
    ggplot( aes(x=Genotype, y=!!sym(y_name), fill=Genotype))+
    geom_violin(lwd=2,trim=FALSE,color="black", ) +
    geom_crossbar(stat = "summary", fun=mean, lwd=2, color="black") +
    geom_jitter(aes(color=Genotype), size=2, alpha=0.55) +
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


p1 <- common_plot("Diameter","Diameter (μm)")
p2 <- common_plot("Area","Area (μm²)")
p3 <- common_plot("Eccentricity","Eccentricity")

ggsave( plot = (p1|plot_spacer()|p2|plot_spacer()|p3) + plot_layout(widths=c(1,0.6,1,0.6,1)), height=10, width=17, filename = "WGA cell measurements.png", units = "in",dpi = 100 )


sink( 'WGA cell measurements test.txt' ) #, append = TRUE )
test_1 <- filter(WGA_measurements, str_detect(Genotype,"Cre_\\+") )
test_2  <- filter(WGA_measurements, str_detect(Genotype,"Cre_flox") )
print( t.test(test_1$Diameter, test_2$Diameter, alternative = "two.sided", paired = FALSE, var.equal = FALSE) )
print( t.test(test_1$Area, test_2$Area, alternative = "two.sided", paired = FALSE, var.equal = FALSE) )
print( t.test(test_1$Eccentricity, test_2$Eccentricity, alternative = "two.sided", paired = FALSE, var.equal = FALSE) )
sink()

#==============
#exit
#==============
exit()



