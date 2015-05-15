#!/bin/bash -e

umount /dev/shm
mount -t tmpfs shm -o rw,nosuid,nodev,noexec,relatime,size=4g /dev/shm

