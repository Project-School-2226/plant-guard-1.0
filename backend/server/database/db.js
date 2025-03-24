// db.js
const mysql = require('mysql2/promise');

let pool;

async function connectToDatabase() {
  try {
    pool = await mysql.createPool({
      host: 'plantguard.c3c00asgk5ua.ap-south-1.rds.amazonaws.com',
      user: 'g46',
      password: 'Vishal!23new',
      database: 'g46',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });
    console.log('Connected to the MySQL database.');
  } catch (error) {
    console.error('Error connecting to the MySQL database:', error);
    throw error;
  }
}

module.exports = {
  connectToDatabase,
  pool: () => pool,
};