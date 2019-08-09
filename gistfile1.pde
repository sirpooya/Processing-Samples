// by d whyte

int[][] result;
float t;

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
    draw_();
  } else {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

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

int samplesPerFrame = 16;
int numFrames = 96;        
float shutterAngle = .5;

boolean recording = true;

void setup_() {
  size(800, 600, P3D);
  smooth(8);
  rectMode(CENTER);
  stroke(70,150,200);
  noFill();
  strokeWeight(2);
}

float x, y, z, tt;
int N = 24, M = 16;
float l = 500, w = 320;
int n = 120;
float h = 120;
float q = 0.00011, ll = .000035;

void draw_() {
  background(250); 
  pushMatrix();
  translate(width/2, height/2 - 25);
  rotateX(PI*.24);
  for (int i=0; i<N; i++) {
    x = map(i, 0, N-1, -l/2, l/2);
    strokeWeight(1.6);
    if(i==0 || i==N-1)
      strokeWeight(4);
    beginShape();
    for (int j=0; j<n; j++) {
      y = map(j, 0, n-1, -w/2-1, w/2+1);
      z = h*sin(TWO_PI*t - q*(x*x + y*y))*exp(-ll*(x*x + y*y));
      vertex(x, y, z);
    }
    endShape();
  }
  for (int i=0; i<M; i++) {
    y = map(i, 0, M-1, -w/2, w/2);
    strokeWeight(1.6);
    if(i==0 || i==M-1)
      strokeWeight(4);
    beginShape();
    for (int j=0; j<n; j++) {
      x = map(j, 0, n-1, -l/2-1, l/2+1);
      z = h*sin(TWO_PI*t - q*(x*x + y*y))*exp(-ll*(x*x + y*y));
      vertex(x, y, z);
    }
    endShape();
  }
  popMatrix();
}
