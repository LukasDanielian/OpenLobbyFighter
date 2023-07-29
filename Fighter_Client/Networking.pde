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
      }
    }
  }
}

//Receives and parses all data from server then sends info all on a new thread
void manageData()
{
  while (true)
  {
    //Recieve data and updates
    if (client.available() > 0)
    {
      String message = client.readString();

      if (message.indexOf("\n") != -1)
      {
        message = message.substring(0, message.indexOf("\n"));
        String[] data = split(message, "|");

        //Other player data
        if (data[0].equals("PLAYERS"))
        {
          synchronized(enemys)
          {
            for (int i = 1; i < data.length; i++)
            {
              String[] pos = split(data[i], "*");

              //Other player info
              if (int(pos[0]) != player.ID)
              {
                Enemy enemy = enemys.get(int(pos[0]));

                //Create new enemy
                if (enemy == null)
                {
                  enemy = new Enemy(int(pos[0]), new PVector(float(pos[1]), float(pos[2]), float(pos[3])), float(pos[4]), float(pos[5]), boolean(pos[6]));
                  enemys.put(int(pos[0]), enemy);
                }

                //Update enemy
                else
                {
                  enemy.pos = new PVector(float(pos[1]), float(pos[2]), float(pos[3]));
                  enemy.yaw = float(pos[4]);
                  enemy.health = float(pos[5]);
                  enemy.dead = boolean(pos[6]);
                }
                
                enemy.didGet = true;
              }

              //Current player
              else
              {
                player.health = float(pos[5]);

                //Respawn
                if (state.equals("Respawning") && !boolean(pos[6]))
                {
                  state = "Playing";
                  player.pos = new PVector(float(pos[1]), float(pos[2]), float(pos[3]));
                  player.yaw = atan2(-player.pos.x, player.pos.z) + HALF_PI;
                  player.gun.ammo = player.gun.magSize;
                  player.gun.reloading = false;
                  player.hitTimer =  0;
                  player.killTimer = 0;
                  player.damageTimer = 0;
                  player.hitBy = new ArrayList<Enemy>();
                }

                //Died
                if (boolean(pos[6]))
                  state = "Respawning";
              }
            }
            
            //remove players that left
            for(int k: enemys.keySet())
            {
              Enemy enemy = enemys.get(k);
              
              if(!enemy.didGet)
              {
                enemys.remove(k);
                break;
              }
            }
            
            //reset states
            for(int k: enemys.keySet())
              enemys.get(k).didGet = false;
          }
        }

        //Leaderboard info
        else if (data[0].equals("RANKINGS"))
        {
          leaders = "";

          for (int i = 1; i < data.length; i++)
            leaders += data[i] + "\n";
        }

        //Player gets a kill
        else if (data[0].equals("KILL"))
        {
          player.killTimer = 60;
        }

        //Player gets hit by enemy
        else if (data[0].equals("HIT"))
        {
          Enemy enemy = enemys.get(int(data[1]));

          if (enemy != null)
          {
            player.damageTimer = 120;

            synchronized(enemys)
            {
              player.hitBy.add(enemy);
            }
          }
        }
      }
    }
  }
}
