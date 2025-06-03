#!/bin/bash

# Create corrected sitemap with proper XML structure
CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")

# Create sitemap.xml file
cat > sitemap.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 
        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
    <url>
        <loc>https://thesiscraft.netlify.app</loc>
        <lastmod>$CURRENT_DATE</lastmod>
        <priority>1.00</priority>
    </url>
    <url>
        <loc>https://thesiscraft.netlify.app/privacy-policy.html</loc>
        <lastmod>$CURRENT_DATE</lastmod>
        <priority>0.80</priority>
    </url>
    <url>
        <loc>https://thesiscraft.netlify.app/terms.html</loc>
        <lastmod>$CURRENT_DATE</lastmod>
        <priority>0.80</priority>
    </url>
</urlset>
EOF

# Add missing pages if they exist
for page in google-verification.html headers; do
  if [ -e "$page" ]; then
    sed -i "/<\/urlset>/i \\
    <url>\\
      <loc>https://thesiscraft.netlify.app/$page</loc>\\
      <lastmod>$CURRENT_DATE</lastmod>\\
      <priority>0.80</priority>\\
    </url>" sitemap.xml
  fi
done

# Simple XML validation
echo "Performing local validation..."
if grep -q "<?xml" sitemap.xml && \
   grep -q "<urlset" sitemap.xml && \
   grep -q "</urlset>" sitemap.xml && \
   [ $(grep -c "<loc>" sitemap.xml) -eq $(grep -c "</loc>" sitemap.xml) ] && \
   [ $(grep -c "<url>" sitemap.xml) -eq $(grep -c "</url>" sitemap.xml) ]
then
  echo "✅ XML appears valid (basic checks passed)"
else
  echo "❌ XML validation failed"
  echo "Please check sitemap.xml manually"
fi

# Add to robots.txt
echo "Updating robots.txt..."
echo -e "\n# Sitemap\nSitemap: https://thesiscraft.netlify.app/sitemap.xml" >> robots.txt

# Simple ping function
ping_search() {
  url="$1"
  if command -v curl &> /dev/null; then
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    echo "$url → HTTP $status_code"
  else
    echo "$url → (curl not available)"
  fi
}

# Ping search engines
echo
echo "Pinging search engines:"
ping_search "https://www.google.com/ping?sitemap=https://thesiscraft.netlify.app/sitemap.xml"
ping_search "https://www.bing.com/ping?sitemap=https://thesiscraft.netlify.app/sitemap.xml"

echo
echo "Sitemap created successfully!"
echo "View at: https://thesiscraft.netlify.app/sitemap.xml"