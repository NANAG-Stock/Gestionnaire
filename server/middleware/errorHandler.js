
const {logEvents} = require("../middleware/logs")
const erroHanler = (err,req,res,next)=>{
    logEvents(`${err.name}: ${err.message}`,'logs_infos.txt')
}
module.exports = erroHanler