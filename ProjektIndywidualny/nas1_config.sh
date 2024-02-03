#!/bin/sh
#utwożenie dysku NAS
#tkowa 05.2023

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Podaj nazwe uzytkownika i sciezke dysku jako argumenty."
  exit 1
fi

username=$1
disc_location=$2

if [ ! -d "$disc_location" ]; then
  echo "Podana scieżka dysku ($disc_location) jest niedostępna."
  exit 1
fi

uid=$(id -u "$username")
if [ $? -eq 0 ]; then
else
  echo "Nie mozna odnalezc uzytkownika: $username"
  exit 1
fi

gid=$(id -g "$username")
if [ $? -eq 0 ]; then
else
  echo "Nie można odnaleźć grupy użytkownika dla: $username"
  exit 1
fi

mkdir /media/NAS1
cp /etc/fstab /etc/fstab.old
echo "$2        /media/NAS1     auto uid=$uid,gid=$gid,noatime 0 0" >> /etc/fstab
echo "" >> /etc/fstab
mount -a

cp /etc/samba/smb.conf /etc/samba/smb.conf.old
echo "" >> /etc/samba/smb.conf
echo "[NAS1]" >> /etc/samba/smb.conf
echo "" >> /etc/samba/smb.conf
echo "  path = /media/NAS1" >> /etc/samba/smb.conf
echo "  valid users = @users" >> /etc/samba/smb.conf
echo "  force group = users" >> /etc/samba/smb.conf
echo "  create mask = 0660" >> /etc/samba/smb.conf
echo "  directory mask = 0771" >> /etc/samba/smb.conf
echo "  read only = on" >> /etc/samba/smb.conf
echo "  guest ok = on" >> /etc/samba/smb.conf
echo "  writeable = on" >> /etc/samba/smb.conf

service smbd restart
