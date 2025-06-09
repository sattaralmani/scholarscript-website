#!/bin/bash

# Navigate to your public directory
cd ~/Desktop/myweb/myweb/public || { echo "Directory not found"; exit 1; }

# Add anchor point to index.html (if not exists)
if ! grep -q 'id="services"' index.html; then
    sed -i '/<section class="services-section"/a \ \ \ \ <div class="container">\n\ \ \ \ \ \ <div class="section-title">\n\ \ \ \ \ \ \ \ <h2>Our Editing Services</h2>\n\ \ \ \ \ \ </div>\n\ \ \ \ </div>' index.html
    echo "Added services section to index.html"
else
    echo "Services section already exists in index.html"
fi

# Update the link in thesis-proposal-complete-guide.html
sed -i 's|<a href="/services">Explore our editing packages</a>|<a href="index.html#services" class="button">Explore our editing packages</a>|' thesis-proposal-complete-guide.html

# Verify changes
echo ""
echo "Verification:"
echo "Anchor in index.html:"
grep -A 5 'id="services"' index.html

echo ""
echo "Link in guide:"
grep 'Explore our editing packages' thesis-proposal-complete-guide.html

# Set permissions
chmod 644 index.html thesis-proposal-complete-guide.html
echo ""
echo "Files updated successfully!"
