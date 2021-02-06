//
//  Keys.swift
//  Flick
//
//  Created by Lucy Xu on 1/9/21.
//  Copyright © 2021 flick. All rights reserved.
//

import Foundation

struct Keys {

    static let devServerURL = Keys.keyDict["PROD_SERVER_URL"] as? String ?? ""
    static let prodServerURL = Keys.keyDict["PROD_SERVER_URL"] as? String ?? ""

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

}

