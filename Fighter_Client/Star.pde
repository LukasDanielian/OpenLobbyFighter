class Star implements Object
{
  PVector pos;

  Star()
  {
    pos = new PVector(random(-15000, 15000), random(-15000, 0), random(-15000, 15000));
    float dist = dist(0, 0, 0, pos.x, pos.y, pos.z);
    
    while (dist < 14900 || dist > 15000)
    {
      pos = new PVector(random(-15000, 15000), random(-15000, 0), random(-15000, 15000));
      dist = dist(0, 0, 0, pos.x, pos.y, pos.z);
    }
  }
  void render()
  {
    push();
    translate(pos.x, pos.y, pos.z);
    stroke(255);
    strokeWeight(25);
    noFill();
    point(0, 0);
    pop();
  }
}
