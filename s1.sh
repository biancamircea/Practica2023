#!/bin/bash

PS3="Alege o optiune din meniul de configurari de retea: " 
select ITEM in "Verificare adrese IP si masca de retea corect configurate" "Verificare interfete retea activate" "Verificare existenta ruta implicita si gateway corect" "Verificare servere DNS existente si accesibile" "Verificare conectivitatea cu un anumit dispozitiv si accesibilitatea unui anumit port" "Verificati lista regulilor de firewall din sistem" "Exit"
do
case $REPLY in
1)network_info=`ifconfig`
if echo "$network_info" | grep -q "inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+"
then
echo "Adresa IP este configurată corect."
else
echo "Adresa IP nu este configurată corect."
fi

if echo "$network_info" | grep -q "netmask [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+"
then
echo "Masca de subrețea este configurată corect."
else
echo "Masca de subrețea nu este configurată corect."
fi;;
2)network_info=`ifconfig`
if echo "$network_info" | grep -q "UP"
then
echo "Toate interfețele sunt activate."
else
echo "Cel puțin una dintre interfețe nu este activată."
fi;;
3)route_info=`ip route show`

if echo "$route_info" | grep -q "default via [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+"
then
echo "Există o rută implicită corectă configurată."
else
echo "Nu există o rută implicită corectă configurată."
fi

if echo "$route_info" | grep -q "via [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+ dev [a-zA-Z0-9]\+"
then
echo "Gateway-urile sunt configurate corect."
else
echo "Gateway-urile nu sunt configurate corect."
fi;;
4)if [ -f "/etc/resolv.conf" ] 
then
echo "Fișierul de configurare /etc/resolv.conf există."
    
#serverele DNS configurate în fișierul /etc/resolv.conf
dns_servers=`grep "nameserver" /etc/resolv.conf | cut -f2 -d" "`
    
#există servere DNS configurate
if [ -n "$dns_servers" ]
then
echo "Serverele DNS configurate sunt:"
echo "$dns_servers"
        
#serverele DNS sunt accesibile
for server in $dns_servers
do
if nslookup google.com $server >/dev/null
then
echo "Serverul DNS $server este accesibil."
else
echo "Serverul DNS $server nu este accesibil."
fi
done
else
echo "Nu sunt configurate servere DNS în fișierul /etc/resolv.conf."
fi
else
echo "Fișierul de configurare /etc/resolv.conf nu există."
fi;;

5)echo "Scrieti adresa IP pentru care doriti testarea conexiunii: "
read target_ip

# Testați conectivitatea folosind comanda ping
rez=`ping -c 3 "$target_ip"| egrep "0 received"`
if [[ -n $rez ]]
then
echo "Nu se poate stabili conectivitatea către $target_ip prin ping."
else
echo "Conectivitatea către $target_ip prin ping este OK."

echo "Pentru ce port doriti testarea accesibilitatii? "
read required_port

refused=`telnet $target_ip "$required_port"|egrep "Connection refused"`
if [[ -n $refused ]]
then
echo "Portul $required_port nu este accesibil."
else
echo "Portul $required_port este accesibil."
fi
fi;;

6)sudo iptables -L;;

7)exit 0;;
*)echo "Varianta incorecta! Reincercati!"
esac
done

