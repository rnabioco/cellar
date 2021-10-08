FROM bioconductor/bioconductor_docker:RELEASE_3_13

LABEL image.authors=""

RUN Rscript -e "BiocManager::install(c('tidyverse', 'rmarkdown', 'Seurat','cowplot', 'colorblindr', 'ComplexHeatmap', 'scran','scDblFinder', 'limma', 'clustifyr', 'slingshot', 'tradeSeq', 'destiny'))"
RUN installGithub.r theislab/destiny
Run Rscript -e "install.packages('markdown')"

COPY test.Rmd /home/rstudio/
WORKDIR /home/rstudio

