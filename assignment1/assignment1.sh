#!/usr/bin/bash --

#1
#ask for the package to be downloaded
read -p "Name of package: " packagename

#2
#ask if it want to install from source or dpkg/rpm
#Skip this and look at the extension of the downloaded file

#3
#read the website
read -p "Enter link for package: " uri

#set extension for use in step 6
extension="${uri: -3}"
echo "$extension"

#4
#check/changes permissions of /usr/local/src so everyone can download
#rwxrwxrwx
sudo chmod 777 /usr/local/src

#5
#use wget to download package
#test website https://nmap.org/dist/nmap-7.91-1.x86_64.rpm
wget $uri -P /usr/local/src

#6
#install package depended on the package type
case $extension in
    ".gz")
        #Source install
        ;;
    
    "deb")
        #deb install
        ;;
    
    "rpm")
        #rpm install
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
