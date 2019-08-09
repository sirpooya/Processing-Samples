// by davey whyte aka @beesandbombs

void setup(){
  size(600,520,P3D);
  colorMode(HSB,1);
  noStroke();
}

float R = 160, r = 55;
int N = 720;
float th1, ph1, th2, ph2, t;
int nSides = 4;
int nFrames = 100;

void draw(){
  background(0.05);
  t = frameCount*1.0/nFrames;
  
  lights();
  ambientLight(1,0,.3);
 
  pushMatrix();
  translate(width/2,height/2 - 40);
  rotateX(-.9);
  
  beginShape(QUADS);
  for(int i=0; i<N; i++){
    fill(i/float(N),1,1);
    th1 = i*nSides*TWO_PI/N;
    th2 = (i+1)*nSides*TWO_PI/N;
    ph1 = i*TWO_PI/N + TWO_PI*t;
    ph2 = (i+1)*TWO_PI/N + TWO_PI*t;
    vertex((R+r*cos(ph1))*cos(th1) , r*sin(ph1),  (R+r*cos(ph1))*sin(th1));
    vertex((R+r*cos(ph2))*cos(th2) , r*sin(ph2),  (R+r*cos(ph2))*sin(th2));
    vertex((R+r*cos(ph2+TWO_PI/nSides))*cos(th2) , r*sin(ph2+TWO_PI/nSides),  (R+r*cos(ph2+TWO_PI/nSides))*sin(th2));
    vertex((R+r*cos(ph1+TWO_PI/nSides))*cos(th1) , r*sin(ph1+TWO_PI/nSides),  (R+r*cos(ph1+TWO_PI/nSides))*sin(th1));
  }
  endShape();
  
  popMatrix();
  
  saveFrame("f###.png");
  if(frameCount == nFrames)
    exit();
}