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
