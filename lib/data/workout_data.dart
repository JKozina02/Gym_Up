import "package:flutter/material.dart";
import "package:gym_up/models/exercise.dart";

import "../models/workout.dart";
import "../models/set.dart";

class WorkoutData extends ChangeNotifier{

  List <Workout> workoutList = [
    Workout(name: "Workout", exercises: [
      Exercise(name: "Exercise", sets: [
        Set(
          id: 1,
          weight: "10",
          reps: "10",
          isCompleted: false,
        )
      ])
    ])
    
  ];

  // get list of workouts
  List<Workout> getWorkoutList(){
  return workoutList;
  }

  List<Exercise> getExerciseList(workoutName){
  Workout relevantWorkout = getRelevantWorkout(workoutName);
  return relevantWorkout.exercises;
  }

  List<Set> getSetList(workoutName, exerciseName){
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    return relevantExercise.sets;
  }

  //add a workout
  void addWorkout(String name){
    workoutList.add(Workout(name: name, exercises: [
      Exercise(name: "Sample", sets: [])
    ]));

    notifyListeners();
  }
  void removeWorkout(String workoutName){

    Workout relevantWorkout = getRelevantWorkout(workoutName);
    workoutList.remove(relevantWorkout);

    notifyListeners();
  }
 
  
  //add an exercise
  void addExercise(String workoutName, String exerciseName){

    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(Exercise(
      name: exerciseName, 
      sets: [], 
      ));
    
    notifyListeners();
  }
  void removeExercise(String workoutName, String exerciseName){

    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.removeWhere((exercise) => exercise.name == exerciseName);

    notifyListeners();
  }
  void addSet(String workoutName, String exerciseName, String weight, String reps){

    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.sets.add(Set(
      id: (relevantExercise.sets.length + 1),
      weight: weight,
      reps: reps,
      isCompleted: false,
      ));

      notifyListeners();
  }

  void deleteSet(String workoutName, String exerciseName, int idToDelete){

    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.sets.removeAt(relevantExercise.sets.indexWhere((set) => set.id == idToDelete));
    for (int i = idToDelete; i <= relevantExercise.sets.length; i++) {
      relevantExercise.sets[i-1].id = i;}
      notifyListeners();

  }

  //checkoff exercise
  void checkOffSet(String workoutName, String exerciseName, int setId){
    Set relevantSet = getRelevantSet(workoutName, exerciseName, setId);

    relevantSet.isCompleted = !relevantSet.isCompleted;

    notifyListeners();
  }

  //return len of workout
  int numberOfExercisesInWorkout(String workoutName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  int numberOfSetsInExercise(String workoutName, String exerciseName){
    Exercise relevantExercise = getRelevantExercise(workoutName,exerciseName);

    return relevantExercise.sets.length;
  }
  //return workout object by name
  Workout getRelevantWorkout(String workoutName){
    Workout relevantWorkout = workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }
  //return exercise by workout and exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    Exercise relevantExercise = relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  //return set 
  Set getRelevantSet(String workoutName, String exerciseName, int setId){
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    
    Set relevantSet = relevantExercise.sets.firstWhere((set) => set.id == setId);
    return relevantSet;
  }
}







