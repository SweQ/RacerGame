//
//  SelectCarCollectionViewCell.swift
//  RacingGameApp
//
//  Created by alexKoro on 8/15/21.
//

import UIKit

class SelectCarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFit
    }
}
