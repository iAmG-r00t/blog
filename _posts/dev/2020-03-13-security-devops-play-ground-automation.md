---
layout: post
title: Security + DevOp's Play Ground Automation Setup
image: /assets/img/blog/2020-03-13/image1.gif
description: >
  Automation may be a good thing, but don't forget that it began with Frankenstein. - Anonymous
category: dev
tags: [Automation, Bash]
---

- Table of Contents
{:toc}

## Prologue

**`Problem statement;`** I used to use a virtual environment as my playground to break and tinker around with stuff, then got a new laptop and I had to set up the whole environment from zero to how my virtual environment state was. I did it the first time manually and when I was done setting up everything found out that the hard disk for the new laptop was faulty 🤬. I had to replace the hard disk and re-do the setup all over again. It was tiresome and it took me a whole week because each time I was faced with a problem that I had to fix, format the disk, reinstall the OS, and re-do the setup.

I got tired of that cycle and I decided to google around for a solution and I came by a [post](https://victoria.dev/blog/how-to-set-up-a-fresh-ubuntu-desktop-using-only-dotfiles-and-bash-scripts/) by [Victoria Drake](https://victoria.dev/). Which made me realize that I can automate my setup process and make my life easy.

First I want to start by noting down my `playground gadgets` and then proceed to explain why I decided to use the bash shell script and not the other fancy stuff (like Vagrant, puppet, chef, or ansible).

## Playground gadgets

I have four major gadgets that I use on a normal day, which are;

  1. `Tmux` - handles all my terminal sessions and screens.
  2. `Vim` - this is my Integrated Development Environment.
  3. `Keepass2` - handles all my SSH keys and stores some of my passwords.
  4. `bash` - preferred shell, this is where I call home. (I defaulted to using bash instead of ZSH)

## Why shell script ??

I decided to use shell script because it will allow me to better understand the language and fine-tune my coding skills plus it comes by default in most Unix systems. While with the other fancy tools I would be forced to install and maybe configure.

## Dotfiles

Most of the above-mentioned gadgets have configuration files that are called `dotfiles`. I won't go into detail on each dotfile check out `Victoria's post` she has done most of the explanation, but I will try my best not to skip the most important bits.

For the structure of my dotfiles, I decided to place all my dotfiles in one directory, then each config in its directory with its name.

![image1](/assets/img/blog/2020-03-13/image1.png){: .centered}

dotfiles: `dotfiles structure`
{:.figcaption}

  * The image above is the representation of how I have arranged my config files before you get to question why let me mention that I am a neat freak (kind of), my mind is as organized as a library so that's why!! now you can go ahead and judge me but it works for me, just do you!

  * In the `.bash` folder, I have two aliases one that does contain the normal aliases and the other that contains aliases that have secrets, tokens, and IPs.

  * The `vim` folder contains the `YouCompleteMe` vim plugin config which I stole from [Jonas [Devlieghere](https://jonasdevlieghere.com/a-better-youcompleteme-config/) and the vim config file.

  * The `eddie` folder contains a `greetings.txt` file which contains lines I would like the [eddie-terminal](https://github.com/victoriadrake/eddie-terminal) to tell me each time I spawn my terminal. Awesome right!! The project is by the one and only [Victoria Drake](https://victoria.dev/).

  * The last folder was for Oh-My-ZSH which I currently don't use in my setup. But it contained various files that were from the bash folder but for the Oh-My-ZSH shell.

## Setup Scripts

For the setup scripts, I will explain the major parts. You can go ahead and check out the whole [project repo](https://github.com/iAmG-r00t/desktop-setup) on my [Github](https://github.com/iAmG-r00t).

1. **dotfiles.sh** setups all my dotfiles, it does more than that so you should have a look at it.
2. **desktop.sh** setups up my folders and desktop environment look and feel. This includes setting up a screensaver, background image, user profile icon, and favorite apps on my dock. (`Kindly read Victoria Drake's post, she explained how to do it`, I would like to mention that some settings like renaming the trash on the desktop don't work in Ubuntu 19 but works efficiently with ubuntu 18, you can play around with it have fun!!)
3. **software.sh** installs all the packages I use on a day-to-day basis and the dependencies required to install all the applications.
4. **setup.sh** brings all the scripts together this is where it all starts, also it does some cleanup, installs vim and tmux plugins, ~~changes my default shell from bash to zsh~~, and then logs out the desktop for some settings to take effect.
5. **sync.sh** syncs all my dotfiles from the home user directory to the local Github repository so that I can update the remote repository.

