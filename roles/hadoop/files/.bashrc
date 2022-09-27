# .bashrc

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# -- HADOOP ENVIRONMENT VARIABLES START -- #
export JAVA_HOME=/etc/alternatives/jre
export HADOOP_HOME=/home/hadoop/VERSION
export PATH=${PATH}:${JAVA_HOME}/bin
export PATH=${PATH}:${HADOOP_HOME}/bin
export PATH=${PATH}:${HADOOP_HOME}/sbin
export CLASSPATH=${CLASSPATH}:$(hadoop classpath):.
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export YARN_HOME=${HADOOP_HOME}
export HADOOP_YARN_HOME=${HADOOP_HOME}
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native
export HADOOP_OPTS="-Djava.library.path=${HADOOP_COMMON_LIB_NATIVE_DIR}"
export HADOOP_LOG_DIR=/var/log/hadoop
# -- HADOOP ENVIRONMENT VARIABLES END -- #

