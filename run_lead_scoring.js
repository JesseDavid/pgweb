const { Client } = require('pg');

const client = new Client({
    connectionString: process.env.DATABASE_URL,
    ssl: {
        rejectUnauthorized: false
      }
});

console.log('connecting to db...');
client.connect();
console.log('...connected');

console.log('Running Lead score processing...');
client.query('call update_leads();', (err, res) => {
    if (err) throw err;
    for (let row of res.rows) {
      console.log(JSON.stringify(row));
    }
    console.log('...done lead processing');
    client.end();
});