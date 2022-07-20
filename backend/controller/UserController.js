var connection = require('../connection/db')

const generateToken = () => {
  return Array(32)
    .fill(0)
    .map((x) => Math.random().toString(36).charAt(2))
    .join('')
}

const auth = (req, res) => {
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

// GOOGLE AUTH
const passport = require('passport')
const GoogleStrategy = require('passport-google-oauth2').Strategy

const GOOGLE_CLIENT_ID = '1082918024867-vfba809eebr6lqbfg10fitp850no8f96.apps.googleusercontent.com'
const GOOGLE_CLIENT_SECRET = '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'

passport.use(
  new GoogleStrategy(
    {
      clientID: GOOGLE_CLIENT_ID,
      clientSecret: GOOGLE_CLIENT_SECRET,
      // callbackURL: 'http://localhost:3000/auth/google/callback',
      callbackURL: 'http://10.0.2.2:3000/auth/google/callback',
      passReqToCallback: true,
    },
    function (request, accessToken, refreshToken, profile, done) {
      return done(null, profile)
    }
  )
)

passport.serializeUser((user, done) => {
  done(null, user)
})

passport.deserializeUser((user, done) => {
  done(null, user)
})

const googleAuth = passport.authenticate('google', { scope: ['email', 'profile'] })

const googleCallback = passport.authenticate('google', {
  successRedirect: '/auth/google/success',
  failureRedirect: '/auth/google/failure',
})

const googleSuccess = (req, res) => {
  if (!req.user) return res.status(400).json({ message: 'Error' })

  let query = 'SELECT * FROM users WHERE email = ? LIMIT 1'
  connection.connect.query(query, [req.user.email], function (err, result, fields) {
    if (!err && result.length) return res.json({ data: result[0], message: 'Success' })
    else {
      let token = generateToken()
      connection.connect.query('INSERT INTO users VALUES (null, ?, ?, ?, ?)', [req.user.displayName, req.user.email, '_', token], function (err, result) {
        if (err) return res.status(400).json({ message: err?.sqlMessage || 'Error!' })
        return res.json({ data: { name: req.user.displayName, email: req.user.email, token: token }, message: 'Success' })
      })
    }
  })
}

const googleFailure = (req, res) => {
  return res.json({ message: 'Error' })
}

exports.auth = auth
exports.googleAuth = googleAuth
exports.googleCallback = googleCallback
exports.googleSuccess = googleSuccess
exports.googleFailure = googleFailure
exports.register = register
exports.getCurrentUser = getCurrentUser
module.exports = exports
