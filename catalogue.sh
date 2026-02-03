#!/bin/bash

source ./common.sh
APP_NAME=catalogue

check_root
app_setup
nodejs_setup
systemd_setup

#this is mongodb calling
dnf install mongodb-mongosh -y &>>$LOGS_FILES
VALIDATE $? "installing mongodb client server"

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")') &>>$LOGS_FILES
if [ $INDEX -le 0 ]; then
mongosh --host $MONGODB_HOST </app/db/master-data.js
VALIDATE $? "Loadin products"
else
echo -e "$(date "+%y-%m-%d %H:%M:%S") | products already loaded....$Y skipping $N"
fi

systemctl restart catalogue &>>$LOGS_FILES
VALIDATE $? "restarting catalogue"
