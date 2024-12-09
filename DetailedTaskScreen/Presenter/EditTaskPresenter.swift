import UIKit

protocol EditTaskOutputProtocol {
    func viewDidLoad()
    func didFinishEditingTask(_ title: String, _ desc: String, _ dateString: String)
}

final class EditTaskPresenter: EditTaskOutputProtocol {
    weak var view: EditTaskViewInputProtocol?
    weak var delegate: EditTaskDelegate?
    
    private var task: TaskModel
    
    init(task: TaskModel) {
        self.task = task
    }
    
    func viewDidLoad() {
        view?.setupWithTask(task)
    }
    
    func didFinishEditingTask(_ title: String, _ desc: String, _ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormat
        guard let date = dateFormatter.date(from: dateString) else { return }
        
        task.todo = title
        task.desc = desc
        task.date = date
        delegate?.didEditTask(task)
    }
}
