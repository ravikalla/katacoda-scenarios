## Execute SQL scripts on DB

* Download the application code that has SQL scripts in it -
`git clone https://github.com/ravikalla/online-bank.git`{{execute}}
![Download the application](https://github.com/ravikalla/images/blob/master/online-bank/4.png)

* Go to application folder -
`cd online-bank`{{execute}}

* Execute SQL scripts in MySQL server -
`docker exec -i bankmysql mysql -uroot -proot < sql_dump/onlinebanking.sql`{{execute}}
![Run SQL scripts in MySQL server](https://github.com/ravikalla/images/blob/master/online-bank/5.png)
