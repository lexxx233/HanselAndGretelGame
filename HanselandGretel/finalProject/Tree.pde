/**
 *
 * A simple and limited Tree Implementation for art project
 * @author Thanh Le | College of Information Science and Technology | PennState University
 * txl252@psu.edu
 **/

class TreeNode {
  Object data; //Make use of java generic
  ArrayList<TreeNode> children;

  TreeNode() {
    children = new ArrayList();
  }

  TreeNode(Object d) {
    data = d;
    children = new ArrayList();
  }

  void addChild(TreeNode n) {
    children.add(n);
  }

  ArrayList<TreeNode> getChildren() {
    return children;
  }

  public TreeNode addNode(Object dataToFind, Object dataToAdd) {
    //Traverse tree until find node
    if (this.getChildren().size() == 0 && !this.data.equals(dataToFind)) {
      return this;
    }

    if (this.data.equals(dataToFind)) {
      this.addChild(new TreeNode(dataToAdd));
      return this;
    } else {
      TreeNode temp = new TreeNode(this.data);
      for (TreeNode c : this.getChildren ()) {
        temp.addChild(c.addNode(dataToFind, dataToAdd));
      }
      return temp;
    }
  }

  public void printNode(Object dataToFind) {
    if (this.getChildren().size() == 0 && !this.data.equals(dataToFind)) {
      print(this.data);
      print(". ");
      return;
    }

    if (this.data.equals(dataToFind)) {
      print(this.data);
    
      print("(");
      for (TreeNode c : this.getChildren ()) {
        print(c.data);
        for (TreeNode cx : c.getChildren ()) {
          cx.printNode(dataToFind);
        }
      }
      print(")");
    } else {
      print(this.data);
      print("(");
      for (TreeNode c : this.getChildren ()) {
        c.printNode(dataToFind);
      }
      print(")");
      return;
    }
  }
}

