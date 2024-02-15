import Foundation

class ApiService {
    static let shared = ApiService()

    private init() {}

    func getEmailCount(jwt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let apiUrl = ApiEndpoints.baseURL + ApiEndpoints.emailCount

        guard let url = URL(string: apiUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let params: [String: Any] = [
            "merchant_phone_email_jwt": jwt,
            "source": "app"
        ]

        request.httpBody = params.percentEncoded()

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.emptyResponseData))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let emailCount = json["email_count"] as? String {
                    completion(.success(emailCount))
                } else {
                    completion(.failure(NetworkError.invalidResponseFormat))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

enum NetworkError: Error {
    case invalidURL
    case emptyResponseData
    case invalidResponseFormat
}
