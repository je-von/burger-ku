var connection = require('../connection/db')

const getAll = (req, res) => {
  let query = req.query.type_id ? 'SELECT * FROM items WHERE type_id = ?' : 'SELECT * FROM items'
  connection.connect.query(query, req.query.type_id, function (err, result) {
    if (err) return res.json({ message: err?.sqlMessage || 'Error!' })
    return res.json({ data: result, message: 'Success' })
  })
}

const getById = (req, res) => {
  let query = 'SELECT * FROM items WHERE id = ? LIMIT 1'
  connection.connect.query(query, req.params.id, function (err, result) {
    if (!err && result.length) return res.json({ data: result[0], message: 'Success' })
    return res.json({ message: err?.sqlMessage || 'Error!' })
  })
}
exports.getAll = getAll
exports.getById = getById
module.exports = exports
