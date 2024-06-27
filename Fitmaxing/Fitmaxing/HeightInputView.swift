struct HeightInputView: View {
    @Binding var showWeightInput: Bool
    @Binding var height: Double
    @Binding var heightClass: String
    @State private var heightInput: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Enter Your Height in cm")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 60)

                TextField("Height", text: $heightInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(width: 200)
                
                Button(action: {
                    if let heightValue = Double(heightInput) {
                        height = heightValue / 100.0 // Convert to meters
                        if heightValue >= 182 {
                            heightClass = "Tall"
                        } else if heightValue >= 162 {
                            heightClass = "Neutral"
                        } else {
                            heightClass = "Short"
                        }
                        withAnimation {
                            showWeightInput = true
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
                    Alert(title: Text("Invalid Input"), message: Text("Please enter a valid height."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}
