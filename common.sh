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