#!/bin/bash

## yet another screenshots grabber and uploader - shotUp
# idea from: http://blog.flienteen.com/2010/08/iuf-linux-image-uploader-v15.html
username='name@gmail.com'			# your username goes there
password='supermegasecretpassword'	# your password goes there

curlOpt=' -s -b cookies.txt -c cookies.txt  -A "Mozilla/5.0 " '
main_page=$(curl $curlOpt http://imgur.com/)
status=$(echo $main_page | sed -n 's/.*id="logged-in"><strong class="green">\([^"]*\)<\/strong>.*/\1/p')

if [ -z "$status" ]; then
	curl $curlOpt -d "username=$username&password=$password&remember=remember&submit=Continue" 'http://imgur.com/signin' > /dev/null

	main_page=$(curl $curlOpt http://imgur.com/)
	status=$(echo $main_page | sed -n 's/.*id="logged-in"><strong class="green">\([^"]*\)<\/strong>.*/\1/p')
fi

if [ -z "$status" ]
then
    echo "Autentificare esuata..."
    exit 1
fi

filename="/tmp/shot_$(date +%d-%m-%y\_%H:%M:%S).png"

scrot -s $filename

response=$(curl -b cookies.txt -c cookies.txt -s -F "image=@$filename" -F "key=486690f872c678126a2c09a9e196ce1b" http://imgur.com/api/upload.xml)

direct_link=$(echo $response | grep -E -o "<original_image>(.)*</original_image>" | grep -E -o "http://i.imgur.com/[^<]*")
echo $direct_link

echo -n $direct_link | xsel --clipboard --input
