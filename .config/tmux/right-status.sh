#!/bin/bash

#function memory-usage() {
#    if [ "$(which bc)" ]; then
#        # Display used, total, and percentage of memory using the free command.
#        read used total <<< $(free -m | awk '/Mem/{printf $2" "$3}')
#        # Calculate the percentage of memory used with bc.
#        percent=$(bc -l <<< "100 * $total / $used")
#        # Feed the variables into awk and print the values with formating.
#        awk -v u=$used -v t=$total -v p=$percent 'BEGIN {printf "%s/%s %.1f% ", t, u, p}'
#        #awk -v u=$used -v p=$percent 'BEGIN {printf "%s %.1f% ", u, p}'
#    fi
#}
#
#function main() {
#    # Comment out any function you do not need. 
#    memory-usage
#}
#
## Calling the main function which will call the other functions.
#main

getCPU=$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]


# grab the second line of the ouput produced by the command: free -g (displays output in Gb)
getMem=$(free -h | sed -n '2p')
getMemPct=$(free -g | sed -n '2p')

#split the string in secondLine into an array
read -ra ADDR <<< "$getMem"
read -ra ADDRPct <<< "$getMemPct"

#get the total RAM from array
totalRam="${ADDR[1]//[^0-9.0-9]/}"
totalRamPct="${ADDRPct[1]}"

#get the used RAM from array
usedRam="${ADDR[2]//[^0-9.0-9]/}"
usedRamPct="${ADDRPct[2]}"

# calculate and display the percentage
pct="$(($usedRamPct*100/$totalRamPct))"
#echo "$pct%"
usage="$usedRam/$totalRam"
#echo "cpu:$getCPU% | mem:$pct% ($usage""G)"
echo "cpu:$getCPU% | mem:$pct% |"


