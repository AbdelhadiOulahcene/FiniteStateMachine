import 'state.dart';
import 'dart:io';
import 'transition.dart';

class Automate {
  int nbEtats;
  int nbFinal;
  List<String> alph;
  List<State> states;
  List<State> etat_access;
  State current;
  Automate();

  void actualiserNbFinal() {
    nbFinal=0;
    for(var s in this.states) {
      if(s!=null && s.finale) nbFinal++;
    }

  }

  void printAutomate() {
    print('\n');
    for (int i = 0; i < this.states.length; i++) {
      if (this.states[i] != null) {
        String fin = '';
        String ini = '';
        if (this.states[i].finale == true) fin = 'final';
        if (this.states[i].initiale == true) ini = 'initial';
        print('Etat $i : $ini $fin \n');
        this.states[i].nextStates.forEach((k, v) =>
            print('(Etat $i , $k , Etat ${this.states.indexOf(v)} )\n'));
        print(
            '/***********************************************************************/');
      }
    }
  }

  void creerAutomate() {
    print('\n');
    this.alph = new List();
    print('Donner nombre d’états de l’automate: ');
    String nb1 = stdin.readLineSync();
    nbEtats = int.parse(nb1);
    if (nbEtats > 0) {
      this.states = new List();
      for (int k = 0; k < nbEtats; k++) {
        this.states.add(new State(k));
      }
      this.states[0].initiale = true;
      print('Donner nombre d’états finaux: ');
      String nb2 = stdin.readLineSync();
      nbFinal = int.parse(nb2);
      if (nbFinal > nbEtats) print('Erreur : le nombre d’états finaux ne doit pas dépasser le nombre d’états de l’automate\n');
      else {
        print('Donner les états finaux: \n');
        for (int i = 0; i < nbFinal; i++) {
          print('Donner un état final: ');
          String nb3 = stdin.readLineSync();
          int etatFinal = int.parse(nb3);
          this.states[etatFinal].finale = true;
        }

      print('Ajouter les transitions:  \n');
      for (int i = 0; i < nbEtats; i++) {
        for (int k = 0; k < nbEtats; k++) {
          print(
              'Est-ce qu’il y a une transition de l’état $i vers l’état $k ? (y/n) ');
          String answer = stdin.readLineSync();
          if (answer == 'y') {
            print(
                'Donner la transition : (Pour une e-transition écrire "eps" ) \n');
            String tr = stdin.readLineSync();
            this.states[i].nextStates.addAll({tr: this.states[k]});
            bool exist = alph.contains(tr);
            if (exist == false) alph.add(tr);
          }
        }
      }
    }
    }
  }

  void reconnaissanceMot() {
    print('\n');
    print('Donner un mot \n');
    String mot = stdin.readLineSync();
    int i = 0;
    bool stop = false;
      int z=0;
      bool stopz=false;
      while(z<this.states.length && !stopz) {
        if(this.states[z]!=null && this.states[z].initiale!=null && this.states[z].initiale) stopz=true;
        else z++;
      }

    this.current = this.states[z];

    while (i < mot.length && !stop) {
      if (this.current.nextStates != null) {
        if (this.current.nextStates.containsKey(mot[i]) || this.current.nextStates.containsKey('eps')) {
          if( this.current.n !=null && this.current.nextStates[mot[i]].n!=null) {
          print('Etat ${this.current.n} ---- ${mot[i]}---- Etat ${this.current.nextStates[mot[i]].n}  \n');
          this.current = this.current.nextStates[mot[i]];
          i++;}
        } else
          stop = true;
      }
    }
    if (i == mot.length && this.current.finale!=null && this.current.finale)
      print('Le mot $mot est reconnu par ce automate\n');
    else
      print('Le mot $mot n’est pas reconnu par ce automate\n');
  }

