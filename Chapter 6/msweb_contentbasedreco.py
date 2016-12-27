# -*- coding: utf-8 -*-
"""
Created on Wed Nov 30 22:36:10 2016

@author: Suresh
"""

import pandas as pd
import numpy as np
import scipy
import sklearn

path = "C:/RND/RecoEngine/anonymous-msweb.test.txt"
raw_data = pd.read_csv(path,header=None,skiprows=7)

#creating user profile
user_activity = raw_data.loc[raw_data[0] != "A"]
user_activity.columns = ['category','value','vote','desc','url']
user_activity = user_activity[['category','value']]

user_activity.groupby('category').count()
len(user_activity.loc[user_activity['category'] =="V"].value.unique())
len(user_activity.loc[user_activity['category'] =="C"].value.unique())
#user_activity['chunk'] = 0
#user_activity['caseid'] = 0
#add = 0
#caseid = 0
tmp = 0
nextrow = False
print(user_activity.index)
lastindex = user_activity.index[len(user_activity)-1]

for index,row in user_activity.iterrows():
    if(index <= lastindex ):
        if(user_activity.loc[index,'category'] == "C"):
            tmp = 0
            #add += 1
            #user_activity.loc[index,'chunk'] += add
            userid = user_activity.loc[index,'value']
            user_activity.loc[index,'userid'] = userid
            user_activity.loc[index,'webid'] = userid
            tmp = userid
            nextrow = True            
        elif(user_activity.loc[index,'category'] != "C" and nextrow == True):
                #user_activity.loc[index,'chunk'] += add
                webid = user_activity.loc[index,'value']
                user_activity.loc[index,'webid'] = webid
                user_activity.loc[index,'userid'] = tmp
                if(index != lastindex and user_activity.loc[index+1,'category'] == "C"):
                    nextrow = False
                    caseid = 0
                   
user_activity = user_activity[user_activity['category'] == "V" ]
user_activity = user_activity[['userid','webid']]
user_activity_sort = user_activity.sort('webid', ascending=True)

user_activity['userid'].unique().shape[0]
user_activity['webid'].unique().shape[0]


sLength = len(user_activity_sort['webid'])
user_activity_sort['rating'] = pd.Series(np.ones((sLength,)), index=user_activity.index)
ratmat = user_activity_sort.pivot(index='userid', columns='webid', values='rating').fillna(0)
ratmat = ratmat.to_dense().as_matrix()

#creating item profile
items = raw_data.loc[raw_data[0] == "A"]
items.columns = ['record','webid','vote','desc','url']
items = items[['webid','desc']]
items['webid'].unique().shape[0]
items2 = items[items['webid'].isin(user_activity['webid'].tolist())]
items_sort = items2.sort('webid', ascending=True)
#tfidf
from sklearn.feature_extraction.text import TfidfVectorizer
v = TfidfVectorizer(stop_words ="english",max_features = 100,ngram_range= (0,3),sublinear_tf =True)
x = v.fit_transform(items_sort['desc'])
itemprof = x.todense()
#numpy.savetxt("C:/RND/RecoEngine/tfidf.txt",x.todense())

#dot product
from scipy import linalg, dot
userprof = dot(ratmat,itemprof)/linalg.norm(ratmat)/linalg.norm(itemprof)


#cosine similarity between  userprofile an item profile
import sklearn.metrics
similarityCalc = sklearn.metrics.pairwise.cosine_similarity(userprof, itemprof, dense_output=True)
#covert the rating to binary format
final_pred= np.where(similarityCalc>0.6, 1, 0)
indexes_of_user = np.where(final_pred[213] == 1)

