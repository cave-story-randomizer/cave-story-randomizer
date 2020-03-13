set -ev

if [ "$TRAVIS_EVENT_TYPE" != "cron" ]; then exit 0; fi
sudo add-apt-repository -y ppa:bartbes/love-stable
sudo apt-get -q update
sudo apt-get -y install love

cd src
love-release
love "releases/CaveStoryRandomizer.love" --daily --headless
cat daily.txt
curl -H "Content-Type: application/json" -X POST -d @daily.txt "$WEBHOOK"