# scPie3D: 3D Pie Charts for Single-Cell Data Visualization

[![Version](https://img.shields.io/badge/version-0.1.2-blue.svg)](https://github.com/yourusername/scPie3D)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-%E2%89%A5%204.0.0-blue.svg)](https://www.r-project.org/)

## 📖 概述

`scPie3D` 是一个专为单细胞RNA-seq数据设计的R包，用于创建美观、专业的3D饼图。该包解决了传统饼图在多组比较时的**颜色不一致**和**位置不一致**问题，让数据可视化更加直观和易于比较。

<table>
<tr>
<td width="50%">

### ✨ 主要特性

- 🎨 **颜色一致性** - 相同细胞类型在所有组保持相同颜色
- 📍 **位置一致性** - 可固定细胞类型位置，便于对比
- 🎯 **双向分析** - 支持按组或按细胞类型两种视角
- 🖼️ **灵活布局** - 单页多图或网格布局
- 🎨 **智能配色** - 自动Seurat配色或自定义
- ⚙️ **高度定制** - 20+参数满足各种需求

</td>
<td width="50%">

### 🎯 适用场景

- ✅ 单细胞RNA-seq数据可视化
- ✅ 多组细胞类型组成比较
- ✅ 时间序列细胞分布分析
- ✅ 不同条件/组织的细胞比例
- ✅ 科研论文图表制作
- ✅ 学术汇报演示

</td>
</tr>
</table>

---

## 🚀 快速开始

### 安装

```r
# 方法1: 从tar.gz安装（推荐）
install.packages("scPie3D_0.1.2.tar.gz", repos = NULL, type = "source")

# 方法2: 从GitHub安装
devtools::install_github("xiaoqqjun/scPie3D")

# 加载包
library(scPie3D)
```

### 5分钟上手

```r
library(scPie3D)
library(Seurat)

# 最简单的使用 - 按组显示细胞类型分布
plot_3d_pie(
  object = your_seurat_obj,
  group_by = "groups",              # 分组列名
  cell_type = "sub_cell_clusters",  # 细胞类型列名
  output_file = "result.pdf"
)

# 网格布局 - 所有组在一页，便于对比
plot_3d_pie_grid(
  object = your_seurat_obj,
  group_by = "groups",
  cell_type = "cell_type",
  ncol = 3,
  output_file = "grid_result.pdf"
)
```

---

## 🎨 核心功能详解

### 功能1: 颜色一致性保证 (v0.1.1+)

**问题**: 传统方法中，相同细胞类型在不同组显示不同颜色

```r
# ❌ 问题示例
# Sham组: Neu(红) Gran(蓝) Mo(绿)
# D02组:  Neu(蓝) Gran(绿) Mo(红)  # 颜色不一致！
```

**解决**: scPie3D自动建立全局颜色映射

```r
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "celltype"
  # ✅ 自动保证颜色一致
  # Sham组: Neu(红) Gran(蓝) Mo(绿)
  # D02组:  Neu(红) Gran(蓝) Mo(绿)
)
```

### 功能2: 位置一致性控制 (v0.1.2+)

**问题**: 每个组按自己的频率排序，导致位置不一致

```r
# ❌ 默认行为
# Sham组: Mo(36%)在右上 → Gran(28%) → Neu(23%)
# D02组:  Neu(36%)在右上 → Gran(26%) → Mo(18%)
```

**解决**: 使用`fixed_order`参数固定位置

```r
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "celltype",
  fixed_order = TRUE,        # 固定顺序
  order_by = "frequency"     # 按总频率排序
  # ✅ 位置一致
  # 两个组都是: Neu → Gran → Mo → Tc (按总频率)
)
```

### 功能3: 双向分析模式

#### Mode 1: by_group - 按组显示细胞类型分布

**用途**: 比较各组之间的细胞类型组成差异

```r
plot_3d_pie(
  object = scedata,
  group_by = "groups",           # PRI, LNM, BM, LM
  cell_type = "cell_type",
  mode = "by_group"              # 每个组一个饼图
)
```

**结果**: 生成4个饼图，分别显示PRI、LNM、BM、LM各组的细胞类型构成

#### Mode 2: by_celltype - 按细胞类型显示组分布

**用途**: 比较某个细胞类型在不同组的分布

```r
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  mode = "by_celltype"           # 每个细胞类型一个饼图
)
```

**结果**: 每个细胞类型一个饼图，显示该类型在各组的占比

---

## 📋 函数参数详解

### plot_3d_pie() - 主函数

创建3D饼图，每个类别独立一页。

#### 基础参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `object` | Seurat/data.frame | - | 数据对象（必需）|
| `group_by` | character | - | 分组变量列名（必需）|
| `cell_type` | character | - | 细胞类型列名（必需）|
| `mode` | character | "by_group" | 模式："by_group"或"by_celltype" |

#### 颜色和样式参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `colors` | character vector | NULL | 颜色向量，NULL使用Seurat配色 |
| `explode` | numeric | 0.05 | 饼图分离度(0-0.2) |
| `theta` | numeric | 0.8 | 3D倾斜角度(0-1) |
| `shade` | numeric | 0.6 | 阴影强度(0-1) |

#### 标签控制参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `show_percentage` | logical | TRUE | 是否显示百分比 |
| `show_label` | logical | TRUE | 是否显示类别名称 |
| `label_threshold` | numeric | 2 | 标签显示阈值(%) |
| `label_cex` | numeric | 0.9 | 标签字体大小 |

#### ⭐ 新功能：一致性控制参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `fixed_order` | logical | FALSE | 是否固定细胞类型顺序 |
| `order_by` | character | "frequency" | 排序方式："frequency"或"name" |

#### 输出参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `output_file` | character | NULL | 输出PDF文件名 |
| `width` | numeric | 12 | PDF宽度(英寸) |
| `height` | numeric | 10 | PDF高度(英寸) |
| `show_legend` | logical | TRUE | 是否显示图例 |
| `legend_position` | character | "topright" | 图例位置 |
| `main_title` | character | NULL | 自定义标题 |
| `title_cex` | numeric | 1.5 | 标题字体大小 |
| `legend_cex` | numeric | 0.8 | 图例字体大小 |

### plot_3d_pie_grid() - 网格布局函数

将多个饼图排列在一页，便于比较。

#### 特殊参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `ncol` | numeric | 3 | 网格列数 |
| `show_common_legend` | logical | TRUE | 显示共同图例 |
| `fixed_order` | logical | **TRUE** | 默认固定顺序(与plot_3d_pie不同) |
| `width` | numeric | 18 | PDF宽度 |
| `height` | numeric | 12 | PDF高度 |

**注意**: `plot_3d_pie_grid()` 默认 `fixed_order=TRUE`，因为网格布局主要用于对比。

---

## 💡 使用示例

### 示例1: 基础使用

```r
# 最简单的调用
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type"
)
```

### 示例2: 发表级图形（推荐配置）

```r
plot_3d_pie_grid(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  
  # 一致性设置
  fixed_order = TRUE,         # 固定位置
  order_by = "frequency",     # 按总频率排序
  colors = NULL,              # 自动配色
  
  # 标签控制
  show_percentage = TRUE,
  label_threshold = 5,        # 只显示>5%
  
  # 布局
  ncol = 3,
  show_common_legend = TRUE,
  
  # 输出
  output_file = "publication_figure.pdf",
  width = 18,
  height = 12
)
```

### 示例3: 自定义颜色

```r
# 使用自己的配色方案
my_colors <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00",
               "#FFFF33", "#A65628", "#F781BF", "#999999")

plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  colors = my_colors,
  output_file = "custom_colors.pdf"
)
```

### 示例4: 控制标签显示

```r
# 只显示百分比，不显示细胞类型名称
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  show_percentage = TRUE,
  show_label = FALSE,        # 隐藏名称
  label_threshold = 5,       # 只显示>5%的
  output_file = "percentage_only.pdf"
)

# 只显示主要细胞群（>10%）
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  label_threshold = 10,      # 高阈值
  output_file = "major_populations.pdf"
)
```

### 示例5: 调整3D效果

```r
# 强3D效果（适合演示）
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  explode = 0.15,            # 更大分离
  theta = 0.9,               # 更高倾角
  shade = 0.8,               # 更强阴影
  label_cex = 1.5,           # 更大标签
  output_file = "strong_3d.pdf"
)

# 弱3D效果（接近2D）
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  explode = 0.02,            # 最小分离
  theta = 0.5,               # 较小倾角
  shade = 0.4,               # 较弱阴影
  output_file = "weak_3d.pdf"
)
```

### 示例6: 使用data.frame而非Seurat对象

```r
# 从Seurat对象提取数据
df <- data.frame(
  groups = scedata$groups,
  cell_type = scedata$sub_cell_clusters
)

# 直接使用data.frame
plot_3d_pie(
  object = df,
  group_by = "groups",
  cell_type = "cell_type",
  output_file = "from_dataframe.pdf"
)
```

### 示例7: 反向分析（按细胞类型显示组分布）

```r
# 看某个细胞类型在各组的分布
plot_3d_pie(
  object = scedata,
  group_by = "groups",           # 会作为填充变量
  cell_type = "cell_type",       # 会作为分类变量
  mode = "by_celltype",          # 关键参数
  output_file = "by_celltype.pdf"
)
```

### 示例8: 时间序列分析

```r
# 观察细胞类型随时间的变化
plot_3d_pie_grid(
  object = scedata,
  group_by = "timepoint",        # D0, D2, D7, D14
  cell_type = "cell_type",
  fixed_order = TRUE,            # 固定位置便于对比
  ncol = 4,                      # 4个时间点排成一行
  output_file = "timeseries.pdf",
  width = 20,
  height = 6
)
```

### 示例9: 批量生成多个分组

```r
# 为不同的分组变量生成图
grouping_vars <- c("treatment", "tissue", "stage")

for(var in grouping_vars) {
  plot_3d_pie_grid(
    object = scedata,
    group_by = var,
    cell_type = "cell_type",
    output_file = paste0("pie_by_", var, ".pdf")
  )
}
```

### 示例10: 完全自定义的发表图

```r
# 精确控制所有参数
plot_3d_pie_grid(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  mode = "by_group",
  
  # 一致性
  fixed_order = TRUE,
  order_by = "frequency",
  
  # 颜色
  colors = NULL,              # Seurat配色
  
  # 3D效果
  explode = 0.08,
  theta = 0.85,
  shade = 0.7,
  
  # 标签
  show_percentage = TRUE,
  label_threshold = 3,
  
  # 布局
  ncol = 3,
  show_common_legend = TRUE,
  
  # 字体大小
  label_cex = 1.0,
  title_cex = 1.8,
  legend_cex = 1.2,
  
  # 输出
  output_file = "final_figure.pdf",
  width = 20,
  height = 14
)
```

---

## 🎯 使用建议

### 何时使用fixed_order = TRUE？

#### ✅ 推荐场景

1. **多组对比** - 需要直观比较各组差异
2. **时间序列** - 观察细胞类型随时间变化
3. **发表图形** - 论文中的对比图
4. **网格布局** - 使用plot_3d_pie_grid时

#### ❌ 不推荐场景

1. **单组展示** - 只关注一个组的内部构成
2. **探索分析** - 快速了解各组特点
3. **突出主要群体** - 想让最大的细胞类型在最显眼位置

### 参数调优指南

#### 标签阈值 (label_threshold)

- **2-3%**: 详细展示，适合细胞类型少的数据
- **5-7%**: 平衡，适合大多数情况
- **10%+**: 只显示主要群体，适合细胞类型很多的数据

#### 3D效果参数

**保守配置**（适合发表）:
```r
explode = 0.05-0.08
theta = 0.7-0.8
shade = 0.5-0.6
```

**强效果配置**（适合演示）:
```r
explode = 0.1-0.15
theta = 0.85-0.9
shade = 0.7-0.8
```

#### 输出尺寸

**单页多图** (plot_3d_pie):
```r
width = 10-12
height = 8-10
```

**网格布局** (plot_3d_pie_grid):
```r
width = 15-20  (ncol * 5-6)
height = 10-15 (nrow * 5)
```

---

## 📊 实际应用案例

### 案例1: 肿瘤微环境分析

```r
# 比较原发灶、淋巴结转移、远处转移的细胞组成
plot_3d_pie_grid(
  object = tumor_data,
  group_by = "site",         # Primary, LN_metastasis, Distant_metastasis
  cell_type = "cell_type",
  fixed_order = TRUE,
  label_threshold = 5,
  ncol = 3,
  output_file = "tumor_microenvironment.pdf"
)
```

### 案例2: 药物响应研究

```r
# 比较不同药物处理后的细胞类型变化
plot_3d_pie(
  object = drug_response_data,
  group_by = "treatment",    # Control, DrugA, DrugB, Combination
  cell_type = "cell_type",
  fixed_order = TRUE,
  order_by = "frequency",
  output_file = "drug_response.pdf"
)
```

### 案例3: 发育时间轴

```r
# 追踪细胞分化过程
plot_3d_pie_grid(
  object = development_data,
  group_by = "stage",        # E10, E12, E14, E16, E18
  cell_type = "cell_type",
  fixed_order = TRUE,
  ncol = 5,
  width = 25,
  output_file = "development_timeline.pdf"
)
```

---

## 🔧 故障排除

### 问题1: 颜色仍然不一致

**可能原因**: 使用了旧版本

**解决方案**:
```r
# 检查版本
packageVersion("scPie3D")  # 应该是 0.1.1 或更高

# 更新到最新版
remove.packages("scPie3D")
install.packages("scPie3D_0.1.2.tar.gz", repos = NULL, type = "source")
```

### 问题2: 位置仍然不一致

**可能原因**: 未设置`fixed_order = TRUE`

**解决方案**:
```r
plot_3d_pie(
  object = scedata,
  group_by = "groups",
  cell_type = "cell_type",
  fixed_order = TRUE  # 添加这个参数
)

# 或使用plot_3d_pie_grid（默认就是TRUE）
plot_3d_pie_grid(...)
```

### 问题3: 标签太多重叠

**解决方案**:
```r
# 提高阈值
label_threshold = 10  # 只显示>10%的

# 或只显示百分比
show_label = FALSE
```

### 问题4: PDF太大或太小

**解决方案**:
```r
# 调整输出尺寸
width = 15   # 增加宽度
height = 12  # 增加高度
```

### 问题5: 图例位置不合适

**解决方案**:
```r
legend_position = "bottomright"  # 或 "topleft", "bottomleft"
```

### 问题6: 找不到列名

**错误信息**: `Column 'xxx' not found`

**解决方案**:
```r
# 检查列名
colnames(your_seurat_obj@meta.data)

# 或使用data.frame
df <- data.frame(
  groups = your_seurat_obj$your_group_column,
  cell_type = your_seurat_obj$your_celltype_column
)
```

---

## 📚 更多资源

### 帮助文档

```r
# 查看函数帮助
?plot_3d_pie
?plot_3d_pie_grid

# 查看包的完整文档
help(package = "scPie3D")
```

### 示例脚本

包中包含完整的示例脚本：
- `examples/example_usage.R` - 10个完整示例
- `test_color_consistency.R` - 颜色一致性测试

### 相关文档

- `QUICKSTART.md` - 快速开始指南
- `INSTALL.md` - 详细安装说明
- `CHANGELOG.md` - 版本更新记录
- `fixed_order_guide.md` - 位置一致性详细指南

---

## 🔄 版本历史

### Version 0.1.2 (2025-11-13) - 当前版本 ⭐

**新增功能**:
- ✅ 新增 `fixed_order` 参数：固定细胞类型位置
- ✅ 新增 `order_by` 参数：选择排序方式
- ✅ `plot_3d_pie_grid()` 默认固定顺序

**影响**:
- 解决了位置不一致问题
- 多组对比更加直观

### Version 0.1.1 (2025-11-13)

**Bug修复**:
- ✅ 修复颜色映射不一致问题
- ✅ 确保相同细胞类型在所有组使用相同颜色

### Version 0.1.0 (2025-11-13)

**初始发布**:
- 基础3D饼图功能
- 两种可视化模式
- 网格布局支持
- Seurat配色方案

---

## 📧 联系与支持

### 作者信息

**xiaoqqjun**
- 📧 Email: xiaoqqjun@sina.com
- 🆔 ORCID: [0000-0003-1813-1669](https://orcid.org/0000-0003-1813-1669)
- 📱 微信公众号: 博士后的小酒馆

### 获取帮助

- 📖 阅读文档: [完整README](README.md)
- 💬 提交Issue: [GitHub Issues](https://github.com/yourusername/scPie3D/issues)
- 📧 发送邮件: xiaoqqjun@sina.com

### 贡献

欢迎贡献代码、报告bug或提出建议！

1. Fork本仓库
2. 创建您的特性分支
3. 提交您的修改
4. 推送到分支
5. 创建Pull Request

---

## 📖 引用

如果您在研究中使用了scPie3D，请引用：

```bibtex
@software{scPie3D,
  author = {xiaoqqjun},
  title = {scPie3D: 3D Pie Charts for Single-Cell Data Visualization},
  year = {2025},
  version = {0.1.2},
  url = {https://github.com/yourusername/scPie3D}
}
```

或文本格式：

```
xiaoqqjun (2025). scPie3D: 3D Pie Charts for Single-Cell Data Visualization. 
R package version 0.1.2. https://github.com/xiaoqqjun/scPie3D
```

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

感谢以下R包的支持：
- [plotrix](https://cran.r-project.org/package=plotrix) - 3D饼图渲染
- [dplyr](https://dplyr.tidyverse.org/) - 数据处理
- [Seurat](https://satijalab.org/seurat/) - 单细胞数据分析

特别感谢所有提出建议和反馈的用户！

---

## 🌟 Star历史

如果这个包对您有帮助，请给我们一个⭐️！

[![Star History](https://api.star-history.com/svg?repos=yourusername/scPie3D&type=Date)](https://star-history.com/xiaoqqjun/scPie3D&Date)

---

<div align="center">

**Made with ❤️ by xiaoqqjun**

**博士后的小酒馆 出品** 🍺

[⬆ 回到顶部](#scpie3d-3d-pie-charts-for-single-cell-data-visualization)

</div>
