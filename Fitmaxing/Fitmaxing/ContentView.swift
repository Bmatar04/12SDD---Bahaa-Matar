import SwiftUI
import AVKit

struct ContentView: View {
    // State variables
    @State private var logoOpacity: Double = 0.0
    @State private var showHeightInput: Bool = false
    @State private var showWeightInput: Bool = false
    @State private var height: Double = 0.0
    @State private var heightClass: String = ""
    @State private var weightClass: String = ""
    @State private var possibleExercises: [String] = []
    @State private var navigateToExercises: Bool = false
    @State private var selectedExercise: String = ""
    @State private var showExerciseDetail: Bool = false
    @State private var exerciseIndex: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                // Initial screen with logo animation
                if showWeightInput {
                    WeightInputView(height: $height, heightClass: $heightClass, weightClass: $weightClass, possibleExercises: $possibleExercises, navigateToExercises: $navigateToExercises)
                        .transition(.opacity)
                } else if showHeightInput {
                    HeightInputView(showWeightInput: $showWeightInput, height: $height, heightClass: $heightClass)
                        .transition(.opacity)
                } else {
                    // Logo animation
                    LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        .edgesIgnoringSafeArea(.all)

                    Image("FMLogo")
                        .resizable()
                        .frame(width: 200, height: 160)
                        .opacity(logoOpacity)
                        .onAppear {
                            // Logo fade-in animation
                            withAnimation(.easeIn(duration: 2)) {
                                logoOpacity = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 2)) {
                                    logoOpacity = 0.0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    // Transition to height input screen
                                    withAnimation {
                                        showHeightInput = true
                                    }
                                }
                            }
                        }
                }

                // Navigation links for exercises
                NavigationLink(destination: ExerciseListView(exercises: possibleExercises, navigateToHeightInput: $showHeightInput, showWeightInput: $showWeightInput, selectedExercise: $selectedExercise, showExerciseDetail: $showExerciseDetail, exerciseIndex: $exerciseIndex), isActive: $navigateToExercises) {
                    EmptyView()
                }

                NavigationLink(destination: ExerciseDetailView(exercise: selectedExercise, exerciseIndex: $exerciseIndex, showExerciseDetail: $showExerciseDetail), isActive: $showExerciseDetail) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HeightInputView: View {
    // State and bindings for height input
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
                // Height input UI
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
                    // Validate height input
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

struct WeightInputView: View {
    // State and bindings for weight input
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
                // Weight input UI
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
                    // Validate weight input
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

    // Function to determine possible exercises based on weight class
    private func determinePossibleExercises() {
        if weightClass == "Overweight" {
            possibleExercises = ["Weightloss", "Fullbody", "Core", "Stamina", "Muscle", "Lowerbody", "Upperbody"]
            if heightClass == "Short" {
                possibleExercises.removeAll(where: { $0 == "Muscle" || $0 == "Lowerbody" || $0 == "Upperbody" })
            }
        } else if weightClass == "Underweight" {
            possibleExercises = ["Muscle", "Fullbody", "Core", "Stamina", "Lowerbody", "Upperbody"]
        } else {
            possibleExercises = ["Weightloss", "Fullbody", "Core", "Stamina", "Muscle", "Lowerbody", "Upperbody"]
        }
    }
}

struct ExerciseListView: View {
    // List of exercises view
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
                // Header and exercise selection UI
                HStack { // Back button handling
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
                
                ScrollView {
                    // Grid of exercise options
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(exercises.indices, id: \.self) { index in
                            VStack {
                                Image("image\(index + 1)") // Placeholder image names from image1 to image8
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                
                                Button(action: {
                                    selectedExercise = exercises[index]
                                    exerciseIndex = 1 // This starts with the first exercise for the selected goal
                                    showExerciseDetail = true
                                }) {
                                    Text(exercises[index])
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ExerciseDetailView: View {
    // Exercise detail view
    var exercise: String
    @Binding var exerciseIndex: Int
    @Binding var showExerciseDetail: Bool

    var body: some View {
        let exerciseImage = "\(exercise)\(exerciseIndex).jpeg" // Corrected image name format
        let exerciseVideo = "\(exercise)\(exerciseIndex).mp4" // Corrected video name format

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
                        
                        Button(action: {
                            showExerciseDetail = false
                        }) {
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

struct ExerciseVideoView: View {
    // Video player view
    var videoName: String

    var body: some View {
        VStack {
            VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: videoName, withExtension: "mp4")!))
                .frame(height: 400)
            
            Text(videoName)
                .font(.largeTitle)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
