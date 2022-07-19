var connection = require('../connection/db')

const auth = (req, res) => {
  let query = "SELECT * FROM users WHERE email = '" + req.body.email + "' AND password = '" + req.body.password + "' LIMIT 1"
  connection.connect.query(query, function (err, result, fields) {
    if (err) throw err
    if (result.length) return res.json({ data: result[0], message: 'Success' })
    else return res.json({ message: 'Invalid email or password!' })
  })
}

const register = (req, res) => {
  let token = Array(32)
    .fill(0)
    .map((x) => Math.random().toString(36).charAt(2))
    .join('')
  let query = "INSERT INTO users VALUES (null, '" + req.body.name + "', '" + req.body.email + "', '" + req.body.password + "', '" + token + "')"

  connection.connect.query(query, function (err, result) {
    if (err) throw err
    return res.json(result)
  })
}

exports.auth = auth
exports.register = register
module.exports = exports
