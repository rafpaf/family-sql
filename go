rm -f ~/code/smjca/output/mountsinai.csv
rm -f ~/code/smjca/output/smithstreet.csv
run final.sql
cd output/
git add .
git commit -m "Committed automatically by script"
git push origin master
