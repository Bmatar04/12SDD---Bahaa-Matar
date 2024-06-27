struct ExerciseListView: View {
    var exercises: [String]
    @Binding var navigateToHeightInput: Bool
    @Binding var showWeightInput: Bool
    @Binding var selectedExercise: String
    @Binding var showExerciseDetail: Bool
    @Binding var exerciseIndex: Int

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            navigateToHeightInput = true
                            showWeightInput = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                            Text("Back")
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 16)

                Text("Pick A Fitness Goal")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                ForEach(exercises, id: \.self) { exercise in
                    Button(action: {
                        selectedExercise = exercise
                        exerciseIndex = 1
                        showExerciseDetail = true
                    }) {
                        VStack {
                            Image(systemName: "photo") // Placeholder image
                                .resizable()
                                .frame(width: 100, height: 100)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding()

                            Text(exercise)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
