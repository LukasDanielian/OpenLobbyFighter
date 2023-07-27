class Player
{
  ArrayList<Enemy> hitBy;
  int ID, hitTimer, killTimer, damageTimer, reviveTimer;
  float yaw, pitch, speed, health;
  PVector pos, lastPos, view, vel;
  boolean jumping, moving;
  Gun gun;

  public Player()
  {
    PVector[] spawnLocs = {new PVector(-4500, 0, 0), new PVector(4500, 0, 0), new PVector(0, 0, -4500), new PVector(0, 0, 4500), new PVector(-4500, 0, -4500), new PVector(4500, 0, 4500), new PVector(4500, 0, -4500), new PVector(-4500, 0, 4500)};
    pos = spawnLocs[(int)random(0, spawnLocs.length)];
    hitBy = new ArrayList<Enemy>();
    yaw = atan2(-pos.x, pos.z) + HALF_PI;
    vel = new PVector(0, 0, 0);
    speed = .075;
    ID = -1;
    health = 100;
    gun = new Gun();
  }

  //Moves players position and view
  void render()
  {
    mouseUpdate();
    buttons();
    checkBounds();
    applyPhysics();
    gun.updateInfo();
    updateCamera();
    gun.render();
  }

  //updates player view
  void updateCamera()
  {
    view = new PVector(cos(yaw) * cos(pitch), -sin(pitch), sin(yaw) * cos(pitch)).mult(-width * .1);
    perspective(PI/gun.zoom, float(width)/height, .01, width * width);
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
    fill(255);
    textSize(15);
    text("Frame Rate: " + (int)frameRate, width * .025, height * .01);
    textAlign(CENTER);

    //Name
    textSize(25);
    text("Player Number: " + ID, width/2, height * .05);

    //Ammo Info
    textSize(50);
    text(gun.ammo + "/" + gun.magSize, width/2, height * .85);

    //Cross hair
    noStroke();
    fill(#FA00FF);
    rect(width/2, height/2, 25, 2);
    rect(width/2, height/2, 2, 25);
    stroke(#FA00FF);
    noFill();
    circle(width/2, height/2, 30);

    //Hit marker
    if (hitTimer > 0)
    {
      stroke(255, 0, 0);
      push();
      translate(width/2, height/2);
      rotate(QUARTER_PI);
      for (int i = 0; i < 4; i++)
      {
        rotate(HALF_PI);
        rect(0, -30, 1, 15);
      }
      pop();

      hitTimer--;
    }

    //Kill indication
    if (killTimer > 0)
    {
      textSize(map(killTimer, 60, 0, 40, 15));
      fill(255, map(killTimer, 60, 0, 255, 0));
      text("+1 KILL", width/2 + 100, height/2 - map(killTimer, 60, 0, 0, 100));
      killTimer--;
    }

    //Point toward enemy hitting you
    if (damageTimer > 0)
    {
      synchronized(enemys)
      {
        for (int i = 0; i < hitBy.size(); i++)
        {
          Enemy enemy = hitBy.get(i);

          //Remove
          if (enemy.dead)
          {
            hitBy.remove(i);
            i--;
          }

          //Arrow
          else
          {
            push();
            translate(width/2, height * .85);
            fill(255, 0, 0);
            noStroke();
            rotate(-atan2(enemy.pos.x - pos.x, enemy.pos.z - pos.z) - (yaw + PI));
            translate(150, 0, 0);
            triangle(10, 0, -10, 50, -10, -50);
            pop();
          }
        }
      }
      
      damageTimer--;
    }

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
    if (gun.reloading)
    {
      noStroke();
      fill(0, 255, 0);
      circle(width/2, height * .85, width/12.5);
      fill(255, 0, 0);
      arc(width/2, height * .85, width/12.5, width/12.5, -HALF_PI, map(gun.reloadTime, 0, 60, -HALF_PI, PI+HALF_PI), PIE);
    }

    //Leaderboard
    textAlign(CENTER, TOP);
    fill(255);
    textSize(25);
    text(leaders, width * .9, height * .01);

    //Damaged
    if (health <= 75)
    {
      fill(255, 0, 0, map(health, 75, 0, 0, 125));
      rect(width/2, height/2, width, height);
    }

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
        gun.reload();
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
    }

    //no movement
    else
      moving = false;
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
