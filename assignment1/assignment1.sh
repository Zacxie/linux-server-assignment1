#!/bin/bash --

#1
#ask for the package to be downloaded
read -p "Name of package: " packagename

#2
#ask if it want to install from source or dpkg/rpm
#Skip this and look at the extension of the downloaded file

#3
#read the website
read -p "Enter link for package: " url

#set extension for use in step 6
extension="${url: -3}"

#4
#check/changes permissions of /usr/local/src so everyone can download
#rwxrwxrwx
sudo chmod 747 /usr/local/src

#5
#use wget to download package
#test website https://nmap.org/dist/nmap-7.91-1.x86_64.rpm
wget $url -P /usr/local/src
filename=`ls /usr/local/src -tu | head -n 1`

#6
#install package depended on the package type
#TODO need to get the full name of the downloaded package. 
case $extension in
    ".gz")
        #Source install
        #extract package
        #sudo tar xzvf /usr/local/src/filename.tar.gz

        #cd into the folder 
        #cd /usr/local/src/filename
        #./configure
        #make
        #sudo make install
        ;;
    "deb")
        #deb install
        #sudo dpkg -i /usr/local/src/filename.deb
        ;;
    "rpm")
        #rpm install
        sudo rpm -i /usr/local/src/$filename
        ;;
    *)
        echo "Unsupported filetype."
        ;;
esac

#7
#Report if the installation was successful
#if  $? is 0, successful, if 1, unsuccessful
if [ $? -eq 0 ]
then
    echo "Successfully installed $packagename""."
else 
    echo "Error. Installation was unsuccessful."
fi

#8
