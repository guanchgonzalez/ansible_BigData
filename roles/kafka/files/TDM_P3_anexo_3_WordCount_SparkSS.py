#!/usr/bin/python3

# Imports
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode
from pyspark.sql.functions import split

spark = SparkSession.builder \
        .appName("StructuredNetworkWordCount")
        .getOrCreate()
spark

lines = spark.readStream \
        .format("socket") \
        .option("host", "localhost") \
        .option("port", 9999) \
        .load()

# Split each lines into words
words = lines.select(explode(split(lines.value, " ")).alias("word"))

# Generate running word count
wordCounts = words.groupBy("word").count()

query = wordCounts.writeStream \
        .outputMode("complete") \
        .format("console") \
        .start()

# Wait a minute before stop
query.awaitTermination(timeout=60)
query.stop()

