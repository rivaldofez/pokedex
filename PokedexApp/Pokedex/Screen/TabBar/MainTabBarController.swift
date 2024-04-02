//
//  MainTabBarController.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import Common

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTabs()
    }
    
    private func setupTabs() {
        let homeRouter = HomeRouter.start()
        guard let homeVC = homeRouter.entry else { return }
        
        let homeNavItem = self.createNav(with: "title.pokemon".localized(bundle: commonBundle), and: UIImage(systemName: "list.bullet.below.rectangle"), vc: homeVC)
        
        let catchRouter = CatchedPokemonRouter.createCatched()
        guard let catchVC = catchRouter.entry else { return }
        
        let catchNavItem = self.createNav(with: "title.favorite".localized(bundle: commonBundle), and: UIImage(systemName: "heart"), vc: catchVC)
        
        self.setViewControllers([homeNavItem, catchNavItem], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }

}
