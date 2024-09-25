@echo off
setlocal EnableDelayedExpansion

echo -- NOTE: This script was created by AleGla. I hope it useful to you.
echo -- NOTE: The goal of this script is to get the certificate of a url in format jks. 

set /p URL= "->  Enter URL (Only domain): "
set /p PATH_CERTIFICATE= "->  Enter path where the certificate will save (jks): "

if exist "%PATH_CERTIFICATE%" (
    echo The path exists. The certificate will be save=!PATH_CERTIFICATE!
	pause
) else (
	set PATH_CERTIFICATE=%cd%/JKS
    echo The path doesn't exists. The certificate will be save= !PATH_CERTIFICATE!
	pause
)

echo -- Will download the certificate in extension .pem of the URL: '%URL%'.

set PEM_FILE=!%PATH_CERTIFICATE%/certificate_temp.pem
openssl s_client -showcerts -connect %URL%:443 <nul 2>nul|openssl x509 -outform PEM >!PEM_FILE!

if exist "%PEM_FILE%" (
    echo .............	The download was OK	.............         
) else (
    echo .............	There was a problem with the download of certificate	.............
	echo Press any key to exit . . .
	pause>nul
)

echo -- Please, introduce the data requested you to create JKS.

set /p LANGUAGE= "->  Enter language in lowercase (ex. en) - jks: "
set /p ALIAS= "->  Enter alias - jks: "
set /p CERTIFICATE_NAME= "->  Enter certificate name - jks: "
set /p STOREPASS= "->  Enter storepass at least 6 characters - jks: "
set JKS_FILE=!%PATH_CERTIFICATE%/%CERTIFICATE_NAME%

echo -- Generating certificate with JKS format...
keytool -J-Duser.language=!LANGUAGE! -import -file !PEM_FILE! -alias !ALIAS! -keystore !JKS_FILE! -storepass !STOREPASS!
del %PEM_FILE:/=\%

if exist "%JKS_FILE%" ( 
    echo .............	The JKS was created successfully	.............
	echo Press any key to exit . . .
	echo -- NOTE: This script was created by AleGla. I hope it has been useful to you.
	pause>nul
) else (
    echo .............	There was a problem with the creation of certificate to jks format	.............
	echo -- NOTE: This script was created by AleGla. I hope it has been useful to you.
	echo Press any key to exit . . .

	pause>nul
)