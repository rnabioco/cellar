#' Plot cells in reduced dimensionality 2D space
#'
#' @description Cells can be colored by gene or feature in meta.data dataframe
#'
#' @param seurat_obj object of class Seurat
#' @param feature feature to plot, either gene name or column in seurat_obj@meta.data
#' @param plot_dat supplemental data.frame containing feature to plot.
#' Must have a column named cell that contains matching colnames in seurat_obj@data
#' @param pt_size size of points produced by geom_point
#' @param pt_alpha alpha value for points plotted by geom_point
#' @param label_text if TRUE display feature labels on plot
#' @param label_size size of label text
#' @param label_color color of label text
#' @param .cols vector of colors to use for plot.
#' @param cell_filter character vector of cell names to include in plot
#' @param palette_type color palette type to use (either viridis, brewer, or cloupe)
#' defaults to using cellranger loupe-like colors
#' @param col_pal palette name to use if palette_type is brewer
#' @param max_y maximum feature value to set scale to. Defaults to max of the feature
#' @param legend_title string to supply for title for the legend
#' @param embedding dimensionality reduction to extract from seurat_obj. Can be any
#' dr method present in seurat_obj@dr (e.g. umap, pca, tsne). defaults to tsne
#;
#' @export
plot_feature <- function(seurat_obj,
                         feature = NULL,
                         plot_dat = NULL,
                         pt_size = 0.001,
                         pt_alpha = 1,
                         label_text = FALSE,
                         label_size = 6,
                         label_color = "grey",
                         .cols = NULL,
                         cell_filter = NULL,
                         palette_type = "cloupe",
                         col_pal = "Reds",
                         max_y = NULL,
                         legend_title = NULL,
                         embedding = "tsne"){
  
  if(length(feature) > 1) {
    args <- as.list(match.call())[-1]
    plts <- list()
    for(i in seq_along(feature)){
      args$feature <- feature[i]
      plts[[i]] <- do.call(plot_feature, args)
    }
    return(plts)
  }
  
  mdata <- seurat_obj@meta.data %>% tibble::rownames_to_column("cell")
  
  if(!embedding %in% names(seurat_obj@dr)){
    stop(paste0(embedding, " not found in seurat object"))
  }
  
  embed_dat <- seurat_obj@dr[[embedding]]@cell.embeddings %>%
    as.data.frame() %>%
    tibble::rownames_to_column("cell")
  
  embed_cols <- colnames(embed_dat)
  xcol <- embed_cols[2]
  ycol <- embed_cols[3]
  
  embed_dat <- left_join(mdata, embed_dat, by = "cell")
  
  if (!is.null(cell_filter)){
    embed_dat <- dplyr::filter(embed_dat,
                               cell %in% cell_filter)
  }
  
  meta_data_col <- feature %in% colnames(embed_dat)
  
  if (!is.null(feature) & !meta_data_col) {
    feature_dat <- get_data(seurat_obj, feature) %>%
      as.data.frame() %>%
      tibble::rownames_to_column("cell")
    embed_dat <- left_join(embed_dat, feature_dat, by = "cell")
  }
  
  if (!is.null(plot_dat)){
    embed_dat <- left_join(embed_dat, plot_dat, by = "cell")
  }
  
  color_aes_str <- feature
  
  color_aes_str_q <- quo(color_aes_str)
  embed_dat <- embed_dat %>% arrange_at(.vars = color_aes_str)
  
  p <- ggplot(embed_dat,
              aes_string(xcol, ycol)) +
    geom_point(aes_string(color = color_aes_str),
               size = pt_size,
               alpha = pt_alpha)
  
  ## discrete or continuous data?
  if (typeof(embed_dat[[feature]]) %in% c(
    "character",
    "logical"
  ) | is.factor(embed_dat[[feature]])) {
    discrete <- T
  } else {
    discrete <- F
  }
  
  ## increase legend size
  if (discrete) {
    p <- p + guides(colour = guide_legend(override.aes = list(size = 4))) +
      theme(legend.title = element_blank())
  }
  
  if (label_text) {
    if(discrete) {
      tsne_mean_dat <- embed_dat %>%
        group_by_at(vars(one_of(feature))) %>%
        summarize(med_dim_1 = median(tSNE_1),
                  med_dim_2 = median(tSNE_2))
      
      p <- p +
        geom_text(data = tsne_mean_dat,
                  aes_string(x = "med_dim_1",
                             y = "med_dim_2",
                             label = feature),
                  size = label_size,
                  color = label_color)
    } else {
      warning("label_text not compatible with continuous features")
    }
  }
  
  ## handle legend limit
  if (is.null(max_y) & !discrete) {
    max_y <- c(0, max(embed_dat[[color_aes_str]]))
  } else if (discrete & is.null(max_y)){
    max_y <- c(NA, NA)
  }
  
  # loupe-like colors
  cols <- rev(brewer.pal(11, "RdGy")[c(1:5, 7)])
  
  #handle legend name
  if(is.null(legend_title)) legend_title <- color_aes_str
  
  ## handle zero expression
  if (!all(is.na(max_y)) && all(max_y == c(0, 0))){
    p <- p + scale_color_gradient(low = cols[1], high = cols[1], name = legend_title)
    return(p)
  }
  
  ## handle colors
  if (is.null(.cols) && !discrete){
    if (palette_type == "viridis") {
      p <- p + scale_color_viridis(discrete = F,
                                   direction = -1,
                                   option = col_pal,
                                   limits = max_y, name = legend_title)
    } else if (palette_type == "brewer") {
      p <- p + scale_color_distiller(limits = max_y,
                                     palette = col_pal,
                                     direction = 1, name = legend_title)
    } else if (palette_type == "cloupe") {
      p <- p + scale_color_gradientn(limits = max_y,
                                     colors = cols, name = legend_title)
    }
  } else if (!is.null(.cols) && !discrete){
    p <- p + scale_color_gradientn(limits = max_y,
                                   colors = .cols, name = legend_title)
  } else {
    
    if(!is.null(.cols)) {
      # use colors provided
      p <- p + scale_color_manual(
        values = .cols,
        name = legend_title
      )
    } else {
      p <- p + scale_color_manual(
        values = discrete_palette_default,
        name = legend_title
      )
    }
  }
  p + theme_cowplot()
}