## Secrets🙊, how do you handle them?

**_The fun part;_** so when I was reading Victoria's post she pointed out that some files that one wouldn't put on a public repo won't / shouldn't be pushed to the remote repository (`best security practice`), that was a problem for me because I wanted to backup everything and at the same time share it to the world. Github doesn't allow one to set some directories in a repository as private so I had to think of a solution to my problem.

After some research, I found a lot of [solutions](#sols) on how to achieve this but I decided to stick with [git-secret](https://git-secret.io/). It uses GPG RSA key pair to encrypt all of your desired secret files and allows you to push them to a public repository, which you can later decrypt in your local environment using the same GPG key.

## SSH Keys

I am paranoid and at the same time lazy. I required a way to log in to my servers efficiently the same way I log in to my online accounts using [LastPass](https://www.lastpass.com/).

There is a way of doing this [using LastPass](https://devopsheaven.com/ssh/security/lastpass/devops/2018/06/13/ssh-lastpass-cli.html) but there were two issues with that, one is that I love to separate my work and social life (**_I do have two separate machines for this ..._**) meaning I needed a way to store all the passwords that I use during work separately from my mere Gmail and other personal account passwords. 

After some research I decided to use [KeePass](https://keepass.info/index.html), I had heard about it during the time I was working at Safaricom PLC but I never knew it had great perks.

It allows you to store SSH keys and has a plugin known as [KeeAgent](https://keeagent.readthedocs.io/en/stable/) which acts as an [ssh-agent](https://www.ssh.com/ssh/agent), which allows you to log in to your servers when the KeePass database file is open without prompting for the ssh-key passphrase.

KeePass has a lot of plugins that do a variety of things, so I decided to look for a way to backup my passwords somewhere and that's when I found [KeeCloud](https://bitbucket.org/devinmartin/keecloud/wiki/Home), It allows you to store a backup in Dropbox and sync the local file with the dropbox file using triggers or manually using KeePass Synchronize option.

## Epilogue

All that being said and done, I need to mention that I will be updating this setup process as time goes by, so if you are reading this blog now or later in the future, check out my Github repository for any updates.

Now let me showcase my work before I end this post, I hope the demo gods will spare me today.

[![asciicast](https://asciinema.org/a/cM0sOz8r2idXdf2E4arL0bhFM.svg)](https://asciinema.org/a/cM0sOz8r2idXdf2E4arL0bhFM)

It backups well, I will be using a default install of ubuntu 18 running in a virtual environment. Enjoy!!

{: style="padding-top: 2em"}

{% include youtube.html id='oNDbW7nxqBM' %}

{: style="padding-top: 2em"}

Before I end this post sorry for the shaky video was recording with my phone, next time I will look for better solutions for such situations. Anyways thank you for your time.

I reconstructed the whole project in 2020 quarter three during the covid period into single modules. In January 2021 when I was creating some challenges for the [Aspire CTF](https://ciphercode.dev/) I ended up deleting my whole 2020 projects directory that I hadn't backed up to GitHub (Backups are important BTW). Hence this project will be redone.
{:.note title="UPDATE"}

{: id="sols"}

## Resources

* [An Introduction to Managing Secrets Safely with Version Control Systems](https://www.digitalocean.com/community/tutorials/an-introduction-to-managing-secrets-safely-with-version-control-systems)
* [Managing dotfiles with Git and Encryption](https://umanovskis.se/blog/post/dotfiles/)
* [Thirty DevOps Tools and Technologies](https://www.guru99.com/devops-tools.html)
* [Encrypt password files and sensitive info in your git repo](https://coderwall.com/p/qzzfrw/encrypt-password-files-and-sensitive-info-in-your-git-repo)
* [Infra-secret-management-overview](https://gist.github.com/maxvt/bb49a6c7243163b8120625fc8ae3f3cd)
* [How to keep your password repository's sensitive data secure using git-secret](https://medium.com/@GeorgiosGoniotakis/how-to-keep-your-repositorys-sensitive-data-secure-using-git-secret-c1ddc28cb985)
* [Password management, cross-platform and in the cloud](http://julien.coubronne.net/en/2016/07/14/password-management-cross-platform-and-in-the-cloud/)
* [Dropbox setup for dummies](https://bitbucket.org/devinmartin/keecloud/issues/19/dropbox-setup-for-dummies)
* [Remove standard bookmarks in Nautilus](http://www.arj.no/2017/01/03/nautilus-bookmarks/)
* [Project repository](https://github.com/iAmG-r00t/desktop-setup)