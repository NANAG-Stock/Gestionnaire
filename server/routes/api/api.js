const express = require('express')
const route = express.Router()
const {checkToken,refreshToken} = require('../../middleware/jwtAuthentication')
const data = require('../../public/data/data.json')
const {authUser} = require('../../controllers/api/authController')
const {gernerateTokens} = require('../../controllers/api/authController')

route.route('/')
    .get((req,res)=>{
        res.json(data.user)
    })
    .post((reqs, res)=>{
        console.log(reqs)
        res.json(data.user)
    })

route.route('/register')
    .post(authUser)
    .get(checkToken,(req,res)=>{
        return res.status(200).json({"user":req.user})
    })
route.route('/refresh')
    .get(refreshToken,(req,res)=>{
        const accessToken = gernerateTokens(req.user,'accessToken');
        return res.status(200).json({accessToken})
    })

route.route("/:id")
    .get((req,res)=>{
        res.json({
            "id":req.params.id
        })
    })

module.exports = route