import 'package:flutter/material.dart';
import 'package:gym_up/data/workout_data.dart';
import 'package:provider/provider.dart';
import "main.dart";
class SetWidget extends StatefulWidget {
  final String exerciseName;
  final String workoutName;
  final int id;
  const SetWidget({super.key, required this.exerciseName, required this.workoutName, required this.id});


  @override
  State<SetWidget> createState() => _SetWidgetState();
  
  
} 

class _SetWidgetState extends State<SetWidget> {
  
  Color kolor = szary;
  
  Color changeColor1(bool value){
    if (value){
      return zielony;
    }else{
      return szary;
    }
  }
  TextStyle changeColor2(bool value){
    if (value){
      return TextStyle(color: czerwony);
    }else{
      return TextStyle(color: zielony);
    }
  }
  
  void deleteSet(String workoutName, String exerciseName, int id){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      title: const Text("Remove Set?"),
      actions:[

        MaterialButton(
          onPressed: () {saveDelSet(workoutName, exerciseName, id);},
          child: const Text("Yes"),
          ),
        MaterialButton(
          onPressed: cancel,
          child: const Text("No"),
          )

      ]
      )
    );
  }
  void saveDelSet(String workoutName, String exerciseName, int id){
      Provider.of<WorkoutData>(context, listen: false).deleteSet(workoutName, exerciseName, id);

      Navigator.pop(context);
    }
    void saveSet(String workoutName, String exerciseName, int id){
      Provider.of<WorkoutData>(context, listen: false).deleteSet(workoutName, exerciseName, id);

      Navigator.pop(context);
    }

    void cancel(){
      Navigator.pop(context);
    }
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder:(context, value, child) => Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: changeColor1(value.getRelevantSet(widget.workoutName, widget.exerciseName, widget.id).isCompleted),
          width: 2.0,
          ),
        borderRadius: BorderRadius.circular(5.0), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: TextButton(onPressed: () {deleteSet(widget.workoutName, widget.exerciseName, widget.id);},child: Text(value.getRelevantSet(widget.workoutName, widget.exerciseName, widget.id).id.toString(), style: tekst2, textAlign: TextAlign.center))),
              const Text("|"),
              Expanded(child: Text(value.getRelevantSet(widget.workoutName, widget.exerciseName, widget.id).weight, style: tekst, textAlign: TextAlign.center)),
              const Text("X"),
              Expanded(child: Text(value.getRelevantSet(widget.workoutName, widget.exerciseName, widget.id).reps, style: tekst, textAlign: TextAlign.center)),
              const Text("|"),
              Expanded(child: TextButton(onPressed: () {
                value.checkOffSet(widget.workoutName, widget.exerciseName, widget.id);
              }, child: Text("X", style: changeColor2(value.getRelevantSet(widget.workoutName, widget.exerciseName, widget.id).isCompleted)),)),
            ]
          )
        )
      )
    ); 
  }
}