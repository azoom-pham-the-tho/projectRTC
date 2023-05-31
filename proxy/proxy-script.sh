serverPort=$( echo $PORT )
domainFe $( echo $DOMAIN )

if [ -z "$serverPort" ]
then
    serverPort="80"
fi

if [ -z "$domain" ]
then
    domainFe="http://94.237.79.161:8080"
fi

if [ -z "$domainBe" ]
then
    domainBe="http://94.237.79.161:8001"
fi

sed -i "s|SERVER_PORT|$serverPort|g" default.conf
sed -i "s|DOMAIN_FE|$domainFe|g" default.conf
sed -i "s|DOMAIN_BE|$domainBe|g" default.conf
