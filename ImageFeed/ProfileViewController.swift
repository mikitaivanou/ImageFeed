//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 14.01.26.
//
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    let labelName = UILabel()
    let labelPersonTag = UILabel()
    let labelGreeting = UILabel()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        if let profile = profileService.profile {
            updateProfileDetails(with: profile)
        }
        
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        
        
//        let imageView = UIImageView(image: UIImage(named: "userPick"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
//        let labelName = UILabel()
//        labelName.text = "Екатерина Новикова"
        labelName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        labelName.textColor = .ypWhite
        labelName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelName)
        labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
//       let labelPersonTag = UILabel()
//        labelPersonTag.text = " "
        labelPersonTag.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelPersonTag.textColor = .ypGray
        labelPersonTag.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelPersonTag)
        labelPersonTag.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelPersonTag.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
        
//      let labelGreeting = UILabel()
//        labelGreeting.text = "Hello, world!"
        labelGreeting.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelGreeting.textColor = .ypWhite
        labelGreeting.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelGreeting)
        labelGreeting.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelGreeting.topAnchor.constraint(equalTo: labelPersonTag.bottomAnchor, constant: 8).isActive = true
        
        var exitImage: UIImage {
            if let systemImage = UIImage(systemName: "ipad.and.arrow.forward") {
                return systemImage
            }
            guard let assetImage = UIImage(named: "exitButton") else {
                fatalError("Missing exitButton image")
            }
            return assetImage
        }
        let button = UIButton.systemButton(
            with: exitImage,
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
    
    private func updateProfileDetails(with profile: Profile) {
        labelName.text = profile.name.isEmpty
            ? "Имя не указано"
            : profile.name
        labelPersonTag.text = profile.loginName.isEmpty
            ? "@неизвестный_пользователь"
            : profile.loginName
        labelGreeting.text = (profile.bio?.isEmpty ?? true)
            ? "Профиль не заполнен"
            : profile.bio
    }

    
    private func updateAvatar() {
            guard
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let imageUrl = URL(string: profileImageURL)
            else { return }
        print("imageUrl: \(imageUrl)")

                let placeholderImage = UIImage(systemName: "person.circle.fill")?
                    .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
                    .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))

                let processor = RoundCornerImageProcessor(cornerRadius: 35) // Радиус для круга
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                    with: imageUrl,
                    placeholder: placeholderImage,
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale), // Учитываем масштаб экрана
                        .cacheOriginalImage, // Кэшируем оригинал
                        .forceRefresh // Игнорируем кэш, чтобы обновить
                    ]) { result in

                        switch result {
                            // Успешная загрузка
                        case .success(let value):
                            // Картинка
                            print(value.image)

                            // Откуда картинка загружена:
                            // - .none — из сети.
                            // - .memory — из кэша оперативной памяти.
                            // - .disk — из дискового кэша.
                            print(value.cacheType)

                            // Информация об источнике.
                            print(value.source)

                            // В случае ошибки
                        case .failure(let error):
                            print(error)
                        }
                    }

        }
    
    @objc
    private func didTapButton() {
        
    }
    
}
