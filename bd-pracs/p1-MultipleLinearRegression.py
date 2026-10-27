import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

# Load data
df = pd.read_csv('/content/p1.2 data.csv')

# 1. Select EXACTLY two features
features = ['Experience', 'Age']
x = df[features]
y = df['Salary']

# Split and train
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)
model = LinearRegression()
model.fit(x_train, y_train)

# 2. Set up a 3D plot
fig = plt.figure(figsize=(10, 7))
ax = fig.add_subplot(111, projection='3d')

# Plot actual data points as dots
ax.scatter(df[features[0]], df[features[1]], y, color='blue', label='Actual Data', s=40)

# Create a grid for the regression plane
x0_range = np.linspace(df[features[0]].min(), df[features[0]].max(), 10)
x1_range = np.linspace(df[features[1]].min(), df[features[1]].max(), 10)
x0_grid, x1_grid = np.meshgrid(x0_range, x1_range)

# Predict salaries across the grid surface
y_grid = model.intercept_ + (model.coef_[0] * x0_grid) + (model.coef_[1] * x1_grid)

# Plot the 3D regression plane
ax.plot_surface(x0_grid, x1_grid, y_grid, color='red', alpha=0.4)

ax.set_xlabel(features[0])
ax.set_ylabel(features[1])
ax.set_zlabel('Salary')
ax.set_title('Multiple Linear Regression (3D Plane)')

plt.show()

