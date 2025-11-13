# scPie3D: 3D Pie Charts for Single-Cell Data Visualization

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

`scPie3D` is an R package for creating beautiful 3D pie charts to visualize cell type distributions across different groups in single-cell RNA-seq data. It provides flexible options for customization and supports both Seurat objects and standard data frames.

## Installation

You can install the development version of scPie3D from the tar.gz file:

```r
install.packages("scPie3D_0.1.0.tar.gz", repos = NULL, type = "source")
```

Or install from source:

```r
# Install devtools if needed
install.packages("devtools")

# Install from GitHub
devtools::install_github("xiaoqqjun/scPie3D")
```

## Features

- 📊 Create stunning 3D pie charts for single-cell data
- 🎨 Automatic Seurat color schemes or custom colors
- 🔄 Two visualization modes: by group or by cell type
- ⚙️ Flexible display options (percentages, labels, thresholds)
- 📑 Multiple plot layouts (single or grid)
- 💾 Direct PDF output support

## Quick Start

### Basic Usage

```r
library(scPie3D)
library(Seurat)

# Load your Seurat object
# seurat_obj <- readRDS("your_seurat_object.rds")

# Create 3D pie charts showing cell type distribution in each group
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "sub_cell_clusters",
  mode = "by_group",
  output_file = "cell_types_by_group.pdf"
)

# Create 3D pie charts showing group distribution in each cell type
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "sub_cell_clusters",
  mode = "by_celltype",
  output_file = "groups_by_celltype.pdf"
)
```

### Grid Layout

```r
# Create a grid layout with all pies on one page
plot_3d_pie_grid(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  mode = "by_group",
  ncol = 3,
  output_file = "grid_pies.pdf"
)
```

### Custom Colors

```r
# Use custom colors
my_colors <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00")

plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  colors = my_colors,
  output_file = "custom_colors.pdf"
)
```

### Control Label Display

```r
# Show only percentages (no cell type names)
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  show_percentage = TRUE,
  show_label = FALSE,
  label_threshold = 5,  # Only show labels >5%
  output_file = "percentages_only.pdf"
)

# Show only cell type names (no percentages)
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  show_percentage = FALSE,
  show_label = TRUE,
  output_file = "labels_only.pdf"
)
```

## Function Parameters

### plot_3d_pie()

Main function for creating 3D pie charts:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `object` | Seurat object or data frame | - |
| `group_by` | Column name for grouping variable | - |
| `cell_type` | Column name for cell type variable | - |
| `mode` | "by_group" or "by_celltype" | "by_group" |
| `colors` | Color vector (NULL uses Seurat colors) | NULL |
| `show_percentage` | Display percentage values | TRUE |
| `show_label` | Display category labels | TRUE |
| `label_threshold` | Minimum % to show labels | 2 |
| `explode` | Pie slice separation (0-0.2) | 0.05 |
| `theta` | 3D tilt angle (0-1) | 0.8 |
| `shade` | Shadow intensity (0-1) | 0.6 |
| `output_file` | PDF output filename | NULL |
| `width` | PDF width in inches | 12 |
| `height` | PDF height in inches | 10 |
| `show_legend` | Display legend | TRUE |
| `legend_position` | Legend position | "topright" |

### plot_3d_pie_grid()

Create grid layout with multiple pies:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ncol` | Number of columns | 3 |
| `show_common_legend` | Show shared legend | TRUE |

All other parameters same as `plot_3d_pie()`.

## Examples

### Example 1: Cell Type Distribution by Group

```r
# Visualize how cell types are distributed within each experimental group
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "sub_cell_clusters",
  mode = "by_group",
  show_percentage = TRUE,
  show_label = TRUE,
  label_threshold = 2,
  explode = 0.1,
  output_file = "celltype_by_group.pdf",
  width = 12,
  height = 10
)
```

### Example 2: Group Distribution by Cell Type

```r
# Visualize how groups are distributed within each cell type
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "sub_cell_clusters",
  mode = "by_celltype",
  show_percentage = TRUE,
  label_threshold = 3,
  output_file = "group_by_celltype.pdf"
)
```

### Example 3: Minimal Labels (Clean Look)

```r
# Show only percentages for cleaner visualization
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "sub_cell_clusters",
  show_percentage = TRUE,
  show_label = FALSE,
  label_threshold = 5,
  explode = 0.08,
  output_file = "minimal_labels.pdf"
)
```

### Example 4: Using Data Frame Instead of Seurat Object

```r
# Create a data frame
df <- data.frame(
  groups = scedata$groups,
  cell_type = scedata$sub_cell_clusters
)

plot_3d_pie(
  object = df,
  group_by = "groups",
  cell_type = "cell_type",
  output_file = "from_dataframe.pdf"
)
```

## Output

The package generates publication-ready PDF files with:
- High-resolution 3D pie charts
- Automatic titles with cell counts
- Color-coded legends
- Percentage labels (configurable)
- Professional styling

## Tips

1. **Color Selection**: Use `NULL` for automatic Seurat colors, or provide custom colors
2. **Label Threshold**: Increase `label_threshold` for cleaner plots with many small categories
3. **Explode Parameter**: Use 0.05-0.15 for good separation without excessive spreading
4. **Mode Selection**: 
   - Use `"by_group"` to compare cell type compositions across groups
   - Use `"by_celltype"` to compare group contributions to each cell type

## Citation

If you use scPie3D in your research, please cite:

```
xiaoqqjun (2025). scPie3D: 3D Pie Charts for Single-Cell Data Visualization. 
R package version 0.1.0.
```

## Author

**xiaoqqjun**
- Email: xiaoqqjun@sina.com
- ORCID: 0000-0003-1813-1669

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Issues

If you encounter any problems or have suggestions, please open an issue on GitHub.

## Acknowledgments

This package builds upon:
- `plotrix` for 3D pie chart rendering
- `Seurat` for single-cell data handling
- `dplyr` for data manipulation
