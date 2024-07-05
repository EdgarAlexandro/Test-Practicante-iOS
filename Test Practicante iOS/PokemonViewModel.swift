//
//  PokemonViewModel.swift
//  Test Practicante iOS
//
//  Created by Edgar Alexandro Castillo Palacios on 05/07/24.
//

import Foundation

class PokemonViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    //Diccionario que almacena la informacion de los pokemon
    private var mainCache = [Int: Pokemon]()
    //Diccionario auxiliar que alamacena el id del pokemon (si este ya se almaceno en el diccionario anterior)
    private var cacheAux = [String: Int]()
    
    func fetchPokemon(nameOrId: String) {
        //Verifica si recibio un ID y busca el pokemon en el cache principal
        if let id = Int(nameOrId), let cachedPokemon = mainCache[id] {
            self.pokemon = cachedPokemon
            return
        }
        
        //En caso de que el valor recibido sea un nombre, busca en el cache auxiliar para determinar si el pokemon se encuentra almacenado en el cache principal
        if let id = cacheAux[nameOrId], let cachedPokemon = mainCache[id] {
            self.pokemon = cachedPokemon
            return
        }
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(nameOrId)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) {
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                    self.mainCache[pokemon.id] = pokemon
                    self.cacheAux[pokemon.name.lowercased()] = pokemon.id
                }
            }
            else {
                self.pokemon = nil
            }
        }
        .resume()
    }
}
