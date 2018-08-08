for v in 1 2
do
	echo $v

    git add "EURUSD-2012-0"$v"_converted.txt"
    git commit -m "uploaded EURUSD-2012-0"$v"_converted.txt"
    git push origin master


done
