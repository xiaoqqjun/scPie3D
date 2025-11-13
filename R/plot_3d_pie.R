#' Plot 3D Pie Charts for Single-Cell Data
#'
#' Create 3D pie charts to visualize cell type distributions across groups
#' or group distributions across cell types in single-cell RNA-seq data.
#'
#' @param object A Seurat object or data frame containing single-cell data
#' @param group_by Character. Column name for grouping variable (e.g., "groups", "condition")
#' @param cell_type Character. Column name for cell type variable (e.g., "cell_type", "sub_cell_clusters")
#' @param mode Character. Either "by_group" (default) to show cell type distribution within each group,
#'   or "by_celltype" to show group distribution within each cell type
#' @param colors Character vector of colors. If NULL (default), uses Seurat discrete colors.
#'   Can also provide custom color vector
#' @param show_percentage Logical. Whether to display percentage values on pie slices (default: TRUE)
#' @param show_label Logical. Whether to display category labels on pie slices (default: TRUE)
#' @param label_threshold Numeric. Minimum percentage to display labels (default: 2)
#' @param explode Numeric. Separation degree of pie slices (0-0.2, default: 0.05)
#' @param theta Numeric. Tilt angle for 3D effect (0-1, default: 0.8)
#' @param shade Numeric. Shadow intensity (0-1, default: 0.6)
#' @param output_file Character. Output PDF file name. If NULL, plots to current device
#' @param width Numeric. Width of output PDF in inches (default: 12)
#' @param height Numeric. Height of output PDF in inches (default: 10)
#' @param show_legend Logical. Whether to show legend (default: TRUE)
#' @param legend_position Character. Legend position: "topright", "topleft", "bottomright", "bottomleft" (default: "topright")
#' @param main_title Character. Custom main title. If NULL, generates automatic title
#' @param label_cex Numeric. Label text size (default: 0.9)
#' @param title_cex Numeric. Title text size (default: 1.5)
#' @param legend_cex Numeric. Legend text size (default: 0.8)
#' @param fixed_order Logical. If TRUE, all groups use the same cell type order for consistent positioning (default: FALSE)
#' @param order_by Character. When fixed_order=TRUE, order by "frequency" (total across all groups) or "name" (alphabetical). Default: "frequency"
#'
#' @return Invisibly returns a list containing the plot data for each category
#'
#' @examples
#' \dontrun{
#' # Using Seurat object - show cell types by group
#' plot_3d_pie(seurat_obj, 
#'             group_by = "groups", 
#'             cell_type = "sub_cell_clusters",
#'             mode = "by_group")
#'
#' # Show groups by cell type
#' plot_3d_pie(seurat_obj, 
#'             group_by = "groups", 
#'             cell_type = "sub_cell_clusters",
#'             mode = "by_celltype")
#'
#' # Custom colors and parameters
#' plot_3d_pie(seurat_obj, 
#'             group_by = "groups", 
#'             cell_type = "cell_type",
#'             colors = c("red", "blue", "green"),
#'             show_percentage = TRUE,
#'             show_label = FALSE,
#'             output_file = "my_3d_pies.pdf")
#' }
#'
#' @export
#' @import plotrix
#' @importFrom dplyr filter group_by mutate ungroup arrange
#' @importFrom grDevices dev.off pdf colorRampPalette
#' @importFrom graphics legend layout par plot.new
plot_3d_pie <- function(object,
                        group_by,
                        cell_type,
                        mode = "by_group",
                        colors = NULL,
                        show_percentage = TRUE,
                        show_label = TRUE,
                        label_threshold = 2,
                        explode = 0.05,
                        theta = 0.8,
                        shade = 0.6,
                        output_file = NULL,
                        width = 12,
                        height = 10,
                        show_legend = TRUE,
                        legend_position = "topright",
                        main_title = NULL,
                        label_cex = 0.9,
                        title_cex = 1.5,
                        legend_cex = 0.8,
                        fixed_order = FALSE,
                        order_by = "frequency") {
  
  # Input validation
  mode <- match.arg(mode, c("by_group", "by_celltype"))
  
  # Extract data from object
  plot_data <- .extract_data(object, group_by, cell_type)
  
  # Prepare data based on mode
  if (mode == "by_group") {
    category_var <- group_by
    fill_var <- cell_type
  } else {
    category_var <- cell_type
    fill_var <- group_by
  }
  
  # Calculate proportions
  plot_data <- plot_data %>%
    dplyr::group_by(!!rlang::sym(category_var)) %>%
    dplyr::mutate(percentage = Freq / sum(Freq) * 100) %>%
    dplyr::ungroup()
  
  # Get all unique fill variable values (for consistent color mapping)
  all_fill_values <- unique(plot_data[[fill_var]])
  n_fill_values <- length(all_fill_values)
  
  # Get or generate colors
  if (is.null(colors)) {
    colors <- .get_seurat_colors(n_fill_values)
  } else {
    if (length(colors) < n_fill_values) {
      warning("Not enough colors provided. Expanding color palette.")
      colors <- grDevices::colorRampPalette(colors)(n_fill_values)
    }
  }
  
  # Create named color vector for consistent mapping
  names(colors) <- all_fill_values
  
  # Determine fixed order if requested
  if (fixed_order) {
    if (order_by == "frequency") {
      # Order by total frequency across all groups
      fill_order <- plot_data %>%
        dplyr::group_by(!!rlang::sym(fill_var)) %>%
        dplyr::summarise(total_freq = sum(Freq), .groups = 'drop') %>%
        dplyr::arrange(dplyr::desc(total_freq)) %>%
        dplyr::pull(!!rlang::sym(fill_var))
    } else {
      # Order alphabetically
      fill_order <- sort(all_fill_values)
    }
  } else {
    fill_order <- NULL
  }
  
  # Get unique categories
  categories <- unique(plot_data[[category_var]])
  
  # Open PDF device if output file specified
  if (!is.null(output_file)) {
    grDevices::pdf(output_file, width = width, height = height)
  }
  
  # Store results
  results <- list()
  
  # Plot for each category
  for (cat in categories) {
    # Filter data for current category
    temp_data <- plot_data %>%
      dplyr::filter(!!rlang::sym(category_var) == cat & Freq > 0)
    
    # Apply ordering
    if (fixed_order && !is.null(fill_order)) {
      # Use fixed order
      temp_data[[fill_var]] <- factor(temp_data[[fill_var]], levels = fill_order)
      temp_data <- temp_data %>%
        dplyr::arrange(!!rlang::sym(fill_var)) %>%
        dplyr::filter(!is.na(!!rlang::sym(fill_var)))  # Remove any NAs
    } else {
      # Order by frequency within this group (default behavior)
      temp_data <- temp_data %>%
        dplyr::arrange(dplyr::desc(Freq))
    }
    
    # Prepare labels
    labels <- .prepare_labels(temp_data[[fill_var]], 
                              temp_data$percentage,
                              show_percentage = show_percentage,
                              show_label = show_label,
                              label_threshold = label_threshold)
    
    # Get colors for current data (maintaining consistency)
    current_colors <- colors[temp_data[[fill_var]]]
    
    # Generate title
    if (is.null(main_title)) {
      if (mode == "by_group") {
        title <- paste0("Cell Type Distribution in ", cat, 
                       "\n(Total cells: ", format(sum(temp_data$Freq), big.mark = ","), ")")
      } else {
        title <- paste0("Group Distribution in ", cat,
                       "\n(Total cells: ", format(sum(temp_data$Freq), big.mark = ","), ")")
      }
    } else {
      title <- main_title
    }
    
    # Plot 3D pie
    plotrix::pie3D(temp_data$Freq,
                   labels = labels,
                   explode = explode,
                   col = current_colors,
                   main = title,
                   labelcex = label_cex,
                   theta = theta,
                   start = 0,
                   border = "white",
                   shade = shade,
                   cex.main = title_cex)
    
    # Add legend if requested
    if (show_legend) {
      graphics::legend(legend_position, 
                      legend = temp_data[[fill_var]],
                      fill = current_colors,
                      cex = legend_cex,
                      bty = "n")
    }
    
    # Store results
    results[[as.character(cat)]] <- temp_data
  }
  
  # Close PDF device if opened
  if (!is.null(output_file)) {
    grDevices::dev.off()
    message("3D pie charts saved to: ", output_file)
  }
  
  invisible(results)
}


