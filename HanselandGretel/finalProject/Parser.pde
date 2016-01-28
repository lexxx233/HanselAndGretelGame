/**
 * Parser parse java source code to get parameters
 * @author Thanh Le | College of Information Science and Technology | PennState University
 * txl252@psu.edu
 **/
import com.github.javaparser.*; //JavaParser project can be found on github
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.List;

class Parser {
  int logicSize;
  Node logicTree;
  
  CompilationUnit cu;

  public Parser(String fileName) {
    println(fileName);

    FileInputStream in;
    try {
      in = new FileInputStream(fileName);
      cu = JavaParser.parse(in);
    }
    catch(FileNotFoundException e) {
      System.err.println(e.getMessage());
    }
    catch(ParseException e) {
      System.err.println(e.getMessage());
    }

    new MethodVisitor().visit(cu, null);
    //new ClassVisitor().visit(cu, null);
  }
}


/**
 * Routine parser
 * @author: Thanh Le | txl252
 **/
private static class MethodVisitor extends VoidVisitorAdapter {
  @Override
    public void visit(MethodDeclaration n, Object arg) {
    // here you can access the attributes of the method.
    // this method will be called for all methods in this 
    // CompilationUnit, including inner class methods
    println(n.getName());
    //System.out.println(n.getBody().getChildrenNodes());
    List<Statement> ls = n.getBody().getStmts();
    if (ls != null) {
      for (Statement s : ls) {
        print("Statement : ");
        println(s.getChildrenNodes());
        
      }
    }
  }
}

/**
 * Conditional parser
 * @author: Thanh Le | txl252
 **/
private static class IfStmtVisitor extends VoidVisitorAdapter {
  @Override
    public void visit(MethodDeclaration n, Object arg) {
    // here you can access the attributes of the method.
    // this method will be called for all methods in this 
    // CompilationUnit, including inner class methods
    System.out.println(n.getName());

    List<Statement> ls = n.getBody().getStmts();
    if (ls != null) {
      for (Statement s : ls) {
        print(s);
      }
    }
  }
}

/**
 * Flow Control Parser
 * @author: Thanh Le | txl252
 **/

private static class ForStmtVisitor extends VoidVisitorAdapter {
  @Override
    public void visit(MethodDeclaration n, Object arg) {
    // here you can access the attributes of the method.
    // this method will be called for all methods in this 
    // CompilationUnit, including inner class methods
    System.out.println(n.getName());
    System.out.println(n.getBody().getChildrenNodes());
  }
}

private static class WhileStmtVisitor extends VoidVisitorAdapter {
  @Override
    public void visit(MethodDeclaration n, Object arg) {
    // here you can access the attributes of the method.
    // this method will be called for all methods in this 
    // CompilationUnit, including inner class methods
    System.out.println(n.getName());
    System.out.println(n.getBody().getChildrenNodes());
  }
}

/**
 * Declration Parser
 * @author: Thanh Le | txl252
 **/
private static class ClassVisitor extends VoidVisitorAdapter {
  @Override
    public void visit(ClassOrInterfaceDeclaration n, Object arg) {
    // here you can access the attributes of the method.
    // this method will be called for all methods in this 
    // CompilationUnit, including inner class methods
    System.out.println(n.getName());
  }
}

private static class VariableVisitor extends VoidVisitorAdapter {
  @Override
    public void visit(ClassOrInterfaceDeclaration n, Object arg) {
    // here you can access the attributes of the method.
    // this method will be called for all methods in this 
    // CompilationUnit, including inner class methods
    System.out.println(n.getName());
  }
}

