// MainTabBa// MainTabBarController.swift
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBarAppearance()
        
        // Optimize tab switching performance
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupViewControllers() {
        // Camera tab
        let cameraViewController = CameraViewController()
        let cameraNav = UINavigationController(rootViewController: cameraViewController)
        cameraNav.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 0)
        
        // Map tab
        let mapViewController = MapViewController()
        let mapNav = UINavigationController(rootViewController: mapViewController)
        mapNav.tabBarItem = UITabBarItem(title: "World Map", image: UIImage(systemName: "map"), tag: 1)
        
        // Account tab (replacing Support tab)
        let accountViewController = AccountViewController()
        let accountNav = UINavigationController(rootViewController: accountViewController)
        accountNav.tabBarItem = UITabBarItem(title: "My Profile", image: UIImage(systemName: "person"), tag: 2)
        
        viewControllers = [cameraNav, mapNav, accountNav]
    }
    
    private func setupTabBarAppearance() {
        // Set tab bar colors
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // Selected item appearance
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)]
        
        // Normal item appearance
        appearance.stackedLayoutAppearance.normal.iconColor = .darkGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    // Add tab selection animation
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Add subtle bounce animation to the selected tab
        guard let idx = tabBar.items?.firstIndex(of: item),
              let tabBarItemView = tabBar.subviews[idx + 1].subviews.first else {
            return
        }
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.2, 0.9, 1.0]
        bounceAnimation.duration = 0.3
        bounceAnimation.calculationMode = .cubic
        
        tabBarItemView.layer.add(bounceAnimation, forKey: nil)
    }
}
