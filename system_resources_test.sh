#!/bin/bash

# Function to check CPU load
check_cpu_load() {
  cpu_load=$(top -bn1 | grep load | awk '{print $(NF-2)}')
  if [[ ${cpu_load} -gt 80 ]]; then
    echo "WARNING: CPU load is high: ${cpu_load}%"
    return 1
  fi
  return 0
}

# Function to check free memory
check_free_mem() {
  free_mem=$(free -m | awk 'NR==2{printf("%.2f", $4/$2 * 100)}')
  if [[ ${free_mem} -lt 15 ]]; then
    echo "WARNING: Free memory is low: ${free_mem}%"
    return 1
  fi
  return 0
}

# Function to check disk usage
check_disk_usage() {
  disk_usage=$(df -h / | awk '$NF=="/"{printf("%s", $5)}')
  if [[ ${disk_usage} -gt 90 ]]; then
    echo "WARNING: Disk space is low: ${disk_usage}%"
    return 1
  fi
  return 0
}

# Main script
check_cpu_load
cpu_status=$?
check_free_mem
mem_status=$?
check_disk_usage
# Print resource usage
echo "CPU Load: ${cpu_load}%"
echo "Free Memory: ${free_mem}%"
echo "Disk Usage (/): ${disk_usage}%"

# Check overall status
if [[ ${cpu_status} -eq 0 && ${mem_status} -eq 0 && ${disk_status} -eq 0 ]]; then
  exit 0
else
  echo "System resource issue detected!"
  exit 1
fi
