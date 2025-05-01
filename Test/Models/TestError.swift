//
//  TestError.swift
//  Test
//
//  Created by vaskov on 29.04.2025.
//

import Foundation


enum TestError: Error {
    case wrongUrl, allDownload, badServer, badParser
    
    var text: String {
        switch self {
        case .wrongUrl:
            return "Your url is bad"
        case .allDownload:
            return "All items have already downnload"
        case .badServer:
            return "Server has sent a error"
        case .badParser:
            return "Your parser is bad"
        }
    }
    
    static func text(from error: Error) -> String {
        guard let testError = error as? TestError else {
            return error.localizedDescription
        }
        return testError.text
    }
}
