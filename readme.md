# How it all started: A love and hate story.

Since the first time I had to use an UIActionSheet or UIAlertView in an app I disliked the way it was implemented. It was a pain if you had two kinds of alerts in the same class for example as everything is done by invoking a delegate method. I also disliked the fact that the code that should be executed in the event of a button was almost always in a separate place in your source code. The code needs a lot of constants, switches and you need to tag your UIAlertView.... I hated it!

But on the other hand they are very useful for asking information in a modal way so I kept using them when it was appropriate.

And then I found [PSFoundation][1] a library of very nice iOS utilities by [Peter Steinberger][2]. It has a LOT of useful utility classes but two stood out for me as a relief for my hatred: [PSActionSheet][3] and [PSAlertView][4].

To see an explanation on how they work, take a look at the blog post that originated PSActionSheet and inspired PSAlertView: ["Using Blocks" by Landon Fuller][5] who apparently hates UIActionSheets as much as I do.

Since I found these classes I've incorporated them into every one of my projects. And when I took over as lead developer for [Arrived's][6] [iPhone app][7] I took a few hours right at the beginning of the project to convert every UIActionSheet and every UIAlertView into a BlockActionSheet and BlockAlertView (I renamed the classes to make the name more memorable and descriptive). 

# A new kind of hate

[Arrived][6] has a very distinctive look. I love the design of the app, with lots of textures, the red carpet over the pictures on the stream, the custom buttons, the title, even the tab bar is customized to look unique. So, in the middle of all this very nice color scheme whenever I had to use an Alert View or an Action Sheet I was punched in the face by a freaking blue Alert! How I hated those Alert Views ruining the look of the app.

And then I got [TweetBot][8]. What a nice app, what a unique interface and.... what the hell? They customized their Alert Views! Super cool. Right then I thought: I gotta have this.... 

# Hate is a very effective motivator

We then decided to terminate every instance of default Alert View and Action Sheet. Since I already had every call to those wrapped with my own Block* classes, it was just a matter of changing these classes and everything should work as before, but with a much better look. And so we did it and we decided to open source it. And let me tell you they look great! 

![][9] ![][10]

But before I send you over to our repository to download this baby, let me tell you how they work and what are the current limitations. 

# Using the library

If you're familiar with the above mentioned PLActionSheet and PLAlertView you will have no problems adjusting to these classes as I didn't change their methods at all. I added some methods to make the class even better but everything that used the old classes worked with no modifications.

You'll need to import 6 files into your project: 4 for both classes (BlockActionSheet.(h|m) and BlockAlertView.(h|m)) and 2 for another view that serves as the background for the alerts and action sheets, obscuring the window to make it look very modal and make the user focus more on the dialog (BlockBackground.(h|m)). You'll never have to use this third class directly though as everything is handled by the two main classes. You'll also need the image assets that we se to draw the view, such as the buttons and background.

To create an alert view you use: 

    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title"
                                                   message:@"This is a very long message, designed just to show you how smart this class is"];
    
Then for every button you want you call: 

    [alert addButtonWithTitle:@"Do something cool" block:^{
        // Do something cool when this button is pressed
    }];
    
You can also add a "Cancel" button and a "Destructive" button (this is one of the improvements that UIAlertView can't even do): 

    [alert setCancelButtonWithTitle:@"Please, don't do this" block:^{
        // Do something or nothing.... This block can even be nil!
    }];
    
    [alert setDestructiveButtonWithTitle:@"Kill, Kill" block:^{
        // Do something nasty when this button is pressed
    }];
    
When all your buttons are in place, just show: 

    [alert show];
    
That's it! Showing an Action Sheet works almost exactly the same. I won't bore you here with more code but the repository has a demo project with everything you'll need.

You can even have more than one cancel and destructive button, despite the fact that the methods are prefixed *set* and not *add*, but this is because I wanted to keep the same names I used in the original libraries where you could only have one cancel button. Feel free to rename those if you don't have any legacy code as I had.

Another cool thing we did was add an animation when showing and hiding the new views as Tweetbot does. This is another area where you can go nuts and add all kinds of animation.

The look of the alerts and action sheets is made of a few assets for the background and the buttons so if you want to change the color scheme all you need is a little time to change ours. Check out the included assets and just change them if they don't work for you.

The only limitation these classes have so far is with device rotation. As [Arrived][11] only works in portrait this is not a problem I needed to solve. And it's not that trivial because you'd have to reposition the buttons and text because the window now has a different size and the alert might be too tall to hold a long message in landscape. And you might need to add a scroll for some action sheets too. But feel free to fork and fix this! 

# Gimme that!

You can get the everything you need from our [GitHub repository][12]. There's a demo project with lots of buttons to trigger alerts and action sheets until you get sick of them.

Another thing that's included in the project but that you might need to roll your own are the graphical assets for the buttons and backgrounds. You can use ours but they might not fit the look of your app.

Now get the project and have fun with it. Feel free to fork and add pull requests so we can incorporate your changes for everyone.

 [1]: https://github.com/steipete/PSFoundation/tree/master/Utils "PSFoundation"
 [2]: https://github.com/steipete
 [3]: https://github.com/steipete/PSFoundation/blob/master/Utils/PSActionSheet.m
 [4]: https://github.com/steipete/PSFoundation/blob/master/Utils/PSAlertView.m
 [5]: http://landonf.bikemonkey.org/code/iphone/Using_Blocks_1.20090704.html
 [6]: http://www.getarrived.com/ "Arrived"
 [7]: http://itunes.apple.com/app/id439811947?mt=8 "Arrived iPhone app"
 [8]: http://tapbots.com/software/tweetbot/
 [9]: http://blog.codecropper.com/wp-content/uploads/2012/01/iOS-Simulator-Screen-shot-Jan-20-2012-4.28.18-PM-200x300.png "iOS Simulator Screen shot Jan 20, 2012 4.28.18 PM"
 [10]: http://blog.codecropper.com/wp-content/uploads/2012/01/iOS-Simulator-Screen-shot-Jan-20-2012-4.28.23-PM-200x300.png "iOS Simulator Screen shot Jan 20, 2012 4.28.23 PM"
 [11]: http://www.getarrived.com "Arrived"
 [12]: https://github.com/Arrived/BlockAlertsAnd-ActionSheets