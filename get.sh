grn=$'\e[1;32m'
end=$'\e[0m'
SECONDS=0
echo "\n${grn}Getting dependencies in app_core\n${end}"
#fvm install
#fvm use
fvm flutter pub get;
#cd modules;
#for d in */; do
#  cd $d;
#  echo "\n${grn}Getting dependencies in: $d\n${end}"
#  fvm flutter pub get;
#  cd ..;
#done
duration=$SECONDS
echo "${grn}Getting done in $(($duration / 60)) minutes and $(($duration % 60)) seconds.${end}"
