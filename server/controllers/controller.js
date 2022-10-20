const path = require('path')
const home = (req,res)=>{
    res.sendFile(path.join(__dirname,'../views','index.html'))
}

const test = (req,res)=>{
    res.send("<h1> The test is perfoms succesfully</h1>") 
}

module.exports = {home,test}