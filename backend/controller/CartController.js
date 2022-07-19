var connection = require('../connection/db')

const getAll = (req, res) => {
  const user = res.locals.current_user
  let query = 'SELECT * FROM carts c JOIN items i ON c.item_id = i.id WHERE user_id = ?'
  connection.connect.query(query, [user.id], function (err, result) {
    if (err) return res.json({ message: err?.sqlMessage || 'Error!' })
    return res.json({
      data: JSON.parse(JSON.stringify(result)).map((r) => ({
        item: {
          id: r.item_id,
          type_id: r.type_id,
          name: r.name,
          description: r.description,
          image_path: r.image_path,
          price: r.price,
        },
        quantity: r.quantity,
      })),
      message: 'Success',
    })
  })
}

const insert = (req, res) => {
  const user = res.locals.current_user
  let query = 'insert into carts (user_id, item_id, quantity) values (?, ?, ?) on duplicate key update quantity = quantity + ?'

  connection.connect.query(query, [user.id, req.body.item_id, req.body.quantity, req.body.quantity], function (err, result) {
    if (err) return res.json({ message: err?.sqlMessage || 'Error!' })
    return res.json({ message: 'Success' })
  })
}

exports.getAll = getAll
exports.insert = insert
module.exports = exports
