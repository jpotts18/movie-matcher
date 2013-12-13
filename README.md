# Movie Matcher

Ios App created for IS 543 Semester Project. Uses Rotten Tomatoes API to pull in movie clips. 

Here is my semester project. I really enjoyed this project, I hope you do too. Please open the xcworkspace not xcodeproj before you run. 

I ran into rate limiting problems with the rottentomatoes API. I have requested extended access and I have used NSLog to show you where this problem could happen. 

Some features that I ended up implementing:

 - I used two, third-party libraries (AFNetworking, and SDWebImage) these were installed using Cocoapods, an obj-c dependency management system. This is why you have to open from xcworkspace.
 - MMLoader class is used to load my data model into a MMGame singleton. This implemented many asynchronous block statements due to the way the API is set up. 
 - MMLoader uses delegates and protocols to notify the MMViewController when the model was finished loading. This was a challenging concept to learn, but it learned a lot. 
 - I used NSUserDefaults to store usernames between sessions on the MMGameSetupController. 
 - NSTimer was used to countdown and award points in the game.
 - MMGame model implements randomization and duplicate checking. 
 - MMLeaderboardViewController shows Leaderboard, but does not save leaderboard over applications sessions.
