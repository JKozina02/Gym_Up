import 'package:flutter/material.dart';
import 'package:gym_up/pages/workout_pake.dart';
import 'package:provider/provider.dart';
import '../data/workout_data.dart';

void main() {
  

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

Color bialy = const Color.fromRGBO(255, 255, 255, 1);
Color szary = const Color.fromRGBO(50, 50, 50, 1);
Color czarny = const Color.fromRGBO(9, 9, 9, 1);
Color niebieski = const Color.fromRGBO(5, 142, 217, 1);
Color czerwony = const Color.fromRGBO(183, 52, 52, 1);
Color zielony = const Color.fromRGBO(5, 217, 26, 1);
TextStyle tekst =  TextStyle(color: bialy);
TextStyle tekst2 =  TextStyle(color: szary);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(                                   //Bottom bar
              child: Container(
                alignment: Alignment.center,
                child: MainScreen(),
                color: szary,
            ),
          )
        ],
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final newWorkoutNameController = TextEditingController();

  void createNewWorkout(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      title: const Text("Create new workout"),
      content: TextField(
        controller: newWorkoutNameController,
      ),
      actions:[

        MaterialButton(
          onPressed:() {
            if(newWorkoutNameController.text.isNotEmpty){
                save();
              }
            else{
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No workout name!'),
                )
              );
            }
          },
          child: const Text("Save"),
          ),
        MaterialButton(
          onPressed: cancel,
          child: const Text("Cancel"),
          )
        ]
      )
    );
  }

  void removeWorkout(String workoutName){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      title: const Text("Remove workout?"),
      actions:[

        MaterialButton(
          onPressed: () {
            Provider.of<WorkoutData>(context, listen: false).removeWorkout(workoutName,);
            Navigator.pop(context);
          }, 
          child: const Text("Remove"),
          ),
        MaterialButton(
          onPressed: cancel,
          child: const Text("Cancel"),
          )
        ]
      )
    );
  }
  void save(){
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutNameController.text);

    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void cancel(){
    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void goToWorkoutPage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(workoutName: workoutName,), ));
  }

  void goToHomePage(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> MainScreen() ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        body: Center(
          child: Container(
            color: czarny,
            child: ListView.builder(
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => goToWorkoutPage(value.getWorkoutList()[index].name),
                child: Container(
                  child: ListTile(
                    title: Row(children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container() 
                          ),
                        Expanded(
                          flex: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: niebieski,
                                width: 2.0,
                                ),
                              borderRadius: BorderRadius.circular(5.0), 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      value.getWorkoutList()[index].name,
                                      style: tekst,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ) 
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(icon: Icon(Icons.delete), onPressed: (){removeWorkout(value.getWorkoutList()[index].name);}),
                        ),
                      ]
                    )
                  ),
                ),
              )
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: niebieski,
          onPressed: createNewWorkout,
          child: Icon(Icons.add, color: bialy,),
        ),
      ),
    );
  }
}