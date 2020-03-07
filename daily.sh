
!/usr/bin/env bash
set -x

P="csrando"

#if [ TRAVIS_EVENT_TYPE ~= "cron"]
#then
#  exit
#fi

##### build #####
mkdir "target"

### .love
cp -r src target	
cd target/src
zip -9 -r - . > "../${P}.love"
cd -
sudo timeout -t 60 xvfb-run love "target/${P}.love" --daily

read -r body <daily.txt
curl -H "Content-Type: application/json" -X POST -d "${body}" "${WEBHOOK}"
