#!/usr/bin/env bash
# The following is a script that will produce performance and statistics 
# of the current system.
clear
# The script Requires elevated root/sudo access the following conditional checks for that
echo 
echo
if [ "$EUID" -ne 0 ];
then
	echo "To properly execute this script needs sudo/elevated privledges."
	exit 1
fi
mkdir -p /var/log/sys_stats
# In order to create logs for each time we execute we need an unique identifier
# the unique identifier in this case can be the date+time
current_date=$(date +%Y-%m-%dT%H-%M-%s)
log_directory="/var/log/sys_stats/"

# Script will make log directory if not there
# log_file variable will be where we write to
log_file="$log_directory/run_$current_date.log"

# one output of the top command
echo "------------------------------------------------------------------------" | tee -a $log_file
echo "SYSTEM INFO		Timestamp: $(date)" | tee -a $log_file
echo "------------------------------------------------------------------------" | tee -a $log_file

cpu_result=$(top -b -n 1 | head -3 | tail +3)
## Capture and split each CPU 
echo "CPU Info:" | tee -a $log_file
echo "------------------------" | tee -a $log_file
cpu_sys=$(echo "$cpu_result" | awk '{print $4}')
cpu_usr=$(echo "$cpu_result" | awk '{print $2}')
cpu_ni=$(echo "$cpu_result" | awk '{print $6}')
cpu_id=$(echo "scale=2; 100 -  $cpu_ni - $cpu_usr - $cpu_sys" | bc)
echo "System Usage: $cpu_usr%" | tee -a $log_file
echo "User Usage: $cpu_usr%" | tee -a $log_file
echo "Nice Usage: $cpu_ni%" | tee -a $log_file
echo "Idle: $cpu_id%" | tee -a $log_file
echo "------------------------" | tee -a $log_file
echo | tee -a $log_file

## Capturing Memory Info
echo "Memory Info:" | tee -a $log_file
echo "------------------------" | tee -a $log_file
mem_result=$(free -m)

mem_line_1=$(echo "$mem_result" | head -2 | tail +2)
mem_line_2=$(echo "$mem_result" | head -3 | tail +3)
total_mem=$(echo $mem_line_1 | awk '{print $2}')
used_mem=$(echo $mem_line_1 | awk '{print $3}')
avail_mem=$(echo $mem_line_1 | awk '{print $4}')

# Percents
used_mem_percent=$(echo "scale=2; $used_mem / $total_mem * 100" | bc)
avail_mem_percent=$(echo "scale=2; $avail_mem / $total_mem * 100" | bc)

echo "Total Memory: $total_mem mb " | tee -a $log_file
echo "Used Memory: $used_mem mb ($used_mem_percent%)" | tee -a $log_file
echo "Available Memory: $avail_mem mb ($avail_mem_percent%)" | tee -a $log_file
echo "------------------------" | tee -a $log_file
echo | tee -a $log_file

## Capturing I/O Info
echo "Disk I/O Info:" | tee -a $log_file
echo "------------------------" | tee -a $log_file
io_info=$(iostat -d)
line_count=$(iostat -d | wc -l)
# this produces 5 lines that we are not concerned with
# my goal is isolate the amount of disk devices via line_count
# for each line in io_info
# 	if line starts with lowercase letter and is not empty 
# 	read lines {awk 1, 2, 3, 4}
count=0
for line in $(seq 1 $line_count)
do
	current_line=$(echo "$io_info" | head -$line | tail +$line)
	if [[ "$current_line" == [a-z]* ]] && [[ "$current_line" != " *" ]]
	then
		count=$(($count + 1))
		echo -n "Device $count	TPS	Writes/sec	Reads/sec" | tee -a $log_file
		echo | tee -a $log_file
		echo "--------" | tee -a $log_file
	      	echo -n "$current_line" | awk '{print $1"\t\t"$2"\t"$3"\t\t"$4}' | tee -a $log_file
		echo | tee -a $log_file
	fi
done
cpu_use_result=$(ps -aux --sort=-%cpu | head -n 6)
mem_use_result=$(ps -aux --sort=-%mem | head -n 6)

echo "------------------------" | tee -a $log_file
echo "CPU Usages (top 5)" | tee -a $log_file
echo "------------------------" | tee -a $log_file
echo "$cpu_use_result" | tee -a $log_file


echo "------------------------" | tee -a $log_file
echo "MEMORY Usages (top 5)" | tee -a $log_file
echo "------------------------" | tee -a $log_file
echo "$mem_use_result" | tee -a $log_file
	

