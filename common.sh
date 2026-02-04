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
MYSQL_HOST=mysql.gaddam.online

mkdir -p $LOGS_FOLDER

echo "$(date "+%y-%m-%d %H:%M:%S") | script started executing at: $(date)" | tee -a $LOGS_FILES

check_root(){
if [ $USER_ID -ne 0 ]; then
 echo -e "$R please run this script as root user access $N" | tee -a $LOGS_FILES
 exit 1
fi
}


VALIDATE(){
 if [ $1 -ne 0 ]; then
   echo -e "$(date "+%y-%m-%d %H:%M:%S") | $2 .... $R FAILURE $N" | tee -a $LOGS_FILES
   exit 1
 else 
   echo -e "$(date "+%y-%m-%d %H:%M:%S") | $2 .. $G SUCCESS $N" | tee -a $LOGS_FILES
 fi

}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOGS_FILES
VALIDATE $? "Disabling Nodejs Default version"

dnf module enable nodejs:20 -y &>>$LOGS_FILES
VALIDATE $? "enable nodejs:20"

dnf install nodejs -y &>>$LOGS_FILES
VALIDATE $? "installing nodejs"

npm install  &>>$LOGS_FILES
VALIDATE $? "Installing dependencies"
}

app_setup(){ 

#creating system user

id roboshop &>>$LOGS_FILES
if [ $? -ne 0 ]; then
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILES
   VALIDATE $? "creating system user"
else 
   echo -e "Roboshope user already exit.....$Y skipping $N" 
fi

#downloading the app dir

mkdir -p /app &>>$LOGS_FILES
VALIDATE $? "creating a app directory"

curl -o /tmp/$APP_NAME.zip https://roboshop-artifacts.s3.amazonaws.com/$APP_NAME-v3.zip &>>$LOGS_FILES
VALIDATE $? "downloading $APP_NAME code"

cd /app &>>$LOGS_FILES
VALIDATE $? "moving to app directory"

rm -rf /app/* &>>$LOGS_FILES
VALIDATE $? "removing the existing code"

unzip /tmp/$APP_NAME.zip &>>$LOGS_FILES
VALIDATE $? "unziping the code"
}

systemd_setup(){
    cp  $SCRIPT_DIR/$APP_NAME.service /etc/systemd/system/$APP_NAME.service &>>$LOGS_FILES
VALIDATE $? "created systemctl service"

systemctl daemon-reload &>>$LOGS_FILES
systemctl enable $APP_NAME &>>$LOGS_FILES
systemctl start $APP_NAME &>>$LOGS_FILES
VALIDATE $? "Enabling and Starting $APP_NAME"
}

java_setup(){

    dnf install maven -y &>>$LOGS_FILES
VALIDATE $? "Installing Maven"

cd /app 
VALIDATE $? "MOVING TO APP DIR"

mvn clean package &>>$LOGS_FILES
VALIDATE $? "installing dependancies and building $APP_NAME"

mv target/$APP_NAME-1.0.jar $APP_NAME.jar  &>>$LOGS_FILES
VALIDATE $? "RENAMING"
}

python_setup(){
    dnf install python3 gcc python3-devel -y &>>$LOGS_FILES
VALIDATE $? "installing Python-devel"

cd /app &>>$LOGS_FILES
VALIDATE $? "Moving to app dir"

pip3 install -r requirements.txt &>>$LOGS_FILES
VALIDATE $? "Installing Build app"
}

app_restart(){
    systemctl restart $APP_NAME &>>$LOGS_FILES
VALIDATE $? "restarting $APP_NAME"
}

print_total_time(){
     END_TIME=$(date +%s)
     TOTAL_TIME=$(( $END_TIME - $START_TIME ))
     echo -e "$(date "+%y-%m-%d %H:%M:%S") | script execute in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILES
}