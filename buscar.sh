#!/bin/bash

if [ -z $0 ]; then
#Si no hemos pasado ningun parametro
	uids=`slapcat | grep "uid:"`
	for i in ${uids[@]}
	do
		#echo "${uids[$i]}"
		echo $i
	done
#else
#Si pasamos algun parametro

fi
