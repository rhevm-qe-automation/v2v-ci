#!/usr/bin/env bash

# Arguments
test_name=$1

# Constants
logging_dir=/tmp
case_dir=$logging_dir/$test_name
monitor_processes=(nmon)
log_folders=(/var/log/uci)

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters given."
    exit
fi

echo "[Initializing] Creating a temporary folder to store logs..."
rm -rvf $case_dir
mkdir $case_dir

for folder in "${log_folders[@]}"; do
    echo "[Initializing] Removing log files from $folder..."
    rm -rvf $folder/*
done

echo "[Running] Running nmon..."
mkdir $case_dir/nmon
nmon -f -s 5 -T -c 83000 -m $case_dir/nmon &

sleep 1s

success=true
for proc in "${monitor_processes[@]}"; do
    echo "[Validating] Process: $proc..."
    if [ -z "$(pgrep $proc)" ]; then
    	echo "Proccess: $proc is not running!"
	success=false
    fi
done

if $success; then
    echo "+++ Validation passed +++"
else
    echo "!!! Validation failed !!!"
fi
