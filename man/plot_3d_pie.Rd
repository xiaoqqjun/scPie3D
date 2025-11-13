\name{plot_3d_pie}
\alias{plot_3d_pie}
\title{Plot 3D Pie Charts for Single-Cell Data}
\usage{
plot_3d_pie(
  object,
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
  legend_cex = 0.8
)
}
\arguments{
\item{object}{A Seurat object or data frame containing single-cell data}

\item{group_by}{Character. Column name for grouping variable (e.g., "groups", "condition")}

\item{cell_type}{Character. Column name for cell type variable (e.g., "cell_type", "sub_cell_clusters")}

\item{mode}{Character. Either "by_group" (default) to show cell type distribution within each group,
or "by_celltype" to show group distribution within each cell type}

\item{colors}{Character vector of colors. If NULL (default), uses Seurat discrete colors.
Can also provide custom color vector}

\item{show_percentage}{Logical. Whether to display percentage values on pie slices (default: TRUE)}

\item{show_label}{Logical. Whether to display category labels on pie slices (default: TRUE)}

\item{label_threshold}{Numeric. Minimum percentage to display labels (default: 2)}

\item{explode}{Numeric. Separation degree of pie slices (0-0.2, default: 0.05)}

\item{theta}{Numeric. Tilt angle for 3D effect (0-1, default: 0.8)}

\item{shade}{Numeric. Shadow intensity (0-1, default: 0.6)}

\item{output_file}{Character. Output PDF file name. If NULL, plots to current device}

\item{width}{Numeric. Width of output PDF in inches (default: 12)}

\item{height}{Numeric. Height of output PDF in inches (default: 10)}

\item{show_legend}{Logical. Whether to show legend (default: TRUE)}

\item{legend_position}{Character. Legend position: "topright", "topleft", "bottomright", "bottomleft" (default: "topright")}

\item{main_title}{Character. Custom main title. If NULL, generates automatic title}

\item{label_cex}{Numeric. Label text size (default: 0.9)}

\item{title_cex}{Numeric. Title text size (default: 1.5)}

\item{legend_cex}{Numeric. Legend text size (default: 0.8)}
}
\value{
Invisibly returns a list containing the plot data for each category
}
\description{
Create 3D pie charts to visualize cell type distributions across groups
or group distributions across cell types in single-cell RNA-seq data.
}
\examples{
\dontrun{
# Using Seurat object - show cell types by group
plot_3d_pie(seurat_obj, 
            group_by = "groups", 
            cell_type = "sub_cell_clusters",
            mode = "by_group")

# Show groups by cell type
plot_3d_pie(seurat_obj, 
            group_by = "groups", 
            cell_type = "sub_cell_clusters",
            mode = "by_celltype")

# Custom colors and parameters
plot_3d_pie(seurat_obj, 
            group_by = "groups", 
            cell_type = "cell_type",
            colors = c("red", "blue", "green"),
            show_percentage = TRUE,
            show_label = FALSE,
            output_file = "my_3d_pies.pdf")
}
}
\author{
xiaoqqjun <xiaoqqjun@sina.com>
}
