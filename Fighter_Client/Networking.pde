//Sets player ID before game
void getID()
{
  while (player.ID == -1)
  {
    if (client.available() > 0)
    {
      String message = client.readString();
      message = message.substring(0, message.indexOf("\n"));

      String[] data = split(message, "|");

      if (data[0].equals("ID"))
      {
        player.ID = int(data[1]);
        state = "Playing";
      }
    }
  }
}

//Receives and parses all data from server then sends info all on a new thread
void manageData()
{
  while (true)
  {
    packet = "";
    
    //Recieve data and updates
    if (client.available() > 0)
    {
      String message = client.readString();
      message = message.substring(0, message.indexOf("\n"));

      String[] lines = split(message, "$");

      for (int i = 0; i < lines.length; i++)
      {
        String line = lines[i];
        String[] data = split(line, "|");

        //Other player data
        if (data[0].equals("PLAYERS"))
        {
          for (int j = 1; j < data.length; j++)
          {
            String[] pos = split(data[j], "*");

            //Other player info
            if (int(pos[0]) != player.ID)
            {
              Enemy enemy = enemys.get(int(pos[0]));

              if (enemy == null)
              {
                enemy = new Enemy(int(pos[0]), new PVector(float(pos[1]), float(pos[2]), float(pos[3])), float(pos[4]), float(pos[5]));
                enemys.put(int(pos[0]), enemy);
              } else
              {
                enemy.pos = new PVector(float(pos[1]), float(pos[2]), float(pos[3]));
                enemy.yaw = float(pos[4]);
                enemy.health = float(pos[5]);
              }
            }
          }
        }

        //Manages damage
        else if (data[0].equals("HIT"))
        {
          if (int(data[2]) == player.ID)
            player.applyDamage(int(data[1]));
        }

        //Other player dies
        else if (data[0].equals("DEAD"))
        {
          if (int(data[1]) != player.ID)
          {
            enemys.get(int(data[1])).dead = true;

            if (int(data[2]) == player.ID)
              player.kills++;
          }
        }

        //player spawns back in
        else if (data[0].equals("RESPAWN"))
        {
          if (int(data[1]) == player.ID)
          {
            state = "Playing";
            player.health = 100;
            player.pos = new PVector(float(data[2]), 0, float(data[3]));
          } else
          {
            enemys.get(int(data[1])).dead = false;
          }
        }

        //Player leaves game
        else if (data[0].equals("LEFT"))
        {
          enemys.remove(int(data[1]));
        }
      }
    }

    //Send data
    packet += "POSITION|" + player.ID + "|" + player.pos.x + "|" + player.pos.y + "|" + player.pos.z + "|" + player.yaw + "|" + player.health;
    client.write(packet + "\n");
  }
}
