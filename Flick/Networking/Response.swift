//
//  Response.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import FutureNova

struct Response<T: Codable>: Codable {

    var data: T
    var success: Bool

}
