code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[36m$1\e[0m"
}

status_check() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Read the log file ${log_file} for more information"
    exit 1
  fi
}

schema_setup(){
  if [ "${schema_type}" == "mongo" ]; then
    print_head "Copy MongoDB Repo"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
    status_check $?

    print_head "Install MongoDB Client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mongo --host mongodb.skasadevops.online </app/schema/${component}.js &>>${log_file}
    status_check $?
  fi
}

nodejs(){
print_head "Configure nodejs Repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install Nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Add roboshop user"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "Create Application Directory"
if [ ! -d /app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?

print_head "Delete Old Content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Download App Content"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
status_check $?
cd /app

print_head "Extracting App Content"
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "Installing Nodejs Dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copying SystemD service File"
cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable ${component} Service"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "Start ${component} Service"
systemctl start ${component} &>>${log_file}
status_check $?

schema_setup
}

