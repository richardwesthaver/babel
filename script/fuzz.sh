#!/bin/sh
# implemented with GNU sed by default
# sed -i 's/SEARCH_REGEX/REPLACEMENT/g' INPUTFILE

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $script_dir/map

declare -A map=(
		[host]=HOST_VAL
		[email]=EMAIL_VAL
		[nginx_domain]=NGINX_DOMAIN_VAL

)
KEYS=("${!map[@]}")

CMD=${1:-fuzz}
TARGET=${2:-./etc/}
run() {
    echo "script started at $(date +%Y-%m-%d_%r)"
		$1 $2
		exit 1
}

fuzz() {
		printf "starting fuzz...\n"
		printf "$# args provided\n\n--++--\n"
		printf "found ${#map[@]} keys\n--++--\n"
		local target=$1
		printf "fuzzing target: $target\nwith: \n"
		for (( I=0; $I < ${#map[@]}; I+=1 )); do
				KEY=${KEYS[$I]}
				echo $KEY := ${map[$KEY]}
		done		
}

run $CMD $TARGET
