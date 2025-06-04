#!/bin/bash
# Proper URL submission script with required headers
URLS=(
  "https://thesiscraft.netlify.app"
  "https://thesiscraft.netlify.app/privacy-policy.html"
  "https://thesiscraft.netlify.app/terms.html"
)

for url in "${URLS[@]}"; do
  echo "Submitting $url"
  curl -X POST -H "Content-Length: 0" "https://www.google.com/webmasters/tools/ping?sitemap=$url"
  sleep 3
done
echo "Done! Check Search Console in 24-48 hours."
