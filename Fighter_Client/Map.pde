class Map
{
  float size;

  Map()
  {
    size = 10000;
  }

  //Renders map
  void render()
  {
    //Ground
    push();
    translate(0, 75, 0);
    noStroke();
    fill(0, 255, 0);
    box(size, 1, size);
    pop();

    //Sun
    push();
    translate(player.pos.x - width, -width * 2, player.pos.z - width);
    noLights();
    noStroke();
    fill(#FFEA00);
    rotateX(HALF_PI);
    circle(0, 0, width/4);
    lights();
    pop();

    //Obstacles
    fill(0);
    colorMode(HSB);
    stroke(frameCount % 255, 255,255);
    colorMode(RGB);
    for (float i = 0; i < TWO_PI; i+= HALF_PI)
    {
      PVector pos = new PVector(sin(i) * size/4, 75, cos(i) * size/4);
      
      push();
      translate(pos.x, pos.y, pos.z);
      sphere(size/8);
      pop();
      
      if (dist(player.pos.x, player.pos.y, player.pos.z, pos.x, pos.y, pos.z) < (size/8) + 25)
        player.pos = PVector.add(pos, player.pos.sub(pos).copy().normalize().mult((size/8) + 25));
    }
    
    //Enemys
    for(int k: enemys.keySet())
      enemys.get(k).render();
  }
}
