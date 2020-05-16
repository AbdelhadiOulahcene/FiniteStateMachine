import 'dart:io';
import 'automate.dart';

void main() {
  int m = 0;
  Automate automate;
  while (m == 0) {
    print('\n\n\n');
    print('\t/*************************   Menu   ********************************/\n');
    print('\t1- Créer un automate déterministe\n');
    print('\t2- Afficher l’automate\n');
    print('\t3- La reconnaissance de mots dans un automate déterministe\n');
    print('\t4- la réduction d’un automate\n');
    print('\t5- Le complément d’un automate ( simple et déterministe ) \n');
    print('\t6- Le miroir d’un automate\n');
    print('\t7- exit');
    print('\t/*************************   Fin Menu   ********************************/\n');
    print('\n\n\n');
    print('Que voulez-vous faire:');
    String ch = stdin.readLineSync();
    switch (ch) {
    
      case '1':
        {
          automate = new Automate();
          automate.creerAutomate();
        }
        break;
      case '2':
        {
          if (automate == null) print("\nCréer d’abord un automate\n");
          else automate.printAutomate();
        }
        break;
      case '3':
        {
          if (automate == null) print("\nCréer d’abord un automate\n");
          else automate.reconnaissanceMot();
        }
        break;

      case '4':
        {
          if (automate == null) print("\nCréer d’abord un automate\n");
          else automate.reduire();
        }

        break;
      case '5':
        {
          if (automate == null) print("\nCréer d’abord un automate\n");
          else automate.complement();
        }
        break;
      case '6':
        {
          if (automate == null) print("\nCréer d’abord un automate\n");
          else automate.miroir();
        }
        break;
      case '7':
        { m = 1;}
        break;
      default:
        {
          print('\nVeuillez sélectionner un choix!\n');
        }
    }
  }
}
