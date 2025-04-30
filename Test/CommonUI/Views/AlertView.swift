

import UIKit
import SnapKit


class AlertView: UIView {
    enum AlertType {
        case success, warning
    }
    
    private let type: AlertType
    private let text: String
    private var complete: (() -> Void)?
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = text
        label.textColor = type.textColor
        return label
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.backgroundColor = type.backgroundColor
        view.layer.borderColor = type.borderColor.cgColor
        return view
    }()
    
    private init(type: AlertType,
         text: String,
         complete: (() -> Void)?) {
        self.type = type
        self.text = text
        self.complete = complete
        
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func show(with type: AlertType,
                    text: String,
                    complete: (() -> Void)? = nil) {
        let view = AlertView(type: type, text: text, complete: complete)
        view.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(Configure.showAlertTime * 1000))) {
            view.hide()
        }
    }
    
    private func configureUI() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        backgroundView.addSubview(messageLabel)
        window.addSubview(backgroundView)
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalTo(window.snp.centerX)
            make.top.equalTo(window.snp.top).offset(25)
        }
        
        backgroundView.layoutIfNeeded()
        backgroundView.transform = CGAffineTransform(translationX: 0, y: -backgroundView.bounds.height - 20)
    }
    
    private func show() {
        //backgroundView.transform = CGAffineTransform(translationX: 0, y: -backgroundView.bounds.height)
        //backgroundView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.transform = .identity
            self.backgroundView.layoutIfNeeded()
        }
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -self.backgroundView.bounds.height - 20)
            self.backgroundView.layoutIfNeeded()
        } completion: { _ in
            self.backgroundView.removeFromSuperview()
            self.complete?()
        }
    }
}


fileprivate extension AlertView.AlertType {
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return .gray1
        case .warning:
            return .red1
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .success:
            return .purple1
        case .warning:
            return .gray1
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .success:
            return .text
        case .warning:
            return .white
        }
    }
}
