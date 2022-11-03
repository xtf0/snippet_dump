#!/usr/bin/env sh
LAST_UPDATE_CHECK="$(cat last_update_check)"
TEAMSPEAK_SERVER_SITE="https://teamspeak.com/en/downloads/"
MOD_TIME="$(curl -sI "$TEAMSPEAK_SERVER_SITE" \
        | grep -h "last-modified" \
        | cut -d: -f2 \
        | LC_TIME=C xargs -i date -d "{}" +%s)"
        # +"%a, %d %b %T %Z %Y" > site_last_mod

if [ "$MOD_TIME" -gt "$LAST_UPDATE_CHECK" ]; then
        DOWNLOAD_URL="$(curl "$TEAMSPEAK_SERVER_SITE" \
        | grep -Eoh "https://files.teamspeak-services.com/releases/server/(.*)/teamspeak3-server_linux_amd64(.*).tar.bz2" ts.html \
        | uniq)"
        VERSION="$(grep -Eho "[0-9]\.[0-9]{1,2}\.[0-9]+" <<< $VERSION | uniq)"
        CURRENT_DIR="$(readlink versions/current)"
        TARGET_DIR="versions/$VERSION"
        if ! [ -d "$TARGET_DIR" ]; then
                mkdir "$TARGET_DIR"
                curl "$DOWNLOAD_URL" \
                | tar xjf - -C "$TARGET_DIR"
        fi
        diff -r $CURRENT_DIR $TARGET_DIR
        echo "OK? Y/N "
        read OK
        [ "$OK" == "Y" ] || [ "$OK" == "y" ] && ln -sf "$TARGET_DIR" "versions/current"
fi

date +%s > last_update_check
