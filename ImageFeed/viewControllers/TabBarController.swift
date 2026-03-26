//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 08/03/2026.
//

import UIKit
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

                guard let imagesListViewController = storyboard.instantiateViewController(
                    withIdentifier: "ImagesListViewController"
                ) as? ImagesListViewController else {
                    assertionFailure("Не удалось создать ImagesListViewController")
                    return
                }

                let imagesListPresenter = ImagesListPresenter()
                imagesListViewController.configure(imagesListPresenter)
                imagesListViewController.tabBarItem = UITabBarItem(
                    title: "",
                    image: UIImage(named: "tab_editorial_active"),
                    selectedImage: nil
                )

                let profileViewController = ProfileViewController()
                let profilePresenter = ProfilePresenter()
                profileViewController.configure(profilePresenter)
                profileViewController.tabBarItem = UITabBarItem(
                    title: "",
                    image: UIImage(named: "tab_profile_active"),
                    selectedImage: nil
                )

                self.viewControllers = [imagesListViewController, profileViewController]
            }
        }
