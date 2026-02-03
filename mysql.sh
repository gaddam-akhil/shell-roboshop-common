#!/bin/bash

APP_NAME=redis
source ./common.sh

check_root

app_restart
print_total_time