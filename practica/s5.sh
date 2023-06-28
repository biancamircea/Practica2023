#!/bin/bash

PS3="Alege o optiune din meniul de monitorizare a sistemului: " 
select ITEM in "Afisare toate aliasurile permanente/temporare" "Afisarea tuturor partitiilor impreuna cu dimensiunea lor" "Afisarea proceselor aflate in starea Running" "Afisarea tuturor jurnalelor de erori din sistem" "Exit"
do
case $REPLY in
1)bashrc_aliases=`grep -w "alias" ~/.bashrc`
session_aliases=`alias`

echo "Aliasurile permanente din .bashrc sunt:"
echo "$bashrc_aliases"

echo "Aliasurile temporare din această sesiune sunt:"
echo "$session_aliases"
;;

2)lsblk -o NAME,SIZE;;

3)ps -eo state -o comm|egrep "^R";;

4)journalctl -p err;;

5)exit 0;;
*)echo "Varianta incorecta. Reincercati!"
esac
done
