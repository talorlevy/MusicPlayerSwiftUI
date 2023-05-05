//
//  ContentView.swift
//  MusicPlayerSwiftUI
//
//  Created by Talor Levy on 3/25/23.
//

import SwiftUI


struct ListView: View {
    
    @ObservedObject var viewModel = ListViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Music")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.leading, 20)
                    .padding(.top, 20)
                
                List(viewModel.results, id: \.trackId) { result in
                    NavigationLink(destination: DetailsView(result: result)) {
                        HStack {
                            if let url = URL(string: result.artworkUrl100 ?? "") {
                                AsyncImage(url: url)
                            }
                            Spacer().frame(width: 20)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(result.trackName ?? "")
                                    .font(.system(size: 20, weight: .bold))
                                Text(result.artistName ?? "")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchResults()
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
