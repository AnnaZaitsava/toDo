
import UIKit

protocol EditTaskDelegate: AnyObject {
    func didEditTask(_ task: TaskModel)
}

final class EditTaskConfigurator {
    func configure(task: TaskModel, delegate: EditTaskDelegate) -> UIViewController {
        let view = EditTaskViewController()
        let presenter = EditTaskPresenter(task: task)
        
        view.output = presenter
        presenter.view = view
        presenter.delegate = delegate
        
        return view
    }
}
