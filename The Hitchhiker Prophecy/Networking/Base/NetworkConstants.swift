//
//  NetworkConstants.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation
import CryptoKit

enum NetworkConstants {
    static let baseUrl = "https://gateway.marvel.com"
    static let publicKey = "147353bbff44e7d29bc31db2a76f1d85" // TODO: Add your marvel keys
    static let privateKey = "4b67ce8e0b310afd394aab4102a711ebb257ad4e" // TODO: Add your marvel keys
}

extension NetworkConstants {
    static func apiHash(ts: String) -> String {
        let digest = Insecure.MD5.hash(data: "\(ts)\(self.privateKey)\(self.publicKey)".data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
