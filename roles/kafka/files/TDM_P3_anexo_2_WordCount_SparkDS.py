#!/usr/bin/python3

# Imports
from pyspark import SparkContext, SparkConf

# Create a local StreamingContext with two working thread and batch interval of 1 second
sc = SparkContext("Spark Streaming (DStreams)")
ssc = StreamingContext(sc, 1)

# Create a DStream that will connect to localhost:9999
lines = ssc.socketTextStream("localhost:9999") 

# Split each lines into words
words = lines.flatMap(lambda line: line.split(" "))

# Count each word in each batch
pairs = words.map(lambda word: (word, 1))
wordCounts = pairs.reduceByKey(lambda x, y: x + y)

# Print the first 10 elements for each RDD generated in this DStream to the console
wordCounts.pprint()

# Start the computation
ssc.start()

# Wait for the computation to terminate
ssc.query.awaitTermination()

