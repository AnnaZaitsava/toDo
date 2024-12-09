import UIKit

protocol EditTaskViewInputProtocol: AnyObject {
    func setupWithTask(_ task: TaskModel)
}

final class EditTaskViewController: UIViewController, EditTaskViewInputProtocol {
    var output: EditTaskOutputProtocol?
    
    private let titleTextView = UITextView()
    private let dateTextField = UITextField()
    private let descriptionTextView = UITextView()
    
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
    
    func setupWithTask(_ task: TaskModel) {
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .customYellow
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        setupTitleTextField()
        setupDateTextField()
        setupDescriptionTextView()
        loadTaskData(task)
    }
    
    private func setupTitleTextField() {
        titleTextView.font = UIFont.boldSystemFont(ofSize: 34)
        titleTextView.backgroundColor = .black
        titleTextView.textColor = .white
        titleTextView.isScrollEnabled = false
        titleTextView.textContainer.lineBreakMode = .byTruncatingTail
        titleTextView.textContainer.maximumNumberOfLines = 3
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextView)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
    }
    
    private func setupDateTextField() {
        dateTextField.font = UIFont.systemFont(ofSize: 12)
        dateTextField.textColor = .faidedWhite
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateTextField)
        
        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 5),
            dateTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.backgroundColor = .black
        descriptionTextView.textColor = .white
        descriptionTextView.autocorrectionType = .yes
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
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
