class House implements Object
{
  PShape house;
  
  House()
  {
    house = loadShape("house.obj");
    house.scale(250);
    house.rotateX(PI);
    house.translate(785,785,0);
  }
  
  void render()
  {
    push();
    translate(0,75,0);
    noStroke();
    shape(house);
    
    fill(#B4985B);
    for(float i = 0; i < TWO_PI; i += PI/10)
    {
      push();
      translate(sin(i) * 785, 0 , cos(i) * 785);
      rotateY(i);
      box(10,100,10);
      translate(0,-50,0);
      box(250,10,10);
      pop();
    }
    pop();
        
    if(dist(player.pos.x,player.pos.z,0,0) < 785)
    {
      PVector pushBack = new PVector(player.pos.x,player.pos.z);
      player.pos.x = pushBack.copy().normalize().x * 785;
      player.pos.z = pushBack.copy().normalize().y * 785;
    }
  }
}
