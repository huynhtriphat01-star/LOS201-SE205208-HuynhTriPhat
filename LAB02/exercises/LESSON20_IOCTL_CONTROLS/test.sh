#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

sudo ./ioctl_test
