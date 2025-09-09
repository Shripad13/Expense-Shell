#!/bin/bash

source common.sh
LOG_FILE="/tmp/mysql.log"
COMPONENT="mysql"

ROOT_PASS="ExpenseApp@1"

COLOR Installing $COMPONENT Server

dnf install mysql-server -y                          &>> $LOG_FILE
stat $?

COLOR Enabling $COMPONENT Service
systemctl enable mysqld                              &>> $LOG_FILE
stat $?

COLOR Starting $COMPONENT Service
systemctl start  mysqld                              &>> $LOG_FILE
stat $?

COLOR Set up of $COMPONENT root password
mysql_secure_installation --set-root-pass $ROOT_PASS           &>> $LOG_FILE
stat $?

echo -e "\e[30m \n\t $COMPONENT Installation is completed. \e[0m"
