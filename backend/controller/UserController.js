var connection = require('../connection/db')

const auth = (req, res) => {
  let query = 'SELECT * FROM users WHERE email = ? AND password = ? LIMIT 1'
  connection.connect.query(query, [req.body.email, req.body.password], function (err, result, fields) {
    if (!err && result.length) return res.json({ data: result[0], message: 'Success' })
    else return res.json({ message: err?.sqlMessage || 'Invalid email or password!' })
  })
}

const register = (req, res) => {
  let token = Array(32)
    .fill(0)
    .map((x) => Math.random().toString(36).charAt(2))
    .join('')
  let query = 'INSERT INTO users VALUES (null, ?, ?, ?, ?)'

  connection.connect.query(query, [req.body.name, req.body.email, req.body.password, token], function (err, result) {
    if (err) return res.json({ message: err?.sqlMessage || 'Error!' })
    return res.json({ message: 'Success' })
  })
}

const getCurrentUser = (req, res) => {
  const user = res.locals.current_user
  return res.json({ data: user, message: 'Success' })
}

exports.auth = auth
exports.register = register
exports.getCurrentUser = getCurrentUser
module.exports = exports
