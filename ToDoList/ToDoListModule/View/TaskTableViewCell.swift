import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func didToggleTaskCompletion(at cell: TaskTableViewCell)
}

final class TaskTableViewCell: UITableViewCell {
    weak var delegate: TaskTableViewCellDelegate?
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let checkmark = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .black
        setupCheckmark()
        setupTitleLabel()
        setupDescriptionLabel()
        setupDateLabel()
        addCheckmarkTapGesture()
    }
    
    private func setupCheckmark() {
        checkmark.layer.cornerRadius = 12
        checkmark.layer.borderWidth = 1
        checkmark.layer.borderColor = UIColor.gray.cgColor
        
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkmark)
        
        NSLayoutConstraint.activate([
            checkmark.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkmark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkmark.widthAnchor.constraint(equalToConstant: 25),
            checkmark.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: checkmark.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: checkmark.centerYAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 2
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])
    }
    
    private func setupDateLabel() {
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCheckmarkTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCheckmarkTap))
        checkmark.addGestureRecognizer(tapGesture)
        checkmark.isUserInteractionEnabled = true
    }
    
    @objc private func handleCheckmarkTap() {
        delegate?.didToggleTaskCompletion(at: self)
    }
    
    func configure(with task: TaskModel) {
        let attributedString = NSAttributedString(
            string: task.todo,
            attributes: [
                .strikethroughStyle: task.completed ? NSUnderlineStyle.single.rawValue : 0,
                .foregroundColor: task.completed ? UIColor.lightGray : UIColor.white
            ]
        )
        titleLabel.attributedText = attributedString
        
        descriptionLabel.text = task.desc
        descriptionLabel.textColor = task.completed ? .lightGray : .white
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormat
        let formattedDate = dateFormatter.string(from: task.date ?? Date())
        dateLabel.text = formattedDate
        
        updateCheckmark(isCompleted: task.completed)
    }
    
    private func updateCheckmark(isCompleted: Bool) {
        checkmark.layer.sublayers?.removeAll()
        
        if isCompleted {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 6, y: 12))
            path.addLine(to: CGPoint(x: 11, y: 18))
            path.addLine(to: CGPoint(x: 20, y: 8))

            let checkmarkLayer = CAShapeLayer()
            checkmarkLayer.path = path.cgPath
            checkmarkLayer.strokeColor = UIColor.customYellow.cgColor
            checkmarkLayer.lineWidth = 1
            checkmarkLayer.fillColor = UIColor.clear.cgColor
            checkmarkLayer.lineCap = .round
            checkmarkLayer.lineJoin = .round

            checkmark.layer.addSublayer(checkmarkLayer)
            checkmark.layer.borderWidth = 1
            checkmark.layer.borderColor = UIColor.customYellow.cgColor
        }
        else {
            checkmark.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
