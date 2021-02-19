#!/usr/bin/python3

# Imports
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode
from pyspark.sql.functions import split

PYTHON_3 = "/usr/bin/python3"
KAFKA_JAR = "org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.1"

spark = SparkSession.builder \
        .config("spark.pyspark.python", PYTHON_3) \
        .config("spark.jars.packages", KAFKA_JAR) \
        .appName("KafkaWordCount") \
        .getOrCreate()
spark

KAFKA_HOST_PORT = "localhost:9092"
TOPIC = "general-topic"

lines = spark.readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", KAFKA_HOST_PORT) \
        .option("subscribe", TOPIC) \
        .load()

# Split each lines into words
words = lines.select(explode(split(lines.value, " ")).alias("word"))

# Generate running word count
wordCounts = words.groupBy("word").count()

query = wordCounts.writeStream \
        .outputMode("Complete") \
        .format("console") \
        .start()

# Wait a minute before stop
query.awaitTermination(timeout=60)
query.stop()

