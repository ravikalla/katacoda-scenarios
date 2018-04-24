## Execute SQL scripts on DB

Download the application code -
`git clone https://github.com/ravikalla/online-bank.git`{{execute}}

Go to application folder -
`cd online-bank`{{execute}}

Execute SQL scripts of the application in the DB -
`docker exec -i bankmysql mysql -uroot -proot < sql_dump/onlinebanking.sql`{{execute}}
