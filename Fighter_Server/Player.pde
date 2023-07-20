class Player
{
  PVector pos;
  float yaw, health;
  int idNum, cooldown;
  boolean dead;
  
  public Player(int idNum)
  {
    this.pos = new PVector(0,0,0);
    this.yaw = 0;
    this.idNum = idNum;
    cooldown = 3 * 60;
  }
  
  String getInfo()
  {
    if(dead)
    {
      cooldown--;
      
      if(cooldown <= 0)
      {
        dead = false;
        cooldown = 3 * 60;
        PVector bestSpawn = getBestSpawn();
        server.write("RESPAWN|" + idNum + "|" + bestSpawn.x + "|" + bestSpawn.z + "\n");
      }
    }
    
    return idNum + "*" + pos.x + "*" + pos.y + "*" + pos.z + "*" + yaw + "*" + health;
  }
}
