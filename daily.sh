if [$TRAVIS_EVENT_TYPE != "cron"] then exit 0 fi
P="csrando"
mkdir target
mkdir target/src
cp -r src target
cd target/src
zip -9 -r "${P}.love" .
sudo xvfb-run --server-args="-screen 0 1024x768x24" love "${P}.love" --daily
cat daily.txt
curl -H "Content-Type: application/json" -X POST -d @daily.txt "$WEBHOOK"