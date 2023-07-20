class Player
{
  int ID, kills;
  float yaw, pitch, speed, health;
  PVector pos, lastPos, view, vel;
  boolean jumping;

  public Player()
  {
    pos = new PVector(0, 0, 0);
    vel = new PVector(0, 0, 0);
    yaw = HALF_PI;
    speed = .05;
    ID = -1;
    health = 100;
  }

  //Moves players position and view
  void render()
  {
    mouseUpdate();
    buttons();
    checkBounds();
    applyPhysics();
    weapon();

    view = new PVector(cos(yaw) * cos(pitch), -sin(pitch), sin(yaw) * cos(pitch)).mult(-width * .1);
    perspective(PI/2.5, float(width)/height, .01, width * width);
    camera(pos.x, pos.y, pos.z, pos.x + view.x, pos.y + view.y, pos.z + view.z, 0, 1, 0);
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
    text("Frame Rate: " + (int)frameRate, width/2, height * .05);
    textAlign(CENTER);

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
      }
      if (keyDown('S'))
      {
        pos.x -= view.x * speed;
        pos.z -= view.z * speed;
      }
      if (keyDown('A'))
      {
        pos.x -= cos(yaw - PI/2) * cos(pitch) * 10;
        pos.z -= sin(yaw - PI/2) * cos(pitch) * 10;
      }
      if (keyDown('D'))
      {
        pos.x += cos(yaw - PI/2) * cos(pitch) * 10;
        pos.z += sin(yaw - PI/2) * cos(pitch) * 10;
      }

      //Actions
      if (keyDown(' '))
      {
        if (!jumping)
        {
          jumping = true;
          vel.y = -15;
        }
      }
    }
  }

  //Manages shooting
  void weapon()
  {
    if (mousePressed && mouseButton == LEFT)
    {
      for (int k : enemys.keySet())
      {
        Enemy enemy = enemys.get(k);

        if (!enemy.dead && calculateCollision(new PVector(pos.x, pos.y, pos.z), view, new PVector(enemy.pos.x, enemy.pos.y, enemy.pos.z), 25))
        {
          packet += "HIT|" + ID + "|" + enemy.ID + "$";
        }
      }
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

  //Taking damage from other player
  void applyDamage(int enemyID)
  {
    health -= 5;

    if (health <= 0)
    {
      packet += "DEAD|" + ID + "|" +enemyID + "$";
      state = "Respawning";
    }
  }
}
