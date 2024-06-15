//
//  MovieModel.swift
//  ARshortframemovie
//
//  Created by kaito on 2024/06/13.
//

import Foundation
import UIKit

struct MovieModel: Identifiable, Codable {
    var id = UUID()
    var Title: String
    var Coma: [UIImage?]
    
    enum CodingKeys: String, CodingKey {
        case id
        case Title
        case Coma
    }
    
    init(id: UUID = UUID(), Title: String, Coma: [UIImage?]) {
        self.id = id
        self.Title = Title
        self.Coma = Coma
    }
    
    // カスタムエンコーダ
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(Title, forKey: .Title)
        let imageDataArray = Coma.map { $0?.jpegData(compressionQuality: 1.0) }
        try container.encode(imageDataArray, forKey: .Coma)
    }
    
    // カスタムデコーダ
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        Title = try container.decode(String.self, forKey: .Title)
        let imageDataArray = try container.decode([Data?].self, forKey: .Coma)
        Coma = imageDataArray.map { $0.flatMap { UIImage(data: $0) } }
    }
}
