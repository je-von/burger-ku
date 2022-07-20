var connection = require('../connection/db')

const getAll = (req, res) => {
  let query = 'SELECT * FROM types'
  console.log(query)
  connection.connect.query(query, req.query.type_id, function (err, result) {
    if (err) return res.status(400).json({ message: err?.sqlMessage || 'Error!' })
    return res.json({
      data: result,
      message: 'Success',
    })
  })
}

exports.getAll = getAll
module.exports = exports
