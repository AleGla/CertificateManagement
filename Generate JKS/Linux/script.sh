echo This script was created to get the certificate from url in format jks.

read -p "Enter URL (Without port): " URL
read -p "Enter language (jks): " LANGUAGE
read -p "Enter alias (jks): " ALIAS
read -p "Enter certificate name (jks): " CERTIFICATE_NAME
read -p "Enter storepass (jks): " STOREPASS

echo Downloading the certificate in extension .pem of the URL: $URL
openssl s_client -showcerts -connect $URL:443 </dev/null 2>/dev/null|openssl x509 -outform PEM >./certificate.pem

FILE=./certificate.pem
if [ -f "$FILE" ]; then
    echo "The download was OK."
else
    echo "There was a problem with the download of certificate."
    exit 0
fi

echo Generating certificate with JKS format...
keytool -J-Duser.language=$LANGUAGE -import -file ./certificate.pem -alias $ALIAS  -keystore ./$CERTIFICATE_NAME -storepass $STOREPASS


FILE=./$CERTIFICATE_NAME
if [ -f "$FILE" ]; then
    rm ./certificate.pem
    echo "The certificate was created successfully."
else
    echo "There was a problem with the creation of certificate to jks format."
    exit 0
fi
