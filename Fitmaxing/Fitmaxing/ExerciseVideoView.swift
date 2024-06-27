struct ExerciseVideoView: View {
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
