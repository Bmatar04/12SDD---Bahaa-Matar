struct ExerciseDetailView: View {
    var exercise: String
    @Binding var exerciseIndex: Int
    @Binding var showExerciseDetail: Bool

    var body: some View {
        let exerciseImage = "\(exercise)\(exerciseIndex).jpeg"
        let exerciseVideo = "\(exercise)\(exerciseIndex).mp4"

        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if exerciseIndex <= 3 {
                    Image(exerciseImage)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .cornerRadius(10)
                        .padding()
                    
                    Text("Do You Confirm This Exercise?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Button(action: {
                            exerciseIndex += 1
                            if exerciseIndex > 3 {
                                exerciseIndex = 1
                            }
                        }) {
                            Text("No")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: ExerciseVideoView(videoName: exerciseVideo)) {
                            Text("Yes")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    Text("Please Pick One Of The 3 Exercises")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        exerciseIndex = 1
                    }) {
                        Text("Return to Exercises")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
