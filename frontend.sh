#!/bin/bash

COMPONENT="frontend"
LOG_FILE="/tmp/frontend.log"

ID=$(id -u)

if [ "$ID" -ne 0 ]; then
  echo -e "\e[33m You should be running this script as root or sudo privileges \n\t Usage: sudo $0 \e[0m"
  exit 1
fi

stat () {
  if [ $1 -eq 0]; then
    echo -e "\e[32m Success \e[0m"
  else
    echo -e "\e[31m Failure \e[0m"
    echo -e "\e[33m Check the log file /tmp/$COMPONENT.log for more information \e[0m"
    exit 1
  fi
}

echo -e "\e[33m Installing Nginx \e[0m"
dnf install nginx -y                            &>> $LOG_FILE
stat ()

echo -e "copy"
cp -prf expense.conf /etc/nginx/default.d/      &>> $LOG_FILE 
stat ()

echo "Downloading the $COMPONENT code"
curl -o /tmp/$COMPONENT.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip   &>> $LOG_FILE
stat ()

echo "Extracting the $COMPONENT Code"
cd /usr/share/nginx/html                        &>> $LOG_FILE
stat ()


echo "Removing the old default code if any"
rm -rf /usr/share/nginx/html/*                  &>> $LOG_FILE
stat ()


echo "Unzipping the downloaded code"
unzip /tmp/$COMPONENT.zip                         &>> $LOG_FILE
stat ()


echo "Starting the $COMPONENT service"
systemctl enable nginx                          &>> $LOG_FILE
systemctl restart nginx                         &>> $LOG_FILE
systemctl status nginx                          &>> $LOG_FILE
stat ()


echo -e "\n\t $COMPONENT is up & running, Hit the Public IP on Browser"
