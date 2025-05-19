Project Goals

Create a command line tool that given a system path will archive and compress the log files located there.
Tool will run directly from the command line
    `log-archive <directory argument>`

Compression to be used will be tar.gz
    Example output (using date to categorize)
    `log_archive_20240816_100648.tar.gz` 

Additional Learning:
    I am running linux using WSL 2.0 currently installed with Arch. For this project it was important that I understand the file system directories on different linux systems.
    To simulate a more standard server enviroment I initated a Cloud Based ubunutu Virtual Machine using `cloud.linode.com`. 
    With both distobutions I want to analyze and compare their file structure particularly the `/var/log` pathway since most system logs are located there.

    I intend to document setting up the virtual ubuntu machine.
    Afterwards I itend to use Excalidraw to illustrate the differences and similarities between the Ubuntu directories and my Arch-based ones with WSL caveats.
    A better understanding of the file system hierachy and how its implemented across different distrubutions should allow me to make a more robust cli tool, and if not
    at the very least better educate myself on system logging.
    
    Setting up the Ubuntu Virtual Machine
    I first setup my account on `https://login.linode.com`AAAAC3NzaC1lZDI1NTE5AAAAIIYKAYQrMXAqAtZdqqTBGbuZUK+5eqHRj7dJBFjMhRCw 
    I used a promotional offer for $100 in free credit - thanks to `Learn Linux TV` via youtube with his promo link `https://www.linode.com/learnlinuxtv`

    I navigated to the main page located at: `cloud.linode.com/linode`
    
    ## node creation
    I selected `Create Linode` in the center of the screen.
    Since this node/server was meant to just exist so i can analyze Ubuntu directores I filled out this quickly withour worry to much about the details.
    
    Region: US East
    OS: Ubuntu 24.04 LTS
    Linode Plan: Shared CPU Nanode 1GB (cheapest option)
    
    Details: ubuntu-us-east
    Security: I set my rootpassword
    
    SSH Keys:
        I wanted to operate on the server from my desktops terminal so i prepared an ssh key to do so.
            * Linode supports ssh-rsa, ssh-dss, ecdsa-sha2-nistp, ssh-ed25519 and sk-ecdsa-sha2-nistp256 formats
        I ran the following commands to generate my key for the virtual machine
        `ssh-keygen -t ed25519` 
        I then was asked to enter a filename for the key
        ``
        I also generated a passphrase for key for additional security
        After the key was generated I wanted to view the public key and send it to linode
        `cd ~/.ssh/`
        `cat <public key filename> | less`
    
    With my ssh key generated I went back to the form on `cloud.linode.com/linodes/create`
    I had previously started
    * I selected the Add an SSH Key button
    * I gave the key a label that would signify where the key came from
    * I then copied over the key into the textbox and hit `Add Key`
   
    Disk Encrpytion
    * I opted out of disk encryption
    
    VPC
    * I opted out of this feature as well

    Firewall
    * As for the firewall - i left it blank. I may need to make an exception for ssh connection on port 22 from my ip.
    
    Vlan:
    * Opted out
    
    Addons
    * Opted out of all
    
    After selecting all the options I hit create. I was then routed to a page overviewing my node
    
    I waited until the server was done provisioning before attempting to work with it.
    On the page there was a dedicated ACCESS section. I went to see if i could just ssh to the server right away.
    
    I was able to successfully ssh into the server  
    On my desktop I wanted to make an alias to quickly connect back and forth.

    To do so
    * I navigated `~/.ssh/config`
    * (if you are using this readme as a guide for any reason, you may need to make this file.
    * the typical setup to make an alias looks like the following
    ```
    Host <alias easy to remember you>
            Hostname <server ip>
            user <user you are running as on the server>
            IdentityFile <this is the private key file on your desktop>
