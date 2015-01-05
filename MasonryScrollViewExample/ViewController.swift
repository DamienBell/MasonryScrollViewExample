//
//  ViewController.swift
//  MasonryScrollViewExample
//
//  Created by Damien Bell on 1/4/15.
//  Copyright (c) 2015 Damien Bell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let scrollview:UIScrollView = UIScrollView()
    let contentview = UIView()
    let expandingView1 = ExpandingView()
    let expandingView2 = ExpandingView()
    let buffer = UIView()

    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        scrollview.backgroundColor = UIColor.whiteColor()
        contentview.backgroundColor = UIColor.grayColor()
        
        //At this point all views have a size of 0
        //It's important add views to a parent view before applying constraints
        view.addSubview(scrollview)
        scrollview.addSubview(contentview)
        contentview.addSubview(expandingView1)
        contentview.addSubview(expandingView2)
        contentview.addSubview(buffer)
        
        //Let's set our scrollview to be the entire width of the screen
        //'make' is a MasonryConstraintMaker
        //It will make constraints for the view we're calling mas_makeConstraints on.
        scrollview.mas_makeConstraints { make in
     
            make.edges.equalTo()(self.view)
            //**Weird swift thing here.** 
            //For a block with a single statement we must explicitly call return or we'll get an error.
            return
        }
        
        //To more easily calculate the vertical space needed for our scrollview
        //we're going to add a contentview to the scrollview, then add all subviews to this contentview
        //This way we can easily calculate the size needed for our scrollview by looking at the size of the contentview
        contentview.mas_makeConstraints({ make in
            
            make.top.equalTo()(self.scrollview.mas_top)
            make.width.equalTo()(self.scrollview)
            make.height.greaterThanOrEqualTo()(self.scrollview)
            make.centerX.equalTo()(self.scrollview)
            return
        })
        
        //Note that I'm we're only setting position related constraint from our view controller.
        //Here we're pinning the top of the first expandingView to the top of our content view, and setting their centers to be equal
        //The expandingView itself will determine it's own height and width for this example.
        expandingView1.mas_makeConstraints({ make in
            
            make.top.equalTo()(self.contentview.mas_top).offset()(10)
            make.centerX.equalTo()(self.contentview)
            return
        })

        //Pin the top of the second expandingView to the bottom of the first one with padding of 10 points
        expandingView2.mas_makeConstraints({make in
            
            make.top.equalTo()(self.expandingView1.mas_bottom).offset()(10)
            make.centerX.equalTo()(self.contentview)
            return
        })

        //The buffer isn't technically nessesary, but I like to have a little space at the bottom.
        //Here we're saying that our buffer should be at least 50pts vertially.
        //We're pinning the top of the buffer to the bottom of the second expandingView
        //and we're pinning the bottom of the buffer to the bottom of the contentView.

        buffer.mas_makeConstraints({ make in
            
            make.height.greaterThanOrEqualTo()(50);
            make.width.equalTo()(self.contentview)
            make.centerX.equalTo()(self.contentview)
            make.top.equalTo()(self.expandingView2.mas_bottom)
            make.bottom.equalTo()(self.contentview.mas_bottom)
            return
        })
        
        //**Notice**
        //We've connected every subview of our contentview.
        //Now whenever one of these subviews changed it's height the others will position themselves accordingly,
        //so we don't have to worry about them overlapping in unpredictable ways, and stretching one will always stretch the contentview
        //to fit, so we can determine the mininum size we'll need for our scrollView by looking at our contentview.size

        //We've updated the constraints so let's call layout
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    //This method is called whenever we call layoutIfNeeded on a view
    //Subviews of this view should call super.layoutIfNeeded as well as their own, when they update their constraints.
    //This way the message is passed up the chain of views and our all of our related views can respond accordingly
    override func viewDidLayoutSubviews() {
    
        //We'll need to manually update the scrollview.contentSize if we actually want it to scroll.
        //Calling this everytime the viewDidLayoutSubviews is called will ensure that we don't get into weird scroll 
        //issues where the a view is "stuck" under the bottom of the scrollable area.
        self.scrollview.contentSize = self.contentview.frame.size
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

