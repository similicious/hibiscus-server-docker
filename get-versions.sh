#!/bin/bash
curl -sL "https://www.willuhn.de/products/hibiscus-server/changelog.php" | \
grep -oP 'Version \d\.\d{2}\.\d{2}' | \
sed 's/Version //' | \
jq -nR '[inputs | {version: ., is_latest: false}] 
        | if length > 0 then .[0].is_latest = true else . end 
        | .[:3]' > versions.json
