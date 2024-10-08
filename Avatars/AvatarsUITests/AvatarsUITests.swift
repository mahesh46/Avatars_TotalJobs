import XCTest
@testable import Avatars

class AvatarsUITests: XCTestCase {
    
    var  app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    fileprivate func checkTableViewCell() {
        let cell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        let cellImage = cell.images["cellImage"]
        let cellLogInLabel = cell.staticTexts["cellLogInLabel"]
        let cellGithubLabel = cell.staticTexts["cellGithubLabel"]
        
        XCTAssert(cell.exists)
        XCTAssert(cellImage.exists)
        XCTAssert(cellLogInLabel.exists)
        XCTAssert(cellGithubLabel.exists)
    }
    
    fileprivate func pickFirstCell() {
        let celUserName = app.staticTexts["mojombo"]
        celUserName.tap()
    }
    
    fileprivate func checkNavigationBarButton() {
        // waitForExistance(timeout:5)
        
        let avatarsButton = app.navigationBars["Avatars.DetailsView"].buttons["Avatars"]
        XCTAssert(avatarsButton.exists)
    }
    
    fileprivate func checkDetailViewHeaderSection() {
        let detailViewImage = app.images["userImage"]
        let deatilViewUserLabel = app.staticTexts["userLabel"]
        let deatilViewGithubLabel = app.staticTexts["githubGithubLabel"]
        XCTAssert(detailViewImage.exists)
        XCTAssert(deatilViewUserLabel.exists)
        XCTAssert(deatilViewGithubLabel.exists)
    }
    
    fileprivate func checkFirstCellDetailInformation() {
        let detailViewName = app.staticTexts["mojombo"]
        let detailViewUrl = app.staticTexts["GitHub:\nhttps://github.com/mojombo"]
        let detailViewFollowing = app.staticTexts["Following: 11"]
        let detailViewRepositories =  app.staticTexts["Repositories count: 30"]
        let detailViewFollowers = app.staticTexts["Followers: 30"]
        let detailViewGists = app.staticTexts["Gists count: N/A"]
        
        XCTAssert(detailViewName.exists)
        XCTAssert(detailViewUrl.exists)
        
        //wait for data then test  !!!!!
        if app.staticTexts["Following: 11"].waitForExistence(timeout: 5) {
            
            XCTAssert(detailViewFollowing.exists)
            XCTAssert(detailViewRepositories.exists)
            XCTAssert(detailViewFollowers.exists)
            XCTAssert(detailViewGists.exists)
        }
    }
    
    fileprivate func checkListViewTitle() {
        let avatarsTileText = app.navigationBars["Avatars"].staticTexts["Avatars"]
        XCTAssert(avatarsTileText.exists)
    }
    
    func testTableViewandDetailView() {
        
        app = XCUIApplication()
        app.launch()
        
        checkListViewTitle()
        
        checkTableViewCell()
        
        pickFirstCell()
        
        checkNavigationBarButton()
       
        checkDetailViewHeaderSection()
        
        checkFirstCellDetailInformation()
        
    }
    

}
