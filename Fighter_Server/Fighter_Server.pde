import processing.net.*;
import java.util.*;

Server server;
HashMap<Integer, Player> players;
HashMap<Client, Integer> clients;
int id;
PVector[] spawnLocs = {new PVector(0, 0, 0), new PVector(-4500, 0, 0), new PVector(4500, 0, 0), new PVector(0, 0, -4500), new PVector(0, 0, 4500), new PVector(-4500, 0, -4500), new PVector(4500, 0, 4500), new PVector(4500, 0, -4500), new PVector(-4500, 0, 4500)};

void setup()
{
  size(150, 150);
  frameRate(60);
  background(0);
  textAlign(CENTER, CENTER);
  text("SERVER", width/2, height/2);

  server = new Server(this, 1234);
  players = new HashMap<Integer, Player>();
  clients = new HashMap<Client, Integer>();
}

void draw()
{
  String toSend = "";

  for (Integer k : players.keySet())
  {
    Player temp = players.get(k);
    toSend += temp.getInfo() + "|";
  }

  if (toSend != "")
  {
    server.write("PLAYERS|" + toSend.substring(0, toSend.length()-1) + "\n");
  }
  
  sendLeaderBoard();
}

//New client joins server
void serverEvent(Server someServer, Client someClient)
{
  Player player = new Player(someClient, id);
  new Thread(player).start();
  players.put(id, player);
  clients.put(someClient, id);
  someClient.write("ID|" + id + "\n");
  id++;
}

//Client leaves server
void disconnectEvent(Client someClient)
{
  server.write("LEFT|" + clients.get(someClient) + "\n");
  players.remove(clients.get(someClient));
  clients.remove(someClient);
}
