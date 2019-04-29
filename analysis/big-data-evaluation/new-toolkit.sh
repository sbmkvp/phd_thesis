#! /bin/bash
awkc="awk -vFPAT='[^,]*|\"[^\"]*\"' -v OFS=','"

FOLDER="/home/ucfnbso/unorganised-files/ff_sample/2018/01/01/"
SENSORS=`ls $FOLDER | head -n 25`

for SENSOR in $SENSORS;
do
  jq_string=".[] | \
    [\"$SENSOR\",\
    ( (input_filename/\"/\" | .[ .|length-1 ] )/\".\" | .[0]),\
    .VendorMacPart+.MacAddress] \
    | @csv";
  cmd="jq -r '$jq_string' $FOLDER$SENSOR/*.pd \
    | sort | uniq \
    | $awkc '{print \$1,\$2}' \
    | sort | uniq -c";
  echo "$(eval $cmd)" > output-new.csv;
done

