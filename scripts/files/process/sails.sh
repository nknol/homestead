#!/usr/bin/env bash
cd /vagrant/base-api/
# sails debug watch --silly
pm2 start process.dev.json
