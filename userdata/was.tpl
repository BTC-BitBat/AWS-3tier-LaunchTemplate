#!/bin/bash

sudo useradd appadm
sudo gpasswd appadm -a appadm

cat <<EOF | sudo tee -a /etc/sudoers
appadm ALL=NOPASSWD: ALL
EOF

## 자바 설치 및 설정
sudo yum install -y java-1.8.0-openjdk-devel

javac_path=$(which javac)
javac_real_path=$(readlink -f $javac_path)
java_path=$(dirname $(dirname $javac_real_path))

cat <<EOF | sudo tee -a /etc/profile.d/java.sh
export JAVA_HOME=$${java_path}
export PATH=$PATH:$JAVA_HOME/bin
EOF
sudo chmod 644 /etc/profile.d/java.sh
source /etc/profile.d/java.sh

cd ~/

##톰캣 설치 및 설정
wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.27/bin/apache-tomcat-8.5.27.tar.gz
tar zxvf apache-tomcat-8.5.27.tar.gz
mv apache-tomcat-8.5.27 /usr/local/tomcat8

cat <<EOF | sudo tee -a /etc/profile.d/catalina.sh
export CATALINA_HOME=/usr/local/tomcat8
EOF
sudo chmod 644 /etc/profile.d/catalina.sh
source /etc/profile.d/catalina.sh

cat <<EOF | sudo tee -a /etc/systemd/system/tomcat8.service
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

cat <<EOF | sudo tee -a /etc/systemd/system/tomcat8.service
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment="JAVA_HOME=$${java_path}"
Environment="CATALINA_HOME=/usr/local/tomcat8"
Environment="CATALINA_BASE=/usr/local/tomcat8"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

ExecStart=/usr/local/tomcat8/bin/startup.sh
ExecStop=/usr/local/tomcat8/bin/shutdown.sh

User=appadm
Group=appadm
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo chown -R appadm:appadm /engn001
sudo chown -R appadm:appadm /logs001
sudo chmod -R 755 /engn001
sudo chmod -R 755 /logs001

sudo systemctl daemon-reload
sudo systemctl enable tomcat8

sudo systemctl start tomcat8