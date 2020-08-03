class Node {
  float x, y, r;
  
  Node(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  
  }
  
void draw() {
  ellipse(x, y, r * 2f, r * 2f);
  stroke(255);
  vertex(x, y);
}

//Check distance from the Node to input coordinates
boolean contains(float x, float y) {
    float dx = this.x - x;
    float dy = this.y - y;
    return sqrt(dx * dx + dy * dy) <= r;
  }
}
