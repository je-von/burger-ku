var connection = require('../connection/db')

const validateToken = (req, res) => {
  let query = "SELECT * FROM users WHERE token = '" + req.headers.auth_token + "' LIMIT 1"
  //   connection.connect.query(query, function (err, result, fields) {
  //     if (err) throw err
  //     if (result.length) return res.json({ data: result[0], message: 'Success' })
  //     else return res.json({ message: 'Invalid email or password!' })
  //   })
}

exports.validateToken = validateToken
