#!/usr/bin/python3

# Imports
from pyspark import SparkContext, SparkConf

# Instantiate the Spark Context
conf = SparkConf() \
       .setAppName("Word counter")
sc = SparkContext(conf=conf)
sc

# Read text file
f = sc.textFile("/var/log/dnf.log")

# Define map and reduce transformations
wc = f.flatMap(lambda line: line.split(' ')) \
     .map(lambda word: (word, 1)) \
     .reduceByKey(lambda a,b: a+b)

# Trigger action to execute transformations and collect results
wc.collect()

sc.stop()

