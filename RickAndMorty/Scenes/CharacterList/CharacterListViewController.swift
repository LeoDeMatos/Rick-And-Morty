//
//  CharacterListViewController
//  RickAndMorty
//
//  Created by Leonardo de Matos on 29/06/19.
//  Copyright © 2019 Leonardo de Matos. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Combine

class CharacterListViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        let identifier = String(describing: CharacterTableViewCell.self)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var characters: [RickAndMortyCharacter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        constrain(view, tableView) { view, tableView in
            tableView.edges == view.edges
        }
        
        fetchAllCharacters()
    }
}

extension CharacterListViewController {
    func fetchAllCharacters() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let endpoint = RickAndMortyAPI.allCharacters
        let url = URL(string: endpoint.url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        let session = URLSession.shared.dataTaskPublisher(for: request)
        
        _ = session
            .tryMap { data, response in
                return data
            }
            .decode(type: RickAndMortyResponseWrapper<[RickAndMortyCharacter]>.self, decoder: jsonDecoder)
            .map { result in result.results }
            .receive(on: RunLoop.main)
            .sink { [weak self] characters in
                self?.characters = characters
                self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension CharacterListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self)) as! CharacterTableViewCell
        cell.configure(character: characters[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = CharacterViewController()
        viewController.character = characters[indexPath.row]
        present(viewController, animated: true, completion: nil)
    }
}
