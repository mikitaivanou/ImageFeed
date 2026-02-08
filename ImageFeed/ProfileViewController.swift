//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 14.01.26.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageView = UIImageView(image: UIImage(named: "userPick"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let labelName = UILabel()
        labelName.text = "Екатерина Новикова"
        labelName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        labelName.textColor = .ypWhite
        labelName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelName)
        labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        let labelPersonTag = UILabel()
        labelPersonTag.text = "@ekaterina_nov"
        labelPersonTag.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelPersonTag.textColor = .ypGray
        labelPersonTag.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelPersonTag)
        labelPersonTag.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelPersonTag.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
        
        let labelGreeting = UILabel()
        labelGreeting.text = "Hello, world!"
        labelGreeting.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelGreeting.textColor = .ypWhite
        labelGreeting.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelGreeting)
        labelGreeting.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelGreeting.topAnchor.constraint(equalTo: labelPersonTag.bottomAnchor, constant: 8).isActive = true
        
        
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        
    }
    
}
