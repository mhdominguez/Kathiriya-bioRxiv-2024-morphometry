
library(ggplot2)
library(readODS)
library(tidyverse)
library(dplyr)
library(extrafont)
loadfonts()

# source data location
setwd("Figure Data/")

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
basic_measurements <-read_ods(path="Basic measurements.ods", sheet=1, formula_as_formula=FALSE, verbose=FALSE)
basic_measurements$Measurement <- as.factor(basic_measurements$Measurement)

#==============
# generate per-heart boxplots
#==============
x_labels <- c("CreERT2/+","CreERT2/flox")
colors_use <- c("#dfd175","#8a7b47")

p1 <- basic_measurements %>%
  ggplot( aes(x=Genotype, y=Value, fill=Genotype))+#, alpha=0.95)) +
  geom_boxplot( outlier.shape = NA, lwd=2, color="black" ) +
  #scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(aes(color=Genotype), size=8, alpha=0.75) +
  facet_wrap(~Measurement, scale="fixed", nrow=1, labeller = label_wrap_gen(width=5)) +
  ylab("") +
  ggtitle("") + # length-normalized dimension
  theme_light() +
  scale_y_continuous(breaks=c(0.5,1.0,1.5)) +
  scale_x_discrete(labels= x_labels ) + #, limits = rev) +
  #scale_color_brewer(palette="YlOrRd") +
  #scale_fill_brewer(palette="YlOrRd") +
  scale_color_manual(values=darken_hex(colors_use,0.5)) +
  scale_fill_manual(values=colors_use) + #"dark gray", "light gray")) +
  theme(
    legend.position="none",
      plot.title = element_text(size=48,color="black",vjust=1,hjust=0.5,family="Arial", face="bold"),
      axis.text.y = element_text(size=44,color="black",family="Arial"),
      axis.title.y = element_text(size=44,color="black",family="Arial", face="bold"),
      axis.text.x = element_text(size=34,color="black",family="Arial", face="bold.italic", angle=60, vjust=1.1, hjust=1.1),
      axis.title.x = element_text(size=32,color="black",family="Arial", face="bold" ),
      strip.text.x = element_text(size=40,color="black",family="Arial", face="bold"),
    panel.grid = element_blank(),
    panel.border = element_rect(color = "dark gray", linetype="solid", linewidth = 5), 
    rect = element_rect( color="black", size=5)
  ) +  
  xlab("")

ggsave( plot = p1, height=10, width=10, filename = "Heart basic measurements.png", units = "in",dpi = 100 )


sink( 'boundary integrity test.txt' ) #, append = TRUE )
for (cat in levels(basic_measurements$Measurement)) {
  filtered_df <- basic_measurements[basic_measurements$Measurement == cat, ]
  
  test_1 <- filter(filtered_df, str_detect(Genotype,"Ctrl") )
  test_2  <- filter(filtered_df, str_detect(Genotype,"Mut") )

  print( t.test(test_1$Value, test_2$Value, alternative = "two.sided", paired = FALSE, var.equal = FALSE) )
  #var.test(test_1$Value, test_2$Value,  alternative = "two.sided", paired = FALSE)
  flush.console()
}
sink()

#==============
#exit
#==============
exit()



