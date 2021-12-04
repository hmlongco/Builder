//
//  ViewController.swift
//  BuilderTest
//
//  Created by Michael Long on 11/7/21.
//

import UIKit
import RxSwift
import Resolver

class TestViewController: UIViewController {
    
    @Variable var pageTitle: String = "Builder Test View"
    @Variable var hidden: Bool = false
    @Variable var tapped: Bool = false
    @Variable var color: UIColor? = UIColor(white: 0, alpha: 0.4)

    var scrollView: UIScrollView?

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.embed(content())
        
        bag.insert {
            $pageTitle.onChange { value in
                print(value)
            }
            
            $hidden.onChange { value in
                print("Changed \(value)")
            }
            
            $tapped.onChange { value in
                self.view.empty()
            }
        }
               
    }
        
    func content() -> View {
        VerticalScrollView {
            VStackView {
                ZStackView {
                    ImageView(UIImage(named: "User-ML"))
                        .contentMode(.scaleAspectFill)
                        .height(250)
                        .cornerRadius(10)
                        .clipsToBounds(true)

                    LabelView("Michael Long")
                        .color(.white)
                        .alignment(.right)
                        .bind(keyPath: \.backgroundColor, binding: $color)
                        .padding(h: 12, v: 8)
                        .roundedCorners(radius: 10, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
                        .clipsToBounds(true)
                        .position(.bottom)
                }
                .backgroundColor(.secondarySystemBackground)
                .padding(20)
                .border(color: .gray)
                .roundedCorners(radius: 16, corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
                .shadow(color: .black, radius: 2, opacity: 0.2, offset: CGSize(width: 2, height: 2))
                .onTapGesture { [weak self] _ in
                    self?.color = .red
                }

                VStackView {
                    LabelView($pageTitle)
                        .font(.largeTitle)

                    LabelView("This demonstrates how easy it is to enable multiline text using Builder!")
                        .font(.preferredFont(forTextStyle: .callout))
                        .color(.label)
                        .numberOfLines(0)
                }
                .spacing(2)

                HStackView {
                    LabelView("Hide Details")
                    SpacerView()
                        .backgroundColor(.tertiarySystemBackground)
                    SwitchView($hidden.asObservable())
                        .onTintColor(.blue)
                        .onChange { [weak self] _ in
                            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                                self?.hidden.toggle()
                            })
                        }
                }
                .alignment(.center)
                .padding(h: 0, v: 8)
                
                DetailsView(hidden: $hidden)
                
                UISlider()
                
                ButtonView("Toggle Switch")
                    .style(.filled)
                    .onTap { [weak self] _ in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                            self?.pageTitle = "Changed the title!"
                            self?.hidden.toggle()
                        })
                    }

                SpacerView()
                    .backgroundColor(.tertiarySystemBackground)
            }
            .spacing(16)
            .padding(30)
        }
        .backgroundColor(.tertiarySystemBackground)
        .onReceive($hidden) { context in
            print("Received \(context.value)")
        }
        .reference(&scrollView)
    }

}

struct DetailsView: ViewBuilder {
    
    @Variable var hidden: Bool

    var body: View {
        VStackView {
            DividerView()
            LabelView("This is some text in a smal font. In fact, it's so small that I have to wonder why you're reading this at all.")
                .font(.footnote)
                .color(.secondaryLabel)
                .numberOfLines(0)
            VStackView {
                ForEach(3) { index in
                    BulletFootnoteItemView(text: "This is some text explaining item \(index + 1).")
                }
            }
            .spacing(1)
            DividerView()
        }
        .spacing(8)
        .hidden(bind: $hidden)
    }
    
}

struct BulletFootnoteItemView: ViewBuilder {

    let text: String

    var body: View {
        HStackView {
            LabelView("•")
                .alignment(.center)
                .color(.secondaryLabel)
                .font(.footnote)
                .width(20)
            LabelView(text)
                .alignment(.left)
                .contentHuggingPriority(.defaultLow, for: .horizontal)
                .color(.secondaryLabel)
                .font(.footnote)
                .numberOfLines(0)
            SpacerView()
        }
        .spacing(4)
    }
}
