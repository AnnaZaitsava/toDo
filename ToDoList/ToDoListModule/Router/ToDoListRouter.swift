protocol ToDoListRouterInputProtocol {
    func presentTaskDetail(_ task: TaskModel, _ delegate: EditTaskDelegate)
    func presentShareSheet(items: [String])
}

import UIKit

final class ToDoListRouter: ToDoListRouterInputProtocol {
    weak var entry: UIViewController?
    
    func presentTaskDetail(_ task: TaskModel, _ delegate: EditTaskDelegate) {
        let editVC = EditTaskConfigurator().configure(task: task, delegate: delegate)
        entry?.navigationItem.backButtonTitle = LocalizedData.back
        entry?.navigationController?.pushViewController(editVC, animated: true)
    }

    func presentShareSheet(items: [String]) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = entry?.view
        entry?.present(activityViewController, animated: true, completion: nil)
    }
}
