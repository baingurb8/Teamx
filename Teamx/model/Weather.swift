//
//  Weather.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-29.
//

import Foundation

struct Weather: Decodable {
    let cityName: String
    let country: String
    let tempC: Double
    let feelsLikeC: Double
    let windKph: Double
    let windDir: String
    let humidity: Int
    let uv: Double
    let visKm: Double
    let condition: String

    enum CodingKeys: String, CodingKey {
        case location
        case current

        enum LocationKeys: String, CodingKey {
            case name
            case country
        }

        enum CurrentKeys: String, CodingKey {
            case tempC = "temp_c"
            case feelsLikeC = "feelslike_c"
            case windKph = "wind_kph"
            case windDir = "wind_dir"
            case humidity
            case uv
            case visKm = "vis_km"
            case condition

            enum ConditionKeys: String, CodingKey {
                case text
            }
        }
    }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let locationContainer = try container.nestedContainer(keyedBy: CodingKeys.LocationKeys.self, forKey: .location)
        let currentContainer = try container.nestedContainer(keyedBy: CodingKeys.CurrentKeys.self, forKey: .current)

        cityName = try locationContainer.decode(String.self, forKey: .name)
        country = try locationContainer.decode(String.self, forKey: .country)
        tempC = try currentContainer.decode(Double.self, forKey: .tempC)
        feelsLikeC = try currentContainer.decode(Double.self, forKey: .feelsLikeC)
        windKph = try currentContainer.decode(Double.self, forKey: .windKph)
        windDir = try currentContainer.decode(String.self, forKey: .windDir)
        humidity = try currentContainer.decode(Int.self, forKey: .humidity)
        uv = try currentContainer.decode(Double.self, forKey: .uv)
        visKm = try currentContainer.decode(Double.self, forKey: .visKm)

        let conditionContainer = try currentContainer.nestedContainer(keyedBy: CodingKeys.CurrentKeys.ConditionKeys.self, forKey: .condition)
        condition = try conditionContainer.decode(String.self, forKey: .text)
    }
}

