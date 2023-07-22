class Tree implements Object
{
  PVector pos;
  PShape tree;
  
  Tree(PVector pos)
  {
    this.pos = pos;
    tree = loadShape("tree.obj");
    tree.scale(250);
    tree.rotateX(PI);
    tree.translate(750,1200,0);
  }
  
  void render()
  {
    push();
    translate(pos.x,pos.y,pos.z);
    shape(tree);
    pop();
    
    if (dist(player.pos.x, player.pos.y, player.pos.z, pos.x, pos.y, pos.z) < 300)
        player.pos = PVector.add(pos, player.pos.sub(pos).copy().normalize().mult(300));
  }
}
