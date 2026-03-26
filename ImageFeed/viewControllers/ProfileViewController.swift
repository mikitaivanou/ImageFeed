//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 14.01.26.
//


import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    let labelName = UILabel()
    let labelPersonTag = UILabel()
    let labelGreeting = UILabel()
    let imageView = UIImageView()

    private var presenter: ProfilePresenterProtocol!

    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .ypBlack

        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true

        labelName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        labelName.textColor = .ypWhite
        labelName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelName)
        labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true

        labelPersonTag.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelPersonTag.textColor = .ypGray
        labelPersonTag.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelPersonTag)
        labelPersonTag.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelPersonTag.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true

        labelGreeting.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelGreeting.textColor = .ypWhite
        labelGreeting.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelGreeting)
        labelGreeting.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelGreeting.topAnchor.constraint(equalTo: labelPersonTag.bottomAnchor, constant: 8).isActive = true

        let exitImage = UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage()
        let button = UIButton.systemButton(
            with: exitImage,
            target: self,
            action: #selector(didTapButton)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }

    func displayProfile(name: String, login: String, bio: String) {
        labelName.text = name
        labelPersonTag.text = login
        labelGreeting.text = bio
    }

    func displayAvatar(url: URL) {
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(
                UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large)
            )

        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]
        )
    }

    func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Вы уверены что хотите выйти?",
            preferredStyle: .alert
        )

        let logoutAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            self?.presenter.didConfirmLogout()
        }

        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)

        alert.addAction(logoutAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }

        let splashVC = SplashViewController()
        window.rootViewController = splashVC
    }

    @objc
    func didTapButton() {
        presenter.didTapLogoutButton()
    }
}
