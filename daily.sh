P="csrando"
mkdir target
mkdir target/src
cp -r src target
cd target/src
zip -9 -r "${P}.love" .
sudo xvfb-run --server-args="-screen 0 1024x768x24" love "${P}.love" --daily
body=$(cat daily.txt)
echo "$body"
curl -H "Content-Type: application/json" -X POST -d "{\"embed\": {\"title\": \"**Daily Challenge: March 07, 2020**\",\"fields\": [{\"name\": \"Seed\",\"value\": \"1583613141\"},{\"name\": \"Settings\",\"value\": \"**Objective**: Best Ending\n**Spawn**: Arthur's House\n**Puppysanity**: Enabled\n**Sequence breaks**: All\n\"},{\"name\": \"Title Screen Code\",\"value\": \"<:mrlittle:685848232521367630> <:ironbond:685848232341143625> <:charcoal:685848232987066409> <:lifecapsule:685848233393913946> <:jellyfishjuice:685848232290680879> (Mr. Little/Iron Bond/Charcoal/Life Capsule/Jellyfish Juice)\"},{\"name\": \"<:rando:558942498668675072> Sharecode\",\"value\": \"`FAAAAAAAAAAxNTgzNjEzMTQxICAgICAgICAgIJH/`\"}]}}" "$WEBHOOK"
curl -H "Content-Type: application/json" -X POST -d "$body" "$WEBHOOK"