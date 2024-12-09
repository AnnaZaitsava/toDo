import UIKit
import SnapKit

protocol EditTaskViewInputProtocol: AnyObject {
    func setupWithTaskData(_ task: TaskModel)
}

final class EditTaskViewController: UIViewController, EditTaskViewInputProtocol {
    var output: EditTaskOutputProtocol?
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 34)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.maximumNumberOfLines = 3
        return textView
    }()
    
    private let dateTextField = UITextField()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.autocorrectionType = .yes
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let title = titleTextView.text,
              let desc = descriptionTextView.text,
              let dateString = dateTextField.text else { return }
        output?.didFinishEditingTask(title, desc, dateString)
    }
    
    func setupWithTaskData(_ task: TaskModel) {
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .customYellow
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        addSubviews()
        setupConstraints()

        setupDateTextField()
        loadTaskData(task)
    }
    
    private func setupDateTextField() {
        dateTextField.font = UIFont.systemFont(ofSize: 12)
        dateTextField.textColor = .faidedWhite
    }
    
    private func loadTaskData(_ task: TaskModel) {
        titleTextView.text = task.todo
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormat
        let formattedDate = dateFormatter.string(from: task.date ?? Date())
        dateTextField.text = formattedDate
        descriptionTextView.text = task.desc
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UI

private extension EditTaskViewController {
    
    func addSubviews() {
        
        [titleTextView, dateTextField, descriptionTextView].forEach(view.addSubview)
    }
    
    func setupConstraints() {
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.left.right.equalToSuperview().inset(15)
        }
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(5)
            make.left.right.equalTo(titleTextView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}
