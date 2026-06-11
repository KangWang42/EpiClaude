# 加载必要的包
library(phytools)  # 用于进化树的绘制和处理
library(grid)      # 用于在进化树节点上绘制彩色方格

# 计算图形的长宽比
asp <- function() {
  dx <- diff(par()$usr[1:2]) # 获取x轴范围的差值
  dy <- diff(par()$usr[3:4]) # 获取y轴范围的差值
  asp <- (dy/dx)*(par()$pin[1]/par()$pin[2]) # 计算长宽比
  asp # 返回长宽比
}

set.seed(123)
# 在树节点上添加彩色方格
tree <- rtree(n = 20) # 生成一颗随机的进化树，共40个末端节点
labs <- c(tree$tip.label, 1:tree$Nnode+Ntip(tree)) # 生成节点标签
Q <- matrix(10, 7, 7, dimnames = list(0:6, 0:6)) # 定义Q矩阵
diag(Q) <- -rowSums(Q) + 0.1 # 修改对角线元素
tt <- tree
n <- Ntip(tt)

# 添加非末端节点
for(i in 1:tree$Nnode) {
  tt <- bind.tip(tt, as.character(i + n), 0, where = Ntip(tt) + i)
}

# 模拟Mk模型下的连续字符数据
X <- sim.Mk(tt, Q, nsim = 16) # 模拟结果
cols <- setNames(colorRampPalette(c("white", "darkgreen"))(7), 0:6) # 定义颜色向量
plotTree(tree, ftype = "off", xlim = c(0, max(nodeHeights(tree)))) # 绘制进化树

pp <- get("last_plot.phylo", envir = .PlotPhyloEnv) # 获取进化树坐标

par(fg = "black") # 设置前景色

# 添加彩色方格
box_size <- 0.75 / asp() # 计算方格大小
nn <- 4 # 方格数
x <- pp$xx # 获取x坐标
y <- pp$yy # 获取y坐标

for (i in 1:nrow(X)) {
  node <- which(labs == rownames(X)[i]) # 获取节点索引
  xleft <- x[node] - box_size/2 # 计算左边界
  ytop <- y[node] + box_size/2*asp()*(nn/nn) # 计算上边界
  
  # 计算方格的坐标和颜色
  m <- 1
  colors <- cols[as.numeric(X[i, ])]
  for (j in 0:(nn-1)) {
    yy <- c(ytop-j*box_size/nn*asp(), ytop-(j+1)*box_size/nn*asp())
    for (k in 0:(nn-1)) {
      xx <- c(xleft+k*box_size/nn, xleft+(k+1)*box_size/nn)
      rect(xx[1], yy[1], xx[2], yy[2], col = colors[m])
      m <- m + 1
    }
  }
}

legend("topright", names(cols), pch = 22, pt.bg = cols, cex = 1,
       pt.cex = 2, bty = "n", col = "#F0EAD6")

