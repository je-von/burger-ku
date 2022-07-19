var express = require('express')
var userController = require('../controller/UserController')
var itemController = require('../controller/ItemController')
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

app.get('/items', itemController.getAll)

module.exports = app
