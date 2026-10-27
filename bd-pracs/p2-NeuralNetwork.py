import numpy as np
import pandas as pd
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
iris = load_iris()
X = iris.data
Y = iris.target
df = pd.DataFrame(X,columns=iris.feature_names)
df['Species'] = Y
df.head()
df.tail()
X_train,X_test,Y_train,Y_test = train_test_split(X,Y,test_size=0.2,random_state=42)
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)
model = Sequential()
model.add(Dense(units=8,
                activation='relu',
                input_shape=(4,)
                ))
model.add(Dense(units=6,
                activation='relu'
                ))
model.add(Dense(units=3,
                activation='softmax'
                ))
model.add(Dense(units=3,
                activation='softmax'
                ))
model.summary()
model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
    )
history = model.fit(
    X_train,
    Y_train,
    epochs=50,
    batch_size=8,
    validation_split=0.2
    )
predictions = model.predict(X_test)
Y_pred = np.argmax(predictions,axis=1)
print("Accuracy:", accuracy_score(Y_test,Y_pred), "\n")
print("Confusion Matrix: \n", confusion_matrix(Y_test,Y_pred), "\n")
# print("Classification Report: \n", classification_report(Y_test,Y_pred))
print("Classification Report: \n", classification_report(Y_test,Y_pred))
import matplotlib.pyplot as plt
plt.figure(figsize=(8,5))
plt.plot(history.history['accuracy'],label='Training Accuracy')
plt.plot(history.history['val_accuracy'],label='Validation Accuracy')
plt.xlabel('Epochs')
plt.ylabel('Accuracy')
plt.title('Training vs Validation Accuracy')
plt.legend()
plt.grid(True)
plt.show()

