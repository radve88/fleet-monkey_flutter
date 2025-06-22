const mysql = require('mysql2');
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'Rashm!123',
  database: 'fleet_monkey_1',
  waitForConnections: true,
  connectionLimit: 10
});
module.exports = pool.promise();
