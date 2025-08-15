USERNAME="13247046"
PASSWORD="tux149"
PORTAL_URL="http://192.168.1.1:8090/login.xml"

RESPONSE=$(curl -s -X POST "$PORTAL_URL" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "mode=191&username=$USERNAME&password=$PASSWORD&a=$(date +%s%3N)&producttype=0")