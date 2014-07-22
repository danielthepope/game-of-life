int[] gridSize = {60,60}; // {137,77}, 10 for fullscreen
int pixelSize = 7;
int cycle = 64; // Cells die after this many frames
int hueColour = int(cycle * 0.1); // trying to get cyan
int occurrence = 20; // Chance of cells spawning (bigger number = less chance)
int fr = 15;    // Frame rate
Universe universe;

void setup() {
  size(gridSize[0] * pixelSize, gridSize[1] * pixelSize);
//  size(displayWidth, displayHeight);
  colorMode(HSB,cycle);
  background(0,0,cycle);
  frameRate(fr);
  strokeWeight(1);
  noStroke();
//  noCursor(); // use for fullscreen
  startUniverse();
}

void startUniverse() {
  universe = new Universe(gridSize[0], gridSize[1]);
  for (int i = 0; i < gridSize[0]; i++) {
    for (int j = 0; j < gridSize[1]; j++) {
      int life = int(random(occurrence)); // Change to 30 or something
      universe.grid[i][j] = new Cell(life);
    }
  }
  drawGrid();
  //noLoop();
}

void draw() {
  tick();
  universe.advance();
  drawGrid();
}

void tick() {
  for (int i = 0; i < gridSize[0]; i++) {
    for (int j = 0; j < gridSize[1]; j++) {
      if (universe.grid[i][j].isAlive()) {
        // It remains alive if it has 2 or 3 neighbours.
        // Otherwise it becomes dead
        int neighbours = liveNeighbours(i, j);
        if (neighbours < 2 || neighbours > 3) {
          universe.grid[i][j].kill();
        }
      } else {
        // It can only come to life if it has 3 neighbours.
        if (liveNeighbours(i, j) == 3) {
          universe.grid[i][j].birth();
        }
      }
    }
  }
}

int liveNeighbours(int x, int y) {
  int count = 0;
  if (universe.getCell(x-1, y-1).isAlive()) count++;
  if (universe.getCell(x,   y-1).isAlive()) count++;
  if (universe.getCell(x+1, y-1).isAlive()) count++;
  if (universe.getCell(x-1, y  ).isAlive()) count++;
  if (universe.getCell(x+1, y  ).isAlive()) count++;
  if (universe.getCell(x-1, y+1).isAlive()) count++;
  if (universe.getCell(x,   y+1).isAlive()) count++;
  if (universe.getCell(x+1, y+1).isAlive()) count++;
  return count;
}

void drawGrid() {
//  background(0,0,cycle); // white
//  background(0,0,0); // black
  noStroke();
  fill(0,0,0,cycle * 0.5); // fadey background
  rect(0,0,width,height);
  noFill();
  int age;
  float size;
  color c;
  for (int i = 0; i < gridSize[0]; i++) {
    for (int j = 0; j < gridSize[1]; j++) {
      if (universe.grid[i][j].isAlive()) {
        age = universe.grid[i][j].getAge();
        //fill(age % cycle,cycle,cycle);
        //fill(age,cycle - age,cycle); //red through white
        c = color(hueColour, cycle - age, cycle);
//        stroke(c);
        fill(c);
        //rect(i * pixelSize, j * pixelSize, pixelSize, pixelSize); // pixel style
        size = ((cycle - (age * 0.8)) / (float)cycle) * (pixelSize);
        ellipse((i*pixelSize)+(pixelSize/2), (j*pixelSize)+(pixelSize/2), size, size);
      }
    }
  }
}

void mouseClicked() {
  // I want it to start again, with a new burst of life!
  startUniverse();
}
class Cell {
  boolean state;
  boolean nextState;
  int age;
  
  Cell(int life) {
    if (life == 1) {
      state = true;
      nextState = true;
    } else {
      state = false;
      nextState = false;
    }
    age = 0;
  }
  
  int getAge() {
    return age;
  }
  
  void setAge (int a) {
    age = a;
  }
  
  void kill() {
    nextState = false;
    age = 0;
  }
  
  void birth() {
    nextState = true;
    age = 0;
  }
  
  boolean isAlive() {
    return state;
  }
  
  boolean advance() {
    if (state == true) age++;
    state = nextState;
    //if (age > 60) explode();
    return state;
  }
}
class Universe {
  public Cell[][] grid;
  int[] gridSize;
  
  Universe(int sizeX, int sizeY) {
    gridSize = new int[2];
    gridSize[0] = sizeX;
    gridSize[1] = sizeY;
    grid = new Cell[sizeX][sizeY];
  }
  
  void advance() {
    // Updates the cell's lives
    for (int i = 0; i < gridSize[0]; i++) {
      for (int j = 0; j < gridSize[1]; j++) {
        grid[i][j].advance();
        if (grid[i][j].getAge() > cycle) {
          // Revive neighbours?
          getCell(i-1,j-1).birth();
          getCell(i,j-1).birth(); 
          getCell(i+1,j-1).birth();
//          getCell(i+1,j).birth();
//          getCell(i+1,j+1).birth();
//          getCell(i,j+1).birth();
//          getCell(i-1,j+1).birth();
//          getCell(i-1,j).birth();
          grid[i][j].kill();
        }
      }
    }
  }

  void pond(int x, int y) {
    universe.grid[x+1][y].birth();
    universe.grid[x+2][y].birth();
    universe.grid[x][y+1].birth();
    universe.grid[x][y+2].birth();
    universe.grid[x+1][y+3].birth();
    universe.grid[x+2][y+3].birth();
    universe.grid[x+3][y+2].birth();  
    universe.grid[x+3][y+1].birth();
  }

  void block(int x, int y) {
    universe.grid[x][y].birth();
    universe.grid[x+1][y].birth();
    universe.grid[x][y+1].birth();
    universe.grid[x+1][y+1].birth();
  }
  
  Cell getCell(int x, int y) {
    if (x < 0) x += gridSize[0];
    else if (x >= gridSize[0]) x-= gridSize[0];
    if (y < 0) y += gridSize[1];
    else if (y >= gridSize[1]) y -= gridSize[1];
    return grid[x][y];
  }
}

