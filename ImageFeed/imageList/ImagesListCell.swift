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
    
    static let reuseIdentifier = "ImagesListCell"
    
    private let gradientLayer = CAGradientLayer()//gradient
    private let gradientHeight: CGFloat = 30//gradient
    
    override func awakeFromNib() {//gradient
        super.awakeFromNib()
        setupGradient()
    }
    
    override func layoutSubviews() {//gradient
        super.layoutSubviews()
        gradientLayer.frame = CGRect(
            x: 0,
            y: contentView.bounds.height - gradientHeight,
            width: contentView.bounds.width,
            height: gradientHeight
        )
    }
    
    @IBAction func cellButton(_ sender: Any) {
    }
    
    private func setupGradient() {//gradient
        
        gradientLayer.colors = [
            UIColor(hex: "#1A1B22", alpha: 0.0).cgColor, // 0%
            UIColor(hex: "#1A1B22", alpha: 1.0).cgColor  // 100%
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
        
        // contentView.layer.addSublayer(gradientLayer)
        contentView.layer.insertSublayer(gradientLayer, at: 1)
    }
}

extension UIColor {//gradient
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255
        let g = CGFloat((rgb >> 8) & 0xFF) / 255
        let b = CGFloat(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
