#!/bin/bash

echo "analyzing log file"
echo -e "\n=================="

echo -e "\nlist of logs"
find . -name "*.log" -mtime -1

grep "ERROR" application.log
grep -c "ERROR" application.log
grep -Ec "FATAL|CRITICAL" system.log
grep "CRITICAL" system.log
