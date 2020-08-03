ArrayList nodes;
Node dragNode = null;
int mesh_color = 0;

/*
* This sketch is used to develop the warp mesh
* This sketch allows the mesh to be manipulated
* All node information is coming from a .json file 
* Unless new nodes are added to the scene
*/

void setup() {
  nodes = new ArrayList();
  fullScreen(2);
  strokeWeight(6);
  
}


void draw() {
  
  //JSON object of nodes
  JSONObject data = loadJSONObject("full_mesh.json"); 
  
  //JSON object of triangles
  JSONObject tris = loadJSONObject("triangles.json"); 
  
  background(255);
  
  //draw nodes from the "nodes" arraylist as long as it is not empty
  if (nodes.size() > 0) {
    for (int i = 0; i < nodes.size(); i++) {
      Node p = (Node) nodes.get(i);
      stroke(mesh_color);
      p.draw();
    }
}


//Render nodes into the Processing sketch directly from the .json file
for (int i = 0; i < data.size(); i++) {
  JSONObject json = data.getJSONObject(str(i));


  int x = json.getInt("x"); 
  int y = json.getInt("y"); 
  
  
  Node n = new Node(x, y, 10);
  
  
  if (nodes.size() < data.size()) {
    nodes.add(n);
    
  }
  
  
  //textSize(96);
  //text(str(i), x-30, y-75);
  //fill(0, 255, 255);
  
}

// Draw the edges for each triangle
for (int i = 0; i < tris.size(); i++) {
  
  JSONObject shape = tris.getJSONObject(str(i));
  
  int l = shape.getInt("v1");
  int m = shape.getInt("v2");
  int n = shape.getInt("v3");
  
  Node a = (Node) nodes.get(l);
  Node b = (Node) nodes.get(m);
  Node c = (Node) nodes.get(n);
  
  JSONObject v1 = data.getJSONObject(str(l));
  float v1x = a.x;
  float v1y = a.y;
  JSONObject v2 = data.getJSONObject(str(m));
  float v2x = b.x;
  float v2y = b.y;
  JSONObject v3 = data.getJSONObject(str(n));
  float v3x = c.x;
  float v3y = c.y;
  
  stroke(mesh_color);
  
  line(v1x, v1y, v2x, v2y);
  line(v1x, v1y, v3x, v3y);
  line(v2x, v2y, v3x, v3y);
  
}

}
