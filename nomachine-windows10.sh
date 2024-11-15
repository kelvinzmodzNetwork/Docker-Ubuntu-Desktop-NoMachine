wget -O ng.sh https://github.com/kmille36/Docker-Ubuntu-Desktop-NoMachine/raw/main/ngrok.sh > /dev/null 2>&1
chmod +x ng.sh
./ng.sh

function goto {
    label=$1
    cd 
    cmd=$(sed -n "/^:[[:blank:]]*${label}/{:a;n;p;ba}" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

: ngrok
clear
echo "Go to: https://dashboard.ngrok.com/get-started/your-authtoken"
read -p "Paste Ngrok Authtoken: " CRP
./ngrok config add-authtoken $CRP 
clear
echo "======================="
echo "Choose ngrok region (for better connection):"
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "Choose ngrok region: " REGION
./ngrok tcp --region $REGION 4000 &>/dev/null &
sleep 1

if curl --silent --show-error http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1; then
    echo "Ngrok is running!"
else
    echo "Ngrok Error! Please try again!"
    sleep 1
    goto ngrok
fi

docker pull danielguerra/ubuntu-xrdp > /dev/null 2>&1
clear
echo "===================================="
echo "Starting Docker with RDP..."
echo "===================================="
docker run --rm -p 3388:3389 danielguerra/ubuntu-xrdp > /dev/null 2>&1 &

echo "===================================="
echo "Username : ubuntu"
echo "Password : ubuntu"
echo "RDP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "===================================="
echo "Don't close this tab to keep RDP running."
echo "Support: akuh.net. Thank you!"
echo "===================================="
seq 1 43200 | while read i; do 
    echo -en "\r Running .     $i s /43200 s"; sleep 0.1
    echo -en "\r Running ..    $i s /43200 s"; sleep 0.1
    echo -en "\r Running ...   $i s /43200 s"; sleep 0.1
    echo -en "\r Running ....  $i s /43200 s"; sleep 0.1
    echo -en "\r Running ..... $i s /43200 s"; sleep 0.1
done
