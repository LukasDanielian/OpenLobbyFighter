class Player
{
  int ID, ammo, magSize, cooldown;
  float yaw, pitch, speed, zoom, health;
  PVector pos, lastPos, view, vel;
  boolean jumping, moving, shooting, reloading;
  PShape gun;

  public Player()
  {
    pos = new PVector(0, 0, 0);
    vel = new PVector(0, 0, 0);
    yaw = HALF_PI;
    speed = .075;
    ID = -1;
    zoom = 2.5;
    health = 100;
    gun = loadShape("gun.obj");
    gun.scale(2);
    gun.rotateX(PI);
    gun.translate(1, 12, 0);
    magSize = 30;
    ammo = magSize;
  }

  //Moves players position and view
  void render()
  {
    mouseUpdate();
    buttons();
    checkBounds();
    applyPhysics();
    weapon();

    //Camera
    view = new PVector(cos(yaw) * cos(pitch), -sin(pitch), sin(yaw) * cos(pitch)).mult(-width * .1);
    perspective(PI/zoom, float(width)/height, .01, width * width);
    camera(pos.x, pos.y, pos.z, pos.x + view.x, pos.y + view.y, pos.z + view.z, 0, 1, 0);

    //Gun model
    push();
    translate(pos.x, pos.y, pos.z);
    rotateY(-yaw + HALF_PI);
    rotateX(pitch);

    PVector gunPos = new PVector(0, 0, 0);
    gunPos.x = map(zoom, 2.5, 5, 5, -.2);
    gunPos.y = map(zoom, 2.5, 5, 5, 3.5);
    gunPos.z = map(zoom, 2.5, 5, -5, 5);

    if (mouseButton != RIGHT)
    {
      if (shooting && ammo != 0)
        gunPos.z += sin(frameCount)/2;
      else if (moving)
      {
        gunPos.x += sin(frameCount * .1)/2;
        gunPos.y -= abs(sin(frameCount * .1))/2;
      }
    }

    translate(gunPos.x, gunPos.y, gunPos.z);
    shape(gun);
    pop();
  }

  //On screen info
  void renderHUD()
  {
    push();
    camera();
    ortho();
    noLights();
    hint(DISABLE_DEPTH_TEST);
    //FPS
    fill(0);
    textSize(15);
    text("Frame Rate: " + (int)frameRate, width * .025, height * .01);
    textAlign(CENTER);

    //Name
    textSize(25);
    text("Player Number: " + ID, width/2, height * .05);

    //Ammo Info
    text(ammo + "/" + magSize, width/2, height * .85);

    //Cross hair
    noStroke();
    fill(#FA00FF);
    rect(width/2, height/2, 25, 2);
    rect(width/2, height/2, 2, 25);
    stroke(#FA00FF);
    noFill();
    circle(width/2, height/2, 30);

    //Heath Bar
    fill(map(health, 100, 0, 175, 255), map(health, 100, 50, 255, 0), 0);
    noStroke();
    rectMode(CORNER);
    rect(width/2-100, height * .95 -15, health * 2, 30);
    rectMode(CENTER);
    noFill();
    stroke(0);
    strokeWeight(2);
    rect(width/2, height * .95, 200, 30);

    //Reloading
    if (reloading)
    {
      noStroke();
      fill(0,255,0);
      circle(width/2, height * .85, width/12.5);
      fill(255, 0, 0);
      arc(width/2, height * .85, width/12.5, width/12.5, -HALF_PI, map(cooldown, 0, 60, -HALF_PI, PI+HALF_PI), PIE);
    }
    
    //Leaderboard
    textAlign(CENTER,TOP);
    fill(0);
    text(leaders, width * .9, height * .01);

    hint(ENABLE_DEPTH_TEST);
    pop();
  }

  //updates cursor info and loc
  void mouseUpdate()
  {
    if (!focused && mouseLock)
      unlockMouse();

    //Bound
    if (mouseLock)
    {
      yaw += (mouseX-offsetX-width/2.0)*.001;
      pitch += (mouseY-offsetY-height/2.0)*.001;
      r.setPointerVisible(false);
      r.warpPointer(width/2, height/2);
      r.confinePointer(true);
    }

    //Not bound
    else
    {
      r.confinePointer(false);
      r.setPointerVisible(true);
    }

    offsetX=offsetY=0;
    pitch = constrain(pitch, -HALF_PI + 0.0001, HALF_PI- .0001);
    lastPos = pos.copy();
  }

  //Checks if bottons were clicked
  void buttons()
  {
    if (keyPressed)
    {
      //Classic movement
      if (keyDown('W'))
      {
        pos.x += view.x * speed;
        pos.z += view.z * speed;
        moving = true;
      }
      if (keyDown('S'))
      {
        pos.x -= view.x * speed;
        pos.z -= view.z * speed;
        moving = true;
      }
      if (keyDown('A'))
      {
        pos.x -= cos(yaw - PI/2) * cos(pitch) * 10;
        pos.z -= sin(yaw - PI/2) * cos(pitch) * 10;
        moving = true;
      }
      if (keyDown('D'))
      {
        pos.x += cos(yaw - PI/2) * cos(pitch) * 10;
        pos.z += sin(yaw - PI/2) * cos(pitch) * 10;
        moving = true;
      }

      //Actions
      if (keyDown('R'))
      {
        if(ammo < magSize && !reloading)
        {
          shooting = false;
          ammo = magSize;
          reloading = true;
        }
      }
      if (keyDown(' '))
      {
        if (!jumping)
        {
          jumping = true;
          vel.y = -15;
          moving = true;
        }
      }
    } else
      moving = false;
  }

  //Manages shooting
  void weapon()
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
        shooting = true;
        player.pitch -= .01;
        player.yaw += random(-.001,.001);
        ammo--;

        for (int k : enemys.keySet())
        {
          Enemy enemy = enemys.get(k);

          if (!enemy.dead && calculateCollision(new PVector(pos.x, pos.y, pos.z), view, new PVector(enemy.pos.x, enemy.pos.y, enemy.pos.z), 25))
            client.write("HIT|" + enemy.ID + "\n");
        }
      }

      //Zoom in
      if (mouseButton == RIGHT)
      {
        if (zoom < 5)
        {
          zoom += .25;
        }
      }
    } else if (zoom > 2.5)
    {
      zoom -= .25;
    }
    
    else
      shooting = false;
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

  //Keeps player in map
  void checkBounds()
  {
    if (pos.x > map.size/2 - 25)
      pos.x = map.size/2 - 25;
    if (pos.x < -map.size/2 + 25)
      pos.x = -map.size/2 + 25;
    if (pos.z > map.size/2 - 25)
      pos.z = map.size/2 - 25;
    if (pos.z < -map.size/2 + 25)
      pos.z = -map.size/2 + 25;
  }

  //Checks all movement conditions
  void applyPhysics()
  {
    pos.add(vel);

    //Jumping animation
    if (jumping)
    {
      vel.y++;

      if (pos.y > 0)
      {
        vel.y = 0;
        pos.y = 0;
        jumping = false;
      }
    } else if (pos.y < 0)
      pos.y = 0;
  }
}
