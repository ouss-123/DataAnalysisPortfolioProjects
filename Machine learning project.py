#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Importing libraries

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


# In[2]:


data = pd.read_csv("/Users/benmansouroussama/Desktop/housing.csv")


# In[3]:


data.head()


# In[4]:


data.info()


# In[5]:


data.dropna(inplace=True)


# In[6]:


data.info()


# In[7]:


#splitting the data into testing and training sets
from sklearn.model_selection import train_test_split

X = data.drop(['median_house_value'], axis=1) # data without the target variable
y = data['median_house_value'] #the target variable


# In[8]:


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2) #20% of data for evaluation)


# In[9]:


train_data = X_train.join(y_train) 


# In[10]:


train_data.head()


# In[11]:


train_data.hist(figsize=(15,8))


# In[12]:


plt.figure(figsize=(15,8))
sns.heatmap(train_data.corr(), annot=True)


# In[13]:


#using log for the right skewed data
train_data['total_rooms'] = np.log(train_data['total_rooms'] + 1)
train_data['total_bedrooms'] = np.log(train_data['total_bedrooms'] + 1)
train_data['population'] = np.log(train_data['population'] + 1)
train_data['households'] = np.log(train_data['households'] + 1)


# In[14]:


train_data.hist(figsize = (15,8))


# In[15]:


#change the ocean proximity column into numerical
train_data = train_data.join(pd.get_dummies(train_data.ocean_proximity)).drop(['ocean_proximity'],axis = 1)


# In[16]:


train_data.head()


# In[17]:


plt.figure(figsize=(15,8))
sns.heatmap(train_data.corr(), annot=True)


# In[18]:


plt.figure(figsize=(15,8))
sns.scatterplot(x='latitude',y='longitude',data = train_data, hue='median_house_value')


# In[19]:


#come up or drop features
train_data['bedroom_ratio'] = train_data['total_bedrooms']/train_data['total_rooms']
train_data['household_rooms'] = train_data['total_rooms']/train_data['households']


# In[20]:


plt.figure(figsize=(15,8))
sns.heatmap(train_data.corr(), annot=True)


# In[21]:


from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()

X_train, y_train = train_data.drop(['median_house_value'],axis =1),train_data['median_house_value']
X_train_s = scaler.fit_transform(X_train)
reg = LinearRegression()

reg.fit(X_train_s, y_train)


# In[22]:


test_data = X_test.join(y_test)  

test_data['total_rooms'] = np.log(test_data['total_rooms'] + 1)
test_data['total_bedrooms'] = np.log(test_data['total_bedrooms'] + 1)
test_data['population'] = np.log(test_data['population'] + 1)
test_data['households'] = np.log(test_data['households'] + 1)

test_data = test_data.join(pd.get_dummies(test_data.ocean_proximity)).drop(['ocean_proximity'],axis = 1)

test_data['bedroom_ratio'] = test_data['total_bedrooms']/test_data['total_rooms']
test_data['household_rooms'] = test_data['total_rooms']/test_data['households']


# In[23]:


X_test, y_test = test_data.drop(['median_house_value'],axis=1),test_data['median_house_value']


# In[24]:


X_test_s = scaler.transform(X_test)


# In[25]:


reg.score(X_test_s, y_test)


# In[26]:


from sklearn.ensemble import RandomForestRegressor

forest = RandomForestRegressor()

forest.fit(X_train_s, y_train)


# In[27]:


forest.score(X_test_s, y_test)


# In[35]:


from sklearn.model_selection import GridSearchCV

forest = RandomForestRegressor()

param_grid = {'n_estimators': [100,200,300],
             'min_samples_split':[2,4],
              'max_depth':[None,4,8]}

grid_search = GridSearchCV(forest, param_grid, cv = 5, scoring='neg_mean_squared_error',return_train_score = True)

grid_search.fit(X_train_s, y_train)


# In[36]:


grid_search.best_estimator_


# In[38]:


grid_search.best_estimator_.score(X_test_s,y_test)


# In[ ]:




