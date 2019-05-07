#! /bin/bash

awkc="awk -vFPAT='[^,]*|\"[^\"]*\"' -v OFS=','"
folder="/home/ucfnbso/unorganised-files/ff_sample/2018/01/01/"
sensors=`ls $folder | head -n $1`

jq_string=".[] | \
  [\"{}\",\
  ( (input_filename/\"/\" | .[ .|length-1 ] )/\".\" | .[0]),\
  .VendorMacPart+.MacAddress] \
  | @csv";
cmd="jq -r '$jq_string' $folder{}/*.pd \
  | sort | uniq \
  | $awkc '{print \$1,\$2}' \
  | sort | uniq -c";

echo "$sensors" \
  | parallel "$cmd" \
  > output-new-parallel.csv