  void reduire() {
    /********************************co-accessible***********************************/
    for (int i = 1; i < this.states.length; i++) {
      if (this.states[i] != null) {
        if (this.states[i].finale!=null && this.states[i].finale == false) {
          if (this.states[i].nextStates!=null && this.states[i].nextStates.isEmpty!=null && (this.states[i].nextStates.isEmpty || this.states[i].sameState())) {
            for (int j = 0; j < this.states.length; j++) {
              if (this.states[j] != null) {
                if (this.states[j].nextStates!=null && this.states[j].nextStates.containsValue(this.states[i])) {
                  this
                      .states[j]
                      .nextStates
                      .removeWhere((k, v) => v == this.states[i]);
                  print('Supression d’une transition de l’état $j vers l’état $i \n');
                }
              }
            }
            this.states[i] = null;
            print('Suppression de l’état $i qui est non co-accessible\n');
            this.nbEtats--;
          }
        }
      }
    }
    /**********************************accessible***********************************/
    List<State> access = new List();
    etat_access = new List();
    int z=0;
      bool stopz=false;
      while(z<this.states.length && !stopz) {
        if(this.states[z].initiale !=null && this.states[z].initiale) stopz=true;
        else z++;
      }
    etat_access.add(this.states[z]);
    int q = 0;
    while (q < etat_access.length) {
      if (etat_access[q].nextStates != null) {
        access.addAll(etat_access[q].nextStates.values);
      }
      for (var s in access) {
        if (!etat_access.contains(s)) etat_access.add(s);
      }
      q++;
    }

    print('--------------------------------------------------------------------------------\n');

    for (int j = 0; j < this.states.length; j++) {
      if (this.states[j] != null) {
        if (!etat_access.contains(this.states[j])) {
          this.states[j] = null;
          print('Suppression de l’état $j qui est non accessible\n');
          this.nbEtats--;
        }
      }
    }
  }

  void complement() {
    State etatPuit = new State(this.states.length);
    etatPuit.finale = false;
    this.states.add(etatPuit);
    this.nbEtats++;

    for (int b = 0; b < this.alph.length; b++) {
      etatPuit.nextStates.addAll({this.alph[b]: etatPuit});
    }

    for (int a = 0; a < this.states.length; a++) {
      if (this.states[a] != null) {
        if (this.states[a].finale!=null && this.states[a].finale == true)
          this.states[a].finale = false;
        else
          this.states[a].finale = true;
        for (int b = 0; b < this.alph.length; b++) {
          if (this.states[a]!=null && this.states[a].nextStates!=null && this.states[a].nextStates.containsKey(this.alph[b]) == false) {
            this.states[a].nextStates.addAll({this.alph[b]: etatPuit});
          }
        }
      }
    }
    this.actualiserNbFinal();
  }

  void miroir() {
    if(this.nbFinal==1){
      int i=0;
      bool stop=false;
      while(i<this.states.length && !stop) {
        if(this.states[i]!=null && this.states[i].finale!=null && this.states[i].finale) stop=true;
        else i++;
      }
      int z=0;
      bool stopz=false;
      while(z<this.states.length && !stopz) {
        if(this.states[z]!=null && this.states[z].initiale!=null && this.states[z].initiale) stopz=true;
        else z++;
      }

      this.states[z].initiale = false;
      this.states[z].finale = true;
      this.states[i].initiale = true;
      this.states[i].finale = false;  
      this.actualiserNbFinal();
    }
    else {
          State etatFinal = new State(this.states.length);
            for (int a = 0; a < this.states.length; a++) {
              if (this.states[a] != null && this.states[a].finale!=null && this.states[a].finale) {
                  this.states[a].finale = false;
                  this.states[a].nextStates.addAll({'eps': etatFinal});
                
              }
            }
            int z=0;
            bool stopz=false;
            while(z<this.states.length && !stopz) {
              if(this.states[z].initiale!=null && this.states[z].initiale) stopz=true;
              else z++;
              }
            this.states[z].initiale = false;
            this.states[z].finale = true;
            etatFinal.initiale = true;
            etatFinal.finale = false;
            this.states.add(etatFinal);
            this.nbEtats++;
            this.actualiserNbFinal();
    }
    this.inverser();

  }
  
  void inverser() {
    List<Transition> trs = new List();
    
      for (var act in this.states) {
        if(act!=null && act.nextStates!=null){
        
          for(var k in act.nextStates.keys) {
          Transition t = new Transition();
              t.init=act.nextStates[k];
              t.trans=k;
              t.next=act;
              trs.add(t);
          }
        }
      }
    for(int i=0;i<this.states.length;i++) {
      if(this.states[i]!=null && this.states[i].nextStates!=null) {
      this.states[i].nextStates.clear();
      this.states[i].nextStates=new Map();
      for(int j=0;j<trs.length;j++) {
        if(trs[j]!=null && trs[j].init!=null && trs[j].init==this.states[i]) {
          this.states[i].nextStates.addAll({trs[j].trans:trs[j].next});
        }

      }
      }
    }
    

  }


}
