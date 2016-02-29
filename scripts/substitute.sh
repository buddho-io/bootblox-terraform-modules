#!/usr/bin/env sh

# File token substitution script.

#/ Usage: substitute -k A_KEY -v A-VALUE [<files>]
#/   -k <key>, --key <key>        The key to replace
#/   -v <value>, --value <value>  The value to substitue the key with
#/   -v, --verbose            verbose mode
#/   -h, --help               show this help message

set -e

usage() {
    grep "^#/" "$0" | cut -c"4-" >&2
    exit "$1"
}
while [ "$#" -gt 0 ]
do
	case "$1" in
		-k|--key) KEY="$2" shift 2;;
		-v|--value) VALUE="$2" shift 2;;
		--verbose) VERBOSE=1 shift;;
		-h|--help) usage 0;;
		-*) echo "# [substitute] unknown switch: $1" >&2;;
		*) break;;
	esac
done

# DIRNAME="$(cd "${1:-"."}" && pwd)"
# [ -z "$KEY" ] && usage 1
# [ -z "$VALUE" ] && usage 1

FILES=$(grep -s -l $KEY -r $@) || true

if [ -n "$FILES" ]; then
	for f in $FILES;
	do
		perl -p -i -e "s/$KEY/$VALUE/g" $f
	done
fi
