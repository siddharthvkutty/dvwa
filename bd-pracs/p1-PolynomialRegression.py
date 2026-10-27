import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.preprocessing import PolynomialFeatures
poly = PolynomialFeatures(degree=2)
data = pd.read_csv('p1 data.csv')
# print(data)
print(data.head())
# X = data.iloc[:,:1].values
# Y = data.iloc[:,1].values
X = data[['Experience']]
Y = data['Salary']
x_poly = poly.fit_transform(X)
model = LinearRegression()
model.fit(x_poly,Y)
prediction = model.predict(x_poly)
plt.scatter(X,Y)
plt.plot(X,prediction,color="red")
plt.show()

