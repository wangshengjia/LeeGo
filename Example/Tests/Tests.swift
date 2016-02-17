// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import LeeGo

class TableOfContentsSpec: QuickSpec {
    override func spec() {

        describe("ComponentTarget tests") { () -> Void in
            it("should create a new component target object with correct name & type", closure: { () -> () in
                let component = ComponentTarget(name: "title", targetClass: UILabel.self)
                expect(component.name) == "title"
            })
        }

//        describe("these will fail") {
//
//            it("can do maths") {
//                expect(1) == 2
//            }
//
//            it("can read") {
//                expect("number") == "string"
//            }
//
//            it("will eventually fail") {
//                expect("time").toEventually( equal("done") )
//            }
//            
//            context("these will pass") {
//
//                it("can do maths") {
//                    expect(23) == 23
//                }
//
//                it("can read") {
//                    expect("🐮") == "🐮"
//                }
//
//                it("will eventually pass") {
//                    var time = "passing"
//
//                    dispatch_async(dispatch_get_main_queue()) {
//                        time = "done"
//                    }
//
//                    waitUntil { done in
//                        NSThread.sleepForTimeInterval(0.5)
//                        expect(time) == "done"
//
//                        done()
//                    }
//                }
//            }
//        }
    }
}
