#!/bin/bash

PS3="Alege o optiune din meniul de securitate al utilizatorilor: " 
select ITEM in "Verificare posibilitate logare ca un anumit utilizator" "Verificare posibilitate rulare comenzi cu drepturile lui root" "Verificati daca parola unui user verifica criteriile de complexitate" "Verificati existenta grupului principal pentru fiecare user din sistem" "Afisarea tuturor documentelor ce apartin unui utilizator" "Afisarea permisiunilor unui utilizator asupra unui anumit fisier" "Exit"
do
case $REPLY in
1)echo "Scrieti numele de utilizator: "
read user

linie=`cat /etc/shadow  | egrep "^$user:"`
if [[ -n $linie ]]
then
parola=`echo $linie| egrep "^$user:!"`
if [[ -n $parola ]]
then
echo "Acest utilizator nu are parola sau este blocat. Nu va puteti loga ca $user!"
else 
echo "Va puteti loga ca $user"
fi
else
echo "Acest utilizator nu exista"
fi;;
2)echo "Scrieti numele de utilizator: "
read user

grSudo=`cat /etc/group|egrep "^sudo:"`
areDR=`echo $grSudo | egrep ":$user|:$user,|,$user|,$user,"`

if [[ -n $areDR ]]
then
echo "Utilizatorul are dreptul de a executa comenzi cu sudo"
else 
echo "Utilizatorul NU are dreptul de a executa comenzi cu sudo"
fi;;
3)echo "Scrieti numele de utilizator: "
read user

linie=`sudo cat /etc/shadow  | egrep "^$user:"`
echo $linie
if [[ -n $linie ]]
then
password=`sudo cat /etc/shadow | egrep "^$user:"|cut -f2 -d":"`
    
pwquality_result=`echo "$password" | cracklib-check`
if [[ "$pwquality_result" != *"OK"* ]]
then
echo "Parola utilizatorului $username nu îndeplinește criteriile de complexitate."
echo "Rezultatul verificării: $pwquality_result"
else
echo "Parola utilizatorului $username îndeplinește criteriile de complexitate."
fi
else
echo "Acest user nu exista"
fi;;
4)userGr=`cat /etc/passwd | cut -f1,4 -d":"`
ok=1
for k in $userGr
do
gid=`echo $k|cut -f2 -d":"`
existaGr=`egrep ":$gid:" /etc/group`
use2=`echo $k| cut -f1 -d":"`
if [[ -z $existaGr ]]
then
echo "Userul $use2 nu respecta cerinta de existenta gr principal"
ok=0
fi
done
if [[ $ok -eq 1 ]]
then 
echo "Toti userii au un grup principal existent"
fi
;;
5)echo "Scrieti numele de utilizator: "
read user

linie=`sudo cat /etc/shadow  | egrep "^$user:"`
echo $linie
if [[ -n $linie ]]
then
sudo find / -user $user
else 
echo "Userul nu exista"
fi;;
6)echo "Scrieti numele de utilizator: "
read user

linie=`sudo cat /etc/shadow  | egrep "^$user:"`
if [[ -n $linie ]]
then
echo "Scrieti calea catre fisier: "
read path
if [[ -e $path ]]
then
owner=`ls -l $path|cut -f3 -d" "`
grOwner=`ls -l $path|cut -f4 -d" "`

realGr=`id -gn $user`
if [[ $owner = $user ]]
then
dr=`ls -l $path| cut -f1 -d" "| cut -c2-4`
echo $dr
elif [[ $grOwner = $realGr ]]
then
dr=`ls -l $path| cut -f1 -d" "| cut -c5-7`
echo $dr
else
dr=`ls -l $path| cut -f1 -d" "| cut -c8-10`
echo $dr
fi
else 
echo "Fisierul nu exista"
fi
else 
echo "Userul nu exista"
fi;;


7)exit 0;;
*)echo "Varianta incorecta! Reincercati!"
esac
done
