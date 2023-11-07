# bulletproof_auth

Firebase authentication and state management using Riverpod. Routes using Routemaster.

Heavily inspired by Rivaan Ranawat's excellent https://github.com/RivaanRanawat/flutter-reddit-clone  See the entire 9.5 hour video at https://www.youtube.com/watch?v=B8Sx7wGiY-s

## Getting Started

- Clone me.

- After cloning, you will need to create your platform directories.  From the main directory simply run

```flutter create .```

- Next, you will need to configure flutterfire to add your firebase credentials. Grab a basic video on firebase setup if this is something you need help with.

```flutterfire configure```

- replace the default Podfile in /ios with the one supplied in ios-dist.  It adds one line to prefetch all the firebase packages. Big time saver!

- you may be asked to do something with android.  I don't know, I'm an IOS guy. Sorry.