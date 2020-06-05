//
//  CollectionViewCell.swift
//  MovingCellCollectionView
//
//  Created by shishir  on 2/6/20.
//  Copyright © 2020 shishir . All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 9
        // Initialization code
    }

}
