class Gun
{
  PShape gun;
  boolean shooting, reloading;
  int ammo, magSize, cooldown;
  float zoom;

  Gun()
  {
    gun = loadShape("gun.obj");
    gun.scale(2);
    gun.rotateX(PI);
    gun.translate(1, 12, 0);
    magSize = 30;
    ammo = magSize;
    zoom = 2.5;
  }

  //Display gun
  void render()
  {
    push();
    translate(player.pos.x, player.pos.y, player.pos.z);
    rotateY(-player.yaw + HALF_PI);
    rotateX(player.pitch);

    //Scoping animation
    PVector gunPos = new PVector(0, 0, 0);
    gunPos.x = map(zoom, 2.5, 5, 5, -.2);
    gunPos.y = map(zoom, 2.5, 5, 5, 3.5);
    gunPos.z = map(zoom, 2.5, 5, -5, 5);

    //Moving and shooting animation
    if (mouseButton != RIGHT)
    {
      //Shooting animation
      if (shooting && ammo != 0)
        gunPos.z += sin(frameCount)/2;

      //Moving animation
      else if (player.moving)
      {
        gunPos.x += sin(frameCount * .1)/2;
        gunPos.y -= abs(sin(frameCount * .1))/2;
      }
    }

    //Render gun
    translate(gunPos.x, gunPos.y, gunPos.z);
    shape(gun);
    pop();
  }

  //Updates info about gun
  void updateInfo()
  {
    //Reload cooldown
    if (reloading)
    {
      cooldown++;

      if (cooldown > 60)
      {
        reloading = false;
        cooldown = 0;
      }
    }

    //Fire logic
    if (mousePressed)
    {
      //Fire
      if (!reloading && frameCount % 6 == 0 && ammo > 0 && mouseButton == LEFT)
      {
        player.pitch -= .01;
        player.yaw += random(-.001, .001);
        shooting = true;
        ammo--;

        synchronized(enemys)
        {
          //Check if hit any enemy
          for (int k : enemys.keySet())
          {
            Enemy enemy = enemys.get(k);

            //Head and body shot
            if (!enemy.dead && (calculateCollision(new PVector(player.pos.x, player.pos.y, player.pos.z), player.view, new PVector(enemy.pos.x, enemy.pos.y, enemy.pos.z), 25) || calculateCollision(new PVector(player.pos.x, player.pos.y, player.pos.z), player.view, new PVector(enemy.pos.x, enemy.pos.y + 50, enemy.pos.z), 25)))
              client.write("HIT|" + enemy.ID + "\n");
          }
        }
      }

      //Zoom in
      if (mouseButton == RIGHT)
      {
        //Scope in
        if (zoom < 5)
          zoom += .25;
      }
    }

    //Unscope
    else if (zoom > 2.5)
      zoom -= .25;

    //Not firing
    else
      shooting = false;
  }

  void reload()
  {
    if (ammo < magSize && !reloading)
    {
      shooting = false;
      ammo = magSize;
      reloading = true;
    }
  }

  //Calculates the Ray sphere collision
  boolean calculateCollision(PVector rayOrigin, PVector rayDirection, PVector sphereCenter, float sphereRadius)
  {
    PVector sphereToRay = PVector.sub(sphereCenter, rayOrigin);
    float projection = PVector.dot(sphereToRay, rayDirection) / PVector.dot(rayDirection, rayDirection);
    PVector closestPointOnRay = PVector.add(rayOrigin, PVector.mult(rayDirection, projection));
    float distance = PVector.dist(closestPointOnRay, sphereCenter);
    return distance < sphereRadius;
  }
}
