//
//  ContentView.swift
//  MakeMeLaugh
//
//  Created by Greg Alton on 6/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var joke: String = "Click the button to get a Chuck Norris joke!"
    
    var body: some View {
        VStack {
            // Chuck Norris Image
            Image("chetNorris")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            
            Spacer()
            
            // Joke Text
            Text(joke)
                .padding()
                .multilineTextAlignment(.center)
                .font(.title)
            Spacer()
            // Button to fetch a new joke
            Button(action: {
                fetchJoke { newJoke in
                    joke = newJoke
                }
            }) {
                Text("Make me laugh!")
                    .padding()
                    .foregroundColor(.white)
            }
            .background(.green)
            .cornerRadius(10)
            .padding(.bottom, 20)
        }
        .padding()
        .onAppear {
            fetchJoke { newJoke in
                joke = newJoke
            }
        }
    }
    
    func fetchJoke(completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.chucknorris.io/jokes/random") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data) {
                    DispatchQueue.main.async {
                        completion(decodedResponse.value)
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        
        task.resume()
    }
}

struct Joke: Codable {
    let value: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
