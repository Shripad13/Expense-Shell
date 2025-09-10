#!/bin/bash

source common.sh

COLOR Listing the Modules
dnf module list                                             &>> $LOG_FILE
stat $?

COLOR Disabling the all nodejs modules
dnf module disable nodejs -y                                &>> $LOG_FILE
stat $?

COLOR Enabling the nodejs 20 module
dnf module enable nodejs:20 -y                              &>> $LOG_FILE
stat $?

COLOR Installing the nodejs 20
dnf install nodejs -y                                        &>> $LOG_FILE
stat $?

COLOR Copying the backend service file
cp -prf backend.service /etc/systemd/system/                 &>> $LOG_FILE
stat $?

COLOR Downloading the backend code
curl -o /tmp/backend.zip https://expense-web-app.s3.amazonaws.com/backend.zip     &>> $LOG_FILE
stat $?


COLOR Creating the user
useradd expense                                              &>> $LOG_FILE
stat $?

COLOR Creating the application directory
rm -rf /app                                                  &>> $LOG_FILE
mkdir /app                                                   &>> $LOG_FILE
stat $?

COLOR Changing the directory
cd /app                                                       &>> $LOG_FILE
stat $?

COLOR Unzipping the backend code
unzip /tmp/backend.zip                                         &>> $LOG_FILE        
stat $?

COLOR Installing the npm package manager
npm install                                                    &>> $LOG_FILE
stat $? 

COLOR Changing the permission & ownership
chmod -R 775 /app                                               &>> $LOG_FILE
chown -R expense:expense /app                                   &>> $LOG_FILE
stat $?

COLOR Installing the mysql server
dnf install mysql-server -y                                      &>> $LOG_FILE
stat $?

COLOR Injecting the schema
mysql -h 172.31.46.19 -uroot -pExpenseApp@1 < /app/schema/backend.sql      &>> $LOG_FILE
stat $?

COLOR Starting the backend service
systemctl daemon-reload                                             &>> $LOG_FILE
systemctl enable backend                                            &>> $LOG_FILE
systemctl restart backend                                           &>> $LOG_FILE
stat $?

echo -e "\e[35m \n\t Backend is up & Running \e[0m"

