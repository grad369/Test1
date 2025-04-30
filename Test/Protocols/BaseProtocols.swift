//
//  BaseProtocol.swift
//  Test
//
//  Created by vaskov on 30.04.2025.
//

protocol BasePresentationLogic {
    func showAlert(type: AlertView.AlertType, text: String)
}

extension BasePresentationLogic {
    func showAlert(type: AlertView.AlertType, text: String) {
        AlertView.show(with: type, text: text)
    }
    
}
