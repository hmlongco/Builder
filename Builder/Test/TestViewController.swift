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
    
    @Variable var pageTitle: String = "ViewBuilder Features!"
    @Variable var hidden: Bool = false
    @Variable var tapped: Bool = false
    
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

                    LabelView("Contained Text")
                        .color(.white)
                        .alignment(.right)
                        .backgroundColor(UIColor(white: 0, alpha: 0.4))
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
                    self?.tapped.toggle()
                }

                LabelView($pageTitle)
                    .font(.largeTitle)

                LabelView("This is some text! In fact, this is some amazing multiline text!")
                    .font(.preferredFont(forTextStyle: .callout))
                    .color(.label)
                    .numberOfLines(0)

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
                            self?.pageTitle = "This is a changed title!"
                            self?.hidden.toggle()
                        })
                    }

                LabelView("This is some more text! In fact, this is more text than we've ever seen before in a single line!")
                    .font(.preferredFont(forTextStyle: .footnote))
                    .color(.secondaryLabel)
                    .numberOfLines(0)
                
                SpacerView()
                    .backgroundColor(.tertiarySystemBackground)
            }
            .spacing(8)
            .padding(30)
        }
        .backgroundColor(.tertiarySystemBackground)
        .onReceive($hidden) { _, value in
            print("Received \(value)")
        }

    }

}

struct DetailsView: ViewBuilder {
    
    @Variable var hidden: Bool

    func build() -> View {
        VStackView {
            DividerView()
            if true {
                VStackView {
                    ForEach(3) { _ in
                        BulletFootnoteItemView(text: "This is some bulletted text.")
                    }
                }
                .spacing(1)
            }
            DividerView()
        }
        .hidden(bind: $hidden)
    }
    
}

struct BulletFootnoteItemView: ViewBuilder {
    let text: String
    func build() -> View {
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

struct SomeViewBuilder2: ViewBuilder {
    func build() -> View {
        LabelView("This is some text!")
            .hidden(false)
            .font(.preferredFont(forTextStyle: .largeTitle))
            .with {
                $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 350).isActive = true
            }
    }
}

struct AnotherViewBuilder2: ViewBuilder {
    func build() -> View {
        SomeViewBuilder1()
            .hidden(true)
    }
}

struct AnotherViewBuilder3: ViewBuilder {
    func build() -> View {
        UITextView()
            .hidden(true)
            .with {
                $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 350).isActive = true
            }
    }
}

struct SomeViewBuilder1: ViewBuilder {
    func build() -> View {
        LabelView("This is VB1 Text!")
    }
}

struct AnotherViewBuilder1: ViewBuilder {
    func build() -> View {
        SomeViewBuilder1()
    }
}

struct AnotherViewBuilder4: ViewBuilder {
    func build() -> View {
        UITextView()
    }
}

struct AnotherViewBuilder5: ViewBuilder {
    func build() -> View {
        SomeViewBuilder1()
            .hidden(true)
            .with {
                $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 350).isActive = true
            }
    }
}
