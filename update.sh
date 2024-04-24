#!/usr/bin/env sh

if ! command -v ebuild &> /dev/null; then
    echo "Error: 'ebuild' command not found. Make sure it's installed and in your PATH."
    exit 1
fi

search_ebuild() {
    local dir="$1"
    for entry in "$dir"/*; do
        [ -d "$entry" ] && search_ebuild "$entry"
        [ "${entry##*.}" = "ebuild" ] && ebuild "$entry" digest
    done
}

search_ebuild "${1:-.}"