#' Plot 3D Pie Charts with Side-by-Side Layout
#'
#' Create 3D pie charts arranged in a grid layout for easier comparison
#'
#' @param object A Seurat object or data frame containing single-cell data
#' @param group_by Character. Column name for grouping variable
#' @param cell_type Character. Column name for cell type variable
#' @param mode Character. Either "by_group" or "by_celltype"
#' @param colors Character vector of colors. If NULL, uses Seurat colors
#' @param show_percentage Logical. Whether to display percentages (default: TRUE)
#' @param label_threshold Numeric. Minimum percentage to display (default: 3)
#' @param explode Numeric. Separation degree (default: 0.05)
#' @param output_file Character. Output PDF file name
#' @param width Numeric. Width of output PDF (default: 18)
#' @param height Numeric. Height of output PDF (default: 12)
#' @param ncol Numeric. Number of columns in layout (default: 3)
#' @param show_common_legend Logical. Show a common legend (default: TRUE)
#' @param fixed_order Logical. If TRUE, all categories use the same order for consistent positioning (default: TRUE for grid layout)
#' @param order_by Character. When fixed_order=TRUE, order by "frequency" or "name". Default: "frequency"
#'
#' @return Invisibly returns plot data
#'
#' @examples
#' \dontrun{
#' plot_3d_pie_grid(seurat_obj, 
#'                  group_by = "groups", 
#'                  cell_type = "cell_type",
#'                  output_file = "grid_pies.pdf")
#' }
#'
#' @export
plot_3d_pie_grid <- function(object,
                             group_by,
                             cell_type,
                             mode = "by_group",
                             colors = NULL,
                             show_percentage = TRUE,
                             label_threshold = 3,
                             explode = 0.05,
                             output_file = NULL,
                             width = 18,
                             height = 12,
                             ncol = 3,
                             show_common_legend = TRUE,
                             fixed_order = TRUE,
                             order_by = "frequency") {
  
  # Extract and prepare data
  plot_data <- .extract_data(object, group_by, cell_type)
  
  if (mode == "by_group") {
    category_var <- group_by
    fill_var <- cell_type
  } else {
    category_var <- cell_type
    fill_var <- group_by
  }
  
  plot_data <- plot_data %>%
    dplyr::group_by(!!rlang::sym(category_var)) %>%
    dplyr::mutate(percentage = Freq / sum(Freq) * 100) %>%
    dplyr::ungroup()
  
  # Get all unique fill values for consistent color mapping
  all_fill_values <- unique(plot_data[[fill_var]])
  n_fill_values <- length(all_fill_values)
  
  # Get colors
  if (is.null(colors)) {
    colors <- .get_seurat_colors(n_fill_values)
  } else {
    if (length(colors) < n_fill_values) {
      warning("Not enough colors provided. Expanding color palette.")
      colors <- grDevices::colorRampPalette(colors)(n_fill_values)
    }
  }
  
  # Create named color vector for consistent mapping
  names(colors) <- all_fill_values
  
  # Determine fixed order if requested
  if (fixed_order) {
    if (order_by == "frequency") {
      # Order by total frequency across all categories
      fill_order <- plot_data %>%
        dplyr::group_by(!!rlang::sym(fill_var)) %>%
        dplyr::summarise(total_freq = sum(Freq), .groups = 'drop') %>%
        dplyr::arrange(dplyr::desc(total_freq)) %>%
        dplyr::pull(!!rlang::sym(fill_var))
    } else {
      # Order alphabetically
      fill_order <- sort(all_fill_values)
    }
  } else {
    fill_order <- NULL
  }
  
  categories <- unique(plot_data[[category_var]])
  n_categories <- length(categories)
  
  # Calculate layout
  nrow <- ceiling((n_categories + ifelse(show_common_legend, 1, 0)) / ncol)
  
  # Open PDF
  if (!is.null(output_file)) {
    grDevices::pdf(output_file, width = width, height = height)
  }
  
  # Set up layout
  if (show_common_legend) {
    layout_matrix <- matrix(1:(nrow * ncol), nrow = nrow, ncol = ncol, byrow = TRUE)
    graphics::layout(layout_matrix)
  } else {
    graphics::par(mfrow = c(nrow, ncol))
  }
  
  graphics::par(mar = c(2, 2, 4, 2))
  
  # Plot each pie
  for (cat in categories) {
    temp_data <- plot_data %>%
      dplyr::filter(!!rlang::sym(category_var) == cat & Freq > 0)
    
    # Apply ordering
    if (fixed_order && !is.null(fill_order)) {
      # Use fixed order
      temp_data[[fill_var]] <- factor(temp_data[[fill_var]], levels = fill_order)
      temp_data <- temp_data %>%
        dplyr::arrange(!!rlang::sym(fill_var)) %>%
        dplyr::filter(!is.na(!!rlang::sym(fill_var)))
    } else {
      # Order by frequency within this category (default)
      temp_data <- temp_data %>%
        dplyr::arrange(dplyr::desc(Freq))
    }
    
    pct_labels <- ifelse(temp_data$percentage > label_threshold,
                        paste0(round(temp_data$percentage, 1), "%"),
                        "")
    
    # Get colors for current data (maintaining consistency)
    current_colors <- colors[temp_data[[fill_var]]]
    
    plotrix::pie3D(temp_data$Freq,
                   labels = if(show_percentage) pct_labels else "",
                   explode = explode,
                   col = current_colors,
                   main = paste0(cat, "\n(n=", format(sum(temp_data$Freq), big.mark = ","), ")"),
                   labelcex = 1,
                   theta = 0.8,
                   start = 0,
                   border = "white",
                   shade = 0.6,
                   cex.main = 1.5)
  }
  
  # Add common legend
  if (show_common_legend) {
    graphics::plot.new()
    all_fills <- unique(plot_data[[fill_var]])
    legend_colors <- colors[all_fills]
    graphics::legend("center", 
                    legend = all_fills,
                    fill = legend_colors,
                    ncol = ifelse(length(all_fills) > 10, 3, 2),
                    cex = 1.2,
                    title = fill_var,
                    title.adj = 0.5,
                    bty = "n")
  }
  
  # Reset layout
  graphics::par(mfrow = c(1, 1))
  
  if (!is.null(output_file)) {
    grDevices::dev.off()
    message("Grid 3D pie charts saved to: ", output_file)
  }
  
  invisible(plot_data)
}
