#!/bin/bash

source common.sh

LOG_FILE="/tmp/backend.log"
COMPONENT="backend"
APPUSER="expense"

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

COLOR Copying the $COMPONENT service file
cp -prf backend.service /etc/systemd/system/                 &>> $LOG_FILE
stat $?

COLOR Downloading the $COMPONENT code
curl -o /tmp/$COMPONENT.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip     &>> $LOG_FILE
stat $?


COLOR Creating the user

id $APPUSER &>> $LOG_FILE   

if [ $? -ne 0 ]; then
  COLOR Creating the application user/Service account
  useradd $APPUSER                                           &>> $LOG_FILE
  stat $?
fi


COLOR Creating the application directory
rm -rf /app                                                  &>> $LOG_FILE
mkdir /app                                                   &>> $LOG_FILE
stat $?

COLOR Changing the directory
cd /app                                                       &>> $LOG_FILE
stat $?

COLOR Unzipping the $COMPONENT code
unzip /tmp/$COMPONENT.zip                                         &>> $LOG_FILE        
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
mysql -h 172.31.46.19 -uroot -pExpenseApp@1 < /app/schema/$COMPONENT.sql      &>> $LOG_FILE
stat $?

COLOR Starting the $COMPONENT service
systemctl daemon-reload                                             &>> $LOG_FILE
systemctl enable $COMPONENT                                            &>> $LOG_FILE
systemctl restart $COMPONENT                                           &>> $LOG_FILE
stat $?

echo -e "\e[35m \n\t $COMPONENT is up & Running \e[0m"

