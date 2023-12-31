class Player implements Runnable, Comparable<Player>
{
  Client client;
  PVector pos;
  float yaw, health;
  int ID, cooldown, reviveTimer, kills;
  boolean dead, active, reviving;

  Player(Client client, int ID)
  {
    this.client = client;
    this.pos = new PVector(0, 0, 0);
    this.yaw = 0;
    this.ID = ID;
    cooldown = 3 * 60;
    health = 100;
    active = true;
  }

  //Runs forever on a new thread constantly talking with individual client about actions
  void run()
  {
    while (active)
    {
      //Grab line from client
      if (client.available() > 0)
      {
        String message = client.readString();
        message = message.substring(0, message.indexOf("\n"));

        if (message != null)
        {
          String[] data = split(message, "|");

          //Location rotation and health
          if (data[0].equals("POSITION"))
          {
            pos.x = float(data[1]);
            pos.y = float(data[2]);
            pos.z = float(data[3]);
            yaw = float(data[4]);
          }

          //One player hit another player
          else if (data[0].equals("HIT"))
          {
            synchronized(players)
            {
              Player player = players.get(int(data[1]));

              if (player != null && player.applyDamage(int(data[2]), ID))
              {
                kills++;
                client.write("KILL|\n");
                sendLeaderBoard();
              }
            }
          }
        }
      }
    }
  }

  //returns true if killed false otherwise
  boolean applyDamage(int damage, int id)
  {
    health -= damage;
    reviveTimer = 60 * 5;
    client.write("HIT|" + id + "\n");

    //dead
    if (health <= 0)
    {
      dead = true;
      return true;
    }

    return false;
  }

  //Returns info about player, also runs cooldown for respawn
  String getInfo()
  {
    if (dead)
    {
      cooldown--;

      if (cooldown <= 0)
      {
        dead = false;
        cooldown = 3 * 60;
        health = 100;
        
        PVector spawn = getBestSpawn();
        pos = new PVector(spawn.x,spawn.y,spawn.z);
      }
    } 
    
    //Revive cooldown
    else if(reviveTimer > 0)
    {
      reviveTimer--;
      
      if(reviveTimer <= 0)
        reviving = true;
    }
    
    //restoring health
    if(reviving)
    {
      health += 3;
      
      if(health > 100)
      {
        health = 100;
        reviving = false;
      }
    }

    return ID + "*" + pos.x + "*" + pos.y + "*" + pos.z + "*" + yaw + "*" + health + "*" + dead;
  }

  //Compares players by kill amount
  int compareTo(Player player)
  {
    return player.kills - kills;
  }
}
