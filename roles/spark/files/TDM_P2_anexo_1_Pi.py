#!/usr/bin/python3

# (1) Import required Python dependencies
#import findspark
#findspark.init()
from pyspark import SparkContext, SparkConf
import random

# (2) Instantiate the Spark Context
#conf = SparkConf().setMaster("spark://10.6.xxx.xxx:7077") \
#  .setAppName("Calculate Pi")
conf = SparkConf().setAppName("Calculate Pi")
sc = SparkContext(conf=conf)
sc

# (3) Calculate the value of Pi i.e. 3.14...
def inside(p):
    x, y = random.random(), random.random()
    return x*x + y*y < 1

num_samples = 1000000
count = sc.parallelize(range(0, num_samples)) \
  .filter(inside).count()
pi = 4 * count / num_samples

# (4) Print the value of Pi
print(pi)

# (5) Stop the Spark Context
sc.stop()

