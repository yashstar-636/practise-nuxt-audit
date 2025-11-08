import express from "express";
import { Server } from "socket.io";
import http from "http";

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

const rooms = {};

io.on("connection", (socket) => {
  console.log("Client connected:", socket.id);

  socket.on("join", (roomId) => {
    socket.join(roomId);
    const others = [...(rooms[roomId] || [])];
    rooms[roomId] = [...(rooms[roomId] || []), socket.id];
    socket.emit("participants", others);
    socket.to(roomId).emit("new-peer", socket.id);
  });

  socket.on("signal", ({ to, data }) => {
    io.to(to).emit("signal", { from: socket.id, data });
  });

  socket.on("leave", (roomId) => {
    socket.leave(roomId);
    rooms[roomId] = (rooms[roomId] || []).filter(id => id !== socket.id);
    socket.to(roomId).emit("peer-left", socket.id);
  });

  socket.on("disconnect", () => {
    for (const [room, ids] of Object.entries(rooms)) {
      if (ids.includes(socket.id)) {
        rooms[room] = ids.filter(id => id !== socket.id);
        socket.to(room).emit("peer-left", socket.id);
      }
    }
  });
});

const PORT = process.env.PORT || 8080;
server.listen(PORT, '0.0.0.0', () => console.log(`Listening on ${PORT}`));
