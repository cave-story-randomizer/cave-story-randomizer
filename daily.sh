set -ev

if [ "$TRAVIS_EVENT_TYPE" != "cron" ]; then exit 0; fi
sudo xvfb-run --server-args="-screen 0 1024x768x24" love "releases/CaveStoryRandomizer.love" --daily
cat daily.txt
curl -H "Content-Type: application/json" -X POST -d @daily.txt "$WEBHOOK"