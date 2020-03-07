P="csrando"
mkdir target
mkdir target/src
cp -r src target
cd target/src
zip -9 -r "${P}.love" .
sudo xvfb-run --server-args="-screen 0 1024x768x24" love "${P}.love" --daily
body=$(cat daily.txt)
echo "$body"
curl -H "Content-Type: application/json" -X POST -d '{"content": "test"}' "$WEBHOOK"
curl -H "Content-Type: application/json" -X POST -d "$body" "$WEBHOOK"