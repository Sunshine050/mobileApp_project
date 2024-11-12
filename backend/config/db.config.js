const mysql = require('mysql2');
require('dotenv').config()

const connection = mysql.createConnection({
  host: process.env.MYSQL_HOST || 'localhost',
  port: process.env.MYSQL_PORT || 3306,
  user: process.env.MYSQL_USRENAME || 'root',
  password: process.env.MYSQL_PASSWORD || '', 
  database: process.env.MYSQL_DATABASE || 'mobile_project'
});

connection.connect((err) => {
  if (err) throw err;
  console.log('Connected to the database!');
});

module.exports = connection;
