//import Foundation
//
//
//
//struct JsonObject: Codable {
//    // Define your JSON structure here
//    // For example, if your JSON looks like {"key": "value"},
//    // you can define properties like this:
//    let key: String
//}
//
//
//protocol ApiInterface {
//    func getEmailCount(jwt: String, source: String, completion: @escaping (Result<JsonObject, Error>) -> Void)
//}
//
//struct RetrofitHelper {
//    static var apiService: ApiInterface {
//        return RetroInstance.getRetroInstance().create(ApiInterface.self)
//    }
//}
//
//class RetroInstance {
//    static func getRetroInstance() -> URLSession {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 100
//        configuration.timeoutIntervalForResource = 100
//
//        return URLSession(configuration: configuration)
//    }
//}
//
//extension ApiInterface {
//    func getEmailCount(jwt: String, source: String, completion: @escaping (Result<JsonObject, Error>) -> Void) {
//        guard let url = URL(string: AppConstants.BASE_URL + "email-count") else {
//            // Handle invalid URL
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        var bodyComponents = URLComponents()
//        bodyComponents.queryItems = [
//            URLQueryItem(name: "merchant_phone_email_jwt", value: jwt),
//            URLQueryItem(name: "source", value: source)
//        ]
//        request.httpBody = bodyComponents.percentEncodedQuery?.data(using: .utf8)
//
//        let task = RetroInstance.getRetroInstance().dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print(error.localizedDescription)
//               // completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                // Handle empty response data
//                return
//            }
//
//            do {
//                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//                print(jsonObject)
//                // Assuming `JsonObject` is a type you've defined for your JSON response
//                //completion(.success(jsonObject as! JsonObject))
//            } catch {
//                print(error)
//               // completion(.failure(error))
//            }
//        }
//
//        task.resume()
//    }
//}
