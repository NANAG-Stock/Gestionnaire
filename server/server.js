const {createPool} = require ("mysql")
const pool = createPool({
    host:"localhost",
    user:"g_stock@2022",
    password:"G-s(2022-8-10)@DK",
    connectionLimit:10,
    database:"quinca",

})

pool.query("Select * From user",(err,res)=>{
    return console.log(res)
})