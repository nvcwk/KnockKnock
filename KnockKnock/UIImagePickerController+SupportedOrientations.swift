//
//  UIImagePickerController+SupportedOrientations.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 23/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit

extension UIImagePickerController
{
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
}


class LandscapePickerController: UIImagePickerController
{
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
}
