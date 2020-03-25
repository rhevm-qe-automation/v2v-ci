#!/usr/bin/env bash

# Arguments
test_name=$1

# Constants
logging_dir=/tmp
case_dir=$logging_dir/$test_name
case_files_dir=$case_dir/files
processes_to_kill=(nmon)
log_dirs=(/var/log/uci)

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters given"
    exit
fi

for process in "${processes_to_kill[@]}"; do
    echo "Killing process: $process..."
    killall $process
done

mkdir $case_files_dir

for log_dir in "${log_dirs[@]}"; do
    echo "Copying specific folder: $log_dir"
    cp -rf $log_dir $case_files_dir
done

file=$(date '+%Y-%m-%d_%H-%M-%S')_$(hostname -s)_$test_name-conv_vm.tar.gz
echo "Compressing logs into $file..."
cd $case_dir && tar cvzf /root/$file * && cd ~

echo "Removing test case temporary folder... $case_dir"
rm -rf $case_dir
