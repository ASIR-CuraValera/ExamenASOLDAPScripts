#!/bin/bash

if ! [ -e dom ]; then
	echo "planet" > dom
	echo "lan" >> dom
fi

renum='^[0-9]+$'

read -p "UID: " uid

if [ -z "$uid" ]; then
	echo "Error: Es obligatorio introducir un UID."
	exit 1
fi

read -p "Apellido: " apellido

if [ -z "$apellido" ]; then
	echo "Error: Es obligatorio introducir un apellido."
	exit 1
fi

read -p "Nombre: " nombre

if [ -z "$nombre" ]; then
	echo "Error: Es obligatorio introducir un nombre."
	exit 1
fi

read -p "Número de usuario: " nusuario

if [ -z "$nusuario" ]; then

	if [ -e "ultnum" ]; then
		nusuario=$(<ultnum)
		nusuario=$((nusuario + 1))
	else
		nusuario=1001
	fi

	echo "Asignado valor $nusuario por defecto"
	echo "$nusuario" > ultnum
else
	if ! [[ $nusuario =~ $renum ]]; then
		echo "Error: El numero de usuario introducido no es un numero."
		exit 1
	fi
fi

read -p "Número de grupo: " ngrupo

if [ -z "$ngrupo" ]; then
	echo "Error: Es obligatorio introducir un numero de grupo."
	exit 1
else
	if ! [[ $ngrupo =~ $renum ]]; then
		echo "Error: El gid debe ser numerico"
		exit 1
	fi
fi

read -p "Contraseña: " pass

directorio_home="/home/$uid"
#Lowercase
lw_nombre="${nombre,,}"
lw_apellido="${apellido,,}"

#Obtener el nombre del dominio
#dominio=`slapcat | grep -m3 "dn" | tail -n1`
#dom1=${dominio:4}
#dom2=(${dom1//,/ })
#dom3="${dom2[0]:3}"
#dom4="${dom2[1]:3}"
dom3=`cat dom | head -n1 | tail -n1`
dom4=`cat dom | head -n2 | tail -n1`

correo="$lw_nombre.$lw_apellido@$dom3.$dom4"

read -p "¿Crear realmente el usuario [s/n]? " confirmacion

if [ $confirmacion = "n" ]; then
	echo "Saliendo"
	exit 1
fi

#Nombre de archivo
arc="usuario-$nusuario.ldif"

echo "dn: uid=$uid,ou=grupos,dc=$dom3,dc=$dom4" > "$arc"
echo "objectClass: inetOrgPerson" >> "$arc"
echo "objectClass: posixAccount" >> "$arc"
echo "objectClass: shadowAccount" >> "$arc"
echo "uid: $uid" >> "$arc"
echo "sn: $nombre" >> "$arc"
echo "cn: $apellido" >> "$arc"
echo "uidNumber: $nusuario" >> "$arc"
echo "gidNumber: $ngrupo" >> "$arc"
echo "userPassword: $pass" >> "$arc"
echo "loginShell: /bin/bash" >> "$arc"
echo "homeDirectory: $directorio_home" >> "$arc"
echo "mail: $correo" >> "$arc"
echo "shadowExpire: -1" >> "$arc"
echo "shadowFlag: 0" >> "$arc"
echo "shadowWarning: 7" >> "$arc"
echo "shadowMin: 8" >> "$arc"
echo "shadowMax: 999999" >> "$arc"
echo "shadowLastChange: 10877" >> "$arc"

ldapadd -x -W -D "cn=admin,dc=$dom3,dc=$dom4" -f "$arc"
