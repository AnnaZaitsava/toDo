
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController = UINavigationController(rootViewController: ToDoListConfigurator().configure(coreDataManager: CoreDataManager(context: appDelegate.persistentContainer.viewContext)))
        window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

