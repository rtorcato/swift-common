//
//  WebImageHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-15.
//

import SwiftUI
import Combine

final class WebImageHelper {
    
    static let instance = WebImageHelper() // Singleton
    
    init() { }
    
    // simplest image func
    @MainActor static func fetchImage(_ urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
    
    static func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    // Completion handler example
    func fetchImage(_ imageUrl: String, completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            // completionHandler(nil, Error())
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let image = WebImageHelper.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }.resume()
    }
    // Combine example
    func fetchImageWithCombine(_ imageUrl: String) -> AnyPublisher<UIImage?, Error> {
        let url = URL(string: imageUrl)
        let pub: AnyPublisher<UIImage?, Error> = URLSession.shared.dataTaskPublisher(for: url!)
            .map(WebImageHelper.handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
        return pub
    }
    // Async example
    func fetchImageWithAsync(_ imageUrl: String) async throws -> UIImage? {
        let url: URL? = URL(string: imageUrl)
        do {
            guard let url = url else { return nil }
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return WebImageHelper.handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}

//
// class WebImageViewVM: ObservableObject {
//    @Published var webImage: UIImage? = nil
//    @Published var fetchImageTask: Task<(), Never>? = nil
//    private var cancellables = Set<AnyCancellable>()
//    private let loader = ImageLoader()
//
//    func fetchImageClosure(_ imageUrl: String) {
//        loader.fetchImage(imageUrl){ [weak self] image, error in
//            DispatchQueue.main.async {
//                self?.webImage = image
//            }
//        }
//    }
//
//    func fetchImageCombine(_ imageUrl: String){
//        loader.fetchImageWithCombine(imageUrl).receive(on: DispatchQueue.main)
//            .sink{ _ in
//
//            } receiveValue: { [weak self] image in
//                self?.webImage = image
//            }
//            .store(in: &cancellables)
//    }
//
//    func fetchImageAsync(_ imageUrl: String) async {
//        let image = try? await loader.fetchImageWithAsync(imageUrl)
//        await MainActor.run{
//            self.webImage = image
//        }
//    }
//
//
// }

//
//    var body: some View {
//        VStack{
//            if let easyImage {
//                Image(uiImage: easyImage)
//                    .resizable()
//                    .scaledToFit()
//            }
//            HStack{
//                if let image = webImageViewVM.webImage {
//                    Image(uiImage: image)
//                        .resizable().scaledToFit().frame(width: 100, height:100)
//                }
//                if let image = webImageViewVM1.webImage {
//                    Image(uiImage: image)
//                        .resizable().scaledToFit().frame(width: 100, height:100)
//                    // swift ui auto cancels tasks
//                    //                .onDisappear{
//                    //                    fetchImageTask?.cancel()
//                    //                }
//                }
//                if let image = webImageViewVM3.webImage {
//                    Image(uiImage: image)
//                        .resizable().scaledToFit().frame(width: 100, height:100)
//                }
//                //        AsyncImage(url: URL(string: imageUrl))
//
//            }
//            .task{
//                webImageViewVM1.fetchImageCombine(imageUrl)
//                webImageViewVM3.fetchImageClosure(imageUrl)
//                webImageViewVM.fetchImageTask = Task {
//                    await webImageViewVM.fetchImageAsync(imageUrl)
//                }
//            }
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 20) {
//                    ForEach(easyImages, id:\.self) { image in
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 120, height:120)
//                        }
//                }
//            }
//            .onAppear{
//                Task{
//                    do{
//                        easyImages = try await fetchImagesWithAsyncLet()
//                    } catch {
//
//                    }
//                }
//            }
//
//        }.task{
//            do{
//                let image1 = try await ImageLoader.fetchImage("https://picsum.photos/300")
//                easyImage = image1
//            } catch {
//
//            }
//        }
//
//    }
// }
//
// struct WebImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebImageView(imageUrl: "https://picsum.photos/1000")
//    }
// }
