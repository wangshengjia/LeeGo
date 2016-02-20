// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import LeeGo

class TableOfContentsSpec: QuickSpec {
    override func spec() {

        describe("ComponentTarget tests") {

            it("should create a new component target instance correctly") {
                let component = ComponentTarget(name: "title", targetClass: UILabel.self).width(40).style([.backgroundColor(UIColor.greenColor())])
                expect(component.name) == "title"
                expect(component.targetClass == UILabel.self)
                expect(component.width) == 40
                if case let .backgroundColor(color) = component.style.first! {
                    expect(color) == UIColor.greenColor()
                }
            }

            it("should create a new component with subcomponents", closure: { () -> () in

                let mockLayout = Layout()

                let component = ComponentTarget(name: "header", targetClass: UIView.self).components(ComponentTarget(name: "title", targetClass: UILabel.self), ComponentTarget(name: "avatar", targetClass: UIImageView.self), layout: { (title, avatar) -> Layout in
                    expect(title) == "title"
                    expect(avatar) == "avatar"
                    return mockLayout
                })
                expect(component.components?.count) == 2
                expect(component.components?.last?.name) == "avatar"
                expect(component.layout) == mockLayout
            })

            it("should build component target instance", closure: { () -> () in
                let component = ComponentBuilder.header.build()
                expect(component.name) == "header"
                expect(component.targetClass == UIView.self)
            })

            it("should build component target instance", closure: { () -> () in
                let component = ComponentBuilder.title.buildFromNib(name: "nibname")
                expect(component.name) == "title"
                expect(component.targetClass == UILabel.self)
                expect(component.nibName) == "nibname"
            })
        }

        describe("Configuration tests") {
            it("should create a empty layout") {
                let layout = Layout()
                expect(layout.formats) == []
            }
            it("should create layout with formats") {
                let mockFormat = ["format1", "format2"]
                let layout = Layout(mockFormat)

                expect(layout.formats) == mockFormat
                expect(layout.formats) != ["format2", "format2"]

                expect(layout.metrics!["top"]!.isEqual(0))
                expect(layout.metrics!["left"]!.isEqual(0))
                expect(layout.metrics!["bottom"]!.isEqual(0))
                expect(layout.metrics!["right"]!.isEqual(0))
                expect(layout.metrics!["interspaceH"]!.isEqual(0))
                expect(layout.metrics!["interspaceV"]!.isEqual(0))
            }

            it("should create layout with formats") {
                let layout = Layout([], ["metrics": 10 ])

                expect(layout.metrics!["metrics"]!.isEqual(10))
            }

            it("two layout should be ==") {
                expect(Layout()) == Layout()

                let layout1 = Layout(["format1", "format2"], ["top": 22, "left": 0, "bottom": 0, "right" : 22, "interspaceH": 0, "interspaceV": 0])
                let layout2 = Layout(["format1", "format2"], (22, 0, 0, 22, 0, 0))

                expect(layout1) == layout2
            }
        }
    }
}

enum ComponentBuilder: ComponentBuilderType {

    case header, title

    static let types: [ComponentBuilder: AnyClass] = [title: UILabel.self]
}















