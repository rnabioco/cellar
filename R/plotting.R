#' 
#' @export
plot_feature <- function(seurat_obj,
                         ident = NULL,
                         gene = NULL,
                         plot_dat = NULL,
                         plot_col = NULL,
                         meta_data_col = NULL,
                         pt.size = 0.001,
                         pt.alpha = 0.25,
                         label_text = FALSE,
                         label.size = 6,
                         .cols = NULL,
                         legend_names = NULL,
                         cell_filter = NULL,
                         palette_type = "cloupe",
                         col_pal = "Reds",
                         max_y = NULL,
                         ...){
  
  mdata <- seurat_obj@meta.data %>% tibble::rownames_to_column("cell")
  
  tsne_dat <- seurat_obj@dr$tsne@cell.embeddings %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("cell")
  
  tsne_dat <- left_join(mdata, tsne_dat, by = "cell")
  
  if (!is.null(cell_filter)){
    tsne_dat <- dplyr::filter(tsne_dat,
                              cell %in% cell_filter)
  }
  
  if (!is.null(gene) & is.null(meta_data_col)) {
    gene_dat <- FetchData(seurat_obj, gene) %>% 
      as.data.frame() %>% 
      tibble::rownames_to_column("cell")
    tsne_dat <- left_join(tsne_dat, gene_dat, by = "cell")
  }
  
  if (!is.null(plot_dat)){
    tsne_dat <- left_join(tsne_dat, plot_dat, by = "cell")
  }
  
  if (!is.null(ident)){
    color_aes_str <- ident
  } else if (!is.null(plot_dat)){
    color_aes_str <- plot_col
  } else if (!is.null(meta_data_col)){
    color_aes_str <- gene
  } else {
    color_aes_str <- gene
  }
  
  color_aes_str_q <- quo(color_aes_str)
  tsne_dat <- tsne_dat %>% arrange_at(.vars = color_aes_str)
  
  p <- ggplot(tsne_dat, 
              aes(tSNE_1, tSNE_2)) +
    geom_point(aes_string(color = color_aes_str),
               size = pt.size,
               alpha = pt.alpha)
  
  ## handle legend limit 
  
  if (is.null(max_y) & is.null(ident)) {
    max_y <- c(0, max(tsne_dat[[color_aes_str]]))
  } else if (!is.null(ident) & is.null(max_y)){
    max_y <- c(NA, NA)
  } 
  
  
  # loupe-like colors
  cols <- rev(brewer.pal(11, "RdGy")[c(1:5, 7)])
  
  ## handle zero expression
  
  if (all(max_y == c(0, 0))){
    p <- p + scale_color_gradient(low = cols[1], high = cols[1])
    return(p)
  }
  
  ## handle colors
  if (is.null(.cols)){
    if (palette_type == "viridis") {
      p <- p + scale_color_viridis(discrete = F,
                                   direction = -1,
                                   option = col_pal,
                                   limits = max_y)
    } else if (palette_type == "brewer") {
      p <- p + scale_color_distiller(limits = max_y,
                                     palette = col_pal,
                                     direction = 1)
    } else if (palette_type == "cloupe") {
      
      p <- p + scale_color_gradientn(limits = max_y,
                                     colors = cols)
    }
  } 
  p
}