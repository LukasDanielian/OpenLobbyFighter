class Enemy
{
  int ID;
  PVector pos;
  float yaw, health;
  boolean dead;
  PShape gun;

  Enemy(int ID, PVector pos, float yaw, float health, boolean dead)
  {
    this.ID = ID;
    this.pos = pos;
    this.yaw = yaw;
    this.health = health;
    this.dead = dead;
    gun = loadShape("gun.obj");
    gun.scale(4);
    gun.rotateX(PI);
    gun.translate(1, 12, 0);
  }

  //Renders enemys
  void render()
  {
    if (!dead)
    {
      sphereDetail(5);
      push();
      translate(pos.x, pos.y, pos.z);
      rotateY(-yaw + HALF_PI);
      stroke(0);
      strokeWeight(1);
      fill(255, 0, 0);
      sphere(25);
      translate(0, 50, 0);
      box(30, 50, 30);

      //Gun model
      translate(20, -10, -15);
      shape(gun);
      pop();
    }
  }
}
