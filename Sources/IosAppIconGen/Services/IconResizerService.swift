import Foundation
import SwiftGD

protocol IconResizerServiceProtocol {
    func resizeIcons(from image: Image, for appIconType: AppIconType) async throws -> [AppIcon]
}

struct IconResizerService: IconResizerServiceProtocol {
    
    func resizeIcons(from image: Image, for appIconType: AppIconType) async throws -> [AppIcon] {
        let icons = appIconType.templateAppIcons
        let imageData = try image.export(as: .png)
        return try await withThrowingTaskGroup(of: AppIcon.self) { group in
            var results = [AppIcon]()
            for icon in icons {
                group.addTask {
                    try self.iconResizedData(from: imageData, appIcon: icon)
                }
            }
            for try await icon in group {
                results.append(icon)
            }
            return results
        }
    }

    private func iconResizedData(from imageData: Data, appIcon: AppIcon) throws -> AppIcon {
        let image = try Image(data: imageData)
        let size = CGSize(
            width: appIcon.point * appIcon.scale,
            height: appIcon.point * appIcon.scale
        )
        guard
            let resized = image.resizedTo(
                width: Int(size.width),
                height: Int(size.height)
            ),
            let data = try? resized.export(as: .png)
        else {
            throw NSError(
                domain: "IconResizer",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to generate icon data"]
            )
        }

        return AppIcon(
            idiom: appIcon.idiom,
            point: appIcon.point,
            scale: appIcon.scale,
            data: data,
            watchRole: appIcon.watchRole,
            watchSubtype: appIcon.watchSubtype
        )
    }
}