var connection = require('../connection/db')

const validateToken = (req, res, next) => {
  if (!req.headers.auth_token) return res.status(403).json({ message: 'No token' })

  let query = 'SELECT * FROM users WHERE token = ? LIMIT 1'
  connection.connect.query(query, [req.headers.auth_token], function (err, result) {
    if (!err && result.length) next()
    else return res.status(403).json({ message: 'Token invalid' })
  })
}

exports.validateToken = validateToken
