class Fence implements Object
{
  PVector pos;
  float rot;
  
  Fence(PVector pos, float rot)
  {
    this.pos = pos;  
    this.rot = rot;
  }
  
  void render()
  {
    push();
    translate(pos.x,pos.y,pos.z);
    rotateY(rot);
    
    noStroke();
    fill(#B4985B);
    box(200,300,10);
    
    fill(#907D55);
    translate(-100,0,0);
    box(25,350,25);
    translate(200,0,0);
    box(25,350,25);
    
    translate(-100,-150,0);
    box(200,10,25);
    translate(0,75,0);
    box(200,10,25);
    translate(0,75,0);
    box(200,10,25);
    pop();
  }
}
