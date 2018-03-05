count=$1
qry=""
while [[ $count -lt $2 ]];do
	qry="$qry INSERT INTO mysql.employees_kudu (emp_no, birth_date, first_name,last_name, gender, hire_date) VALUES ($count.000, '2017-8-11','Geert','Vanderkelen', 'M',CURDATE());"
	count=$((count+1))
done

echo $qry

/usr/bin/mysql -uroot -pcloudera << eof
$qry
eof