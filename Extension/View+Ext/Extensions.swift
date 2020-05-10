//
//  Extensions.swift
//  Netflux
//
//  Created by Martin Parker on 09/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//


import UIKit

extension UIViewController {
    
    //Simple Alert controller with only Ok button
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension UIImage {
    func imageWithPixelSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, opaque: Bool = false) -> UIImage? {
        return imageWithSize(size: size, filledWithColor: color, scale: 1.0, opaque: opaque)
    }
    
    func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UISearchBar {
    private var textField: UITextField? {
        let subViews = self.subviews.flatMap { $0.subviews }
        if #available(iOS 13, *) {
            if let _subViews = subViews.last?.subviews {
                return (_subViews.filter { $0 is UITextField }).first as? UITextField
            }else{
                return nil
            }
            
        } else {
            return (subViews.filter { $0 is UITextField }).first as? UITextField
        }
        
    }
    
    private var searchIcon: UIImage? {
        let subViews = subviews.flatMap { $0.subviews }
        return  ((subViews.filter { $0 is UIImageView }).first as? UIImageView)?.image
    }
    //////
    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            @unknown default:
                break
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    
    
    ///////
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    // Public API
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            let _searchIcon = searchIcon
            if newValue {
                if activityIndicator == nil {
                    let _activityIndicator = UIActivityIndicatorView(style: .medium)
                    _activityIndicator.startAnimating()
                    _activityIndicator.backgroundColor = UIColor.clear
                    let clearImage = UIImage().imageWithPixelSize(size: CGSize.init(width: 14, height: 14)) ?? UIImage()
                    self.setImage(clearImage, for: .search, state: .normal)
                    textField?.leftViewMode = .always
                    textField?.leftView?.addSubview(_activityIndicator)
                    let leftViewSize = CGSize.init(width: 14.0, height: 14.0)
                    _activityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                self.setImage(_searchIcon, for: .search, state: .normal)
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}

/*
 Usage:
 
 To show the acttivity indicator
 searchController.searchBar.isLoading = true
 
 To stop the activity indicator (assuming it will be called when a network or extensive block is finished)
 DispatchQueue.main.async {
 searchController.searchBar.isLoading = false
 }
 */
