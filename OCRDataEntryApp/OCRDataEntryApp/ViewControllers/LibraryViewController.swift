////////
////////  LibraryViewController.swift
////////  OCRDataEntryApp
////////
////////  Created by Justin Janice on 4/11/21.
////////  Copyright © 2021 SparkBU. All rights reserved.
////////
//////
////
////struct Form: Decodable{ //codable or decodable for this
////    let docket: String
////    let number_of_counts: Int
////    let defen_name: String
////    let defen_adr: String
////    let defen_DOB: String
////    let court_name_adr: String
////    let complaint_issued_date: String
////    let offense_date: String
////    let arrest_date: String
////    let next_event_date: String
////    let next_event_type: String
////    let next_event_room_session: String
////    let offense_city: String
////    let offense_adr: String
////    let police_dept: String
////    let police_incident_num: String
////    let OBTN: String
////    let PCF_number: String
////    let defen_xref_id: String
////    let offense_codes: String
////    let raw_text: String
////    let cc_id: Int
////    let created_by: String
////    let updated_by: String
////    let created_at: Date
////    let updated_at: Date
////    let img_key: String
////    let aws_bucket: String
////}
//
//import UIKit
//import SwiftUI
//
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
//struct RecordsList2: View {
//    @State var records: [Post] = []
//    var body: some View {
//        ZStack{
//            List(records) { record in
//                VStack{
//                    Spacer()
////                            Text(record.defen_name).frame(alignment: .leading)
////                            Text(record.police_dept).frame(alignment: .leading)
//                    Text(record.title).frame(alignment: .leading)
//                    Text(record.body).frame(alignment: .leading)
//                }
//            }
//            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 80, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: .infinity, maxHeight: 700, alignment: .topLeading)
//            .onAppear {
//                Api2().getData() { (records) in
//                    self.records = records
//                }
//            }
//        }
//    }
//}
//
//
//struct RecordsList_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordsList2()
//    }
//}
//
//
