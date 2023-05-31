import SwiftUI
import ContactsUI

/**
 Presents a CNContactPickerViewController view modally.
 - Parameters:
 - showPicker: Binding variable for presenting / dismissing the picker VC
 - onSelectContact: Use this callback for single contact selection
 - onSelectContacts: Use this callback for multiple contact selections
 */

// UIViewControllerRepresentable is a protocol in SwiftUI that allows you to integrate a UIKit view controller into a SwiftUI view hierarchy
public struct ContactPicker: UIViewControllerRepresentable {
    @Binding var showPicker: Bool
    @State private var viewModel = ContactPickerViewModel()
    public var onSelectContact: ((_: CNContact) -> Void)?
    public var onSelectContacts: ((_: [CNContact]) -> Void)?
    public var onCancel: (() -> Void)?

    public init(showPicker: Binding<Bool>, onSelectContact: ((_: CNContact) -> Void)? = nil, onSelectContacts: ((_: [CNContact]) -> Void)? = nil, onCancel: (() -> Void)? = nil) {
        self._showPicker = showPicker
        self.onSelectContact = onSelectContact
        self.onSelectContacts = onSelectContacts
        self.onCancel = onCancel
    }

    // The makeUIViewController method is called when the view is created and should return an instance of your UIKit view controller.
    // This context object allows you to communicate between your SwiftUI view and the underlying UIKit view controller. It is managed by UIViewControllerRepresentable
    // The context object is useful when you need to access properties or methods of the UIKit view controller from your SwiftUI view, or when you need to respond to events that occur in the UIKit view controller.
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ContactPicker>) -> ContactPicker.UIViewControllerType {
        let dummy = _DummyViewController()
        viewModel.dummy = dummy
        return dummy
    }

    // The updateUIViewController method is called when the view needs to be updated and gives you a chance to update the state of your UIKit view controller
    public func updateUIViewController(_ uiViewController: _DummyViewController, context: UIViewControllerRepresentableContext<ContactPicker>) {

        guard viewModel.dummy != nil else {
            return
        }

        // able to present when
        // 1. no current presented view
        // 2. current presented view is being dismissed
        let ableToPresent = viewModel.dummy.presentedViewController == nil || viewModel.dummy.presentedViewController?.isBeingDismissed == true

        // able to dismiss when
        // 1. cncpvc is presented
        let ableToDismiss = viewModel.vc != nil

        if showPicker && viewModel.vc == nil && ableToPresent {
            let pickerVC = CNContactPickerViewController()
            pickerVC.delegate = context.coordinator
            viewModel.vc = pickerVC
            viewModel.dummy.present(pickerVC, animated: true)
        } else if !showPicker && ableToDismiss {
            viewModel.dummy.dismiss(animated: true)
            self.viewModel.vc = nil
        }
    }

    // The context object conforms to the UIViewControllerRepresentableContext protocol, which requires you to implement two methods: coordinator and update. The coordinator method returns a coordinator object that you can use to manage interactions between the SwiftUI view and the UIKit view controller. The update method is called when the SwiftUI view's state changes and gives you a chance to update the context object.

    // For example, if you're using a UIImagePickerController to allow the user to choose a photo, you might need to dismiss the UIImagePickerController when the user selects a photo. You can use the context object to communicate between your SwiftUI view and the UIImagePickerController.

    public func makeCoordinator() -> ContactPickerCoordinator {
        if self.onSelectContacts != nil {
            return MultipleSelectionCoordinator(self)
        } else {
            return SingleSelectionCoordinator(self)
        }
    }

    public final class SingleSelectionCoordinator: NSObject, ContactPickerCoordinator {
        var parent: ContactPicker

        init(_ parent: ContactPicker) {
            self.parent = parent
        }

        public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.showPicker = false
            parent.onCancel?()
        }

        public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.showPicker = false
            parent.onSelectContact?(contact)
        }
    }

    public final class MultipleSelectionCoordinator: NSObject, ContactPickerCoordinator {
        var parent: ContactPicker

        init(_ parent: ContactPicker) {
            self.parent = parent
        }

        public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.showPicker = false
            parent.onCancel?()
        }

        public func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            parent.showPicker = false
            parent.onSelectContacts?(contacts)
        }
    }
}

class ContactPickerViewModel {
    var dummy: _DummyViewController!
    var vc: CNContactPickerViewController?
}

public protocol ContactPickerCoordinator: CNContactPickerDelegate {}

public class _DummyViewController: UIViewController {}
