const express = require('express')
const app = express()
const path = require('path')
const {createLogs} = require('./middleware/logs')
const erroHanler = require('./middleware/errorHandler')
const cors = require('cors')
const corsOptions = require('./config/authorization')
const PORT = process.env.PORT || 8000

app.use(createLogs)
app.use(cors(corsOptions))
app.use(express.json())
app.use(express.urlencoded({extended:false}))
app.use(express.static(path.join(__dirname,'/public')))
app.use('/',require('./routes/web'))    
app.use('/user',require('./routes/api/api'))    
app.all("/*",(req,res)=>{ 
    res.status('404').sendFile(path.join(__dirname,'views','404.html'))
})
//
app.use(erroHanler)

// 
app.listen(PORT,()=>{
    console.log(`Server running on port ${PORT}`)
})

