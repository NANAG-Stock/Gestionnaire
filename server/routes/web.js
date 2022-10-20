const express = require('express')
const route = express.Router()
const path = require('path')
const webRout = require('../controllers/controller')

route.get("^/$|index(.html)?",webRout.home)
route.get("/test(.html)?",webRout.test)

module.exports = route

