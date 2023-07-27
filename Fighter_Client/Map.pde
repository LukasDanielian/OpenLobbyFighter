class Map
{
  float size;
  ArrayList<Object> objects;

  Map()
  {
    size = 10000;
    objects = new ArrayList<Object>();
    
    //House
    objects.add(new House());
    
    //Stars
    for(int i = 0; i < 100; i++)
      objects.add(new Star());
      
    //Grass
    for(int i = 0; i < 250; i++)
      objects.add(new Grass());
    
    //Trees
    for(float i = 0; i < TWO_PI; i += HALF_PI)
      objects.add(new Tree(new PVector(sin(i) * size/4, 75, cos(i) * size/4)));
      
    //Rocks
    boolean far = false;
    for(float i = 0; i < TWO_PI; i += QUARTER_PI)
    {
      if(far)
        objects.add(new Rock(new PVector(sin(i) * size/1.75, 75, cos(i) * size/1.75)));
      else
        objects.add(new Rock(new PVector(sin(i) * size/2.5, 75, cos(i) * size/2.5)));
        
      far = !far;
    }
      
    //Fence
    for(float x = -size/2; x <= size/2; x += 200)
      objects.add(new Fence(new PVector(x,75,-size/2),0));
    for(float x = -size/2; x <= size/2; x += 200)
      objects.add(new Fence(new PVector(x,75,size/2),0));
    for(float z = -size/2; z <= size/2; z += 200)
      objects.add(new Fence(new PVector(-size/2,75,z),HALF_PI));
    for(float z = -size/2; z <= size/2; z += 200)
      objects.add(new Fence(new PVector(size/2,75,z),HALF_PI));
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
