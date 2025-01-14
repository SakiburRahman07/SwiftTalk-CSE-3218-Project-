import Foundation

// Teacher model with additional fields
struct Teacher: Codable, Identifiable {
    let id = UUID()
    let name: String
    let extNo: String
    let contactNumber: String
    let email: String
}

// Lab model with additional fields
struct Lab: Codable, Identifiable {
    let id = UUID()
    let name: String
    let roomNumber: String
    let extNo: String
    let relatedPerson: String
}

// Parent model for all data
struct TeacherContactData: Codable {
    let teachers: [Teacher]
    let labs: [Lab]
}

// Extension for Bundle to decode data
extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}
