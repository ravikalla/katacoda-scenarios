## Execute SQL scripts on DB

* Download the application code that has SQL scripts in it -
`git clone https://github.com/ravikalla/online-bank.git`{{execute}}

* Go to application folder -
`cd online-bank`{{execute}}

* Execute SQL scripts in MySQL server -
`docker exec -i bankmysql mysql -uroot -proot < sql_dump/onlinebanking.sql`{{execute}}
