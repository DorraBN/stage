const app = require('express')();
const server = require('http').createServer(app);
const io = require('socket.io')(server, {
    cors: {
        origin: "*", // Autorisez tous les origines, à adapter selon votre besoin
        methods: ["GET", "POST"]
    }
});

io.on('connection', (socket) => {
    console.log('Client connected');

    socket.on('disconnect', () => {
        console.log('Client disconnected');
    });
});

io.on('MenuItemDeleted', (data) => {
    io.emit('MenuItemDeleted', data); // Émettre l'événement vers tous les clients connectés
});

server.listen(6001, () => {
    console.log('WebSocket server is listening on port 6001');
});
