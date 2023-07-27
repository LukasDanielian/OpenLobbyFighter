class Rock implements Object
{
  PShape rock;
  PVector pos;
  
  Rock(PVector pos)
  {
    this.pos = pos;
    rock = loadShape("rock.obj");
    rock.scale(5);
    rock.translate(150,300,0);
  }
  
  void render()
  {
    push();
    translate(pos.x,pos.y,pos.z);
    shape(rock);
    pop();
    
    //Collision
    if(dist(player.pos.x,player.pos.z,pos.x,pos.z) < 400)
    {
      PVector pushBack = new PVector(player.pos.x - pos.x,player.pos.z - pos.z);
      player.pos.x = pos.x + (pushBack.copy().normalize().x * 400);
      player.pos.z = pos.z + (pushBack.copy().normalize().y * 400);
    }
  }
}
