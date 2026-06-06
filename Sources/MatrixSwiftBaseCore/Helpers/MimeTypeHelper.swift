//
//  MimeTypeHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-06.
//

import Foundation
import UniformTypeIdentifiers

public final class MimeTypeHelper {

    public init() { }

    /// Broad classification of a MIME type, useful for switching on file kind.
    public enum Kind: String, CaseIterable, Sendable {
        case image
        case audio
        case video
        case text
        case pdf
        case archive
        case font
        case other
    }

    /// MIME type for a file extension (e.g. `"jpg"` → `"image/jpeg"`).
    /// The extension may include or omit a leading dot.
    public static func mimeType(forExtension ext: String) -> String? {
        let trimmed = normalizedExtension(ext)
        guard !trimmed.isEmpty else { return nil }
        return UTType(filenameExtension: trimmed)?.preferredMIMEType
    }

    /// MIME type for a filename or path (e.g. `"photo.jpg"` → `"image/jpeg"`).
    /// Returns nil when the path has no extension or the extension is unknown.
    public static func mimeType(forFilename filename: String) -> String? {
        let ext = (filename as NSString).pathExtension
        guard !ext.isEmpty else { return nil }
        return mimeType(forExtension: ext)
    }

    /// Preferred file extension for a MIME type (e.g. `"image/jpeg"` → `"jpeg"`).
    public static func preferredExtension(forMimeType mimeType: String) -> String? {
        UTType(mimeType: mimeType)?.preferredFilenameExtension
    }

    /// All known file extensions for a MIME type. Empty when the MIME type is unknown.
    public static func extensions(forMimeType mimeType: String) -> [String] {
        guard let type = UTType(mimeType: mimeType) else { return [] }
        return type.tags[.filenameExtension] ?? []
    }

    /// True when the MIME type conforms to `public.image`.
    public static func isImage(_ mimeType: String) -> Bool {
        conforms(mimeType, to: .image)
    }

    /// True when the MIME type conforms to `public.audio`.
    public static func isAudio(_ mimeType: String) -> Bool {
        conforms(mimeType, to: .audio)
    }

    /// True when the MIME type conforms to `public.movie` (video).
    public static func isVideo(_ mimeType: String) -> Bool {
        conforms(mimeType, to: .movie)
    }

    /// True when the MIME type conforms to `public.text`.
    public static func isText(_ mimeType: String) -> Bool {
        conforms(mimeType, to: .text)
    }

    /// Broad classification for a MIME type. Returns `.other` for unknown or unclassified types.
    public static func kind(forMimeType mimeType: String) -> Kind {
        guard let type = UTType(mimeType: mimeType) else { return .other }
        if type.conforms(to: .image) { return .image }
        if type.conforms(to: .audio) { return .audio }
        if type.conforms(to: .movie) { return .video }
        if type.conforms(to: .pdf) { return .pdf }
        if type.conforms(to: .archive) { return .archive }
        if type.conforms(to: .font) { return .font }
        if type.conforms(to: .text) { return .text }
        return .other
    }

    private static func conforms(_ mimeType: String, to base: UTType) -> Bool {
        UTType(mimeType: mimeType)?.conforms(to: base) ?? false
    }

    private static func normalizedExtension(_ ext: String) -> String {
        var value = ext
        if value.hasPrefix(".") { value.removeFirst() }
        return value.lowercased()
    }
}
