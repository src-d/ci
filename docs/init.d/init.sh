SHARED_FOLDER=/etc/shared
LANDING_FOLDER="$SHARED_FOLDER/landing"
CI_FOLDER="$SHARED_FOLDER/ci"
ERROR_PAGES_FOLDER=/var/www/public/errors
SITE_GENERATOR="$CI_FOLDER/docs/site-generator"

# install python, sphinx and breathe
echo 'Installing python, sphinx and breathe...';
apk --update add python py-pip && \
pip install Sphinx --no-cache-dir && \
pip install alabaster --no-cache-dir && \
pip install breathe --no-cache-dir;

# install doxygen
echo 'Installing doxygen...';
apk add doxygen;

# install nodejs and npm
echo 'Installing node & npm...';
apk add nodejs;

# install gettext
# gettext is installed only because of the envsubst
echo 'Installing gettext...';
apk add gettext;

# clone ci shared repo
if [ ! -d "$CI_FOLDER" ]; then
    echo 'Cloning CI shared repo...';
    git clone https://github.com/src-d/ci.git $CI_FOLDER;
else
    echo "Skiping CI cloning; already in ${CI_FOLDER}";
fi;

# install landing and export commons
if [ ! -d "$LANDING_FOLDER" ]; then
    echo 'Installing landing...';
    git clone https://github.com/src-d/landing.git $LANDING_FOLDER;
else
    echo "Skiping Landing cloning; already in ${LANDING_FOLDER}";
fi;

# prepare all hugo template assets
make -C $SITE_GENERATOR boilerplate;

# prepare 404 and 500 error pages
make -C $SITE_GENERATOR error-site OUTPUT="$ERROR_PAGES_FOLDER" SHARED="$SHARED_FOLDER" SOURCES="$ERROR_PAGES_FOLDER"
