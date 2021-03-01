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

wget $url -P /usr/local/src
filename=`ls /usr/local/src -tu | head -n 1`

#6
#install package depended on the package type
case $extension in
    ".gz")
        #test website https://nmap.org/dist/nmap-7.91.tar.bz2
        #Source install
        #extract package
        sudo tar xzvf /usr/local/src/$filename

        #cd into the folder 
        cd /usr/local/src/$filename
        ./configure
        #make
        sudo make install
        ;;
    "bz2")
        echo "entered .bz2"
        #test website https://nmap.org/dist/nmap-7.91.tar.bz2
        #Source install
        #extract package
        sudo tar jxvf /usr/local/src/$filename -C /usr/local/src 
        filename=`ls /usr/local/src -tu | head -n 1`

        #cd into the folder 
        /usr/local/src/$filename/./configure
        make
        su
        make install
        ;;
    "deb")
        # test website https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
        #deb install
        sudo dpkg -i /usr/local/src/$filename
        ;;
    "rpm")
        #test website https://nmap.org/dist/nmap-7.91-1.x86_64.rpm
        #rpm install
        #the -i auto installs the generated packages (deb)
        sudo alien -i /usr/local/src/$filename
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
    exit
else 
    echo "Error. Installation was unsuccessful."
fi

#8
echo "Missing dependencies."
 
 read -p "Do you wish to install the missing dependencies? (y/n): " dependsAnswer

 if [ "$dependsAnswer" = "y" ]
 then
    echo "install depend with apt"
    #install dependencies with apt
    yes | sudo apt -f install
else 
    echo "Abort."
    exit
fi

#check if successfull
if [ $? -eq 0 ]
then
    echo "Successfully installed $packagename""."
else 
    echo "Error. Installation was unsuccessful."
fi
