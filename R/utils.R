#' Extract Data from Seurat Object or Data Frame
#'
#' @param object Seurat object or data frame
#' @param group_by Column name for grouping
#' @param cell_type Column name for cell type
#'
#' @return Data frame with Freq column
#' @keywords internal
#' @noRd
.extract_data <- function(object, group_by, cell_type) {
  
  # Check if Seurat object
  if (methods::is(object, "Seurat")) {
    # Extract metadata from Seurat object
    metadata <- object@meta.data
    
    if (!group_by %in% colnames(metadata)) {
      stop("Column '", group_by, "' not found in Seurat object metadata")
    }
    if (!cell_type %in% colnames(metadata)) {
      stop("Column '", cell_type, "' not found in Seurat object metadata")
    }
    
    # Create frequency table
    plot_data <- as.data.frame(table(metadata[[group_by]], metadata[[cell_type]]))
    colnames(plot_data) <- c(group_by, cell_type, "Freq")
    
  } else if (is.data.frame(object)) {
    # Handle data frame input
    if (!group_by %in% colnames(object)) {
      stop("Column '", group_by, "' not found in data frame")
    }
    if (!cell_type %in% colnames(object)) {
      stop("Column '", cell_type, "' not found in data frame")
    }
    
    plot_data <- as.data.frame(table(object[[group_by]], object[[cell_type]]))
    colnames(plot_data) <- c(group_by, cell_type, "Freq")
    
  } else {
    stop("Input must be either a Seurat object or a data frame")
  }
  
  return(plot_data)
}


#' Get Seurat Default Colors
#'
#' Generate colors using Seurat's discrete color palette
#'
#' @param n Number of colors needed
#'
#' @return Character vector of hex colors
#' @keywords internal
#' @noRd
.get_seurat_colors <- function(n) {
  
  # Seurat's default discrete color palette
  seurat_colors <- c(
    "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", 
    "#FFFF33", "#A65628", "#F781BF", "#999999", "#66C2A5", 
    "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F", 
    "#E5C494", "#B3B3B3", "#8DD3C7", "#FFFFB3", "#BEBADA",
    "#FB8072", "#80B1D3", "#FDB462", "#B3DE69", "#FCCDE5",
    "#D9D9D9", "#BC80BD", "#CCEBC5", "#FFED6F", "#1B9E77",
    "#D95F02", "#7570B3", "#E7298A", "#66A61E", "#E6AB02",
    "#A6761D", "#666666", "#7FC97F", "#BEAED4", "#FDC086",
    "#FFFF99", "#386CB0", "#F0027F", "#BF5B17", "#1F78B4",
    "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00",
    "#CAB2D6", "#6A3D9A", "#B15928", "#FBB4AE", "#B3CDE3",
    "#CCEBC5", "#DECBE4", "#FED9A6", "#FFFFCC", "#E5D8BD",
    "#FDDAEC", "#F2F2F2"
  )
  
  if (n <= length(seurat_colors)) {
    return(seurat_colors[1:n])
  } else {
    # If more colors needed, use colorRampPalette
    return(grDevices::colorRampPalette(seurat_colors)(n))
  }
}


#' Prepare Labels for Pie Chart
#'
#' Create appropriate labels based on user preferences
#'
#' @param names Character vector of category names
#' @param percentages Numeric vector of percentages
#' @param show_percentage Logical. Show percentage values
#' @param show_label Logical. Show category names
#' @param label_threshold Numeric. Minimum percentage to show
#'
#' @return Character vector of labels
#' @keywords internal
#' @noRd
.prepare_labels <- function(names, 
                           percentages, 
                           show_percentage = TRUE, 
                           show_label = TRUE, 
                           label_threshold = 2) {
  
  labels <- rep("", length(names))
  
  for (i in seq_along(names)) {
    if (percentages[i] > label_threshold) {
      if (show_label && show_percentage) {
        labels[i] <- paste0(names[i], "\n", round(percentages[i], 1), "%")
      } else if (show_label && !show_percentage) {
        labels[i] <- as.character(names[i])
      } else if (!show_label && show_percentage) {
        labels[i] <- paste0(round(percentages[i], 1), "%")
      }
    }
  }
  
  return(labels)
}


#' Validate Color Input
#'
#' Check if provided colors are valid
#'
#' @param colors Character vector of colors
#'
#' @return Logical indicating if colors are valid
#' @keywords internal
#' @noRd
.validate_colors <- function(colors) {
  
  if (is.null(colors)) {
    return(TRUE)
  }
  
  if (!is.character(colors)) {
    warning("Colors must be a character vector. Using default colors.")
    return(FALSE)
  }
  
  # Try to validate colors
  tryCatch({
    grDevices::col2rgb(colors)
    return(TRUE)
  }, error = function(e) {
    warning("Invalid color specification. Using default colors.")
    return(FALSE)
  })
}


#' Calculate Optimal PDF Dimensions
#'
#' Calculate appropriate width and height for multi-panel plots
#'
#' @param n_panels Number of panels to plot
#' @param ncol Number of columns
#' @param panel_width Width per panel
#' @param panel_height Height per panel
#'
#' @return List with width and height
#' @keywords internal
#' @noRd
.calc_dimensions <- function(n_panels, ncol = 3, panel_width = 6, panel_height = 5) {
  
  nrow <- ceiling(n_panels / ncol)
  
  list(
    width = ncol * panel_width,
    height = nrow * panel_height
  )
}
