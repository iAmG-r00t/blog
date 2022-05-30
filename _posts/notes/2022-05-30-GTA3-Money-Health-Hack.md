---
layout: post
title: 'GTA III; Money & Health Hacked'
image: /assets/img/blog/2022-05-30/image1.png
description: >
  My primary goal of hacking was intellectual curiosity, the seduction of adventure. - Kevin Mitnick
category: notes
tags: [gamehacking]
---

- TOC
{:toc}

## Intro

This post will introduce a whole series of a game I found either last year or during covid on my friend's laptop. I did play this game while I was young, and I would love to take this opportunity to bring back the nostalgic feeling I had when completing missions but this time while hacking it as I learn and enjoy myself.

I was motivated by [Guided Hacking], from the amazing [series] on game hacking, and [Live0verflow] with some epic content on Minecraft hacking.

My main goal for this series is to Hack while I enjoy myself and maybe learn how to bypass anti-cheats. I won't go into the details or the steps to reproduce what I have been doing. Mainly explain the technical details that I found difficult or confusing, particularly for this game, while creating a cheat engine table.

## DxWnd to the Rescue

I needed a way to make the game run in windowed mode because it wasn't possible, as we can tell game developers in the year 2001 never included it.

After some research, I came by a software application from [sourceforge] known as [DxWnd], a window hooker that runs fullscreen programs in a window. I found a [thread] that contained a `.dxw`` config file which worked after some minor edits; despite that, it took me a whole day.

## Money Hack

I got two static addresses for the money value, which was easy getting it. Watch Guided Hacking [series] episode 1.

## Health Hack

Getting the health address took a toll on me. I scanned for 4bytes exact value while the value type was float. I found the address and thought I was done, but the addresses never worked when I closed off the game and started it again. I researched and found an [old video] by Guided Hacking where he showed how to solve this issue using the [AssultCube] game.

![image2](/assets/img/blog/2022-05-30/image2.png){: .centered}

Instructions that write to the Health Address
{:.figcaption}

The image above shows the instructions that write to the health address. The first instruction loads the floating-point value, and then the second instruction subtracts the value at the address `[ESP+3C`], then the remainder is at the same address it was loaded from `[EBP+2C0]`.

Following the [old video] with this information, I obtained several static addresses and confirmed the correct one that was the actual Player Object Pointer. I then took the offset we found from the instructions writing to the health address and found my actual health address that never changes even when spawning the game later on.

Below is a screen recording of the actual footage of my upcoming cheat table at work.

{: style="padding-top: 2em"}

{% include youtube.html id='W5596Egy0B4' %}

## Epilogue

Now that we have obtained the Player Object Pointer, it opens up endless hacking opportunities. Thank you for your time, and see you in the other realm.

Remember, it can be done; all that is required is some bit of practice and consistency.

## Resources

* LiveOverflow series on [hacking Minecraft](https://www.youtube.com/watch?v=Ekcseve-mOg&list=PLhixgUqwRTjwvBI-hmbZ2rpkAl4lutnJG).
* Guided Hacking [game hacking](https://www.youtube.com/watch?v=tiiQBPgSQBI&list=PLt9cUwGw6CYFSoQHsf9b12kHWLdgYRhmQ) series.
* Guided Hacking [webstite](https://guidedhacking.com/) that contains other resources on game hacking.


[Guided Hacking]: https://twitter.com/GuidedHacking
[series]: https://www.youtube.com/playlist?list=PLt9cUwGw6CYFSoQHsf9b12kHWLdgYRhmQ
[Live0verflow]: https://www.youtube.com/c/LiveOverflow
[sourceforge]: https://sourceforge.net/
[DxWnd]: https://sourceforge.net/projects/dxwnd/
[thread]: https://sourceforge.net/p/dxwnd/discussion/general/thread/c360cbc28e/
[old video]: https://youtu.be/fvv8IJGke1Q
[AssultCube]: https://assault.cubers.net/