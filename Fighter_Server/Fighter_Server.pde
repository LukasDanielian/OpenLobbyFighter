import processing.net.*;

Server server;
HashMap<Integer, Player> players;
HashMap<Client, Integer> clients;
int id;
PVector[] spawnLocs = {new PVector(0,0,0), new PVector(-7500,0,0), new PVector(7500,0,0), new PVector(0,0,-7500), new PVector(0,0,7500), new PVector(-7500,0,-7500), new PVector(7500,0,7500), new PVector(7500,0,-7500), new PVector(-7500,0,7500)};
String packet;

void setup()
{
  size(150, 150);
  frameRate(1000);
  background(0);
  textAlign(CENTER, CENTER);
  text("SERVER", width/2, height/2);

  server = new Server(this, 1234);
  players = new HashMap<Integer, Player>();
  clients = new HashMap<Client, Integer>();
}

void draw()
{
  packet = "";
  receiveData();
  sendData();
  server.write(packet + "\n");
}

//Takes data from every 
void receiveData()
{
  Client client = server.available();

  if (client != null)
  {
    String allData = client.readString();
    allData = allData.substring(0, allData.indexOf("\n"));

    if (allData != null)
    {      
      String[] data = split(allData, "|");

      //Location rotation and health
      if (data[0].equals("POSITION"))
      {
        Player temp = players.get(int(data[1]));

        //Update info on server end
        if (temp != null)
        {
          temp.pos.x = float(data[2]);
          temp.pos.y = float(data[3]);
          temp.pos.z = float(data[4]);
          temp.yaw = float(data[5]);
          temp.health = float(data[6]);
        }
      }
      
      //One player hit another player
      else if(data[0].equals("HIT"))
      {
        packet += allData + "$";
        //server.write(allData + "\n");
      }
      
      //Player dies 
      else if(data[0].equals("DEAD"))
      {
        players.get(int(data[1])).dead = true;
        //server.write(allData + "\n");
        packet += allData + "$";
      }
    }
  }
}

//Send out player location info
void sendData()
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
    packet += "PLAYERS|" + toSend.substring(0, toSend.length()-1) + "$";
  }
}

//New client joins server
void serverEvent(Server someServer, Client someClient)
{
  players.put(id, new Player(id));
  clients.put(someClient, id);
  server.write("ID|" + id + "\n");
  id++;
}

//Client leaves server
void disconnectEvent(Client someClient)
{
  server.write("LEFT|" + clients.get(someClient) + "\n");
  players.remove(clients.get(someClient));
}
