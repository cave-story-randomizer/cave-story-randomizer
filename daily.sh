
#!/usr/bin/env bash
set -x

P="csrando"
LV="11.2" # love version
LZ="https://bitbucket.org/rude/love/downloads/love-${LV}-win32.zip"

#if [ TRAVIS_EVENT_TYPE != "cron"]
#then
#  exit
#fi

##### build #####
mkdir "target"

### .love
cp -r src target	
cd target/src

# .love file
7z a "../${P}.love" *
cd -

### .exe
if [ ! -f "target/love-win.zip" ]; then wget "$LZ" -O "target/love-win.zip"; fi
7z e "target/love-win.zip" -o"target"
cd target
tmp="tmp"
mkdir -p "$tmp/$P"
cat "love.exe" "${P}.love" > "$tmp/${P}/${P}.exe"
cp  *dll target/license* "$tmp/$P"
cd "$tmp/$P"
"./${P}.exe" --daily
read -r body <daily.txt
curl -H "Content-Type: application/json" -X POST -d "${body}" "${WEBHOOK}"
