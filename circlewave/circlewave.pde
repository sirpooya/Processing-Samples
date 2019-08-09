// by dave whyte

int[][] result;
float t;

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

int samplesPerFrame = 4;
int numFrames = 144;        
float shutterAngle = .5;

boolean recording = false;

void setup_() {
  size(800, 600, P2D);
  smooth(8);
  noFill();
}

int N = 360;
int n = 7;
float os;
float R = 165, r;
float th;
color bg = color(42, 40, 38);

float ease(float q){
  return 3*q*q - 2*q*q*q;
}

void drawCircle(float q){
  beginShape();
  for (int i=0; i<N; i++) {
    th = i*TWO_PI/N;
    os = map(cos(th-TWO_PI*t), -1, 1, 0, 1);
    os = 0.125*pow(os, 2.75);
    r = R*(1+os*cos(n*th + 1.5*TWO_PI*t + q));
    vertex(r*sin(th), -r*cos(th));
  }
  endShape(CLOSE);
}

void drawCircles() {
  drawCircle(0);
  drawCircle(PI);
}

void draw_() {
  background(bg);
  pushMatrix();
  translate(width/2, height/2);
  stroke(lerpColor(bg, color(0), .15));
  strokeWeight(7.5);
  pushMatrix();
  translate(2, 3);
  drawCircles();
  popMatrix();
  stroke(230);
  strokeWeight(6);
  drawCircles();
  popMatrix();
}

