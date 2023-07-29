class Gun
{
  PShape gun;
  boolean reloading, loadingBullet;
  int ammo, magSize, reloadTime, bulletTime;
  float zoom;

  Gun()
  {
    gun = g;
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

    //Shooting animation
    if (mouse[0] && ammo != 0 && !reloading)
      gunPos.z += sin(frameCount)/2;

    //Moving animation
    if (!mouse[1] && player.moving)
    {
      gunPos.x += sin(frameCount * .1)/2;
      gunPos.y -= abs(sin(frameCount * .1))/2;
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
      reloadTime++;

      if (reloadTime > 60)
      {
        reloading = false;
        reloadTime = 0;
      }
    }
    
    //Fire rate 
    if(loadingBullet)
    {
      bulletTime++;
      
      if(bulletTime > 5)
      {
        loadingBullet = false;
        bulletTime = 0;
      }
    }

    //Fire logic
    else if (mouse[0] || mouse[1])
    {
      //Fire
      if (mouse[0] && !loadingBullet && !reloading && ammo > 0 && (zoom == 5 || zoom == 2.5))
      {
        player.pitch -= .01;
        player.yaw += random(-.001, .001);
        ammo--;
        loadingBullet = true;

        synchronized(enemys)
        {
          //Check if hit any enemy
          for (int k : enemys.keySet())
          {
            Enemy enemy = enemys.get(k);

            if (!enemy.dead)
            {
              //head then body checks
              if(calculateCollision(new PVector(player.pos.x, player.pos.y, player.pos.z), player.view, new PVector(enemy.pos.x, enemy.pos.y, enemy.pos.z), 25))
                client.write("HIT|" + enemy.ID + "|" + 15 +"\n");
              else if(calculateCollision(new PVector(player.pos.x, player.pos.y, player.pos.z), player.view, new PVector(enemy.pos.x, enemy.pos.y + 50, enemy.pos.z), 25))
                client.write("HIT|" + enemy.ID + "|" + 10 +"\n");
              else
                return;
  
              player.hitTimer = 5;
            }
          }
        }
      }

      //Zoom in
      if (mouse[1])
      {
        //Scope in
        if (zoom < 5)
          zoom += .5;
      }
    }

    //Unscope
    else if (zoom > 2.5 && !mouse[1])
      zoom -= .5;
  }

  //Resets total bullets and starts cooldown
  void reload()
  {
    if (ammo < magSize && !reloading)
    {
      zoom = 2.5;
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
    return distance <= sphereRadius;
  }
}
