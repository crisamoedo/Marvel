//
//  HistoriesViewController.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//

import Foundation
import UIKit

class StoriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct MarvelResponse: Codable {
        let code: Int
        let status: String
        let data: MarvelData
    }
    
    struct MarvelData: Codable {
        let results: [Story]
    }
    
    struct Story: Codable {
        let title: String?
        let description: String?
    }
    var stories: [Story] = []
    var viewModel: StoriesListViewModel?
    
    func fetchMarvelStories(completion: @escaping (Result<[Story], Error>) -> Void) {
        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
        let baseURL = "https://gateway.marvel.com/v1/public/stories"
        
        // Construir la URL con las claves y otros parámetros
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        let urlString = "\(baseURL)?apikey=\(publicKey)&ts=\(timestamp)&hash=\(hash)"
        print("URL: \(urlString)")
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        // Decodificar la respuesta como un objeto MarvelResponse
                        let decoder = JSONDecoder()
                        let marvelResponse = try decoder.decode(MarvelResponse.self, from: data)
                        
                        // Verificar si la respuesta fue exitosa (código 200)
                        guard marvelResponse.code == 200 else {
                            let error = NSError(domain: "Marvel API Error", code: marvelResponse.code, userInfo: nil)
                            print("Marvel API Error: \(error)")
                            completion(.failure(error))
                            return
                        }
                        
                        // Acceder a la matriz de cómics dentro de la respuesta
                        let stories = marvelResponse.data.results
                        
                        // Actualizar la interfaz de usuario en el hilo principal
                        DispatchQueue.main.async {
                            completion(.success(stories))
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            }
            // Iniciar la tarea
            task.resume()
        } else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            print("Error: \(error)")
            completion(.failure(error))
        }
    }
    func updateUI(with stories: [Story]) {
        self.stories = stories
        DispatchQueue.main.async {
            self.storiesTable.reloadData()
        }
    }
    
    @IBOutlet weak var storiesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarvelStories { result in
            switch result {
            case .success(let stories):
                // Procesa los cómics y actualiza la interfaz de usuario
                self.updateUI(with: stories)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        storiesTable.dataSource = self
        storiesTable.delegate = self
        storiesTable.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storiesTable.dequeueReusableCell(withIdentifier: "storieCell" , for : indexPath)
        let story = stories[indexPath.row]
        cell.textLabel?.text = story.title
        cell.detailTextLabel?.text = story.description
        cell.imageView?.image = UIImage(systemName: "pencil.line")
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "vistaDeDetalle", sender: self)
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "vistaStories" {
    //            if let indexPath = tableView.indexPathForSelectedRow,
    //               let destinationVC = segue.destination as? StoriesViewController {
    //             // AQUÍ PASAMOS LOS DATOS QUE QUEREMOS A LA OTRA VISTA
    //                destinationVC.dato = datos[indexPath.row]
    //            }
    //        }
    //        if segue.identifier == "vistaAuthor" {
    //            if let indexPath = tableView.indexPathForSelectedRow,
    //               let destinationVC = segue.destination as? AuthorViewController {
    //             // AQUÍ PASAMOS LOS DATOS QUE QUEREMOS A LA OTRA VISTA
    //                destinationVC.dato = datos[indexPath.row]
    //            }
    //        }
    //    }
    
}
