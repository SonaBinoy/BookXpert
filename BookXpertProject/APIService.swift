//
//  APIService.swift
//  BookXpertProject
//
//  Created by sona on 17/05/25.
//




import Foundation

class APIManager {
    static let shared = APIManager()
    let urlString = "https://api.restful-api.dev/objects"
    
    func fetchData(completion: @escaping ([ItemModel]?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        print("🌐 Sending API request to: \(url)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response")
                completion(nil)
                return
            }

            print("📡 HTTP status code: \(httpResponse.statusCode)")

            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }

            do {
                let decoded = try JSONDecoder().decode([ItemModel].self, from: data)
                print("✅ Decoded \(decoded.count) items from API")
                completion(decoded)
            } catch {
                print("❌ JSON decoding failed: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🔎 Raw JSON:\n\(jsonString)")
                }
                completion(nil)
            }

        }.resume()
    }


//    func fetchData(completion: @escaping ([ItemModel]?) -> Void) {
//        guard let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else {
//                completion(nil)
//                return
//            }
//            let decoded = try? JSONDecoder().decode([ItemModel].self, from: data)
//            completion(decoded)
//        }.resume()
//    }
}

// ItemModel.swift

struct ItemModel: Codable {
    let id: String
    let name: String
    let data: [String: CodableValue]?
}
struct CodableValue: Codable, CustomStringConvertible {
    var value: Any

    var description: String {
        return String(describing: value)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else {
            value = "Unknown"
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let v = value as? Int {
            try container.encode(v)
        } else if let v = value as? Double {
            try container.encode(v)
        } else if let v = value as? Bool {
            try container.encode(v)
        } else if let v = value as? String {
            try container.encode(v)
        } else {
            try container.encodeNil()
        }
    }
}
