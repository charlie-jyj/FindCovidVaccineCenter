//
//  CenterAPIResponse.swift
//  FindCovidVaccineCenter
//
//  Created by UAPMobile on 2022/02/11.
//

import Foundation

struct CenterAPIResponse: Decodable {
    let data: [Center]
}
