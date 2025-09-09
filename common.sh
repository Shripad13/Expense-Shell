ID=$(id -u)

COLOR() {
    echo -e "\e[33m $* \e[0m"
}

if [ "$ID" -ne 0 ]; then
  echo -e "\e[33m You should be running this script as root or sudo privileges \n\t Usage: sudo $0 \e[0m"
  exit 1
fi

stat () {
  if [ $1 -eq 0 ] ; then
    echo -e "\e[32m Success \e[0m"
  else
    echo -e "\e[31m Failure \e[0m"
    echo -e "\e[33m Check the log file /tmp/$COMPONENT.log for more information \e[0m"
    exit 1
  fi
}