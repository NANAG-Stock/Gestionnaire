const fs = require('fs')
const fsPromise = require('fs').promises
const path = require('path')
const {v4:uuid} = require('uuid')
const {format} = require('date-fns')



const logEvents = async(msg,logFileName) =>{
    const id = uuid();
    const date = `${format(new Date(),'yyyy-MM-dd\tHH:mm:ss')}`
    const logTxt = `${id}\t${date}\t ${msg}\n`
try {
    if(!fs.existsSync(path.join(__dirname,'../logs'))){
        await fsPromise.mkdir(path.join(__dirname,'../logs'))
    }
    await fsPromise.appendFile(path.join(__dirname,'../logs',logFileName),logTxt)
    
} catch (error) {
    console.log(error)
}
    
}
const createLogs = (req,res,next)=>{
    logEvents(`${req.headers['user-agent']}\t${req.method}\t${req.headers.origin}\t${req.url}`,'logs_infos.txt')
    next()
}

module.exports = {createLogs,logEvents}