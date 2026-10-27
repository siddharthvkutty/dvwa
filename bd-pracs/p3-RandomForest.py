# Importing libraries
# Data manipulation
import pandas as pd
import numpy as np
# Splitting dataset
from sklearn.model_selection import train_test_split
# Random Forest Regression
from sklearn.ensemble import RandomForestRegressor
# Model Evaluation
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
#Visualizationimport matplotlib.pyplot as plt

# Loading Dataset
data = pd.read_csv("/content/HousePrice.csv")
# Displaying the Dataset
print(data.head())

# Seperating the features and target
X = data[['Area','Bedrooms','Age']]
y = data['Price']

# Splitting the dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.20, random_state=42)

# Creating the Random Forest Model
model = RandomForestRegressor(n_estimators=100, criterion='squared_error', max_depth=5, random_state=42)

# Training the model
model.fit(X_train, y_train)
# Predicting
prediction = model.predict(X_test)

# Evaluating the model

# R² Score
print("R2 Score:", r2_score(y_test, prediction))
# Calculating the Mean Squared Error
print("MSE:",mean_squared_error(y_test, prediction))

# Predicting the prices of the new house
new_house = [[1800,3,6]]

price = model.predict(new_house)

print(price)
 
# Implementing Feature Importance
importance = model.feature_importances_

for feature, score in zip(X.columns, importance):
    print(feature, score)

# Visualizing Feature Importance
plt.figure(figsize=(6,4))

plt.bar(
    X.columns,
    importance
)
plt.title("Feature Importance")
plt.xlabel("Features")
plt.ylabel("Importance")
plt.show()

