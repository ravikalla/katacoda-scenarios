## Execute SQL scripts on DB

* Download the application code that has SQL scripts in it -
`git clone https://github.com/ravikalla/online-bank.git`{{execute}}

* Go to application folder -
`cd online-bank`{{execute}}

* Execute SQL scripts in MySQL server(wait for 15 seconds for SQL Server to start) -
`docker exec -i bankmysql mysql -uroot -proot < sql_dump/onlinebanking.sql`{{execute}}

Note: If there are errors in the above line(while running SQL Scripts), wait for ~15 seconds and run it again.
