## scPie3D Example Usage Script
## Author: xiaoqqjun
## Email: xiaoqqjun@sina.com

# Install and load required packages
# install.packages("scPie3D_0.1.0.tar.gz", repos = NULL, type = "source")

library(scPie3D)
library(Seurat)  # If you're using Seurat objects

# =============================================================================
# Example 1: Basic Usage with Seurat Object
# =============================================================================

# Load your Seurat object (replace with your actual data)
# seurat_obj <- readRDS("your_seurat_object.rds")

# Example data structure should have:
# - A grouping variable (e.g., "groups", "condition", "treatment")
# - A cell type variable (e.g., "cell_type", "sub_cell_clusters", "seurat_clusters")

# Create 3D pie charts - cell types by group
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",           # Your grouping column
  cell_type = "sub_cell_clusters", # Your cell type column
  mode = "by_group",             # Show cell types within each group
  output_file = "example1_by_group.pdf"
)

# =============================================================================
# Example 2: Reverse View - Groups by Cell Type
# =============================================================================

# Show how groups are distributed within each cell type
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "sub_cell_clusters",
  mode = "by_celltype",          # Show groups within each cell type
  output_file = "example2_by_celltype.pdf"
)

# =============================================================================
# Example 3: Custom Colors
# =============================================================================

# Define custom colors
my_colors <- c(
  "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00",
  "#FFFF33", "#A65628", "#F781BF", "#999999", "#66C2A5"
)

plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  colors = my_colors,
  output_file = "example3_custom_colors.pdf"
)

# =============================================================================
# Example 4: Control Label Display
# =============================================================================

# Show only percentages (no category names)
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  show_percentage = TRUE,
  show_label = FALSE,           # Hide category names
  label_threshold = 5,          # Only show if >5%
  output_file = "example4_percent_only.pdf"
)

# Show only category names (no percentages)
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  show_percentage = FALSE,      # Hide percentages
  show_label = TRUE,
  output_file = "example5_labels_only.pdf"
)

# =============================================================================
# Example 5: Adjust 3D Effects
# =============================================================================

plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  explode = 0.15,               # More separation
  theta = 0.9,                  # Higher tilt angle
  shade = 0.8,                  # Stronger shadow
  output_file = "example6_enhanced_3d.pdf"
)

# =============================================================================
# Example 6: Grid Layout - All Pies on One Page
# =============================================================================

plot_3d_pie_grid(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  mode = "by_group",
  ncol = 3,                     # 3 columns
  show_common_legend = TRUE,    # Shared legend at bottom
  output_file = "example7_grid_layout.pdf",
  width = 18,
  height = 12
)

# =============================================================================
# Example 7: Using Data Frame Instead of Seurat Object
# =============================================================================

# Create a data frame from your data
df <- data.frame(
  groups = seurat_obj$groups,
  cell_type = seurat_obj$sub_cell_clusters
)

plot_3d_pie(
  object = df,                  # Use data frame instead
  group_by = "groups",
  cell_type = "cell_type",
  output_file = "example8_from_dataframe.pdf"
)

# =============================================================================
# Example 8: High Threshold for Clean Visualization
# =============================================================================

# Only show labels for major cell populations
plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  label_threshold = 10,         # Only show if >10%
  explode = 0.1,
  output_file = "example9_clean_major_pops.pdf"
)

# =============================================================================
# Example 9: No Legend (for presentations)
# =============================================================================

plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  show_legend = FALSE,          # Hide legend
  label_cex = 1.2,              # Larger labels
  title_cex = 2.0,              # Larger title
  output_file = "example10_no_legend.pdf"
)

# =============================================================================
# Example 10: Custom Dimensions and Layout
# =============================================================================

plot_3d_pie(
  object = seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  width = 15,                   # Custom width
  height = 12,                  # Custom height
  legend_position = "bottomright",
  output_file = "example11_custom_dims.pdf"
)

# =============================================================================
# Tips for Best Results
# =============================================================================

# 1. Color Selection:
#    - Use NULL for automatic Seurat colors
#    - Provide custom colors for specific branding
#    - Make sure you have enough colors for all categories

# 2. Label Threshold:
#    - Use 2-3% for detailed views
#    - Use 5-10% for cleaner, publication-ready figures

# 3. Mode Selection:
#    - "by_group": Compare cell type compositions across groups
#    - "by_celltype": Compare group contributions to each cell type

# 4. 3D Effect Parameters:
#    - explode: 0.05-0.15 (higher = more separation)
#    - theta: 0.7-0.9 (higher = more tilt)
#    - shade: 0.5-0.8 (higher = stronger shadow)

# 5. For Publications:
#    - Use grid layout for multiple comparisons
#    - Set label_threshold higher (5-10%)
#    - Use consistent colors across figures
#    - Adjust width/height for journal requirements

cat("Examples completed! Check your working directory for output PDFs.\n")
