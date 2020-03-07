
#!/usr/bin/env bash
set -x

P="csrando"

#if [ TRAVIS_EVENT_TYPE != "cron"]
#then
#  exit
#fi

##### build #####
mkdir "target"

### .love
cp -r src target	
cd target/src
"love-release -D -p ${P}"
cd releases
{$P.deb} --daily

read -r body <daily.txt
curl -H "Content-Type: application/json" -X POST -d "${body}" "${WEBHOOK}"
