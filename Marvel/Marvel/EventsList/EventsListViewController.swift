//
//  EventsListViewController.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//

import Foundation
import UIKit

class EventsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct MarvelResponse: Codable {
        let code: Int
        let status: String
        let data: MarvelData
    }
    
    struct MarvelData: Codable {
        let results: [Event]
    }
    
    struct Event: Codable {
        let title: String?
        let description: String?
    }
    var events: [Event] = []
    var viewModel: EventsListViewModel?
    
    func fetchMarvelEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
        let baseURL = "https://gateway.marvel.com/v1/public/events"
        
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
                        let events = marvelResponse.data.results
                        
                        // Actualizar la interfaz de usuario en el hilo principal
                        DispatchQueue.main.async {
                            completion(.success(events))
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
    func updateUI(with events: [Event]) {
        self.events = events
        DispatchQueue.main.async {
            self.eventsTable.reloadData()
        }
    }
    
    @IBOutlet weak var eventsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarvelEvents { result in
            switch result {
            case .success(let events):
                // Procesa los cómics y actualiza la interfaz de usuario
                self.updateUI(with: events)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        eventsTable.dataSource = self
        eventsTable.delegate = self
        eventsTable.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTable.dequeueReusableCell(withIdentifier: "eventCell" , for : indexPath)
        let events = events[indexPath.row]
        cell.textLabel?.text = events.title
        cell.detailTextLabel?.text = events.description
        cell.imageView?.image = UIImage(systemName: "av.remote")
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "vistaDeDetalle", sender: self)
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "vistaEvent" {
    //            if let indexPath = tableView.indexPathForSelectedRow,
    //               let destinationVC = segue.destination as? EventsViewController {
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
