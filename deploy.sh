# Heroku (php)
flutter build web #  make sure the env is dev in locator file
cp composer.json build/web 
cp index.php build/web 
cp .htaccess build/web cd 
cd build/web
git add .
git commit -m 'deploy'
git push heroku master

# Firebase
rm build/web/composer.json
rm build/web/index.php
rm build/web/.htaccess
flutter build web
firebase deploy

# Netlify
flutter build web
rm build/web/composer.json
rm build/web/index.php
rm build/web/.htaccess
cp _redirects build/web #for allowing spa
netlify deploy
