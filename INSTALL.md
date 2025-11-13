# scPie3D Installation Guide

## Quick Installation

### Method 1: Install from tar.gz file

```r
# Install from local tar.gz file
install.packages("scPie3D_0.1.0.tar.gz", repos = NULL, type = "source")
```

### Method 2: Install from source directory

```r
# Install devtools if needed
install.packages("devtools")

# Install from source
devtools::install_local("path/to/scPie3D")
```

### Method 3: Install using R CMD

```bash
# In terminal/command line
R CMD INSTALL scPie3D_0.1.0.tar.gz
```

## Dependencies

The package will automatically install required dependencies:
- plotrix
- dplyr
- rlang

Optional dependencies (for Seurat objects):
- Seurat
- SeuratObject

Install optional dependencies manually if needed:

```r
install.packages("Seurat")
```

## Verify Installation

```r
# Load the package
library(scPie3D)

# Check package version
packageVersion("scPie3D")

# View help
?plot_3d_pie
```

## Quick Test

```r
# Create test data
test_df <- data.frame(
  groups = sample(c("A", "B", "C"), 1000, replace = TRUE),
  cell_type = sample(c("Type1", "Type2", "Type3", "Type4"), 1000, replace = TRUE)
)

# Create a simple 3D pie chart
plot_3d_pie(
  object = test_df,
  group_by = "groups",
  cell_type = "cell_type",
  output_file = "test_pie.pdf"
)
```

If the test runs successfully and generates `test_pie.pdf`, the installation is complete!

## Troubleshooting

### Issue: plotrix not found
```r
install.packages("plotrix")
```

### Issue: dplyr conflicts
```r
# Restart R session and load scPie3D first
library(scPie3D)
```

### Issue: Cannot create PDF
Check that you have write permissions in the output directory.

## Getting Help

- Check the README.md for examples
- View function documentation: `?plot_3d_pie`
- See example script: `examples/example_usage.R`
- Contact: xiaoqqjun@sina.com

## Uninstall

```r
remove.packages("scPie3D")
```
