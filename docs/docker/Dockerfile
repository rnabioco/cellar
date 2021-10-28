FROM bioconductor/bioconductor_docker:RELEASE_3_13

LABEL image.authors=""

RUN Rscript -e "BiocManager::install(c('tidyverse', 'rmarkdown', 'Seurat','cowplot', 'colorblindr', 'ComplexHeatmap', 'scran','scDblFinder', 'limma', 'clustifyr', 'slingshot', 'tradeSeq', 'clusterExperiment'))"
RUN installGithub.r theislab/destiny
RUN installGithub.r rnabioco/scbp
RUN installGithub.r immunogenomics/harmony
Run installGithub.r johannesbjork/LaCroixColoR

Run Rscript -e "install.packages('markdown')"

COPY test-install.Rmd /home/rstudio/
WORKDIR /home/rstudio

