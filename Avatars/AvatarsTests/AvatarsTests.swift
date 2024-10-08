import XCTest
@testable import Avatars


class AvatarsTests: XCTestCase {
    var sut: AvatarDownloader!
    var mockImageDataError: MockAvatarImageDataError!
    var mockUrlError: MockAvatarNetworkError!

    override func setUp() {
        super.setUp()
        sut = AvatarDownloader()
        mockImageDataError = MockAvatarImageDataError()
        mockUrlError = MockAvatarNetworkError()

    }

    override func tearDown() {
        sut = nil
        mockImageDataError = nil
        mockUrlError = nil
        super.tearDown()
    }

    func testDownloadAvatar_SuccessfulDownload_ReturnsImage() async {

        do {
            let image = try await sut.downloadAvatar(avatarID: "1", size: 100)
            XCTAssertNotNil(image)
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func testDownloadAvatar_InvalidURL_ThrowsError() async {
        
        Task.init {
            do {
                let _ = try await mockUrlError.downloadAvatar(avatarID: "testID", size: 100)
            } catch {
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
            }

        }
    }

    func testDownloadAvatar_InvalidImageData_ThrowsError() async {

        Task.init {
            do {
                let _ = try await mockImageDataError.downloadAvatar(avatarID: "testID", size: 100)
            } catch {
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidImageData)
            }
        }
    }
}

