
!/usr/bin/env bash
set -x

P="csrando"

#if [ TRAVIS_EVENT_TYPE ~= "cron"]
#then
#  exit
#fi

sudo add-apt-repository ppa:bartbes/love-stable
sudo apt-get update
sudo apt-get install love

##### build #####
mkdir "target"

### .love
cp -r src target	
cd target/src

# .love file
zip -9 -r - . > "../${P}.love"
cd -

xvfb-run love "target/${P}.love" --daily

read -r body <daily.txt
curl -H "Content-Type: application/json" -X POST -d "${body}" "${WEBHOOK}"
