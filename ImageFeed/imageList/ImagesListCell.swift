//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 8.01.26.
//

import UIKit
 
final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellDataLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellButtonImage: UIButton!
    @IBAction func cellButton(_ sender: Any) {
    }
    static let reuseIdentifier = "ImagesListCell"
}
