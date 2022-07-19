var connection = require('../connection/db')

const getAll = (req, res) => {
  console.log(req.headers.auth_token)

  let query = 'SELECT * FROM items'
  connection.connect.query(query, function (err, result) {
    if (err) return res.json({ message: err.sqlMessage || 'Error!' })
    return res.json({ data: result, message: 'Success' })
  })
}

exports.getAll = getAll
module.exports = exports
