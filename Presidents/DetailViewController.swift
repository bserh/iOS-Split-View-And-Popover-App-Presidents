//
//  DetailViewController.swift
//  Presidents
//
//  Created by Sergey Bavykin on 4/1/16.
//  Copyright © 2016 Sergey Bavykin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    private var languageListController: LanguageListTableViewController?
    private var languageButton: UIBarButtonItem?
    var languageString = "" {
        didSet {
            if languageString != oldValue {
                configureView()
            }
        }
    }

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                let dict = detail as! [String: String]
                let urlString = modifyUrlForLanguage(dict["url"]!, language: languageString)
                label.text = urlString
                
                let url = NSURL(string: urlString)!
                let request = NSURLRequest(URL: url)
                webView.loadRequest(request)
                
                let name = dict["name"]!
                title = name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        languageButton = UIBarButtonItem(title: "Choose Language", style: .Plain, target: self, action: "showLanguagePopover")
        navigationItem.rightBarButtonItem = languageButton
        
        self.configureView()
    }
    
    func showLanguagePopover() {
        if languageListController == nil {
            languageListController = LanguageListTableViewController()
            languageListController?.detailViewController = self
            languageListController?.modalPresentationStyle = .Popover
        }
        presentViewController(languageListController!, animated: true, completion: nil)
        if let ppc = languageListController?.popoverPresentationController {
            ppc.barButtonItem = languageButton
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func modifyUrlForLanguage(url: String, language lang: String?) -> String {
        var newUrl = url
        
        if let langStr = lang {
            let range = NSMakeRange(8, 2)
            if !langStr.isEmpty && (url as NSString).substringWithRange(range) != langStr {
                newUrl = (url as NSString).stringByReplacingCharactersInRange(range, withString: langStr)
            }
        }
        
        return newUrl
    }
}

