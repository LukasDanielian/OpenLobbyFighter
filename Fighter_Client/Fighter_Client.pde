import processing.net.*;
import com.jogamp.newt.opengl.GLWindow;

GLWindow r;
boolean[] keys;
boolean mouseLock;
PVector oldMouse;
int offsetX, offsetY;
Player player;
Map map;
Client client;
HashMap<Integer,Enemy> enemys;
String state,leaders;

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
  
  state = "Loading";
  thread("loadEverything");
}

void draw()
{
  //Loading
  if (state.equals("Loading"))
  {
    background(0);
    textSize(100);
    text("Connecting to TIC Server...", width/2, height/2);
    
    fill(255);
    for(float i = 0; i < TWO_PI; i+= QUARTER_PI)
      circle(width/2 + sin(i - frameCount * .1) * 50, height * .75 + cos(i - frameCount * .05) * 50, 10);
  }

  //Playing
  else if (state.equals("Playing"))
  {
    background(#16819D);
    lights();
    directionalLight(196, 123, 76, .75, 1, .75);

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
}

void loadEverything()
{
  r=(GLWindow)surface.getNative();
  keys = new boolean[256];
  oldMouse = new PVector(mouseX, mouseY);
  lockMouse();
  player = new Player();
  map = new Map();
  enemys = new HashMap<Integer, Enemy>();
  client = new Client(this, "192.168.1.183", 1234);
  getID();
  leaders = "";
  state = "Playing";
  thread("manageData");
}
