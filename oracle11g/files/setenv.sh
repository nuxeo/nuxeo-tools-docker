#!/bin/bash -e

umount /dev/shm
mount -t tmpfs shm -o rw,nosuid,nodev,noexec,relatime,size=4g /dev/shm
sysctl kernel.shmmax=4294967295

