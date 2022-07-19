var connection = require('../connection/db')

const getAll = (req, res) => {
  let query = 'SELECT * FROM items'
  connection.connect.query(query, function (err, result) {
    if (err) return res.json({ message: err?.sqlMessage || 'Error!' })
    return res.json({ data: result, message: 'Success' })
  })
}

exports.getAll = getAll
module.exports = exports
