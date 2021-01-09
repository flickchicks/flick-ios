//
//  Keys.swift
//  Flick
//
//  Created by Lucy Xu on 1/9/21.
//  Copyright © 2021 flick. All rights reserved.
//

import Foundation

struct Keys {

    static let serverURL = Keys.keyDict["SERVER_URL"] as? String ?? ""

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

}

