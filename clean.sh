grn=$'\e[1;32m'
end=$'\e[0m'
SECONDS=0
find . -name "*.lock" -type f -delete
find . -name "*.gm.dart" -type f -delete
echo "\n${grn}Cleaning dependencies in app_core\n${end}"
fvm flutter clean;
cd modules;
for d in */; do
  cd $d;
  echo "\n${grn}Cleaning dependencies in: $d\n${end}"
  fvm flutter clean;
  cd ..;
done
duration=$SECONDS
echo "${grn}Cleaning done in $(($duration / 60)) minutes and $(($duration % 60)) seconds.${end}"