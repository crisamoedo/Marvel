//
//  ViewController.swift
//  SearchBarEjemplo
//
//  Created by Jorge Abalo Dieste on 26/11/23.
//
import UIKit
import CryptoKit

class Personaje {
    var name: String

    init(name: String) {
        self.name = name
    }
}

class TableViewViewController: UIViewController {
    
    var personajes: [Personaje] = []
    var personajesFiltrados: [Personaje] = []
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Definir los delegados de la tabla
        // Definir el delegado del searchBar
        searchBar.delegate = self
        tabla.delegate = self
        tabla.dataSource = self
        
        obtenerPersonajesDesdeAPI()
    }
    
    func obtenerPersonajesDesdeAPI() {
        // Claves de autenticación
        let publicKey = "4da961812496c30cf73ed692b494f315"
        let privateKey = "d7fc2827797d7e47f6417dca83b3beeb4c5607ee"
        
        // Timestamp
        let timestamp = String(Date().timeIntervalSince1970)
        
        // Construir el hash para la autenticación
        let hash = "hashInput".hashed(using: Insecure.MD5.self)
        print(hash)
        
        // URL de la API que proporciona los personajes
        let baseURL = "https://gateway.marvel.com:443/v1/public/characters"
        let limit = 20
        let apiKeyParam = "apikey=\(publicKey)"
        let timestampParam = "ts=\(timestamp)"
        let hashParam = "hash=\(hash)"
        let limitParam = "limit=\(limit)"
        
        let urlAPI = "\(baseURL)?\(apiKeyParam)&\(timestampParam)&\(hashParam)&\(limitParam)"
        
        guard let url = URL(string: urlAPI) else {
            print("URL no válida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let data = data {
                do {
                    // Decodificar los datos JSON
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = json["data"] as? [String: Any],
                       let results = data["results"] as? [[String: Any]] {
                        
                        for result in results {
                            if let name = result["name"] as? String {
                                let nuevoPersonaje = Personaje(name: name)
                                self.personajes.append(nuevoPersonaje)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tabla.reloadData()
                        }
                    }
                } catch let error as DecodingError {
                    // Manejar errores específicos de decodificación
                    switch error {
                    case .keyNotFound(let key, let context):
                        print("Error de decodificación: Clave no encontrada - \(key), Contexto: \(context)")
                    case .typeMismatch(let type, let context):
                        print("Error de decodificación: Tipo incorrecto - \(type), Contexto: \(context)")
                    case .valueNotFound(let value, let context):
                        print("Error de decodificación: Valor no encontrado - \(value), Contexto: \(context)")
                    default:
                        print("Error de decodificación: \(error)")
                    }
                } catch {
                    // Manejar otros errores
                    print("Error: \(error)")
                }
            }
        }.resume()
    }
}

// Extensión para calcular el hash MD5
extension String {
    func hashed(using algorithm: any HashFunction.Type) -> String {
        let inputData = Data(self.utf8)
        let hashedData = algorithm.hash(data: inputData)
        return hashedData.map { String(format: "%02hhx", $0) }.joined()
    }
}

// Métodos SearchBar
extension TableViewViewController: UISearchBarDelegate {
    // Identificar cuando el usuario empieza a escribir
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        personajesFiltrados = []
        
        if searchText == "" {
            personajesFiltrados = personajes
        } else {
            for personaje in personajes {
                if personaje.name.lowercased().contains(searchText.lowercased()) {
                    personajesFiltrados.append(personaje)
                }
            }
        }
        // Actualizar la tabla constantemente cuando se escriba el texto.
        self.tabla.reloadData()
    }
}

// Métodos UITableView
extension TableViewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personajesFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        celda.textLabel?.text = personajesFiltrados[indexPath.row].name
        
        return celda
    }
}
