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
