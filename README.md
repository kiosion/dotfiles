<pre>
_________/\\\_____________________________________/\\\\\________/\\\\\\________________________________        
 ________\/\\\___________________________________/\\\///________\////\\\________________________________       
  ________\/\\\____________________/\\\__________/\\\_______/\\\____\/\\\________________________________      
   ________\/\\\______/\\\\\_____/\\\\\\\\\\\__/\\\\\\\\\___\///_____\/\\\________/\\\\\\\\___/\\\\\\\\\\_     
    ___/\\\\\\\\\____/\\\///\\\__\////\\\////__\////\\\//_____/\\\____\/\\\______/\\\/////\\\_\/\\\//////__    
     __/\\\////\\\___/\\\__\//\\\____\/\\\_________\/\\\______\/\\\____\/\\\_____/\\\\\\\\\\\__\/\\\\\\\\\\_   
      _\/\\\__\/\\\__\//\\\__/\\\_____\/\\\_/\\_____\/\\\______\/\\\____\/\\\____\//\\///////___\////////\\\_  
       _\//\\\\\\\/\\__\///\\\\\/______\//\\\\\______\/\\\______\/\\\__/\\\\\\\\\__\//\\\\\\\\\\__/\\\\\\\\\\_ 
        __\///////\//_____\/////_________\/////_______\///_______\///__\/////////____\//////////__\//////////__
</pre>


Dotfiles are how you personalize your system and programs, these are mine! :)

I was tired of having everything unorganized, and slightly different on all my devices. That inspired me to upload my most common config files here, both to use when distro-hopping and in case anyone wanted to use my configs as starting points!

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — ex: "Java" — you can add a java directory and put files in there. Anything with an extension of .fish (my preferred shell) will be automatically included in your shell. Anything with an extension of .symlink will get symlinked without extension into $HOME/ when you run [script/bootstrap](script/bootstrap).

## What's inside

A lot. Check them out in the file browser above to see what components may work for you. Fork it, remove what you don't use, and build on what you do.

## Components

There's a few special files.

    bin/: Anything in bin/ will get added to your $PATH and be made available everywhere.
    topic/*.fish: Any files ending in .fish get loaded into your environment.
    topic/path.fish: Any file named path.fish is loaded first and is expected to setup $PATH or similar.
    topic/completion.fish: Any file named completion.fish is loaded last and is expected to setup autocomplete.
    topic/install.sh: Any file named install.sh is executed when you run script/install. To avoid being loaded automatically, its extension is .sh, not .fish.
    topic/*.symlink: Any file ending in *.symlink gets symlinked into your $HOME. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run script/bootstrap.

## Install

Run this:
```
git clone https://github.com/kiosion/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```
*( Work in progress, I'm adapting [holman's install script](https://github.com/holman/dotfiles/blob/master/script/bootstrap) to work for my setup )*

This will symlink the appropriate files in .dotfiles to your home directory. Everything is configured and tweaked within ~/.dotfiles.

The main file you'll want to change right off the bat is fish/fishrc.symlink, which sets up a few paths that'll be different on your particular machine.

dot is a simple script that installs some dependencies, sets sane macOS defaults, and so on. Tweak this script, and occasionally run dot from time to time to keep your environment fresh and up-to-date. You can find this script in bin/.
bugs

I want this to work for everyone; that means when you clone it down it should work for you even though you may not have rbenv installed, for example. That said, I do use this as my dotfiles, so there's a good chance I may break something if I forget to make a check for a dependency.

If you're brand-new to the project and run into any blockers, please open an issue on this repository and I'd love to get it fixed for you!
thanks

## Thanks to

I used holman's great dotfiles repo for this readme, and took inspiration from some of their configs. Go check out [their project](https://github.com/holman/dotfiles)!
