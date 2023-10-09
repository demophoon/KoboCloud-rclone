#!/bin/sh
#Kobocloud getter

set +x

TEST=$1
#load config
. $(dirname $0)/config.sh

# Print functions
raw_info() {
    echo "`$Dt`: $*"
}
info() {
    raw_info "(  ) $*"
}
fail() {
    raw_info "(!!) $*"
    toast "'$*'"
    exit 1
}
run() {
    raw_info "(ex) Running $*"
    $@
}

# UI Functions
toast() {
    raw_info "(to) $*"
    if has_qndb; then
        /usr/bin/qndb -m mwcToast 3000 "$*"
    fi
}

# Test functions
has_qndb() {
    if [ -f "/usr/bin/qndb" ]; then
        return 0
    fi
    return 1
}
is_uninstall() {
    grep -q '^UNINSTALL$' $UserConfig
}
is_remove_deleted() {
    grep -q '^REMOVE_DELETED$' $UserConfig
}

# Flow functions
wait_for_internet() {
    i=0;
    info "waiting for network connected"
    if has_qndb; then
        /usr/bin/qndb -t 30000 -s wmNetworkConnected
    fi
    info "network connected"
    while [ $i -lt 10 ]; do
        info "Waiting for internet connection... $i"
        if has_internet; then
            info "internet connected successfully"
            return 0
        fi
        sleep 1
        i=$((i+1))
    done
    fail "Couldn't connect to internet"
}
has_internet() {
    wget --spider --quiet http://example.com
}

install_dependencies() {
    # check for qbdb
    if [ "$PLATFORM" = "Kobo" ]; then
        if has_qndb; then
            info "NickelDBus found"
        else
            info "NickelDBus not found: installing it!"
            wget "https://github.com/shermp/NickelDBus/releases/download/0.2.0/KoboRoot.tgz" -O - | tar xz -C /
        fi
        if [ -f "${RCLONE}" ]; then
            info "rclone found"
        else
            info "rclone not found: installing it!"
            mkdir -p "${RCLONEDIR}"
            rcloneTemp="${RCLONEDIR}/rclone.tmp.zip"
            rm -f "${rcloneTemp}"
            wget "https://github.com/rclone/rclone/releases/download/v1.64.0/rclone-v1.64.0-linux-arm-v7.zip" -O "${rcloneTemp}"
            unzip -p "${rcloneTemp}" rclone-v1.64.0-linux-arm-v7/rclone > ${RCLONE}
            rm -f "${rcloneTemp}"
        fi
    fi
}

fetch_books() {
    info "fetching books from kobocloud..."
    while read url || [ -n "$url" ]; do
        if echo "$url" | grep -q '^#'; then
            continue
        elif echo "$url" | grep -q "^REMOVE_DELETED$"; then
            info "Will delete files no longer present on remote"
        elif [ -n "$url" ]; then
            info "Getting $url"
            command=""
            if grep -q "^REMOVE_DELETED$" $UserConfig; then
              # Remove deleted, do a sync.
              command="sync"
            else
              # Don't remove deleted, do a copy.
              command="copy"
            fi
            remote=$(echo "$url" | cut -d: -f1)
            dir="$Lib/$remote/"
            mkdir -p "$dir"
            run ${RCLONE} ${command} --error-on-no-transfer --no-check-certificate -v --config ${RCloneConfig} "$url" "$dir"
            if [ $? = 0 ]; then
                update_libraries
            else
                info "skipping library refresh"
            fi
        fi
    done < $UserConfig
    info "completed fetching books"
}

update_libraries() {
    info "refreshing libraries"
    if has_qndb; then
        /usr/bin/qndb -t 3000 -s pfmDoneProcessing -m pfmRescanBooksFull
    fi
}


# Main function
main() {
    if is_uninstall; then
        info "uninstalling KoboCloud!"
        run $KC_HOME/uninstall.sh
        exit $?
    fi

    if is_remove_deleted; then
        info "Remove Deleted detected."
        echo "$Lib/filesList.log" > "$Lib/filesList.log"
    fi

    wait_for_internet
    install_dependencies
    fetch_books

    run rm "$Logs/index" >/dev/null 2>&1
    info "done!"
}

main
exit 0
