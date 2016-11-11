import KIF
import Quick
import Nimble
import Nimble_Snapshots
import PPAssetsActionController

extension XCTestCase {
    func tester(file : String = #file, _ line : Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    func system(file : String = #file, _ line : Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}

extension KIFTestActor {
    func tester(file : String = #file, _ line : Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    func system(file : String = #file, _ line : Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }

    func deviceSpecificName(for name: String) -> String {
        let idiom = UIDevice.current.userInterfaceIdiom == .phone ? "iPhone" : "iPad"
        let systemVersion = UIDevice.current.systemVersion.components(separatedBy: ".").first! + "x"
        return name + "_" + idiom + "_" + systemVersion
    }
}



class ViewsSpec: QuickSpec {
    override func spec() {
        var window: UIView!
        
        beforeEach {
            window = UIApplication.shared.keyWindow
        }
        afterEach {
            self.tester().tapView(withAccessibilityLabel: "cancel-cell")
        }
        
        describe("Default Configuration, 3 options") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "default-3-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                UIAutomationHelper.acknowledgeSystemAlert()
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "3_options_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "default-3-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "3_options_expanded")) )
            }
        }
        
        describe("Default Configuration, no options") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "default-no-options")
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "no_options_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "default-no-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "no_options_expanded")) )
            }
        }
        
        describe("Custom Cell Height, 3 options") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-height-3-options")
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_cell_height_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-height-3-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_cell_height_expanded")) )
            }
        }
        
        describe("Custom Font, 2 options") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-font-2-options")
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_font_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-font-2-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_font_expanded")) )
            }
        }
        
        describe("Custom Preview Height, 1 option") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-preview-height-1-option")
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_preview_height_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-preview-height-1-option")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_preview_height_expanded")) )
            }
        }
        
        describe("Custom Inset, 4 options") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-inset-4-options")
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_inset_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-inset-4-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_inset_expanded")) )
            }
        }
        
        describe("Custom Section Spacing, 4 options") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-section-spacing-4-options")
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_spacing_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-section-spacing-4-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_spacing_expanded")) )
            }
        }
        
        describe("Custom Background Color, 5 options") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-background-color-5-options")
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_background_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-background-color-5-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_background_expanded")) )
            }
        }
        
        describe("Custom Tint Color, 5 options") {
            it("regular height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-tint-color-5-options")
                self.tester().waitForView(withAccessibilityLabel: "asset-0")
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_tint_regular")) )
            }
            
            it("expanded height displayed correctly") {
                self.tester().tapView(withAccessibilityLabel: "custom-tint-color-5-options")
                self.tester().waitForView(withAccessibilityLabel: "assets-action-view")
                self.tester().tapView(withAccessibilityLabel: "asset-0")
                self.tester().waitForAnimationsToFinish()
                expect(window).to( haveValidSnapshot(named: self.tester().deviceSpecificName(for: "custom_tint_expanded")) )
            }
        }
    }
}
