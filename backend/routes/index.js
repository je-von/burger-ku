var express = require('express')
var userController = require('../controller/UserController')
var itemController = require('../controller/ItemController')
var cartController = require('../controller/CartController')
var middleware = require('../middleware/AuthMiddleware')

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

/* GET home page. */
app.get('/', function (req, res, next) {
  res.render('index', { title: 'Express' })
})
app.post('/auth', userController.auth)
app.post('/register', userController.register)

// MIDDLEWARE to check user token
app.use(middleware.validateToken)
app.get('/users/current', userController.getCurrentUser)
app.get('/items', itemController.getAll)
app.get('/items/:id', itemController.getById)
app.get('/carts', cartController.getAll)
app.post('/carts', cartController.insert)
app.delete('/carts', cartController.remove)
app.delete('/carts/checkout', cartController.checkout)

module.exports = app
