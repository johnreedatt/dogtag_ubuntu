#!/bin/bash
set -eu

DS_DIR=/etc/389-ds

DT_DIR=/etc/dogtag

hostname=$(hostname)

sudo setup-ds --silent  --debug --file=${DS_DIR}/setup.inf
sudo pkispawn -v -f ${DT_DIR}/kra.conf -s KRA
sudo pkispawn -v -f ${DT_DIR}/ca.conf -s CA
