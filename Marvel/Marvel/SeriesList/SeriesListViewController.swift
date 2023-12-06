//
//  SeriesListViewController.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//

import Foundation
import UIKit

class SeriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct MarvelResponse: Codable {
        let code: Int
        let status: String
        let data: MarvelData
    }
    
    struct MarvelData: Codable {
        let results: [Series]
    }
    
    struct Series: Codable {
        let title: String?
        let description: String?
    }
    var series: [Series] = []
    var viewModel: SeriesListViewModel?
    
    func fetchMarvelSeries(completion: @escaping (Result<[Series], Error>) -> Void) {
        let publicKey = "91876cd71efdc7d4d08056257a5dd7bf"
        let privateKey = "4b31ba5c27608c34ec0d47763e976f32001d59e6"
        let baseURL = "https://gateway.marvel.com/v1/public/series"
        
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
                        let series = marvelResponse.data.results
                        
                        // Actualizar la interfaz de usuario en el hilo principal
                        DispatchQueue.main.async {
                            completion(.success(series))
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
    func updateUI(with series: [Series]) {
        self.series = series
        DispatchQueue.main.async {
            self.seriesTable.reloadData()
        }
    }
    
    @IBOutlet weak var seriesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarvelSeries { result in
            switch result {
            case .success(let series):
                // Procesa los cómics y actualiza la interfaz de usuario
                self.updateUI(with: series)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        seriesTable.dataSource = self
        seriesTable.delegate = self
        seriesTable.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = seriesTable.dequeueReusableCell(withIdentifier: "serieCell" , for : indexPath)
        let series = series[indexPath.row]
        cell.textLabel?.text = series.title
        cell.detailTextLabel?.text = series.description
        cell.imageView?.image = UIImage(systemName: "film.circle.fill")
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "vistaDeDetalle", sender: self)
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "vistaSerie" {
    //            if let indexPath = tableView.indexPathForSelectedRow,
    //               let destinationVC = segue.destination as? SeriesViewController {
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
