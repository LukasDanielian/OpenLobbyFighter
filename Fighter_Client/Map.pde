class Map
{
  float size;
  ArrayList<Object> objects;

  Map()
  {
    size = 10000;
    objects = new ArrayList<Object>();
    
    for(int i = 0; i < 500; i++)
      objects.add(new Star());
      
    for(int i = 0; i < 1000; i++)
      objects.add(new Grass());
    
    for(float i = 0; i < TWO_PI; i += HALF_PI)
      objects.add(new Tree(new PVector(sin(i) * size/4, 75, cos(i) * size/4)));
      
    for(float x = -size/2; x <= size/2; x += 200)
      objects.add(new Fence(new PVector(x,75,-size/2),0));
    for(float x = -size/2; x <= size/2; x += 200)
      objects.add(new Fence(new PVector(x,75,size/2),0));
    for(float z = -size/2; z <= size/2; z += 200)
      objects.add(new Fence(new PVector(-size/2,75,z),HALF_PI));
    for(float z = -size/2; z <= size/2; z += 200)
      objects.add(new Fence(new PVector(size/2,75,z),HALF_PI));
      
    objects.add(new House());
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

    //Objects
    for(int i = 0; i < objects.size(); i++)
      objects.get(i).render();
    
    //Enemys
    synchronized(enemys)
    {
      for(int k: enemys.keySet())
        enemys.get(k).render();
    }
  }
}
