class Grass implements Object
{
  PVector pos;
  
  Grass()
  {
    pos = new PVector(random(-5000,5000),75,random(-5000,5000));
  }
  
  void render()
  {
    push();
    translate(pos.x,pos.y,pos.z);
    rotateY(-player.yaw + HALF_PI);
    noStroke();
    fill(#32811D);
    triangle(-2,0,2,0,0,-15);
    pop();
  }
}
