//
//  JsonParsing.swift
//  JsonParsing
//
//  Created by Auto on 8/13/23.
//

import SwiftUI

struct JsonParsingModel: Identifiable, Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
    
    //        init(from decoder: Decoder) throws {
    //            let container = try decoder.container(keyedBy:  CodingKeys.self)
    //            self.userId = try decode(Int.self, forKey: .userID)
    //            self.id = try decode(Int.self, forKey: .iD)
    //            self.title = try decode(String.self, forKey: .title)
    //            self.body = try decode(String.self, forKey: .body)
    //        }
    
}

class CodableViewModel: ObservableObject {
    @Published var jsonParsing: [JsonParsingModel] = []
    
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    self.jsonParsing = try JSONDecoder().decode([JsonParsingModel].self, from: data)
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }.resume()
    }
    
    //    func getJSONData() -> Data? {
    //        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return nil }
    //        guard let jsonData = try? Data(contentsOf: url) else { return nil }
    //        return jsonData
    //    }
}



struct JsonParsing: View {
    
    @StateObject var vm = CodableViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(vm.jsonParsing) { item in
                        VStack(alignment: .leading) {
                            Text("User ID: \(item.userId)") .bold()
                            Text("ID: \(item.id)") .bold()
                            Text("Title: \(item.title).") .padding(3)
                            Text("Body: \(item.body).") .padding(3)
                        }
                        .padding(20)
                    }
                }
                .navigationTitle("Json Parsing")
            }
        }
    }
}

struct JsonParsing_Previews: PreviewProvider {
    static var previews: some View {
        JsonParsing()
    }
}
