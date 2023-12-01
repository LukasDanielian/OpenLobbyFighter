import processing.net.*;
import java.util.*;

Server server;
HashMap<Integer, Player> players;
HashMap<Client, Integer> clients;
int id;
PVector[] spawnLocs = {new PVector(-4500, 0, 0), new PVector(4500, 0, 0), new PVector(0, 0, -4500), new PVector(0, 0, 4500), new PVector(-4500, 0, -4500), new PVector(4500, 0, 4500), new PVector(4500, 0, -4500), new PVector(-4500, 0, 4500)};

void setup()
{
  size(200, 150);
  frameRate(60);
  background(0);
  textSize(25);
  textAlign(CENTER, CENTER);

  server = new Server(this, 1111);
  players = new HashMap<Integer, Player>();
  clients = new HashMap<Client, Integer>();

  text(server.ip(), width/2, height/2);
}

//Sends all info about every player to everyone 60 times per second
void draw()
{
  String toSend = "";

  //get info from all players
  for (Integer k : players.keySet())
  {
    Player temp = players.get(k);
    toSend += temp.getInfo() + "|";
  }

  //Write info on all players to all clients
  if (toSend != "")
    server.write("PLAYERS|" + toSend.substring(0, toSend.length()-1) + "\n");
}

//New client joins server
protected void serverEvent(Server someServer, Client someClient)
{
  Player player = new Player(someClient, id);
  new Thread(player).start();
  players.put(id, player);
  clients.put(someClient, id);
  someClient.write("ID|" + id + "\n");
  id++;
  sendLeaderBoard();
}

//Client leaves server
protected void disconnectEvent(Client someClient)
{
  int id = clients.get(someClient);
  players.get(id).active = false;
  players.remove(id);
  clients.remove(someClient);
  sendLeaderBoard();
}
