const accessDomain = ['https://www.google.com','http://localhost:8000']
const corsOptions = {
    origin:(origin,callback)=>{
        if(accessDomain.indexOf(origin)!==-1 || !origin){
            callback(null,true)
        }else{
            callback(new Error("Domain not allow"))
        }
    },
    optionsSuccessStatus:200
}

module.exports=corsOptions