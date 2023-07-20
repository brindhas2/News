//
//  RSError.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import Foundation
struct RSError: Codable {
    let status: String?
    let code: String?
    let message: String?
}

struct ErrorDetail {
    var errorCode: String? = "1000"
    var title: String? =  "Error"
    var message: String? = "We are unable to process your request at this time. Please try again later."
}
