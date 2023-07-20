//Determines the most optimal respawn location for players by calculating the average distance from preset locations to every player that is alive. Then uses the location with the largest average distance of players away from spawn location
PVector getBestSpawn()
{
  PVector toRet = spawnLocs[0];
  float largest = 0;
  
  //Preset locations
  for(int i = 0; i < spawnLocs.length; i++)
  {
    PVector loc = spawnLocs[i];
    float average = 0;
    int alivePlayers = 0;
    
    //Every player
    for(int k: players.keySet())
    {
      Player player = players.get(k);
      
      if(!player.dead)
      {
        average += dist(loc.x,loc.z,player.pos.x,player.pos.z);
        alivePlayers++;
      }
    }
    
    average /= alivePlayers;
    
    if(average > largest)
    {
      largest = average;
      toRet = loc;
    }
  }
  
  return toRet;
}
