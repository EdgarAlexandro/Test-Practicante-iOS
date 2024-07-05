//
//  ContentView.swift
//  Test Practicante iOS
//
//  Created by Edgar Alexandro Castillo Palacios on 05/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PokemonViewModel()
    @State var pokemonName: String = ""
    @State var firstRun: Bool = true
    
    var body: some View {
        Text("Pokédex")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
        ScrollView{
            VStack(alignment: .leading) {
                Text("Búsqueda:")
                    .font(.headline)
                TextField("Nombre o ID del Pokémon", text: $pokemonName, onCommit: {
                    viewModel.fetchPokemon(nameOrId: pokemonName.lowercased())
                    firstRun = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            VStack {
                if let pokemon = viewModel.pokemon {
                    VStack {
                        Text(pokemon.name.capitalized)
                            .font(.title)
                            .fontWeight(.bold)
                        HStack{
                            //Previous button
                            Button(action: {
                                viewModel.fetchPokemon(nameOrId: String(Int(pokemon.id) - 1))
                                pokemonName = ""
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .foregroundColor(Int(pokemon.id) - 1 <= 0 ? Color.gray : Color.black)
                                    .frame(width: 20, height: 40)
                            }
                            .disabled(Int(pokemon.id) - 1 <= 0)
                            //Pokemon image
                            AsyncImage(url: URL(string: pokemon.sprites.front_default)) { image in
                                image.resizable()
                                    .frame(width: 300, height: 300)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 300, height: 300)
                            }
                            //Next button
                            Button(action: {
                                viewModel.fetchPokemon(nameOrId: String(Int(pokemon.id) + 1))
                                pokemonName = ""
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .foregroundColor(Int(pokemon.id) + 1 > 1025 ? Color.gray : Color.black)
                                    .frame(width: 20, height: 40)
                            }
                            .disabled(Int(pokemon.id) + 1 > 1025)
                        }
                        VStack{
                            Text("Información")
                                .font(.title2)
                                .padding()
                            Text("ID: \(pokemon.id)")
                            Text("Height: \(pokemon.height) dm")
                            Text("Weight: \(pokemon.weight) hg")
                        }
                        .font(.title3)
                        VStack{
                            Text("Estadísticas")
                                .font(.title2)
                                .padding()
                            ForEach(pokemon.stats, id: \.stat.name) { stat in
                                Text("\(stat.stat.name.capitalized): \(stat.base_stat)")
                            }
                        }
                        .font(.title3)
                    }
                }
                else if firstRun{
                    Text("Ingresa el nombre o el Pokédex ID de un pokémon para desplegar su información")
                        .padding()
                }
                else{
                    Text("Nombre o Pokédex ID incorrecto")
                        .foregroundColor(.red)
                    Text("Intenta nuevamente")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
