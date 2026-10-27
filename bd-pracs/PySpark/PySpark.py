import pyspark
import pandas as pd

data = pd.read_csv('data.csv')
print(data)

from pyspark.sql import SparkSession
spark = SparkSession.builder.appName('Practice').getOrCreate()

df_spark = spark.read.csv('data.csv', header = True, inferSchema = True)
print(df_spark.show())

print(type(df_spark))

print("\nSchema: ")
print(df_spark.printSchema())

print("\nFirst 3 values: ")
print(df_spark.head(3))

print("\nColumn Names: ")
print(df_spark.columns)

print(df_spark.select(['Name']).show())
print(df_spark.select(['Name','Age']).show())
print(df_spark.select(['Name','Experience']).show())

print(df_spark.dtypes)

df_spark = df_spark.withColumn('Experience After 2 Years',df_spark['Experience']+2)
df_spark.show()

df_spark = df_spark.drop('Experience After 2 Years')
df_spark.show()

df_spark = df_spark.withColumnRenamed('Name','New Name')
df_spark.show()

# df_spark = df_spark.drop('New Name')
# df_spark.show()
df_spark.na.drop().show()

# df_spark.na.drop(how='all').show()
# df_spark.na.drop(how='any').show()
print("Threshold: ")
df_spark.na.drop(how='all',thresh=4).show()

df_spark.na.drop(how='any',subset=['Experience']).show()

df_spark = df_spark.na.fill('Missing Values')
df_spark.show()
df_spark = df_spark.na.fill({'Salary': 0})
df_spark.show()