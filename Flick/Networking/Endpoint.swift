//
//  Endpoint.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {

    static func setupEndpointConfig() {

        // TODO: Add base networking URL to Keys
//        let baseURL = Keys.serverURL
        let baseURL = "example.example.com"

        #if LOCAL
            Endpoint.config.scheme = "http"
            Endpoint.config.port = 5000
        #else
            Endpoint.config.scheme = "http"
        #endif
        Endpoint.config.host = baseURL
        // TODO: Update common path
        Endpoint.config.commonPath = "/api/v1"

    }

}

