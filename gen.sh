grn=$'\e[1;32m'
end=$'\e[0m'
SECONDS=0
echo "\n${grn}Start generating\n${end}"
fvm flutter pub run build_runner build --delete-conflicting-outputs
duration=$SECONDS
echo "${grn}Generating done in $(($duration / 60)) minutes and $(($duration % 60)) seconds.${end}"