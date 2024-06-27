struct WeightInputView: View {
    @Binding var height: Double
    @Binding var heightClass: String
    @Binding var weightClass: String
    @Binding var possibleExercises: [String]
    @Binding var navigateToExercises: Bool
    @State private var weightInput: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Enter Your Weight in kg")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 60)

                TextField("Weight", text: $weightInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(width: 200)
                
                Button(action: {
                    if let weightValue = Double(weightInput) {
                        let bmi = weightValue / (height * height)
                        if bmi <= 18.5 {
                            weightClass = "Underweight"
                        } else if bmi >= 25 {
                            weightClass = "Overweight"
                        } else {
                            weightClass = "Neutral"
                        }
                        determinePossibleExercises()
                        withAnimation {
                            navigateToExercises = true
                        }
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text("Please enter a valid weight."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }

    private func determinePossibleExercises() {
        if weightClass == "Overweight" {
            possibleExercises = ["Weight Loss", "Work Fullbody", "Work Core", "Work Stamina", "Increase Muscle", "Build Lower Body", "Build Upper Body"]
            if heightClass == "Short" {
                possibleExercises.removeAll(where: { $0 == "Increase Muscle" || $0 == "Build Lower Body" || $0 == "Build Upper Body" })
            }
        } else if weightClass == "Underweight" {
            possibleExercises = ["Muscle Mass Increase", "Work Fullbody", "Work Core", "Work Stamina", "Build Lower Body", "Build Upper Body"]
        } else {
            possibleExercises = ["Weight Loss", "Work Fullbody", "Work Core", "Work Stamina", "Increase Muscle", "Build Lower Body", "Build Upper Body"]
        }
    }
}
