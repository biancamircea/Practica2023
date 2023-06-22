#!/bin/bash

PS3="Alege o optiune din meniul de configurari servicii de retea: " 
select ITEM in "Verificare serviciu activ" "Verificare porturi care asculta conexiuni" "Verificare jurnale de activitate al unui anumit serviciu" "Verificare fisiere de log pentru un anumit serviciu" "Exit"
do
case $REPLY in
1)echo "Scrieti serviciul pe care vreti sa-l verificati: "
read required_service

if systemctl is-active "$required_service.service" >/dev/null
then
echo "Serviciul $required_service este activ."
else
echo "Serviciul $required_service nu este activ."
fi;;
2)sudo netstat -tulnp
;;
3)
#EXEMPLE: nginx" "apache2" "mysql"
echo "Scrieti serviciul pentru care vreti sa verificati Jurnalele din ultimele 24 de ore: "
read required_service

journalctl -u $required_service --since "24 hours ago" ;;

4)
#EXEMPLE: "/var/log/boot.log" "/var/log/syslog"

echo "Scrieti numele fisierului de log pe care doriti sa-l verificati: "

read required_log
sudo tail -n 100 $required_log 
;;
5)exit 0;;
*)echo "Varinta incorecta. Reincercati!"

esac
done
