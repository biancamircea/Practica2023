#!/bin/bash

PS3="Alege o optiune din meniul de configurare al sistemului de fisiere: " 
select ITEM in "Verificati tipul unui fisier" "Verificati permisiunile detaliate ale unui fisier pentru fiecare grup/utilizator" "Afisati toate fisierele de un anumit tip din sistem" "Verificare specificatii legate de dimeniunile unui fisier" "Verificare timpi fisier" "Verificarea dimensiunilor tuturor fisierelor dintr-un anumit director" "Exit"
do
case $REPLY in
1) echo "Scrieti calea fisierului: "
read path
if [[ -f $path ]]
then
echo "Calea $path este un fișier."
elif [[ -d $path ]]
then
echo "Calea $path este un director."
elif [[ -L $path ]]
then
echo "Calea $path este o legătură simbolică."
elif [[ -c $path ]]
then
echo "Calea $path este un fisier de tipul char device."
elif [[ -b $path ]]
then
echo "Calea $path este un fisier de tipul block device."
elif [[ -p $path ]]
then
echo "Calea $path este named pipe."
else
echo "Calea $path nu este un fișier sau director valid."
fi;;

2)echo "Scrieti calea fisierului: "
read path

getfacl $path;;

3)echo "Scrieti tipul de fisier dorit (regular/director/char/block/piped/linked): "
read type

if [[ $type = "regular" ]]
then
sudo find / -type f | less
elif [[ $type = "director" ]]
then
sudo find / -type d | less
elif [[ $type = "char" ]]
then
sudo find / -type c |less
elif [[ $type = "block" ]]
then
sudo find / -type b | head -n 100
elif [[ $type = "piped" ]]
then
sudo find / -type p | less
elif [[ $type = "linked" ]]
then
sudo find / -type l | less
else echo "Tip invalid de fisier"
fi;;

4)echo "Scrieti denumirea fisierului: "
read file

if [[ -e $file ]]
then
dim=`du -sh $file|tr -s " "| cut -f1 -d" "`
echo "Marime fisier: $dim"
freeBlocks=`stat -c %f $file`
echo "Numar blocuri libere: $freeBlocks"
maxLen=`stat -c %l $file`
echo "Lungime maxima fisier: $maxLen"
blocS=`stat -c %s $file`
echo "Block size: $blocS"
else 
echo "Fisierul nu exista"
fi;; 

5)echo "Scrieti denumirea fisierului: "
read file

if [[ -e $file ]]
then
creare=`stat -c %w $file`
echo "Timp creare fisier: $creare"
acces=`stat -c %x $file`
echo "Timp ultim acces: $acces"
modif=`stat -c %y $file`
echo "Timp ultima modificare: $modif"
status=`stat -c %z $file`
echo "Timp ultima schimbare a stucturii fisierului: $status"
else 
echo "Fisierul nu exista"
fi;; 

6)echo "Scrieti calea directorului: "
read dir
toateFis=`find $dir -maxdepth 1`
echo $toateFis
for i in $toateFis
do
echo $i
dim=`stat -c %s $i`
echo 
echo $i are dimensiunea $dim
done;;

7)exit 0;;
*)echo "Varianta incorecta. Reincercati!"
esac
done
