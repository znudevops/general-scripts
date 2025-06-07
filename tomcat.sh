#install tomcat in Amazon Linux 2023 server
#!/bin/bash

# Update system packages
dnf update -y

# Install OpenJDK 11 (Tomcat 9 requires Java 8+)
dnf install java-11-amazon-corretto -y

# Create a 'tomcat' user (no shell access)
useradd -m -U -d /opt/tomcat -s /bin/false tomcat

# Download and install Tomcat 9
cd /tmp
TOMCAT_VERSION=9.0.105
wget https://downloads.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Extract and move to installation directory
tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz
mkdir -p /opt/tomcat
mv apache-tomcat-${TOMCAT_VERSION} /opt/tomcat/latest

# Set permissions
chown -R tomcat: /opt/tomcat
chmod +x /opt/tomcat/latest/bin/*.sh

# Create systemd service unit for Tomcat
cat > /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Tomcat
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

