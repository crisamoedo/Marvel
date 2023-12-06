//
//  CharactersListViewController.swift
//  Marvel
//
//  Created by Jorge Abalo Dieste on 4/12/23.
//
import UIKit

class CharactersListViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var Characters = ["Iron-Man", "Capitan America", "Hulk", "Thor", "Black Widow", "Vision", "Wanda", "Spider-man", "Ojo de Halcon", "Venom", "Loki", "Capitana Marvel", "Groot", "Star Lord", "Gamora", "Rocket", "Drax", "Wolverine", "Ms.Marvel"]
    
    var filteredCharacters: [String]!
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }
    
    func setupTableView() {
        // Crear una instancia de UITableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        filteredCharacters = Characters
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = filteredCharacters[indexPath.row]
        return cell
    }
}

extension CharactersListViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCharacters = []
        if searchText.isEmpty {
            filteredCharacters = Characters
        } else {
            for character in Characters {
                if character.lowercased().contains(searchText.lowercased()) {
                    filteredCharacters.append(character)
                }
            }
        }
        tableView.reloadData()
    }
}

