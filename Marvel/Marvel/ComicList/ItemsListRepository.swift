//
//  ItemsListRepository.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 28/11/23.
//

import Foundation
import Combine



class ItemsListRepository {
    
//    struct Comic: Codable {
//        let id: Int
//        let title: String
//        
//        enum CodingKeys: String, CodingKey {
//            case id
//            case title
//        }
//    }
//    
//    func fetchMarvelComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
//        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
//        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
//        let baseURL = "https://gateway.marvel.com"
//        
//        // Construir la URL con las claves y otros parámetros
//        let timestamp = String(Date().timeIntervalSince1970)
//        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
//        let urlString = "\(baseURL)?apikey=\(publicKey)&ts=\(timestamp)&hash=\(hash)"
//        print("URL: \(urlString)")
//        
//        if let url = URL(string: urlString) {
//            // Crear y configurar la sesión de URLSession
//            let session = URLSession.shared
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    print("Error: \(error)")
//                    completion(.failure(error))
//                } else if let data = data {
//                    do {
//                        // Decodificar los datos de respuesta a un array de Comic
//                        let decoder = JSONDecoder()
//                        let comics = try decoder.decode([Comic].self, from: data)
//                        // Imprimir algunos datos de los cómics
//                        for comic in comics {
//                            print("Comic ID: \(comic.id), Title: \(comic.title)")
//                        }
//                        completion(.success(comics))
//                    } catch {
//                        print("Error decoding JSON: \(error)")
//                        completion(.failure(error))
//                    }
//                }
//            }
//            // Iniciar la tarea
//            task.resume()
//        } else {
//            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
//            print("Error: \(error)")
//            completion(.failure(error))
//        }
//    }
//    
//    //    // Ejemplo de uso
//    //    fetchMarvelComics { result in
//    //        switch result {
//    //        case .success(let comics):
//    //            // Procesar y mostrar los cómics en la interfaz de usuario
//    //            print("Número de cómics: \(comics.count)")
//    //        case .failure(let error):
//    //            print("Error: \(error)")
//    //        }
//    //    }
}
