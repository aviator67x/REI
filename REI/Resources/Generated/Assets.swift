// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Assets {
  internal static let circleButton = ImageAsset(name: "circleButton")
  internal static let switchCamera = ImageAsset(name: "switchCamera")
  internal static let checkmark = ImageAsset(name: "checkmark")
  internal static let chevronLeft = ImageAsset(name: "chevron.left")
  internal static let facebookLogo = ImageAsset(name: "facebookLogo")
  internal static let googleLogo = ImageAsset(name: "googleLogo")
  internal static let internGramLogo = ImageAsset(name: "internGramLogo")
  internal static let blueprint = ImageAsset(name: "blueprint")
  internal static let launchBackground = ImageAsset(name: "launchBackground")
  internal static let loggogo = ImageAsset(name: "loggogo")
  internal static let logo = ImageAsset(name: "logo")
  internal static let newLogo = ImageAsset(name: "newLogo")
  internal static let galleryIcon = ImageAsset(name: "galleryIcon")
  internal static let internGram = ImageAsset(name: "InternGram")
  internal static let dot = ImageAsset(name: "dot")
  internal static let dude = ImageAsset(name: "dude")
  internal static let fourLeft = ImageAsset(name: "fourLeft")
  internal static let fourRight = ImageAsset(name: "fourRight")
  internal static let girl = ImageAsset(name: "girl")
  internal static let heartFill = ImageAsset(name: "heart.fill")
  internal static let house = ImageAsset(name: "house")
  internal static let messageMF = ImageAsset(name: "messageMF")
  internal static let newLogoo = ImageAsset(name: "newLogoo")
  internal static let woman = ImageAsset(name: "woman")
  internal static let zero = ImageAsset(name: "zero")
  internal static let homeFeelImage = ImageAsset(name: "HomeFeelImage")
  internal static let homeImage = ImageAsset(name: "HomeImage")
  internal static let likeImage = ImageAsset(name: "LikeImage")
  internal static let newPostImage = ImageAsset(name: "NewPostImage")
  internal static let openCamera = ImageAsset(name: "openCamera")
  internal static let circle = ImageAsset(name: "circle")
  internal static let hashtag = ImageAsset(name: "Hashtag")
  internal static let search = ImageAsset(name: "Search")
  internal static let searchFeelImage = ImageAsset(name: "SearchFeelImage")
  internal static let searchImage = ImageAsset(name: "SearchImage")
  internal static let defaultUser = ImageAsset(name: "defaultUser")
  internal static let multiply = ImageAsset(name: "multiply")
  internal static let multiply1x = ImageAsset(name: "multiply1x")
  internal static let exit = ImageAsset(name: "exit")
  internal static let message = ImageAsset(name: "message")
  internal static let heart = ImageAsset(name: "heart")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
