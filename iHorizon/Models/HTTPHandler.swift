//
//  HTTPHandler.swift
//  MaglinoSwift
//
//  Created by ahmed.fouadgomaa on 3/28/18.
//  Copyright © 2018 ahmedfouad. All rights reserved.
//

import UIKit

class HTTPHandler: NSObject {
    func postWebserviceCall(parameters:NSMutableDictionary, completion: @escaping ( Any, Bool? , Error?)-> Void) -> Void{
        guard let url = URL(string:"http://www.maglino.com/postrequest/getResponse") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("99921d0a-3777-2025-a209-bbd7c19c4e66", forHTTPHeaderField: "postman-token")
        
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
//        [request addValue:@"99921d0a-3777-2025-a209-bbd7c19c4e66" forHTTPHeaderField:@"postman-token"];
        
        var jsonTodo: Data
        do{
            jsonTodo = try JSONSerialization.data(withJSONObject: parameters, options: [])
            if let json = String(data: jsonTodo, encoding: .utf8) {
                print("+ + + + + + + + + + \(json)")
                let jsonString:String = "data=\(json)"
                jsonTodo = jsonString.data(using: .utf8)!
            }
            request.httpBody = jsonTodo
            print(NSString(data: request.httpBody!, encoding:String.Encoding.utf8.rawValue)!)
        }catch{
            print("- - - - - - - \(error)")
        }
        
        //let session = URLSession.shared
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response{
                    print(response)
                }
                if let data = data{
                    do{
                        let myData = try JSONSerialization.jsonObject(with: data, options: [])
                        //below is string if interested
                        let responseString = String(data: data, encoding: String.Encoding.utf8)
                        completion(responseString! , true, nil)
                        print("- - - - - - - \(myData)")
                    }catch{
                        print("- - - - - - - \(error)")
                        completion(error, false, error)
                    }
                    
                }
            }
            
            
        }.resume()
    }
    
    func getWebServiceCall( urlString:String, completion: @escaping ( Any, Bool? , Error?)-> Void){
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let response = response{
                    print(response)
                }
                if let data = data{
                    do{
                        let myData = try JSONSerialization.jsonObject(with: data, options: [])
                        //below is string if interested
                        let responseString = String(data: data, encoding: String.Encoding.utf8)
                        completion(responseString! , true, nil)
                        print("- - - - - - - \(myData)")
                    }catch{
                        print("- - - - - - - \(error)")
                        completion(error, false, error)
                    }
                    
                }
            }
            }.resume()
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
