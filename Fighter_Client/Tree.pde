class Tree implements Object
{
  PVector pos;
  PShape tree;
  float rot;
  
  Tree(PVector pos)
  {
    this.pos = pos;
    tree = t;
    rot = random(0,TWO_PI);
  }
  
  void render()
  {
    push();
    translate(pos.x,pos.y,pos.z);
    rotateY(rot);
    shape(tree);
    pop();
    
    //Collision
    if(dist(player.pos.x,player.pos.z,pos.x,pos.z) < 250)
    {
      PVector pushBack = new PVector(player.pos.x - pos.x,player.pos.z - pos.z);
      player.pos.x = pos.x + (pushBack.copy().normalize().x * 250);
      player.pos.z = pos.z + (pushBack.copy().normalize().y * 250);
    }
  }
}
