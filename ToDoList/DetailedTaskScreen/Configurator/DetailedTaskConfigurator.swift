
import UIKit

protocol DetailedTaskDelegate: AnyObject {
    func didEditTask(_ task: TaskModel)
}

final class DetailedTaskConfigurator {
    func configure(task: TaskModel, delegate: DetailedTaskDelegate) -> UIViewController {
        let view = DetailedTaskViewController()
        let presenter = DetailedTaskPresenter(task: task)
        
        view.output = presenter
        presenter.view = view
        presenter.delegate = delegate
        
        return view
    }
}
