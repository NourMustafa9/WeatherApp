//
//  HTTPRequestService.swift
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

import Foundation
import AFNetworking
class HTTPRequestService {
    
    func GET(url: String, complete: @escaping (Bool, Any?) -> ()) {
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, headers: nil, progress: .none) { sessionDataSuccess, anyObj in
complete(true, anyObj)
        } failure: { sessionDataFail, anyObj in

        }

    }
}
