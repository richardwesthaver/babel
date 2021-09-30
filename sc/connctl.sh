#!/usr/bin/sh

print_tech() {
connmanctl technologies | awk '/Type/ { print $NF }'
}

main() {
print_tech
}
main
