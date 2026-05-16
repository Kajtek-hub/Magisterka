import 'package:flutter/material.dart';
import 'package:magisterka/theme.dart';
import 'dart:math';
import 'dart:async';
import 'package:magisterka/api/secure_storage.dart';
import 'package:magisterka/api/test_service.dart';

class TwoBackScreen extends StatefulWidget{
  
  const TwoBackScreen (this.onTwoBack, {super.key});
  final void Function() onTwoBack;

  @override
  State<StatefulWidget> createState() {
    return _TwoBackScreen();
  }
}

class _TwoBackScreen extends State<TwoBackScreen>{

  List <int> fullTestListNBack = List.filled(60, 0);  //Końcowy placeholder listy kombinacji cyfr na razie puste 0 
  List <int> indexOfPairs = []; //Indexy poprawnych momentów kliknięcia

  int rollTimeDuration = 0; //Wylosowany czas pojawienia/zniknięcia cyfry
  bool isDiaplayed = false; //Odpowiada za pokazanie/ukrycie cyfry
  int currentNumber = 0;  //Obecna cyfra
  int hits = 0; //Liczba poprawnych odpoiwedzi
  int misses = 0; //Liczba pominiętych dobrych
  int falseAlarms = 0;  //Liczba złych odpoiwedzi
  int tempSwitcher = 0; //Sprawdzamy czy index pasuje do indexu poprawnych par
  bool hasResponded = false;  //Czy użytkownik wykonał ruch
  bool isMatch = false;  //Czy pasuje
  int stimulusValue = 0;  //To co wyśwetlamy

  void testPreparation(){
    int numberOfPairs = Random().nextInt(6) + 12; //Liczba poprawnych indexów
    Set <int> all = {}; //Set żeby nie było powtórek poprawnych indexów
    while(all.length< numberOfPairs){
      all.add(Random().nextInt(57)+2);  //Wybór poprawnych indexów
    }
    indexOfPairs = all.toList();  //Przekształcamy set do listy żęby było łatwiej operować
    indexOfPairs.sort();  //Sortowanie listy poprawnych indexów od najmniejszej do największej 
    print("MATCH COUNT: $numberOfPairs"); //Print poprawności ilości par
    print("MATCH INDEXES: $indexOfPairs"); //Print poprawności indexów par

    int tempIndexList = 0;  //Zmienna krocząca po liście indexów i sprawdzająca czy i w pętli for akurat wylądował na odpowiednim indexie
    fullTestListNBack[0] = Random().nextInt(6)+1; //Losowanie pierwszej wartości
    fullTestListNBack[1] = Random().nextInt(6)+1; //Losowanie drugiej wartości

    for (var i=2; i<fullTestListNBack.length; i++) {
      if(tempIndexList < indexOfPairs.length){
        if(i == indexOfPairs[tempIndexList]){
          fullTestListNBack[i] = fullTestListNBack[i-2];
          tempIndexList++;
        }else{
          int value;
          do {
            value = Random().nextInt(6) + 1;
          } while (value == fullTestListNBack[i - 2]);
          fullTestListNBack[i] = value;
        }
      }else{
        int value;
        do {
          value = Random().nextInt(6) + 1;
        } while (value == fullTestListNBack[i - 2]);
        fullTestListNBack[i] = value;
      }
      
    }

    print("MATCH COUNT: $fullTestListNBack");
  }

  void startTrial() {
    hasResponded = false; //Czy użytkownik odpowiedział
    stimulusValue = fullTestListNBack[currentNumber]; //Przypisujemy obecną liczbę do wyświetlenia
    isMatch = (tempSwitcher < indexOfPairs.length && currentNumber == indexOfPairs[tempSwitcher]);  //
  }

  void indexChecker() {

    if (hasResponded) return; 
      hasResponded = true;

    if (isMatch) {
      hits++;
      tempSwitcher++;
    } else {
      falseAlarms++;
    }
  }

  void evaluateMiss() {
    if (isMatch && !hasResponded) {
      misses++;
      tempSwitcher++;
      print('Miss Index $currentNumber');
    }
  }

  void timer(){
    Timer.periodic(const Duration(milliseconds: 500), (timer)async{
      if(currentNumber < 60){

        setState(() {

          if((rollTimeDuration == 0) && (isDiaplayed == false)){  //Wyłącznie widoku cyfry - początek
            
            rollTimeDuration = Random().nextInt(4)+1; //Losujemy czas ukrycia cyfry
            startTrial();
          }

          else if((rollTimeDuration != 0) && (isDiaplayed == false)){ //Wyłączenie widoku cyfry - do końca
            rollTimeDuration--; //Zmniejsamy wylosowany czas 
            if(rollTimeDuration == 0){  //Aż do zera żeby przejść do włączenia
              isDiaplayed = true; //Na true to włączamy liczbę
            }
          }

          else if((rollTimeDuration == 0) && (isDiaplayed == true)){  //Włączenie widoku cyfry - początek
            rollTimeDuration = Random().nextInt(1)+1; //Losujemy czas pojawienia cyfry
            
          }
          else if((rollTimeDuration != 0) && (isDiaplayed == true)){  //Włączenie widoku cyfry - do końca
            rollTimeDuration--; //Zmniejsamy wylosowany czas 
            if(rollTimeDuration == 0){ //Jak czas dojdzie do 0
              evaluateMiss();
              isDiaplayed = false;  //Wyłączamy widok cyfry
              currentNumber++;      //Przechodzimy do następnej 
            }
          }

        });
      }else{
        timer.cancel();
        try{
          final userId = await SecureStorage.getUserId();
          if (userId != null) {
            await TestService.saveNBack(
              userId: userId,
              hits: hits,
              misses: misses,
              falseAlarms: falseAlarms,
            );
          }
                  }catch (e){
          print("Saving 2-Back error: $e");
        }
        if(mounted){
          Navigator.pushNamed(context, '/test-menu-screen');
        }
        
        //print('Hits : $hits ');
        //print('Misses : $misses');
        //print('False Alarms : $falseAlarms');
        return;
      }
    });
  }

  @override
  void initState(){
    super.initState();
    testPreparation();
    timer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme_Colors.background1,
            Theme_Colors.background2
          ],
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight
          )
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isDiaplayed 
              ?Container(width: 80 ,height: 100, color: Colors.transparent, alignment: Alignment.center, child: Text(stimulusValue.toString(), style: TextStyle(fontSize: 80, color: Colors.white),))
              :Container(width: 80 ,height: 100, color: Colors.transparent,),
              SizedBox(height: 80,),
              ElevatedButton(onPressed: (){print("Hit Index: $currentNumber");indexChecker();}, child:  Text('Press Me'))
            ],
          ),
        ),
      ),
    );
  }
}