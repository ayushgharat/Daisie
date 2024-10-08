import Foundation

struct SecondAPIRequestData: Codable {
    let user_input: String
    let chat_history: [[String: String]] // List of Human/AI message pairs
    let model_output_alz: String
    let model_output_park: String
}

class APIService {
    
    // Function to send JSON to an API endpoint
    static func postDataToAPI(jsonString: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://daisy-production.up.railway.app/process") else {
            print("Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion("Error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    completion(responseString)
                }
            }
        }.resume()
    }

    // Function to make the second API call
    static func postSecondAPIData(requestData: SecondAPIRequestData, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://daisy-production.up.railway.app/chat") else {
            print("Invalid second API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(requestData)
            print(jsonData)
            request.httpBody = jsonData
        } catch {
            DispatchQueue.main.async {
                completion("Error encoding request data: \(error.localizedDescription)")
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion("Error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    completion(responseString)
                }
            }
        }.resume()
    }
}
