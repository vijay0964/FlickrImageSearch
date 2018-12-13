//
//  SearchCell.swift
//  FlickrImageSearch
//
//  Created by VJ on 12/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
