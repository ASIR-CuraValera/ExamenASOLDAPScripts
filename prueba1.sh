#!/bin/bash
dominio=`slapcat | grep -m3 "dn" | tail -n1`
dom1=${dominio:4}
dom2=(${dom1//,/ })
dom3=${dom2[0]:3}
dom4=${dom2[1]:3}
echo "$dom3.$dom4"
