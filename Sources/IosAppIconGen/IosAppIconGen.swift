// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftGD
import ArgumentParser
import Foundation

@main
struct IosAppIconGen: AsyncParsableCommand {

    @Argument(help: "Input image file path")
    var inputImagePath: String

    @Argument(help: "Path to export")
    var exportPath: String

    @Flag(help: "Passing this flag will override all other flags")
    var all = false

    @Flag(help: "Generate iPhone and iPad icons in single folder")
    var ios = false

    @Flag(name: .customLong("iphone"), help: "Generate iPhone icons")
    var iphone = false

    @Flag(name: .customLong("ipad"), help: "Generate iPad icons")
    var ipad = false

    @Flag(help: "Generate macOS icons")
    var mac = false

    @Flag(help: "Generate watchOS icons")
    var watch = false
        
    func run() async throws {
        
        let location = URL(fileURLWithPath: inputImagePath)
        guard let image = Image(url: location) else {
            fatalError("Failed to initialize image. Give a valid input image path")
        }

        do{
            
            var appIconType = [AppIconType]()
            if all {
                appIconType = [ .iPhoneAndiPad, .mac, .appleWatch]
            }
            else{
                if ios {
                    appIconType.append(.iPhoneAndiPad)
                    }
                else if iphone{
                    appIconType.append(.iphone)
                }
                else if ipad{
                    appIconType.append(.ipad)
                }
                if mac{
                    appIconType.append(.mac)
                }
                if watch{
                    appIconType.append(.appleWatch)
                }
            }

            if appIconType.count == 0{
                appIconType = [ .iPhoneAndiPad, .mac, .appleWatch]
            }

            let iconFileGeneratorService = IconFileGeneratorService(fileService: FileIconService(), resizeService: IconResizerService())
            try await iconFileGeneratorService.generateIconsURL(for: appIconType, with: image, path: exportPath)
            print("\nIcons generated successfully at \(exportPath)")
            return

        } catch {
            print(error.localizedDescription)
            }
    }

    
}
