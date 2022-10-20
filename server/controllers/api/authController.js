const userData = require('../../public/data/data.json')

const jwt = require('jsonwebtoken')
require('dotenv').config()

function gernerateTokens (user,type){
    return type==="all"?{
        "accessToken":jwt.sign(user,process.env.ACCESS_TOKEN_SECRET,{expiresIn:'120s'}),
        "refreshToken":jwt.sign(user,process.env.REFRESH_TOKEN_SECRET,{expiresIn:'100d'})
    }:type==="accessToken"?{
        "accessToken":jwt.sign(user,process.env.ACCESS_TOKEN_SECRET,{expiresIn:'120s'}),
    }:{
        "refreshToken":jwt.sign(user,process.env.REFRESH_TOKEN_SECRET,{expiresIn:'100d'})
    }
}

const authUser = (req,res)=>{
    const {username,pws} = req.body
    console.log(username,pws)
    if(!username || !pws) return res.status('401').json('{message: Username and password are required}')
    else if(userData.user.find(users => users.username===username)) {return res.status('409').json('{message: Username already exist}')}
   else{

    const tokens = gernerateTokens(req.body,'all')
    return res.json({tokens})
}
}

module.exports = {authUser,gernerateTokens}