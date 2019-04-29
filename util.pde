

void linePVector2DVertex(PVector p1, PVector p2) {
  vertex(p1.x, p1.y); 
  vertex(p2.x, p2.y);
}
void linePVector2D(PVector p1, PVector p2) {
  line(p1.x, p1.y, 
    p2.x, p2.y);
}
void linePVector(PVector p1, PVector p2) {
  line(p1.x, p1.y, p1.z, 
    p2.x, p2.y, p2.z);
}

float maxAbs(float v1, float v2) {
  if (abs(v1) > abs(v2)) {
    return v1;
  } else {
    return v2;
  }
}
boolean contains(int[] arr, int e) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == e) return true;
  }
  return false;
}
void printIntArray(int[] arr) {
  for (int i = 0; i < arr.length; i++) {

    print(arr[i]);
    if (i != arr.length -1 ) {
      print(",");
    } else {
      print("\n");
    }
  }
}


void reverseRotation(PVector p) {

  rotateZ(-p.z);
  rotateY(-p.y);
  rotateX(-p.x);
}

void drawLineTrace(PVector p1, PVector p2) {
  PVector start = p1.copy();

  int n = 10;
  float x_step = (p2.x - p1.x)/n;
  float z_step = (p2.z - p1.z)/n;
  PVector step = PVector.sub(p2, p1).mult(1.0f / n);
  for (int i = 0; i < n; i++) {
    PVector end = start.copy();
    end.x += x_step;
    end.y += step.y; 
    end.z += getEaseStep(p1.z, p2.z, i, n);
    line(start.x, start.y, start.z, 
      end.x, end.y, end.z);

    start.set(end);
  }
}

float getEaseStep(float p1, float p2, int i, int n) {
  return  (p2 - p1) * (ease_step_sin(i, n));
}

float ease_step_para(int i, int n) {
  float step = i * 1.0 / n;
  return ((1+i)*step)*((1+i)*step) - (i*step)*(i*step) ;
}
float ease_step_sin(int i, int n) {
  float step =  1.0 / n* PI /2;
  return pow(sin((1+i)*step ), 2) - pow(sin(i*step), 2) ;
}

void drawTex(color col, float alpha, float size, PImage tex) {

  beginShape(QUAD);
  noStroke(); 
  tint(col, alpha);
  texture(tex);
  normal(0, 0, 1);


  vertex(0 - size/2, 0 - size/2, 0, 0, 0);
  vertex(0 + size/2, 0 - size/2, 0, tex.width, 0);
  vertex(0 + size/2, 0 + size/2, 0, tex.width, tex.height);
  vertex(0 - size/2, 0 + size/2, 0, 0, tex.height);


  endShape();
}

void drawTex(color col, float alpha, float w, float h, PImage tex) {

  beginShape(QUAD);
  noStroke(); 
  tint(col, alpha);
  texture(tex);
  normal(0, 0, 1);


  vertex(0 - w/2, 0 - h/2, 0, 0, 0);
  vertex(0 + w/2, 0 - h/2, 0, tex.width, 0);
  vertex(0 + w/2, 0 + h/2, 0, tex.width, tex.height);
  vertex(0 - w/2, 0 + h/2, 0, 0, tex.height);


  endShape();
}

void drawFire(color fireColor, float alpha, float size, PImage fire, float seed) {

  beginShape(QUAD);
  noStroke(); 
  tint(fireColor, alpha);
  texture(fire);
  normal(0, 0, 1);

  // switch between  four sectors
  int seedPtr = floor(seed * 20);
  if ( seedPtr % 4 == 0) { 
    vertex(0 - size/2, 0 - size/2, 0, 0, 0);
    vertex(0 + size/2, 0 - size/2, 0, fire.width/2, 0);
    vertex(0 + size/2, 0 + size/2, 0, fire.width/2, fire.height/2);
    vertex(0 - size/2, 0 + size/2, 0, 0, fire.height/2);
  }
  if ( seedPtr % 4 == 1) {

    vertex(0 - size/2, 0 - size/2, 0, fire.width/2, 0);
    vertex(0 + size/2, 0 - size/2, 0, fire.width, 0);
    vertex(0 + size/2, 0 + size/2, 0, fire.width, fire.height/2);
    vertex(0 - size/2, 0 + size/2, 0, fire.width/2, fire.height/2);
  }
  if ( seedPtr % 4 == 2) {

    vertex(0 - size/2, 0 - size/2, 0, 0, fire.height/2);
    vertex(0 + size/2, 0 - size/2, 0, fire.width/2, fire.height/2);
    vertex(0 + size/2, 0 + size/2, 0, fire.width/2, fire.height);
    vertex(0 - size/2, 0 + size/2, 0, 0, fire.height);
  }
  if ( seedPtr % 4 == 3) {

    vertex(0 - size/2, 0 - size/2, 0, fire.width/2, fire.height/2);
    vertex(0 + size/2, 0 - size/2, 0, fire.width, fire.height/2);
    vertex(0 + size/2, 0 + size/2, 0, fire.width, fire.height);
    vertex(0 - size/2, 0 + size/2, 0, fire.width/2, fire.height);
  }

  endShape();
}
int[] _pitchIntervalMap_ = {-1, 0, 1, 0, -1, 1, 0, -1, 0, 1, 0, -1};
int[] _pitchIntervalAccumMap_ = {0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12};


int pitchIntervalMap(int notePitch) {
  return _pitchIntervalMap_[notePitch];
}

int pitchIntervalMapAccum(int notePitch) {
  return _pitchIntervalAccumMap_[notePitch];
}
void drawBoxBetween(PVector p1, PVector p2, float w, float h, 
  color col, float alpha, PImage tex) {

  // only 2D
  PVector dir = p1.copy().sub(p2);
  float len = dir.mag();
  dir.normalize();
  float ang = atan2(dir.y, dir.x);
  //if (ang < 0) ang += TWO_PI;
  w = len*1.0;


  pushMatrix();
  //translate(p1.x, p2.y);
  rotate(ang); 

  drawTex(col, alpha, w, h, tex);  

  //image( road6, -len * 3.0/2, -3); 
  popMatrix();
} 



PVector rotate2D(float x, float y, float ang) {
  PVector p = new PVector();
  float newx = 0, newy = 0;
  newx = x * cos(ang) + y * sin(ang);
  newy = - x * sin(ang) + y * cos(ang);
  p.set(newx, newy);
  return p;
}
