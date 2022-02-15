//
//  CenterDetailView.swift
//  FindCovidVaccineCenter
//
//  Created by UAPMobile on 2022/02/15.
//

import SwiftUI
import MapKit

struct CenterDetailView: View {
    var center: Center
    var body: some View {
        VStack {
            MapView(coordination: center.coordinate)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            CenterRow(center: center)
        }
        .navigationTitle(center.facilityName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CenterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let center0 = Center(id: 0, sido: .경기도, facilityName: "실내빙상장 앞", address: "경기도 뫄뫄시 뫄뫄구", lat: "37.404476", lng: "126.9491998", centerType: .central, phoneNumber: "010-0000-0000")
        CenterDetailView(center: center0)
    }
}
