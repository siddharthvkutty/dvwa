import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

# Load data
df = pd.read_csv('/content/p1 data.csv')

# FIX 1: Pass 'Experience' as a 2D DataFrame [['Experience']] instead of 1D Series ['Experience']
x = df[['Experience']]
y = df['Salary']

# Split data
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)

# Train model
model = LinearRegression()
model.fit(x_train, y_train)

# FIX 2: Correct typo from 'predic' to 'predict'
y_pred = model.predict(x_test)

print("Slope (Coefficient):", model.coef_[0])
print("Intercept:", model.intercept_)

# Evaluating the model
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)
print('Mean Squared Error:', mse)
print('R2 Score:', r2)

# plotting regression line
plt.scatter(x,y,color='blue')
plt.plot(x,model.predict(x),color='red')
plt.xlabel('Experience')
plt.ylabel('Salary')
plt.title('Simple Linear Regression')
plt.show()

