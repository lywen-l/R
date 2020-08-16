#要是没有这个包的话，首先需要安装一下
#install.packages("factoextra")
#载入包
library(factoextra)
# 载入数据
data("USArrests") 
# 数据进行标准化
df <- scale(USArrests) 
# 查看数据的前五行
head(df, n = 5)
#确定最佳聚类数目
fviz_nbclust(df, kmeans, method = "wss") + geom_vline(xintercept = 4, linetype = 2)
#可以发现聚为四类最合适，当然这个没有绝对的，从指标上看，选择坡度变化不明显的点最为最佳聚类数目。
#设置随机数种子，保证实验的可重复进行
set.seed(123)
#利用k-mean是进行聚类
km_result <- kmeans(df, 4, nstart = 24)
#查看聚类的一些结果
print(km_result)
#提取类标签并且与原始数据进行合并
dd <- cbind(USArrests, cluster = km.res$cluster)
head(dd)
#查看每一类的数目
table(dd$cluster)
#进行可视化展示
fviz_cluster(km_result, data = df,
             palette = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
             ellipse.type = "euclid",
             star.plot = TRUE, 
             repel = TRUE,
             ggtheme = theme_minimal()
)
#先求样本之间两两相似性
result <- dist(df, method = "euclidean")
#产生层次结构
result_hc <- hclust(d = result, method = "ward.D2")
#进行初步展示
fviz_dend(result_hc, cex = 0.6)
fviz_dend(result_hc, k = 4, 
          cex = 0.5, 
          k_colors = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
          color_labels_by_k = TRUE, 
          rect = TRUE          
)