
final int X_OFFSET  =  40;                     // x-distance to left upper corner of window
final int Y_OFFSET  =  60;                     // y-distance to left upper corner of window
final int BOT_DIST  =  80;                     // distance to bottom line of window
final int COL_WIDTH =   4;                     // column widt
final int Y_DIST    =  64;                     // distance horizontal lines
final int X_DIST    =   5;                     // distance vertical lines
final int X_MAX     = (128+1)*X_DIST+1;        // x-axis lenght
final int Y_MAX     = 256;                     // y-axis lenght
final int X_WINDOW  = X_MAX + 2*X_OFFSET;      // window width
final int Y_WINDOW  = Y_MAX+BOT_DIST+Y_OFFSET; // window height
final int X_ENUM    = 10;
PFont fontA;
color graphColor = color(25, 25, 250);
PFont fontGraph;
import processing.serial.*;
Serial port;
int[] inBuffer = new int[128];

void draw_grid()                               // draw grid an title
{ 
  int count=0;

  background(200);
  stroke(0);
  for (int x=0+X_DIST; x<=X_MAX; x+=X_DIST)    // vertical lines
  {
    if ( X_ENUM == count || 0 == count)
    { 
      line (x+X_OFFSET, Y_OFFSET, x+X_OFFSET, Y_MAX+Y_OFFSET+10);
      count=0;
    }
    else
    {
      line (x+X_OFFSET, Y_OFFSET, x+X_OFFSET, Y_MAX+Y_OFFSET);
    }    
    count++;
  }
  for (int y=0; y<=Y_MAX; y+=Y_DIST)           // horizontal lines 
  {
    line (X_OFFSET, y+Y_OFFSET, X_MAX+X_OFFSET, y+Y_OFFSET);
    textFont(fontA, 16);
    text( (Y_MAX-y), 7, y+Y_OFFSET+6);
  }
  textFont(fontA, 32);
  fill(graphColor); 
  text("128-Channel Spectrum Analyser", 215, 40);
  textFont(fontA, 16);
  text("magnitude", 7, 20);  
  text("(8bit-value)", 7, 40);  
  text("--> channel (number i)", X_OFFSET, Y_WINDOW-Y_OFFSET/2);
  text(" frequency   f ( i ) = i * SAMPLE_RATE / FHT_N ", 350, Y_WINDOW-Y_OFFSET/2 );
} 

void serialEvent(Serial p)                      // ISR triggerd by "port.buffer(129);"
{ 
  if ( 255 == port.read() )                     //  1 start-byte               
  {
    inBuffer = int( port.readBytes() );         // 128 data-byte
  }
}

void setup() 
{ 
                        // size of window
  noStroke();
  fontGraph = loadFont("ArialUnicodeMS-48.vlw");
  textFont(fontGraph, 12);
  println(Serial.list());                        // show available COM-ports
  port = new Serial(this, "COM9", 9600);
  port.buffer(129);                              // 1 start-byte + 128 data-bytes 
  fontA = loadFont("ArialUnicodeMS-48.vlw");
  textFont(fontA, 16);
}

void settings()
{
  size(X_WINDOW, Y_WINDOW);
}

void draw() 
{ 
  int count=0;

  draw_grid();

  for (int i=0; i<128; i++)
  { 
    fill(graphColor);
    rect(i*X_DIST+X_OFFSET+X_DIST-COL_WIDTH/2, height-BOT_DIST, COL_WIDTH, -inBuffer[i]);
    if ( X_ENUM == count || 0 == count)
    { 
      text(i, (i+1)*X_DIST+X_OFFSET-COL_WIDTH/2, height-BOT_DIST+25);
      count=0;
    }
    count++;
  }
}
