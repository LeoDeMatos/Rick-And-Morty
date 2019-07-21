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
        applyGradientCircle()
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        titleLabel.textColor = .label
    }
    
    private func applyGradientCircle() {
        let cornerRadius = iconImageView.frame.width / 2
        iconImageView.layer.cornerRadius = cornerRadius
        iconImageView.layer.masksToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: iconImageView.frame.size)
        gradient.colors = [UIColor.rmMediumGreen.cgColor,
                           UIColor.rmLightGreen.cgColor,
                           UIColor.rmDarkGreen.cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 7
        shape.path = UIBezierPath(roundedRect: iconImageView.bounds,
                                  cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        iconImageView.layer.addSublayer(gradient)
    }
}
