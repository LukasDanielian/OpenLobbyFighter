class Enemy
{
  int ID;
  PVector pos;
  float yaw, health;
  boolean dead;

  Enemy(int ID, PVector pos, float yaw, float health)
  {
    this.ID = ID;
    this.pos = pos;
    this.yaw = yaw;
    this.health = health;
  }

  //Renders enemys
  void render()
  {
    if (!dead)
    {
      push();
      translate(pos.x, pos.y, pos.z);
      rotateY(-yaw);
      stroke(0);
      fill(255, 0, 0);
      sphere(25);
      translate(0, 50, 0);
      box(30, 50, 30);
      pop();
    }
  }
}