#' Get gene or meta.data column from a seurat object
#' 
get_data <- function(seurat_obj, features = NULL) {
  
  features_are_genes <- features %in% rownames(seurat_obj@data)
 
  if (any(features_are_genes)) {
    gene_expr <- t(as.matrix(seurat_obj@data[features[features_are_genes], 
                                       , 
                                       drop = FALSE]))
  } else {
    gene_expr <- NULL
  }
  
  if (all(features_are_genes)) {
    return(as.matrix(gene_expr))
  }
   
 features_are_mdata <- features %in% colnames(sobj@meta.data)
 
 if(any(features_are_mdata)){
   mdata_cols <- seurat_obj@meta.data[, 
                                      which(features %in% colnames(sobj@meta.data))]
   if(is.null(gene_expr)){
     return(mdata_cols)
   } else {
     return(cbind(gene_expr, mdata_cols))
   }
 } else {
    stop("no features found in seurat object")
  }
 
}


discrete_palette_default <- c(brewer.pal(12, "Paired"),
                              brewer.pal(9, "Set1"),
                              brewer.pal(8, "Set2"),
                              brewer.pal(8, "Dark2"))


# Calculate Force Directed Layout ------------------------------------------------

#' Calculate force directed graph coordinates
#' 
#' @param seurat_obj seurat_obj
#' @param k_neighbors number of nearest neighbors to compute
#' @param seed integer seed for reproducible analysis
#' 
#' @return data.frame with columns necessary for plotting with ggnetwork, 
#' and all columns from meta.data slot
#' 
#' @importFrom ggnetwork ggnetwork
#' @importFrom RANN nn2
#' @export
calc_graph <- function(seurat_obj, k_neighbors = 15, seed = 42) {
  
  mat <- seurat_obj@dr$pca@cell.embeddings
  
  # calculate nearest neighbors in PCA space
  knn.info <- RANN::nn2(mat, k = k_neighbors)
  knn <- knn.info$nn.idx
  
  # convert to adjacency matrix
  adj <- matrix(0, nrow(mat), nrow(mat))
  rownames(adj) <- colnames(adj) <- rownames(mat)
  for(i in seq_len(nrow(mat))) {
    adj[i,rownames(mat)[knn[i,]]] <- 1
  }
  
  # make force directed graph directly from adjacency matrix
  set.seed(seed)
  gn <- ggnetwork::ggnetwork(adj, 
                  layout = "fruchtermanreingold", 
                  niter = 500)
  
  mdata <- tibble::as_tibble(seurat_obj@meta.data, rownames = "cell")
  
  # add in metadata
  gn$vertex.names <- as.character(gn$vertex.names)
  gn <- left_join(gn, mdata, by = c("vertex.names" = "cell"))
  
  gn
  
}

#' Plot force directed graph with cell annotations
#' 
#' @param graph_df data.frame produced by calc_graph
#' @param color_by column from graph_df to color cells by
#' 
#' @return ggplot object
#' 
#' @import ggnetwork
#' @export
plot_graph <- function(graph_df, 
                       color_by = "orig.ident"){
  
  graph_df <- graph_df %>% arrange_at(.vars = color_by)
  
  p <- ggplot(graph_df,
         aes(x, y, xend = xend, yend = yend)) +
    geom_edges(
      aes_string(color = color_by),
      alpha = 0.1,
      arrow = arrow(length = unit(0.1, "pt"),
                    type = "closed"),
      curvature = 0.05) +
    geom_nodes(aes_string(color = color_by),
               size = 0.1) 
  
  if(is_discrete(graph_df[[color_by]])){
    p <- p + scale_color_manual(color_by, values = discrete_palette_default) 
  } else {
    max_y <- c(0, max(graph_df[[color_by]]))
    cols <- rev(brewer.pal(11, "RdGy")[c(1:5, 7)])
    
    p <- p + scale_color_gradientn(limits = max_y,
                                   colors = cols, 
                                   name = color_by)
  }
    
  p + 
  theme_blank() +
  theme(legend.position = "bottom")
}



is_discrete <- function(x){
  if (typeof(x) %in% c(
    "character",
    "logical"
  ) | is.factor(x)) {
    discrete <- TRUE
  } else {
    discrete <- FALSE
  }
  discrete
}

