grn=$'\e[1;32m'
end=$'\e[0m'
SECONDS=0
echo "\n${grn}Generating localization in subscription_one\n${end}"
fvm flutter gen-l10n;
cd modules || exit;
for d in */; do
  cd $d || exit;
  echo "\n${grn}Generating localization in: $d\n${end}"
  fvm flutter gen-l10n;
  cd ..;
done
duration=$SECONDS
echo "${grn}Generating localization  done in $(($duration / 60)) minutes and $(($duration % 60)) seconds.${end}"