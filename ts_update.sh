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

exit
diff output
Only in versions/3.13.7: 3RD_PARTY_LICENSES
diff -r versions/3.13.6/CHANGELOG versions/3.13.7/CHANGELOG
11a12,16
> ## Server Release 3.13.7 22 June 2022
> 
> ### Changed
> - New embedded default license is valid until the 1st of July 2027
> 
Only in versions/3.13.7: files
Only in versions/3.13.7: query_ip_allowlist.txt
Only in versions/3.13.7: query_ip_denylist.txt
Only in versions/3.13.7: ssh_host_rsa_key
Binary files versions/3.13.6/ts3server and versions/3.13.7/ts3server differ
