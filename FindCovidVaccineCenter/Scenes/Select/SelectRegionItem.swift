//
//  SelectRegionItem.swift
//  FindCovidVaccineCenter
//
//  Created by UAPMobile on 2022/02/11.
//

import SwiftUI

struct SelectRegionItem: View {
    var region: Center.Sido
    var count: Int
    var body: some View {
        ZStack{
            Color(white: 0.9)
            VStack {
                Text(region.rawValue)
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.purple)
                Text("(\(count))")
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SelectRegionItem_Previews: PreviewProvider {
    static var previews: some View {
        let region0 = Center.Sido.경기도
        SelectRegionItem(region: region0, count: 3)
    }
}
