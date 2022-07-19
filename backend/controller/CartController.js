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
      })),
      message: 'Success',
    })
  })
}

const insert = (req, res) => {
  const user = res.locals.current_user
  let query = 'replace into carts (user_id, item_id) values (?, ?)'

  connection.connect.query(query, [user.id, req.body.item_id], function (err, result) {
    if (err) return res.json({ message: err?.sqlMessage || 'Error!' })
    return res.json({ message: 'Success' })
  })
}

const remove = (req, res) => {
  const user = res.locals.current_user
  let query = 'DELETE FROM carts WHERE user_id = ? AND item_id = ?'

  connection.connect.query(query, [user.id, req.body.item_id], function (err, result) {
    if (err || !result.affectedRows) return res.json({ message: err?.sqlMessage || 'Error!' })
    return res.json({ message: 'Success' })
  })
}

const checkout = (req, res) => {
  const user = res.locals.current_user
  let query = 'DELETE FROM carts WHERE user_id = ?'

  connection.connect.query(query, [user.id, req.body.item_id], function (err, result) {
    if (err || !result.affectedRows) return res.json({ message: err?.sqlMessage || 'Error!' })
    return res.json({ message: 'Success' })
  })
}

exports.getAll = getAll
exports.insert = insert
exports.remove = remove
exports.checkout = checkout
module.exports = exports
