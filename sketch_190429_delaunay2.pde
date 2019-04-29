import megamu.mesh.*;

import org.processing.wiki.triangulate.*;


float[] rand;
PVector[] rndvec;

Delaunay myDelaunay;
float[][] points;

int total;


int DEFAULT = 0, RADIATION = 1;


void setup() {
  size(700, 700, P2D);
  rand = new float[5000]; 
  rndvec = new PVector[5000];
  for (int i = 0; i < 5000; i++) {
    rand[i] = random(5);
    rndvec[i] = PVector.random2D();
  }
  //points = new float[in*jn][2];
  resetRandom();

  //myDelaunay = new Delaunay( points );
}

void draw() {


  ArrayList triangles = new ArrayList();
  ArrayList<PVector> points = new ArrayList<PVector>();


  surface.setTitle(str(frameRate));
  int in = 22; 
  int jn = 25;
  total = in*jn;

  int borderInterval = 262;
  background(237);
  float speed = 0.003;
  if (true) {
    points.clear();
    for (int i = 0; i < in; i++) {
      for (int j = 0; j < jn; j++) {
        //points[i*jn + j][0] = rndvec[i*jn + j].copy().mult(rand[i]*100).x + mouseX;
        //points[i*jn + j][1] = rndvec[i*jn + j].copy().mult(rand[i+2]*100).y + mouseY;
        float x = map(rndvec[i*jn + j].x, 0, 1, 0-borderInterval, width+borderInterval) 
          + 153 * map(noise(frameCount * speed +i, j), 0, 1, -1, 1);
        float y = map(rndvec[i*jn + j].y, 0, 1, 0-borderInterval, height+borderInterval)
          + 153 * map(noise(frameCount * speed +i, j), 0, 1, -1, 1);
        points.add(new PVector(x, y));
      }
    }
  }

  triangles.clear();
  triangles = Triangulate.triangulate(points);

  strokeWeight(1.50);
  stroke(#fbdce4, 48);
  drawTriangles(triangles);
  strokeWeight(1.39);
  stroke(#7d34a7, 40);
  drawTriangles(triangles, RADIATION, 7);
}

void drawTriangles(ArrayList tris) {
  drawTriangles(tris, DEFAULT, 0);
}

void drawTriangles(ArrayList tris, int _MODE, int subdivs) {
  if (_MODE == DEFAULT) {
    beginShape(TRIANGLES);

    for (int i = 0; i < tris.size(); i++) {
      Triangle t = (Triangle)tris.get(i);
      vertex(t.p1.x, t.p1.y);
      vertex(t.p2.x, t.p2.y);
      vertex(t.p3.x, t.p3.y);
    }
    endShape();
  } else if (_MODE == RADIATION) {

    beginShape(LINES);
    for (int i = 0; i < tris.size(); i++) {
      Triangle t = (Triangle)tris.get(i);
      PVector top = t.p1;
      //PVector dir = PVector.sub(p3, p2);

      for (int j = 0; j <= subdivs; j++) {
        linePVector2DVertex(top, PVector.lerp(t.p2, t.p3, j*1.0/subdivs));
      }
    }
    endShape();
  }
}


void resetRandom() {

  for (int i = 0; i < 5000; i++) {
    rand[i] = random(5);
    //rndvec[i].set(PVector.random2D());
    rndvec[i].x = random(0, 1);
    rndvec[i].y = random(0, 1);
  }
}
void keyPressed() {
  if (keyCode == ' ') {
    resetRandom();
    redraw();
  }
}
