//
//  TabBarController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 17/11/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarItem()
        setupTabs()

    }
    
    private func configureTabBarItem() {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = .black
 
            let stacked = tabBarAppearance.stackedLayoutAppearance
            stacked.selected.iconColor = .white
            stacked.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            stacked.normal.iconColor = .lightGray
            stacked.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]

            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance

            tabBar.tintColor = .white
        }
    

        private func setupTabs() {
            
            let homeVc = createNavigationController(
                with: "Home",
                and: UIImage(systemName: "photo.stack.fill"),
                vc: HomeViewController()
            )
            
            let searchVc = createNavigationController(
                with: "Search",
                and: UIImage(systemName: "magnifyingglass"),
                vc: SearchViewController()
            )
            
            let favVc = createNavigationController(
                with: "Favorites",
                and: UIImage(systemName: "heart.fill"),
                vc: FavoriteViewController()
            )
            
            let profileVc = createNavigationController(
                with: "Profile",
                and: UIImage(systemName: "person.crop.circle"),
                vc: ProfileViewController()
            )
            
            setViewControllers([homeVc, searchVc, favVc, profileVc], animated: true)
        }

   
    
    private func createNavigationController(
        with title: String,
        and image: UIImage?,
        vc: UIViewController) -> UINavigationController {
        let nc = UINavigationController(rootViewController: vc)
            nc.tabBarItem.title = title
            nc.tabBarItem.image = image
            return nc
    }
    


}
