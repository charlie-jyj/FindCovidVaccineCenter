//
//  CenterRow.swift
//  FindCovidVaccineCenter
//
//  Created by UAPMobile on 2022/02/15.
//

import SwiftUI

struct CenterRow: View {
    var center: Center
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text(center.facilityName)
                    .font(.headline)
                Text(center.centerType.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            Text(center.address)
                .font(.footnote)
            
            if let url = URL(string: "tel:" + center.phoneNumber) {
                Link(center.phoneNumber, destination: url)  // hyperLink처럼 url 삽입
            }
        }
        .padding()
    }
}

struct CenterRow_Previews: PreviewProvider {
    static var previews: some View {
        let center0 = Center(id: 0, sido: .경기도, facilityName: "수지구청 앞", address: "경기도 용인시 수지구", lat: "37.404476", lng: "126.9491998", centerType: .central, phoneNumber: "010-0000-0000")
        CenterRow(center: center0)
    }
}
