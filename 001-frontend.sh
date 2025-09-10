#!/bin/bash

COMPONENT="frontend"
LOG_FILE="/tmp/frontend.log"

source common.sh

COLOR Installing Nginx 
dnf install nginx -y                            &>> $LOG_FILE
stat $?

COLOR  Copying  the configuration file 
cp -prf expense.conf /etc/nginx/default.d/      &>> $LOG_FILE 
stat $?

COLOR Downloading the $COMPONENT code
curl -o /tmp/$COMPONENT.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip   &>> $LOG_FILE
stat $?

COLOR Extracting the $COMPONENT Code
cd /usr/share/nginx/html                        &>> $LOG_FILE
stat $?


COLOR Removing the old default code if any
rm -rf /usr/share/nginx/html/*                  &>> $LOG_FILE
stat $?


COLOR Unzipping the downloaded code
unzip /tmp/$COMPONENT.zip                         &>> $LOG_FILE
stat $?


COLOR Starting the $COMPONENT service

systemctl enable nginx                          &>> $LOG_FILE
systemctl restart nginx                         &>> $LOG_FILE
systemctl status nginx                          &>> $LOG_FILE
stat $?


echo -e "\e[35m \n\t $COMPONENT is up & running, Hit the Public IP on Browser \e[0m"
