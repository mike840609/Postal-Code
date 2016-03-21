//
//  MateriaTextField.swift
//  SocialNetwork
//
//  Created by 蔡鈞 on 2016/3/20.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit

class MateriaTextField: UITextField {

    override func awakeFromNib() {
        
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        
    }
    
    // For placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    // For editable text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    

}
