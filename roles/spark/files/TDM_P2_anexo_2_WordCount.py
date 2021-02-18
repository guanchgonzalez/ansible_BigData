#!/usr/bin/python3

# import required Python dependencies
#import findspark
#findspark.init()
from pyspark import SparkContext, SparkConf

# instantiate the Spark Context
#conf = SparkConf() \
#  .setMaster("spark://10.6.xxx.xxx:7077") \
conf = SparkConf() \
  .setAppName("Word counter")
sc = SparkContext(conf=conf)
sc

# read text file
f = sc.textFile("/var/log/dnf.log")

# define map and reduce transformations
wc = f.flatMap(lambda line: line.split(' ')) \
  .map(lambda word: (word, 1)) \
  .reduceByKey(lambda a,b: a+b)

# trigger action to execute transformations and collect results
wc.collect()

sc.stop()

