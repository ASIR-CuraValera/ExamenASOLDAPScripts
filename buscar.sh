#!/bin/bash

if [ $# -eq 0 ]; then
#Si no hemos pasado ningun parametro
	ldapsearch -x -b "dc=planet,dc=lan" -LLL "uid=*" | grep "uid:"
else
#Si pasamos algun parametro
	result_ap=`ldapsearch -x -b "dc=planet,dc=lan" -LLL "cn=$1" | grep -E "sn:|cn:|mail:"`
	result_nombre=`ldapsearch -x -b "dc=planet,dc=lan" -LLL "sn=$1" | grep -E "sn:|cn:|mail:"`

	#Cambiamos el separador por defecto, ya que si no nos mostrara todo en nuevas lineas
	orifs=IFS
	IFS=;

	if [ -z "$result_ap" ] && [ -z "$result_nombre" ]; then
		echo "No se han encontrado resultados con $1."
	elif ! [ -z "$result_ap" ]; then
		echo "Se han encontrado resultados con los apellidos."
		for i in ${result_ap[@]}
		do
			echo $i
		done
	elif ! [ -z "$result_nombre" ]; then
		echo "Se han encontrado resultados con el nombre."
		for i in ${result_nombre[@]}
		do
			echo $i
		done
	fi

	IFS=orifs
fi
