//
//  TestViews.swift
//  Builder
//
//  Created by Michael Long on 11/26/21.
//

import UIKit

struct SomeViewBuilder2: ViewBuilder {
    var body: View {
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
    var body: View {
        SomeViewBuilder1()
            .hidden(true)
    }
}

struct AnotherViewBuilder3: ViewBuilder {
    var body: View {
        UITextView()
            .hidden(true)
            .with {
                $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 350).isActive = true
            }
    }
}

struct SomeViewBuilder1: ViewBuilder {
    var body: View {
        LabelView("This is VB1 Text!")
    }
}

struct AnotherViewBuilder1: ViewBuilder {
    var body: View {
        SomeViewBuilder1()
    }
}

struct AnotherViewBuilder4: ViewBuilder {
    var body: View {
        UITextView()
    }
}

struct AnotherViewBuilder5: ViewBuilder {
    var body: View {
        SomeViewBuilder1()
            .hidden(true)
            .with {
                $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 350).isActive = true
            }
    }
}
