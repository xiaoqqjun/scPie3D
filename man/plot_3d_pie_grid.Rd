\name{plot_3d_pie_grid}
\alias{plot_3d_pie_grid}
\title{Plot 3D Pie Charts with Side-by-Side Layout}
\usage{
plot_3d_pie_grid(
  object,
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
  show_common_legend = TRUE
)
}
\arguments{
\item{object}{A Seurat object or data frame containing single-cell data}

\item{group_by}{Character. Column name for grouping variable}

\item{cell_type}{Character. Column name for cell type variable}

\item{mode}{Character. Either "by_group" or "by_celltype"}

\item{colors}{Character vector of colors. If NULL, uses Seurat colors}

\item{show_percentage}{Logical. Whether to display percentages (default: TRUE)}

\item{label_threshold}{Numeric. Minimum percentage to display (default: 3)}

\item{explode}{Numeric. Separation degree (default: 0.05)}

\item{output_file}{Character. Output PDF file name}

\item{width}{Numeric. Width of output PDF (default: 18)}

\item{height}{Numeric. Height of output PDF (default: 12)}

\item{ncol}{Numeric. Number of columns in layout (default: 3)}

\item{show_common_legend}{Logical. Show a common legend (default: TRUE)}
}
\value{
Invisibly returns plot data
}
\description{
Create 3D pie charts arranged in a grid layout for easier comparison
}
\examples{
\dontrun{
plot_3d_pie_grid(seurat_obj, 
                 group_by = "groups", 
                 cell_type = "cell_type",
                 output_file = "grid_pies.pdf")
}
}
\author{
xiaoqqjun <xiaoqqjun@sina.com>
}
