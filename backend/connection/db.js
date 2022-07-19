var mysql = require('mysql')

var connect = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'burgerku',
})

exports.connect = connect
module.exports = exports
