
class State {
  int n;
  bool finale=false;
  bool initiale=false;
  Map<String,State> nextStates = new Map();
  State(int i) {
    this.n=i;
  }
  bool sameState() {
    bool e=true;
    for(var s in nextStates.values) {
      if(s!=this) e=false;
    }
    return e;
  }

}

