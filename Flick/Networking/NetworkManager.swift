//
//  NetworkManager.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import FutureNova

class NetworkManager {

    static let shared: NetworkManager = NetworkManager()

    private let networking: Networking = URLSession.shared.request

    private init() {}

    // TODO: Add Network Routes

}
