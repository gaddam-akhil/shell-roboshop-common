#!/bin/bash

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILES="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.gaddam.online
START_TIME=$(date +%s)

mkdir -p $LOGS_FOLDER

echo "$(date "+%y-%m-%d %H:%M:%S") | script started executing at: $(date)" | tee -a $LOGS_FILES

check_root() {
if [ $USER_ID -ne 0 ]; then
 echo -e "$R please run this script as root user access $N" | tee -a $LOGS_FILES
 exit 1
fi
}


VALIDATE() {
 if [ $1 -ne 0 ]; then
   echo -e "$(date "+%y-%m-%d %H:%M:%S") | $2 .... $R FAILURE $N" | tee -a $LOGS_FILES
   exit 1
 else 
   echo -e "$(date "+%y-%m-%d %H:%M:%S") | $2 .. $G SUCCESS $N" | tee -a $LOGS_FILES
 fi

}

print_total_time(){
     END_TIME=$(date +%s)
     TOTAL_TIME=$(( $END_TIME - $START_TIME ))
     echo -e "$(date "+%y-%m-%d %H:%M:%S") | script execute in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILES
}