//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Leonardo de Matos on 29/06/19.
//  Copyright © 2019 Leonardo de Matos. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        UIView.animate(withDuration: 0.3) { [weak self] in
            if selected {
                self?.setSelected(false, animated: true)
            }
        }
    }
    
    func configure(character: RickAndMortyCharacter) {
        titleLabel.text = character.name
        subtitleLabel.text = character.species + " from " + character.origin.name
        
        if let url = URL(string: character.image) {
            iconImageView.kf.setImage(with: url)
        }
    }
}
