class Enemy
{
  int ID;
  PVector pos;
  float yaw, health;
  boolean dead, didGet;
  PShape gun, eye;

  Enemy(int ID, PVector pos, float yaw, float health, boolean dead)
  {
    this.ID = ID;
    this.pos = pos;
    this.yaw = yaw;
    this.health = health;
    this.dead = dead;
    gun = g2;
    eye = e;
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
      strokeWeight(5);
      shape(eye);
      translate(0, 50, 0);
      fill(map(health, 100, 0, 175, 255), map(health, 100, 50, 255, 0), 0);
      box(30, 50, 30);

      //Gun model
      translate(20, -10, -15);
      shape(gun);
      pop();
    }
  }
}
