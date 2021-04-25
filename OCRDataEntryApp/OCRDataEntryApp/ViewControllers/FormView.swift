//
//  RecordsList.swift
//  OCRDataEntryApp
//
//  Created by Jana Mikaela Aguilar on 4/12/21.
//  Copyright © 2021 SparkBU. All rights reserved.
//

import UIKit
import SwiftUI

//struct Post: Codable, Identifiable {
//    let id = UUID()
//    var title: String
//    var body: String
//
//}
//
//class Api2 {
//    func getData(completion: @escaping ([Post]) -> ()) {
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            let records = try! JSONDecoder().decode([Post].self, from: data!)
//            DispatchQueue.main.async {
//                completion(records)
//            }
//        }
//        .resume()
//    }
//
//}
//struct FormView: View {
//    @State var records: [Post] = []
//    var body: some View {
//        List(records) { record in
//            VStack{
//                Spacer()
////                            Text(record.defen_name).frame(alignment: .leading)
////                            Text(record.police_dept).frame(alignment: .leading)
//                Text(record.title).frame(alignment: .leading)
//                Text(record.body).frame(alignment: .leading)
//            }
//        }
////            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 80, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: .infinity, maxHeight: 700, alignment: .topLeading)
//        .onAppear {
//            Api2().getData() { (records) in
//                self.records = records
//            }
//        }
//    }
//}


struct Form: Codable, Identifiable {
    let id = UUID()
    var docket: String?
    var number_of_counts: Int?
    var defen_name: String?
    var defen_adr: String?
    var defen_DOB: String?
    var court_name_adr: String?
    var complaint_issued_date: String?
    var offense_date: String?
    var arrest_date: String?
    var next_event_date: String?
    var next_event_type: String?
    var next_event_room_session: String?
    var offense_city: String?
    var offense_adr: String?
    var police_dept: String?
    var police_incident_num: String?
    var OBTN: String?
    var PCF_number: String?
    var defen_xref_id: String?
    var offense_codes: String?
    var raw_text: String?
    var cc_id: Int?
    var created_by: String?
    var updated_by: String?
    var created_at: String?
    var updated_at: String?
    var img_key: String?
    var aws_bucket: String?
}

//struct Form: Codable
//{
//    var returnedForms: form
//
//    init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//        returnedForms = try container.decode(form.self)
//    }
//}


class Api2 {
    func getData(completion: @escaping ([Form]) -> ()) {
        struct RetrieveCcfAPI2 {
            let baseURL: URL
            let token: String
            let type: String

            init(baseURL: String, token: String, type: String) {
                let resourceString = "http://\(baseURL)/api/"

                guard let resourceURL = URL(string: resourceString) else {fatalError()}

                self.baseURL = resourceURL
                self.token = token
                self.type = type
            }
        }
        guard let token = UserDefaults.standard.string(forKey: "tokenValue"), let type = UserDefaults.standard.string(forKey: "tokenType") else {return}
        print("PASSED")
        let apiCall = RetrieveCcfAPI2(baseURL: Config.baseURL, token: token, type: type)
        let myUrl = apiCall.baseURL.appendingPathComponent("v1/records/ccf")
        let request = NSMutableURLRequest(url:myUrl)

        request.httpMethod = "GET";

        let boundary = generateBoundaryString()

        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            print("Entered")
//            print(response)
//            print(data)
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let decoder = JSONDecoder()
//            let records = try! decoder.decode([Form].self, from: data!)
//            print(records)
            let rec = try! JSONDecoder().decode([Form].self, from: data!)
                DispatchQueue.main.async {
                    completion(rec)
                }
        }
        .resume()
        }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
//
struct FormView: View {
    @State var records: [Form] = []
    var body: some View {
        List(records) { record in
            VStack{
                let name: String? = record.defen_name
                let date: String? = record.offense_date
                let id: Int? = record.cc_id
                if name != nil {
                    Text("Defendant: " + name!)

                }
                if date != nil {
                    Text("Offense Date: " + date!)
                }
                if id != nil {
                    Text("CC Id: " + "\(id!)")
                }
            }
        }
//            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 80, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: .infinity, maxHeight: 700, alignment: .topLeading)
        .onAppear {
            Api2().getData() { (records) in
                self.records = records
            }
        }
    }
}

//struct FormView_Previews: PreviewProvider {
//    static var previews: some View {
////        FormView()
//    }
//}

