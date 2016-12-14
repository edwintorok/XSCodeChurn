#!/bin/bash
#retrieve list of test cases associated to CAs
#stdin: list of CAs
#Example output from web service
#{"xenrt_job": 397394, "xenrt_sequence": "sarasota-sxm-othersr-config-02.seq", "tc_id": "TC-16920", "tc_variant": null}
webService=http://testrun.xenrt.citrite.net/tools/bugdetails
while read LINE 
do  
#	echo  $webService/$LINE
	tc=`wget -qO - $webService/$LINE`
#	echo ">$tc<"
	if [ "$tc"  = "{}" ]; then
		echo $LINE,'','','',''
	else
		xenrt_job=`echo $tc | jq '.xenrt_job'`
		xenrt_sequence=`echo $tc | jq '.xenrt_sequence'`
		tc_id=`echo $tc | jq '.tc_id'`
		tc_variant=`echo $tc | jq '.tc_variant'`
		echo $LINE,$xenrt_job,$xenrt_sequence,$tc_id,$tc_variant
	fi
done 
