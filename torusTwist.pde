int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3);

void setup() {
  setup_();
  result = new int[width*height][3];
}

void draw() {

  if (!recording) {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  } else {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(result[i][0]*1.0/samplesPerFrame) << 16 | 
        int(result[i][1]*1.0/samplesPerFrame) << 8 | 
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("f###.gif");
    if (frameCount==numFrames)
      exit();
  }
}

//////////////////////////////////////////////////////////////////////////////

int samplesPerFrame = 4;
int numFrames = 200;        
float shutterAngle = .5;

boolean recording = false;

void setup_() {
  size(540, 500, P3D);
  rectMode(CENTER);
  fill(32);
  noStroke();
  sphereDetail(10);
  smooth(8);
}

float sr = 4;
float x, y, tt;
int N = 64, M = 12;
float R = 120, r = 72;
float rr = 70;

float th1, th2, ph1, ph2;

void tVert(float ph, float th) {
  vertex((R+rr*cos(th))*cos(ph), rr*sin(th), (R+rr*cos(th))*sin(ph));
}

void draw_() {
  background(250); 
  pushMatrix();
  translate(width/2, height/2 - 30);
  rotateX(-.9);
  noStroke();
  for (int a=0; a<N; a++) {
    tt = t + (a+4*t)/float(N);
    tt %= 1;
    tt = constrain(1.4*tt,0,1);
    pushMatrix();
    rotateY(TWO_PI*(a+4*t)/N);
    translate(R, 0, 0);
    for (int i=0; i<M; i++) {
      fill(32);
      pushMatrix();
      rotate(TWO_PI*(i+.5*a + 2*ease(tt,4))/M);
      translate(r, 0, 0);
      sphere(sr);
      popMatrix();
    }
    popMatrix();

    fill(250);

    beginShape(QUADS);
    for (int i=0; i<50; i++) {
      for (int j=0; j<20; j++) {
        th1 = map(i, 0, 50, 0, TWO_PI);
        th2 = map(i+1, 0, 50, 0, TWO_PI);
        ph1 = map(j, 0, 20, 0, TWO_PI);
        ph2 = map(j+1, 0, 20, 0, TWO_PI);
        tVert(th1, ph1);
        tVert(th2, ph1);
        tVert(th2, ph2);
        tVert(th1, ph2);
      }
    }
    endShape();
  }
  popMatrix();
}