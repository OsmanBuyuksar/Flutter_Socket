const app = require('express')()

app.get('/', (req, res) => {
    res.send("Node Server is running. Yay!!")
})
const server = app.listen(3000, ()=>{
    console.log('Server listening to 3000')
})

console.log("server online")
//Socket Logic
const socketio = require('socket.io')(server)  //socket olusturulur
socketio.on('connection', (socket) => {
    console.log("connection")
    socket.on('msg', (data) =>{  //msg olayı gerçekleşirse verilen veriyi emit ile client a geri dondur
        console.log("received msg data, emitting sent data")
        socket.emit('sent', (data))
    })
})
