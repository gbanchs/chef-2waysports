#Jenkins
#source:  http://pkg.jenkins-ci.org/debian-stable/
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo "deb http://pkg.jenkins-ci.org/debian binary/" >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get install jenkins
