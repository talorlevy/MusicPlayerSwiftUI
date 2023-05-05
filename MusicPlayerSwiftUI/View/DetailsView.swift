//
//  DetailsView.swift
//  MusicPlayerSwiftUI
//
//  Created by Talor Levy on 3/25/23.
//

import SwiftUI
import AVFoundation


struct DetailsView: View {
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var currentTime: TimeInterval = 0
    @State var isPlaying: Bool = false
    
    var result: ResultModel?
    
    var body: some View {
        VStack(spacing: 50) {
            if let result = result, let price = result.trackPrice,
               let releaseDate = result.releaseDate, let url = URL(string: result.artworkUrl100 ?? "") {
                AsyncImage(url: url)
                    .frame(width: 100, height: 100)
                Text(result.trackName ?? "")
                    .font(.system(size: 28, weight: .bold))
                Text(result.artistName ?? "")
                HStack {
                    Text(Formatting.formatDate(dateString: releaseDate) ?? "")
                    Spacer()
                    Text("Price: $\(String(format: "%.2f", price))")
                }
                Slider(value: Binding(
                    get: { self.currentTime },
                    set: { newValue in
                        self.currentTime = newValue
                        self.audioPlayer?.currentTime = newValue
                    }
                ), in: 0...(audioPlayer?.duration ?? 0))
                HStack {
                    Button(action: {
                        playOrPauseAudio()
                    }, label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color.black)
                    })
                    Spacer()
                    Button(action: {
                        stopAudio()
                    }, label: {
                        Image(systemName: "stop")
                            .font(.system(size: 32))
                            .foregroundColor(Color.black)
                    })
                }
                .padding(.top, 10)
                .padding(.horizontal, 50)
                .padding(.bottom, 20)
            }
        }
        .padding()
        .onAppear {
            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                guard let player = audioPlayer else { return }
                currentTime = player.currentTime
            }
            loadAudio()
        }
    }
    
    func loadAudio() {
        guard let url = URL(string: result?.previewUrl ?? "") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error loading audio file: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(data: data)
            } catch {
                print("Error creating audio player: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    func playOrPauseAudio() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            audioPlayer?.play()
            isPlaying = true
        }
    }

    func stopAudio() {
        isPlaying = false
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        currentTime = 0
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(result: ResultModel(trackId: 1, artistName: "Tracy Chapman", trackName: "Fast Car", releaseDate: "July 3, 2022", trackPrice: 1.99))
    }
}
