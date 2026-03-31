//
//  PKAPIParameterEncoding.swift
//  Pick记账
//
//  Created by Dev on 2023/6/12.
//

import Alamofire

struct PKAPIParameterEncoding: ParameterEncoding {
    static let `default` = PKAPIParameterEncoding()
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let params = parameters, !params.isEmpty else {
            return request
        }

        let paramsData = try JSONSerialization.data(withJSONObject: params, options: [])
        guard let paramsString = String(data: paramsData, encoding: .utf8) else {
            return request
        }

        guard let encrytString = PKAPICryptor.encrypt(string: paramsString), !encrytString.isEmpty else {
            return request
        }
        
        if !encrytString.isEmpty {
            request.setValue("multipart/form-data;boundary=mm_form_data_boundry", forHTTPHeaderField: "Content-Type")
        }

        let dataString = "--mm_form_data_boundry\r\nContent-Disposition:form-data;name=\"data\"\r\n\r\n\(encrytString)\r\n--mm_form_data_boundry--"
        
        request.httpBody = dataString.data(using: .utf8)

        return request
    }
}

