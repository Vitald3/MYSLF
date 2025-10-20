import SwiftUI
import UIKit

struct ClickableText: UIViewRepresentable {
    struct Part {
        let text: String
        let url: String?
        let color: UIColor
        let underline: Bool

        init(_ text: String,
             url: String? = nil,
             color: UIColor = .label,
             underline: Bool = false) {
            self.text = text
            self.url = url
            self.color = color
            self.underline = underline
        }
    }

    let parts: [Part]
    let alignment: NSTextAlignment

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textAlignment = alignment
        textView.delegate = context.coordinator
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.dataDetectorTypes = []
        textView.linkTextAttributes = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        updateText(in: textView)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        updateText(in: uiView)
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    private func updateText(in textView: UITextView) {
        let attributed = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment

        for part in parts {
            var attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: part.color,
                .paragraphStyle: paragraph
            ]
            if part.underline {
                attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
            let sub = NSMutableAttributedString(string: part.text, attributes: attrs)
            if let link = part.url {
                sub.addAttribute(.link, value: link, range: NSRange(location: 0, length: part.text.count))
            }
            attributed.append(sub)
        }

        textView.attributedText = attributed
    }

    class Coordinator: NSObject, UITextViewDelegate {
        func textView(_ textView: UITextView,
                      shouldInteractWith URL: URL,
                      in characterRange: NSRange,
                      interaction: UITextItemInteraction) -> Bool {
            UIApplication.shared.open(URL)
            return false
        }
    }
}
