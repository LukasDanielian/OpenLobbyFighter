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
    r.warpPointer((int) oldMouse.x, (int) oldMouse.y);
    
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
