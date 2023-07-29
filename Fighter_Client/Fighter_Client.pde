import processing.net.*;
import com.jogamp.newt.opengl.GLWindow;

GLWindow window;
boolean[] keys = new boolean[256];
boolean[] mouse = new boolean[2];
boolean mouseLock;
PVector oldMouse;
int offsetX, offsetY;
Player player;
Map map;
Client client;
HashMap<Integer, Enemy> enemys;
String state, leaders, ip;
PShape r, g, g2, t, e;

void setup()
{
  fullScreen(P3D);
  shapeMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  imageMode(CENTER);
  hint(ENABLE_STROKE_PERSPECTIVE);
  frameRate(60);
  textSize(128);

  state = "Typing";
  ip = "192.168.1.182";
}

void draw()
{
  //User enters IP
  if (state.equals("Typing"))
  {
    background(0);
    textSize(50);
    fill(255);
    textAlign(LEFT, CENTER);
    text("Enter IP: " + ip, width/3, height/2);
    textAlign(CENTER, CENTER);

    if (keyPressed && key == ENTER)
    {
      state = "Loading";
      thread("loadEverything");
    }

    return;
  }

  //Loading
  else if (state.equals("Loading"))
  {
    background(0);
    textSize(100);
    text("Connecting to Server...", width/2, height/2);

    fill(255);
    for (float i = 0; i < TWO_PI; i+= QUARTER_PI)
      circle(width/2 + sin(i - frameCount * .1) * 50, height * .75 + cos(i - frameCount * .05) * 50, 10);

    return;
  }

  //Playing
  else if (state.equals("Playing"))
  {
    background(#050508);
    lights();
    directionalLight(157, 119, 35, .75, 1, .75);

    player.render();
    map.render();
    player.renderHUD();
  }

  //Respawn
  else if (state.equals("Respawning"))
  {
    push();
    camera();
    ortho();
    noLights();
    hint(DISABLE_DEPTH_TEST);
    background(0);
    textSize(100);
    fill(255);
    text("Respawning...", width/2, height/2);
    hint(ENABLE_DEPTH_TEST);
    pop();
  }

  client.write("POSITION|" + player.pos.x + "|" + player.pos.y + "|" + player.pos.z + "|" + player.yaw + "\n");
}

void loadEverything()
{
  window=(GLWindow)surface.getNative();
  oldMouse = new PVector(mouseX, mouseY);
  lockMouse();
  r = loadShape("rock.obj");
  r.scale(5);
  r.translate(150, 300, 0);

  g = loadShape("gun.obj");
  g.scale(2);
  g.rotateX(PI);
  g.translate(1, 12, 0);
  
  g2 = loadShape("gun.obj");
  g2.scale(4);
  g2.rotateX(PI);
  g2.translate(1, 12, 0);

  t = loadShape("tree.obj");
  t.scale(150);
  t.rotateX(HALF_PI);
  t.translate(-850, 900, -700);

  e = createShape(SPHERE, 25);
  e.setTexture(loadImage("eye.jpg"));
  e.rotateY(-HALF_PI);
  e.translate(25, 25, 0);
  e.setStroke(false);

  player = new Player();
  map = new Map();
  enemys = new HashMap<Integer, Enemy>();
  client = new Client(this, ip, 1111);
  getID();
  leaders = "";
  state = "Playing";
  thread("manageData");
}
