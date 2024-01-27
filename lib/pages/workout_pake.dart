import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:gym_up/data/workout_data.dart";
import "package:gym_up/pages/set_bar.dart";
import "package:provider/provider.dart";
import "main.dart";

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({super.key, required this.workoutName});

  void createNewExercise(){}

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}
class _WorkoutPageState extends State<WorkoutPage> {
  
  final newExerciseNameController = TextEditingController();

  void createNewExercise(String workoutName){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      title: const Text("Create new exercise"),
      content: TextField(
        controller: newExerciseNameController,
      ),
      actions:[

        MaterialButton(
          onPressed: () {if (newExerciseNameController.text.isNotEmpty){
            save(newExerciseNameController.text, workoutName);}
           else{
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No exercise name!'),
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
  void removeExercise(String workoutName, String exerciseName, int index){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      title: const Text("Remove exercise?"),
      actions:[

        MaterialButton(
          onPressed: () {
            Provider.of<WorkoutData>(context, listen: false).removeExercise(widget.workoutName, Provider.of<WorkoutData>(context, listen: false).getExerciseList(widget.workoutName)[index].name);
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
  final newSetWeight = TextEditingController();
  final newSetReps = TextEditingController();

  void createNewSet(String workoutName, String exerciseName){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      title: const Text("Create new set"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: newSetWeight,
              decoration: const InputDecoration(
                hintText: "Weight"
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
            ],
              ),
            TextField(
              controller: newSetReps,
              decoration: const InputDecoration(
                hintText: "Reps"
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
              )
          ]    
        ),
      ), 
      actions:[
        MaterialButton(
          onPressed: () {if (newSetWeight.text.isNotEmpty && newSetReps.text.isNotEmpty){
            saveSet(exerciseName, workoutName, newSetWeight.text, newSetReps.text);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No weight or reps!'),
                )
              );
            }
          },
          child: const Text("Save"),
          ),
        MaterialButton(
          onPressed: () {
            cancel();
          },
          child: const Text("Cancel"),
          )
        ]
      )
    );
  }
  void save(String exerciseName, String workoutName){
    Provider.of<WorkoutData>(context, listen: false).addExercise(workoutName, exerciseName);

    Navigator.pop(context);
    newExerciseNameController.clear();
  }
  void saveSet(String exerciseName, String workoutName, String weight, String reps){
    Provider.of<WorkoutData>(context, listen: false).addSet(workoutName, exerciseName, weight, reps);

    Navigator.pop(context);
    newSetReps.clear();
    newSetWeight.clear();
    
  }

  void cancel(){
    Navigator.pop(context);
    newExerciseNameController.clear();
    newSetReps.clear();
    newSetWeight.clear();
  }
  

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: czarny,
      appBar: AppBar(
        backgroundColor: szary,
        title: Text(widget.workoutName, style: tekst),
        ),
      body: ListView.builder(
        itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
        itemBuilder: (context, index) => ListTile(
          title: Row(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 12,
                child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: szary,
                    width: 2.0,
                    ),
                  borderRadius: BorderRadius.circular(5.0), 
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          value.getExerciseList(widget.workoutName)[index].name,
                          style: tekst
                          ),
                      ),
                      Row(                    
                        children: [
                            Expanded(child: Text("SET", style: tekst2, textAlign: TextAlign.center)),
                            Expanded(child: Text("KG", style: tekst2, textAlign: TextAlign.center)),
                            Expanded(child: Text("REP", style: tekst2, textAlign: TextAlign.center)),
                            Expanded(child: Text("DONE", style: tekst2, textAlign: TextAlign.center))
                      ],),  
                      Column(
                      children: value.getSetList(
                        widget.workoutName,
                        value.getExerciseList(widget.workoutName)[index].name
                          ).map((set) {
                        return SetWidget(
                          exerciseName: value.getExerciseList(widget.workoutName)[index].name,
                          workoutName: widget.workoutName,
                          id: set.id
                        );
                      }).toList(),
                    ),
                    Row(children: [
                    const Spacer(),
                     ElevatedButton(
                      onPressed: () {
                       createNewSet(widget.workoutName, value.getExerciseList(widget.workoutName)[index].name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: niebieski,
                        foregroundColor: bialy
                      ),
                      child: const Text("Add"),
                      
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        removeExercise(widget.workoutName, value.getExerciseList(widget.workoutName)[index].name, index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: czerwony,
                        foregroundColor: bialy
                      ),
                      child: const Text("Remove"),
                    ),
                    const Spacer(),
                    ],)
                    ],),
                    ),
                  )
                ),
              Expanded(flex: 1, child: Container()),
            ],
          ) ,          
        ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: niebieski,
          onPressed: () {createNewExercise(widget.workoutName);},
          child: Icon(Icons.add, color: bialy,),
        ),
        ),
      );
  }
}