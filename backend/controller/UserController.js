var connection = require('../connection/db')
const fetch = (url) => import('node-fetch').then(({ default: fetch }) => fetch(url))

const generateToken = () => {
  return Array(32)
    .fill(0)
    .map((x) => Math.random().toString(36).charAt(2))
    .join('')
}

const auth = (req, res) => {
  if (!req.body.email || !req.body.email.includes('@') || !req.body.email.endsWith('.com') || !req.body.password || req.body.password.length < 8) {
    return res.status(400).json({ message: 'Error (Invalid input)' })
  }

  let query = 'SELECT * FROM users WHERE email = ? AND password = ? LIMIT 1'
  connection.connect.query(query, [req.body.email, req.body.password], function (err, result, fields) {
    if (!err && result.length) return res.json({ data: result[0], message: 'Success' })
    else return res.status(400).json({ message: err?.sqlMessage || 'Invalid email or password!' })
  })
}

const register = (req, res) => {
  let token = generateToken()
  let query = 'INSERT INTO users VALUES (null, ?, ?, ?, ?)'

  connection.connect.query(query, [req.body.name, req.body.email, req.body.password, token], function (err, result) {
    if (err) return res.status(400).json({ message: err?.sqlMessage || 'Error!' })
    return res.json({ message: 'Success' })
  })
}

const getCurrentUser = (req, res) => {
  const user = res.locals.current_user
  return res.json({ data: user, message: 'Success' })
}

const googleAuth = async (req, res) => {
  if (!req.body.access_token || !req.body.name || !req.body.email) return res.status(400).json({ message: 'Error' })

  // ? Intinya ini buat cek dulu access tokennya, valid dan sesuai sama emailnya gak
  let response = await fetch(`https://oauth2.googleapis.com/tokeninfo?access_token=${req.body.access_token}`)
  let data = await response.json()
  if (!data.email || data.email != req.body.email) return res.status(400).json({ message: "Error (Access token doesn't match user)" })

  let query = 'SELECT * FROM users WHERE email = ? LIMIT 1'
  connection.connect.query(query, [req.body.email], function (err, result, fields) {
    if (!err && result.length) return res.json({ data: result[0], message: 'Success' })
    else {
      let token = generateToken()
      connection.connect.query('INSERT INTO users VALUES (null, ?, ?, ?, ?)', [req.body.name, req.body.email, '_', token], function (err, result) {
        if (err) return res.status(400).json({ message: err?.sqlMessage || 'Error!' })
        return res.json({ data: { id: result.insertId, name: req.body.name, email: req.body.email, token: token }, message: 'Success' })
      })
    }
  })
}

exports.auth = auth
exports.googleAuth = googleAuth

exports.register = register
exports.getCurrentUser = getCurrentUser
module.exports = exports
