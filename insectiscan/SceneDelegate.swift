// SceneDelegate.swift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Set global animation speed for a smoother feel
        UIView.appearance().layer.speed = 1.5
        
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = MainTabBarController()
        
        // Add subtle fade-in animation for initial load
        tabBarController.view.alpha = 0
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        UIView.animate(withDuration: 0.3) {
            tabBarController.view.alpha = 1
        }
    }
}
