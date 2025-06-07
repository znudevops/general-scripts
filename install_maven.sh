#!/bin/bash

set -e

# Define Maven version and install directory
MAVEN_VERSION=3.9.6
INSTALL_DIR=/opt
MAVEN_TAR=apache-maven-${MAVEN_VERSION}-bin.tar.gz
MAVEN_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_TAR}

# Go to the install directory
cd $INSTALL_DIR

# Download Maven
sudo curl -O $MAVEN_URL

# Extract the archive
sudo tar -xvzf $MAVEN_TAR

# Create symlink
sudo ln -sfn apache-maven-${MAVEN_VERSION} apache-maven

# Add to PATH
sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export M2_HOME=${INSTALL_DIR}/apache-maven
export PATH=\$M2_HOME/bin:\$PATH
EOF

sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

# Verify
mvn -version
