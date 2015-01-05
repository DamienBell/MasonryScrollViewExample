//
//  AddView.swift
//  MasonryScrollViewExample
//
//  Created by Damien Bell on 1/4/15.
//  Copyright (c) 2015 Damien Bell. All rights reserved.
//

import UIKit

class ExpandingView: UIView {
    
    let plus_button = UIButton()
    let minus_button = UIButton()
    
    convenience override init () {
        
        self.init(frame:CGRectZero)
        
        self.backgroundColor = UIColor.blueColor()
        
        plus_button.setTitle("+", forState: UIControlState.Normal)
        minus_button.setTitle("-", forState: UIControlState.Normal)
        
        plus_button.backgroundColor = UIColor.grayColor()
        minus_button.backgroundColor = UIColor.grayColor()
        
        plus_button.addTarget(self, action: "expandView:", forControlEvents: UIControlEvents.TouchUpInside)
        minus_button.addTarget(self, action: "revertView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(plus_button)
        self.addSubview(minus_button)
        
        //Let's position our buttons centered near the bottom of the view.
        plus_button.mas_makeConstraints({make in
            make.height.equalTo()(44)
            make.width.equalTo()(44)
            make.centerX.equalTo()(self).offset()(-24)
            make.bottom.equalTo()(self).offset()(-10)
            return
        })
        minus_button.mas_makeConstraints({make in
            make.height.equalTo()(44)
            make.width.equalTo()(44)
            make.centerX.equalTo()(self).offset()(24)
            make.bottom.equalTo()(self).offset()(-10)
            return
        })
        super.updateConstraints()
    }
    
    //In this case I'm making the width of the expandingView dependent on the superview
    //Since we can't get that information without having been added to a superview then 
    //We won't create dimension constraints until this view has actually been added.
    override func didMoveToSuperview(){
        
        //When possible, I like to have views responsible for their own dimensions while the super.view
        //is responsible for positioning them.
        self.mas_makeConstraints({make in
            make.height.equalTo()(300)
            make.width.equalTo()(self.superview).offset()(-10)
            return
        })
        
        super.updateConstraints()
    }
    
    //This method will update the height of the view to 400pts with a nice animation
    func expandView(sender:UIButton!){
        
        //We will be updating our constaints, so by all means let's set "needsUpdateConstraints"
        self.setNeedsUpdateConstraints()
        
        //Here we're going to update our vertical constraint
        self.mas_updateConstraints({make in
            make.height.equalTo()(400)
            return
        })
        
        //We'll need to create a weak reference to superview so that we can use it in our animation block
        var super_ref = super.superview
        
        UIView.animateWithDuration(1.0, animations: {
            
            //Each cycle in the animatin should update the layout on this view and it's super
            self.layoutIfNeeded()
            super_ref?.layoutIfNeeded()
            
            }, completion: { completed in
                //One more time just in case. This isn't entirely nessesary, but it helps me sleep at night.
                super_ref?.layoutIfNeeded()
                return
        })
        
        //Update superview's constraints so that we'll be able to update the scrollView contentSize
        super.updateConstraints()
    }
    
    func revertView(sender:UIButton!){
        
        self.setNeedsUpdateConstraints()
        
        self.mas_updateConstraints({make in
            make.height.equalTo()(300)
            return
        })
        
        var super_ref = super.superview
        
        UIView.animateWithDuration(1.0, animations: {
            
            self.layoutIfNeeded()
            super_ref?.layoutIfNeeded()
            
            }, completion: { completed in
                
                super_ref?.layoutIfNeeded()
                return
        })
        
        super.updateConstraints()
    }
}
