//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Leonardo de Matos on 29/06/19.
//  Copyright © 2019 Leonardo de Matos. All rights reserved.
//

import UIKit
import Cartography
import Combine

class CharacterViewController: UIViewController {
    
    let characterIdentifier = String(describing: CharacterTableViewCell.self)
    let episodeIdentifier = String(describing: EpisodeTableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
    
        tableView.register(UINib(nibName: characterIdentifier, bundle: nil), forCellReuseIdentifier: characterIdentifier)

        tableView.register(UINib(nibName: episodeIdentifier, bundle: nil), forCellReuseIdentifier: episodeIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    var episodes: [Episode] = []
    var character: RickAndMortyCharacter?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = character?.name
        view.addSubview(tableView)
        constrain(view, tableView) { view, tableView in
            tableView.edges == view.edges
        }
        
        fetchAllEpisodes()
    }
    
    private func fetchAllEpisodes() {
        let unsafeIds = character?.episode?.compactMap { item -> Int? in
            let startOfId = item.lastIndex(of: "/")!
            let string = item.suffix(from: startOfId).replacingOccurrences(of: "/", with: "")
            return Int("\(string)")
        }
        
        guard let ids = unsafeIds else { return }
        
        let requests = ids.compactMap { id in
            return createEpisodeRequest(from: id)
        }
        _ = Publishers.MergeMany(requests)
            .compactMap { $0 as? Episode}
            .sink { [weak self] episode in
                self?.episodes.append(episode)
                self?.tableView.insertRows(at: [[1, (self?.episodes.count ?? 0) - 1]], with: .right)
            }
    }

    private func createEpisodeRequest(from id: Int) -> some Publisher {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let endpoint = RickAndMortyAPI.episode(id: id)
        let url = URL(string: endpoint.url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        let session = URLSession.shared.dataTaskPublisher(for: request)
        
        return session
            .tryMap { data, response in
                return data
            }
            .decode(type: Episode.self, decoder: jsonDecoder)
            .receive(on: RunLoop.main)
    }
}

// MARK: - UITableViewDelegate
extension CharacterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableViewDataSource
extension CharacterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return episodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: characterIdentifier, for: indexPath)
            
            guard let c = cell as? CharacterTableViewCell,
                let character = character else { return UITableViewCell() }
            
            c.configure(character: character)
            
            return c
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: episodeIdentifier, for: indexPath)
            
            guard let c = cell as? EpisodeTableViewCell else { return UITableViewCell() }
                
            c.configure(episode: episodes[indexPath.row ])
            
            return c
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            let label = UILabel()
            label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width, height: 40)
            label.text = "Appears in"
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.textColor = .label
            label.backgroundColor = .systemBackground
            
            view.addSubview(label)
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
}
