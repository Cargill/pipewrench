val=$(head -c 1 partition.txt)

if [[ $val -eq 4 ]]
then
	echo -n "1" > partition.txt
else
	echo -n $((val+1)) > partition.txt
fi
