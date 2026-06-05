//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-05.
//
#if canImport(MessageUI)
import Foundation
import MessageUI

public class MessageUIManager {
    /// The delegate required by `MFMailComposeViewController`
    private let mailComposeDelegate = MailDelegate()
    
    /// The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageDelegate()
    
    // static let shared = MailManager() // Singleton
    
    public init() {}
    
    public func getEMailComposer() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = mailComposeDelegate
        mailComposeVC.accessibilityElementDidLoseFocus()
        return mailComposeVC
    }
    public func getMessageComposer() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = messageComposeDelegate
        messageComposeVC.accessibilityElementDidLoseFocus()
        return messageComposeVC
    }
    
    public func sendTestEmail() {
        let composer = getEMailComposer()
        composer.setSubject("App support")
        composer.setToRecipients(["support@matrixdigital.com"])
        composer.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
        let vc = AppHelper.getFirstWindowRootViewController()
        vc?.present(composer, animated: true)
    }
    
    /// Present an mail compose view controller modally in UIKit environment
    public func presentEMailComposer(composer: MFMailComposeViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let vc = AppHelper.getFirstWindowRootViewController()
        vc?.present(composer, animated: true)
    }
    /// Present an message compose view controller modally in UIKit environment
    public func presentMessageCompose() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        // Customize here
        let vc = AppHelper.getFirstWindowRootViewController()
        vc?.present(composeVC, animated: true)
    }
    
    // Delegate for view controller as `MFMailComposeViewControllerDelegate`
    private class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    
    // Delegate for view controller as `MFMessageComposeViewControllerDelegate`
    private class MessageDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }
    
    public static func canSendEmail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
}

// MARK: example
// func sendSupportEmail() {
// let messageManager = MessageUIManager()
//    if messageManager.canSendEmail() {
//        let emailComposer = messageManager.getEMailComposer()
//        emailComposer.setSubject("Support request")
//        emailComposer.setToRecipients(["test@test.com"])
//        emailComposer.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
//        emailComposer.presentEMailComposer(composer: emailComposer)
//    } else {
//        AlertHelper.showSimpleAlert(title: "No Email", message: "Sorry your device cannot send email")
//    }
// }

#endif
