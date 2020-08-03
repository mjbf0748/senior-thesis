void keyPressed() {
  
  if (key == 'd') {
      Node n = new Node(mouseX , mouseY, 10);
      n.draw();
      nodes.add(n);
  }
  
  if (key == 's') {
    saveNodes();
  }
}

//Save the nodes that are in the arraylist nodes

void saveNodes() {
  JSONObject Mynodes = new JSONObject();
  
  for (int i = 0; i < nodes.size(); i++) {
      JSONObject node = new JSONObject();
      Node n = (Node) nodes.get(i);
      node.setInt("id", i);
      node.setInt("x", (int)n.x);
      node.setInt("y", (int)n.y);
      Mynodes.setJSONObject(str(i), node);
  }
  saveJSONObject(Mynodes, "nodes.json");
  System.out.println("saved");
}


void mousePressed() {
  dragNode = null;
  Node n;
  for (int i = 0; i < nodes.size(); i++) {
    n = (Node) nodes.get(i);
    if (n.contains(mouseX, mouseY)) {
      dragNode = n;
    }
  }
}

void mouseDragged() {
  if (dragNode != null) {
    dragNode.x = mouseX;
    dragNode.y = mouseY;
  }


}

void mouseReleased() {
  dragNode = null;
}
