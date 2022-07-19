var mysql = require('mysql')

const connect = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'burgerku',
})
connect.on('error', function (err) {
  console.log(err)
})
exports.connect = connect
module.exports = exports
