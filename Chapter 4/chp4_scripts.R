#linear regression
library(MASS)
data("Boston")
set.seed(0)
which_train <- sample(x = c(TRUE, FALSE), size = nrow(Boston),
                      replace = TRUE, prob = c(0.8, 0.2))
train <- Boston[which_train, ]
test <- Boston[!which_train, ]
lm.fit =lm(medv~. ,data=train )
summary(lm.fit)
pred = predict(lm.fit,test[,-14])

#logistic regression
set.seed(1)
x1 = rnorm(1000)           # sample continuous variables 
x2 = rnorm(1000)
z = 1 + 4*x1 + 3*x2        # data creation
pr = 1/(1+exp(-z))         # applying logit function
y = rbinom(1000,1,pr)      # bernoulli response variable

  #now feed it to glm:
df = data.frame(y=y,x1=x1,x2=x2)
glm( y~x1+x2,data=df,family="binomial")

#knn classification
data("iris")
library(dplyr)
iris2 = sample_n(iris, 150)
train = iris2[1:120,]
test = iris2[121:150,]
cl = train$Species
library(caret)
fit <- knn3(Species~., data=train, k=3)
predictions <- predict(fit, test[,-5], type="class")
table(predictions, test$Species)

vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )

library('clusteval')
cluster_similarity(vec1, vec2, similarity = "jaccard")


#MF
library(recommenderlab)
data("MovieLense")
dim(MovieLense)

#applying MF using NMF
mat  = as(MovieLense,"matrix")
mat[is.na(mat)] = 0
res = nmf(mat,10)
res

#fitted values
r.hat <- fitted(res)
dim(r.hat)

p <- basis(res)
dim(p)
q <- coef(res)
dim(q)






