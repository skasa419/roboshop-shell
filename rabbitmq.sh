source common.sh

roboshop_app_password=${1}

if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing roboshop app password argument\e[0m"
  exit 1
fi

print_head "Setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Setup rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Install erlang & rabbitmq"
yum install rabbitmq-server erlang -y &>>${log_file}
status_check $?

print_head "Enable rabbitmq service"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "start rabbitmq service"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "Add Application user"
sudo rabbitmqctl list_users | grep roboshop
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
fi
status_check $?

print_head "Configure permissions for app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?

