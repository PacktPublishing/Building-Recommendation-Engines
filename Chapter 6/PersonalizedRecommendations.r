#movielens data preparation
#laod data
raw_data = read.csv("C:/Suresh/R&D/packtPublications/reco_engines/drafts/personalRecos/udata.csv",sep="\t",header=F)
colnames(raw_data) = c("UserId","MovieId","Rating","TimeStamp")
ratings = raw_data[,1:3]
movies = read.csv("C:/Suresh/R&D/packtPublications/reco_engines/drafts/personalRecos/uitem.csv",sep="|",header=F)
colnames(movies) = c("MovieId","MovieTitle","ReleaseDate","VideoReleaseDate","IMDbURL","Unknown","Action","Adventure","Animation","Children","Comedy","Crime","Documentary","Drama","Fantasy","FilmNoir","Horror","Musical","Mystery","Romance","SciFi","Thriller","War","Western")
movies = movies[,-c(2:5)]

'users = read.csv("C:/Suresh/R&D/packtPublications/reco_engines/drafts/personalRecos/uuser.csv",sep="|",header=F)
colnames(users) = c("UserId","Age","Gender","Occupation","ZipCode")
users = users[,-c(4,5)]'
#basic stats of data
dim(movies)
#[1] 1682   24
#dim(users)
#[1] 943   5

#merging user item rating with user profile
#ratings = merge(x = ratings, y = users, by = "UserId", all.x = TRUE)
ratings = merge(x = ratings, y = movies, by = "MovieId", all.x = TRUE)

names(ratings)

#remove unwanted columns
#ratings = ratings[,-c(4,8:12)]

#conversion to categorical
nrat = unlist(lapply(ratings$Rating,function(x)
{
  if(x>3) {return(1)}
  else {return(0)}
}))
ratings = cbind(ratings,nrat)
apply(ratings[,-c(1:3,23)],2,function(x)table(x))
scaled_ratings = ratings[,-c(3,4)]
#ratings$Rating = as.factor(ratings$Rating)
#ratings$Gender = factor(ratings$Gender,levels=c("0","1"))
#ratings$NAge = scale(ratings$Age)
#ratings = ratings[,-4]
names(scaled_ratings)
#scaled_ratings = scale(ratings[,-c(1,2)])
#build models
'library(caret)
control <- trainControl(method="repeatedcv", number=10, repeats=1)
set.seed(7)
modelKNN <- train(Rating~., data=ratings[,-c(1,2)], method="knn",metric="Accuracy", trControl=control)
'
'k-Nearest Neighbors 

100000 samples
22 predictor
5 classes: "1", "2", "3", "4", "5" 

No pre-processing
Resampling: Cross-Validated (5 fold) 
Summary of sample sizes: 80000, 80000, 80000, 80000, 80000 
Resampling results across tuning parameters:

k  Accuracy  Kappa      Accuracy SD  Kappa SD   
5  0.35001   0.1001631  0.003126380  0.003737368
7  0.35419   0.1022643  0.001690192  0.001714554
9  0.35468   0.1001364  0.003435586  0.004281009

Accuracy was used to select the optimal model using  the largest value.
The final value used for the model was k = 9. 
'
scaled_ratings=scale(scaled_ratings[,-c(1,2,21)])
scaled_ratings = cbind(scaled_ratings,ratings[,c(1,2,23)])
#train test samples
set.seed(7)
which_train <- sample(x = c(TRUE, FALSE), size = nrow(scaled_ratings),
                      replace = TRUE, prob = c(0.8, 0.2))
model_data_train <- scaled_ratings[which_train, ]
model_data_test <- scaled_ratings[!which_train, ]
library(randomForest)
fit = randomForest(as.factor(nrat)~., data = model_data_train[,-c(19,20)])
predictions <- predict(fit, model_data_test[,-c(19,20,21)], type="class")
cm = table(predictions,model_data_test$nrat)
(accuracy <- sum(diag(cm)) / sum(cm))
(precision <- diag(cm) / rowSums(cm))
recall <- (diag(cm) / colSums(cm))






table(predictions, model_data_test$Rating)

library(pROC)
plot.roc(as.numeric(model_data_test$nrat),as.numeric(predictions))
#create a movie rating matrix

totalMovieIds = unique(movies$MovieId)
nonratedmoviedf = function(userid){
  ratedmovies = raw_data[raw_data$UserId==userid,]$MovieId
  non_ratedmovies = totalMovieIds[!totalMovieIds %in% ratedmovies]
  df = data.frame(cbind(rep(userid),non_ratedmovies,0))
  names(df) = c("UserId","MovieId","Rating")
  return(df)
}
activeusernonratedmoviedf  = nonratedmoviedf(943)
#oneratings = merge(x = onenonratedmoviedf, y = users, by = "UserId", all.x = TRUE)
activeuserratings = merge(x = activeusernonratedmoviedf, y = movies, by = "MovieId", all.x = TRUE)

predictions <- predict(fit, activeuserratings[,-c(1:4)], type="class")
recommend = data.frame(MovieId = activeuserratings$MovieId,predictions)
recommend = recommend[which(recommend$predictions == 1),]
#predList = apply(predictions,1,function(x) if(x[1] > x[2]) return(x[1]) else return(x[2]))






################################################################################
#convert timestamp to local time
ratings_ctx = merge(x = raw_data, y = movies, by = "MovieId", all.x = TRUE)
ts = ratings_ctx$TimeStamp
hours <- as.POSIXlt(ts,origin="1960-10-01")$hour
ratings_ctx = data.frame(cbind(ratings_ctx,hours))
UCP  = ratings_ctx[(ratings_ctx$UserId == 943),][,-c(2,3,4,5)]
UCP_pref = aggregate(.~hours,UCP[,-1],sum)
UCP_pref_sc = cbind(context = UCP_pref[,1],t(apply(UCP_pref[,-1], 1, function(x)(x-min(x))/(max(x)-min(x)))))
UCP_pref_content = merge(x = recommend, y = movies, by = "MovieId", all.x = TRUE)

dim(UCP_pref_content)
dim(UCP_pref_sc)

active_user =cbind(UCP_pref_content$MovieId,(as.matrix(UCP_pref_content[,-c(1,2,3)]) %*% as.matrix(UCP_pref_sc[4,2:19])))
active_user_df = as.data.frame(active_user)
names(active_user_df) = c('MovieId','SimVal')
FinalPredicitons_943 = active_user_df[order(-active_user_df$SimVal),]




names(context_df) = c('UserId','hourOfDay')
context_matrix = table(context_df)
context_matrix_sc = t(apply(context_matrix, 1, function(x)(x-min(x))/(max(x)-min(x))))




################################################################################




