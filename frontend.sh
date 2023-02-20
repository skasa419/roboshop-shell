code_dir=$(pwd)
echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y
echo -e "\e[35mRemoving Old Conent\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[35mDownloading Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[35mExtracting Download Frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[35mCopying Nginx Config for Roboshop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[35mEnabling Nginx\e[0m"
systemctl enable nginx
echo -e "\e[35mStarting Nginx\e[0m"
systemctl restart nginx