import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private final static int NUM_BOMBS = 70;
private boolean lost = false;
private int clearedCount = 0;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines()
{
  //your code

  while (mines.size() < NUM_BOMBS) {
    int randomRow = (int)(Math.random()*NUM_ROWS);
    int randomCol = (int)(Math.random()*NUM_COLS);
    if ((mines.contains(buttons[randomRow][randomCol])) == false) {
      mines.add(buttons[randomRow][randomCol]);
    }
   // System.out.println(randomRow+ "," +randomCol);
  }
}


public void draw ()
{
  background( 0 );
 // println(clearedCount + ", " + (NUM_ROWS*NUM_COLS - mines.size()));
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  int num = 0; 

  for (int i = 0; i < mines.size(); i++) {
    if (mines.get(i).flagged == true) {
      num++;
    }
  }

  if (clearedCount == NUM_ROWS*NUM_COLS - mines.size()) {

    return true;
  }

  if (num == NUM_BOMBS) {
    return true;
  }

  return false;
}
public void displayLosingMessage()
{
  //your code here
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("O");
  buttons[10][8].setLabel("U");
  buttons[10][9].setLabel("");
  buttons[10][10].setLabel("L");
  buttons[10][11].setLabel("O");
  buttons[10][12].setLabel("S");
  buttons[10][13].setLabel("E");
  buttons[11][9].setLabel(":)");

  for (int i = 0; i < mines.size(); i++) {
    mines.get(i).clicked = true;
  }
  lost = true;
}
public void displayWinningMessage()
{
  //your code here
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("O");
  buttons[10][8].setLabel("U");
  buttons[10][10].setLabel("W");
  buttons[10][11].setLabel("I");
  buttons[10][12].setLabel("N");
  buttons[10][13].setLabel(":|");
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      if (isValid(row+i, col+j) && mines.contains(buttons[row+i][col+j])) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  return numMines;
}

public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel; 

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (isWon() == false && lost == false) {

      if (mouseButton == LEFT && !mines.contains(this)) {
        clearedCount++;
      }

      if (mouseButton == RIGHT && buttons[myRow][myCol].myLabel == "") {
        flagged = !flagged;
        if (flagged == false) {
          clicked = false;
        }
      } else if (mines.contains(this)) {
        displayLosingMessage();
      } else if (countMines(myRow, myCol)>0) {
        myLabel = (""+countMines(myRow, myCol));
      } else {
        for (int r = -1; r <=1; r++) {
          for (int c = -1; c <=1; c++) {
            if (isValid(myRow+r, myCol+c) && buttons[myRow+r][myCol+c].clicked == false) {
              myLabel = " ";
              buttons[r+myRow][c+myCol].mousePressed();
            }
          }
        }
      }
    }
  }

  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if (clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked) {
      fill( 200 );
    } else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
