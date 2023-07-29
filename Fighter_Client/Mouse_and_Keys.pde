//Locks mouse into place
void lockMouse() 
{
  if (!mouseLock) 
  {
    oldMouse = new PVector(mouseX, mouseY);
    offsetX = mouseX - width/2;
    offsetY = mouseY - height/2;
  }
  
  mouseLock = true;
}

//unlocks mouse
void unlockMouse() 
{
  if (mouseLock) 
    window.warpPointer((int) oldMouse.x, (int) oldMouse.y);
    
  mouseLock = false;
}

//Key down
void keyPressed()
{
  if (keyCode >= 0 && keyCode < 256)
    keys[keyCode] = true;
    
  if(key == 'p')
  {
    if(mouseLock)
      unlockMouse();
      
    else
      lockMouse();
  }
  
  //Enter IP
  if(state.equals("Typing"))
  {
    if(key == BACKSPACE && ip.length() > 0)
      ip = ip.substring(0,ip.length()-1);
    
    else if((key >= 48 && key <= 57) || key == 46)
      ip += key;
  }
}

//Key up
void keyReleased() 
{
  if (keyCode >= 0 && keyCode < 256)
    keys[keyCode] = false;
}

//Grabs key
boolean keyDown(int key) 
{
  return keys[key];
}

//Checks if mouse buttons are pressed
void mousePressed()
{
  if(mouseButton == LEFT)
    mouse[0] = true;
  if(mouseButton == RIGHT)
    mouse[1] = true;
}

//checks if mouse buttons are released
void mouseReleased()
{
  if(mouse[0] && mouse[1])
  {
    if(mouseButton == RIGHT)
      mouse[1] = false;
    if(mouseButton == LEFT)
      mouse[0] = false;
  }
  
  else
  {
    mouse[0] = false;
    mouse[1] = false;
  }
}
