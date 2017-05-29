apk --update add python py-pip && \
        rm -rf /var/cache/apk && \
        pip install Sphinx --no-cache-dir && \
        pip install alabaster --no-cache-dir && \
        pip install breathe --no-cache-dir;
