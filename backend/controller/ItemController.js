var connection = require('../connection/db')

const getAll = (req, res) => {
  let query = 'SELECT i.id, i.name, i.description, i.image_path, i.description, i.price, t.name AS type_name FROM items i JOIN types t ON t.id = i.type_id'
  connection.connect.query(query, req.query.type_id, function (err, result) {
    if (err) return res.status(400).json({ message: err?.sqlMessage || 'Error!' })
    return res.json({
      data: JSON.parse(JSON.stringify(result)).map((r) => ({
        id: r.id,
        type: r.type_name,
        name: r.name,
        description: r.description,
        image_path: r.image_path,
        price: r.price,
      })),
      message: 'Success',
    })
  })
}

const getById = (req, res) => {
  let query = 'SELECT * FROM items WHERE id = ? LIMIT 1'
  connection.connect.query(query, req.params.id, function (err, result) {
    if (!err && result.length) return res.json({ data: result[0], message: 'Success' })
    return res.status(400).json({ message: err?.sqlMessage || 'Error!' })
  })
}
exports.getAll = getAll
exports.getById = getById
module.exports = exports
