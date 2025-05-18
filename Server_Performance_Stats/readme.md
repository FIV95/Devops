# Server Performance and Stats Script
---
## Summary
Goal of this project is to write a script to analyse server performance stats.  
It will use `stdout` to show results and will log outputs for future reference.

### note:
This project was completed on macOS and wanted to experiment with docker.

## Process

* Installed Docker:
  * `brew install docker`
  * `docker pull ubuntu`  
    This allowed me to emulate a Linux environment / server.

* Initialized container:
  * `docker run -it ubuntu bash`  
  * `docker rename wonderful_mclean tmp_linux`
    This bash shell environment will be where I create the script.

* Navigated to `/usr/local/bin/`:
  * This directory will contain the scripts:
    * On the PATH for everyone
    * Writable only by root
    * Should be safe from accidental deletion by package managers

* Navigated to `/var/log/sys_stats/`:
  * This directory will hold log files for each execution.
  * Adjusted the permissions so that the script file can write to the directory:
    * `chmod 755 /var/log/sys_stats`

* Navigated back to `/usr/local/bin/` & created the script:
  * `touch server_stats_and_performance.sh`
  * Changed permissions to allow execution by everyone:
    * `chmod a+x server_stats_and_performance.sh`

* Script creation:
  * Sending output to screen and file — utilizing `tee`
  * Set up variables in the script to easily reference objects (e.g. `$log_file`)
  * Utilized system utilities to spotlight system information:
  
    * `date`  
      * Utilized the date to create a unique identifier for logs

    * `top`  
      * Used to capture the CPU state  
      * Used `-b` (batch mode) to direct output to log  
      * Used `-n 1` to capture just one iteration

    * `free -m`  
      * Used `-m` flag to convert usage to megabytes for easier reading

    * `ps -aux --sort=-%mem,-%cpu`  
      * Wanted more isolated info rather than `top`'s interactivity  
      * `-a` shows processes for all users  
      * `-u` shows the owner of each process  
      * `-x` shows processes not attached to the current terminal  
      * `--sort=-%mem,-%cpu` sorts processes by highest memory and CPU usage  
      ✅ *The script logs the top 5 memory- and CPU-consuming processes.*

    * `iostat -d`  
      * Used `-d` to display only disk-related statistics  
      ✅ *The script filters for valid devices by checking for lowercase-starting names to exclude headers and format lines properly.*

  * Common Bash utilities:
    * `awk` for slicing outputs
    * `head` + `tail` to isolate lines
    * `bc` to perform arithmetic
    * `[a-z]*` + other pattern matching for line/device filtering

## Extracting the config file from the docker container
    * `docker cp tmp_linux:/user/local/bin/server_stats_and_performance.sh ~/Documents/Devops/Server_Performance_Stats`
    ✅ * Concludes this project
---

This project was completed as part of the roadmap.sh (Devops pathway)
 `https://roadmap.sh/projects/server-stats`
