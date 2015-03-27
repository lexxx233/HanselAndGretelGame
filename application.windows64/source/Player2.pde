class Player2{
  float fuel = 200;
  FCircle[] crumbs = new FCircle[500];
  
  int inx = 0;
  
  private void upi(){
     inx = (inx+1) % crumbs.length;
     HanselandGretel.world.remove(crumbs[inx]);
     
  }
  
  void draw(){
    fill(100);
    rect(30, 24, 200*2.75, 12);
    fill(0, 147, 207);
    noStroke();
    rect(30, 24, fuel*2.75, 12);
  }
  
  void mouseMoved(){
    fuel -= 0.1;
    fuel = constrain(fuel, 0, 200);
  }
  
  void mousePressed(){
    if(fuel > 0){
      crumbs[inx] = new FCircle(4);
      crumbs[inx].setPosition(mouseX, mouseY);
      crumbs[inx].setDensity(0.001);
      crumbs[inx].setStrokeWeight(0);
      crumbs[inx].setFill(random(203-20, 203+20), random(178-20, 178+20),random(51-20,51+20));
      HanselandGretel.world.add(crumbs[inx]);  
      upi();
      fuel -= 0.3;
    }
  }
  
}
