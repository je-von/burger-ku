var express = require('express')
var userController = require('../controller/UserController')
var itemController = require('../controller/ItemController')
var typeController = require('../controller/TypeController')
var cartController = require('../controller/CartController')
var middleware = require('../middleware/AuthMiddleware')
var passport = require('passport')
var session = require('express-session')
var cors = require('cors')

var app = express()
app.use(
  cors({
    origin: '*',
  })
)
app.use(express.json())
app.use(express.static('public'))
app.use(express.urlencoded({ extended: false }))
app.use(session({ secret: 'SECRET' }))
app.use(passport.initialize())
app.use(passport.session())
/* GET home page. */
app.get('/', function (req, res, next) {
  res.render('index', { title: 'Express' })
})
app.post('/auth', userController.auth)
app.post('/register', userController.register)

app.get('/auth/google', userController.googleAuth)
app.get('/auth/google/callback', userController.googleCallback)
app.get('/auth/google/success', userController.googleSuccess)
app.get('/auth/google/failure', userController.googleFailure)

// MIDDLEWARE to check user token
app.use(middleware.validateToken)
app.get('/users/current', userController.getCurrentUser)
app.get('/items', itemController.getAll)
app.get('/types', typeController.getAll)
app.get('/items/:id', itemController.getById)
app.get('/carts', cartController.getAll)
app.post('/carts', cartController.insert)
app.delete('/carts', cartController.remove)
app.delete('/carts/checkout', cartController.checkout)

module.exports = app
