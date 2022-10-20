
const jwt = require('jsonwebtoken')
require('dotenv').config()


const checkToken = (req,res,next)=>{
const authHeader = req.headers['authorization']
const token = authHeader && authHeader.split(' ')[1]
if(!token) return res.status("401").json({"message":"The access token is require"})

jwt.verify(token,process.env.ACCESS_TOKEN_SECRET,(err,user)=>{
    if(err) return res.status('401').send(err)
    req.user = user
    next()
})

}
const refreshToken = (req,res,next)=>{
    const authHeader = req.headers['authorization']
    const token = authHeader && authHeader.split(' ')[1]
    if(!token) return res.status("401").json({"message":"The access token is require"})
    
    jwt.verify(token,process.env.REFRESH_TOKEN_SECRET,(err,user)=>{
        if(err) return res.status('401').send(err)
        delete user.iat
        delete user.exp
        req.user = user
        next()
    })
    
    }
module.exports = {checkToken,refreshToken}