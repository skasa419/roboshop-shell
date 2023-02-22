source common.sh

mysql_root_password=${1}

if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing MYSQL Root password argument\e[0m"
  exit 1
fi


print_head "Disabling mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Setup mysql repository"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Installing mysql Server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable mysql service"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Start mysql service"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Set Root Password"
mysql_secure_installation --set-root-pass ${mysql_root_password}
status_check $?