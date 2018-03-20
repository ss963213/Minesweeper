import de.bezier.guido.*;
int NUM_ROWS=20;
int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs=new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    
    buttons= new MSButton[NUM_ROWS][NUM_COLS];
    for(int i=0;i<NUM_ROWS;i++){
    for(int j=0;j<NUM_COLS;j++){
    buttons[i][j]=new MSButton(i,j);
    }}
    setBombs();
}
public void setBombs()
{ for(int i=0;i<50;i++){
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[row][col]))
    bombs.add(buttons[row][col]);}
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int clikd=0;
    for(int i=0; i<NUM_ROWS;i++)
    {
        for(int j=0; j< NUM_COLS;j++)
        {
            if(buttons[i][j].clicked)
                clikd++;
        }
    }
    if(clikd>=350)
    {
        return true;
    }
    return false;
}
public void displayLosingMessage()
{
    for(int i =0; i<NUM_ROWS;i++)
    {
        for(int j=0; j<NUM_COLS;j++)
        {
            if(bombs.contains(buttons[i][j]))
                buttons[i][j].clicked=true;
            else
                buttons[i][j].setLabel(new String(""));
        }
    }
    fill(0);
    textSize(20);
    buttons[10][8].setLabel(new String("L"));
    buttons[10][9].setLabel(new String("o"));
    buttons[10][10].setLabel(new String("s"));
    buttons[10][11].setLabel(new String("t"));
}
public void displayWinningMessage()
{
   buttons[10][9].setLabel(new String("W"));
    buttons[10][10].setLabel(new String("I"));
    buttons[10][11].setLabel(new String("N"));
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if(mouseButton==RIGHT)
        marked=!marked;
        else if(mouseButton==LEFT&&bombs.contains(this)){
          clicked = true;
        displayLosingMessage();}
        else if(countBombs(r,c)>0){
          clicked = true;
        label=""+countBombs(r,c);
        }
        else{
          clicked = true;
          for(int i=-1; i<2;i++)
                {
                    for(int j=-1; j<2;j++)
                    {   
                        if(isValid(r+i,c+j)&&buttons[r+i][c+j].isClicked()==false)
                        buttons[r+i][c+j].mousePressed();
                    }
                }
        } 
        }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if(clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r>=0&&r<NUM_ROWS&&c>=0&&c<NUM_COLS)
        return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
         int numBombs = 0;
        for(int i=-1;i<2;i++)
        {
            for(int j=-1;j<2;j++)
            {
            if(isValid(row+i,col+j)&&bombs.contains(buttons[row+i][col+j]))
                numBombs++;
             }
        }
        
        return numBombs;
    }
    }