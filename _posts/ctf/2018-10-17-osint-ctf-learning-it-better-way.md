---
layout: post
title: 'OSINT C.T.F: Learning it the Better Way'
image: /assets/img/blog/2018-10-17/image1.png
description: >
  A good teacher can inspire hope, ignite the imagination, and instill a love of learning.
  - Brad Henry
category: ctf
tags: [create]
---

- Table of Contents
{:toc}

## Prologue

`O`pen `S`ource `INT`telligence, is a technique of `collecting data from publicly available sources to produce actionable intelligence`.

While roaming the internet space, I came by a YT video titled; open-source intelligence, what I learned being an OSINT creeper by Josh Huff. After watching the video, I was excited and eager to learn more. I proceeded to give it a try, but after a few trials, I felt like I had no grip on the methodology presented by Josh.

{: style="padding-top: 2em"}

{% include youtube.html id='6kBOCnOlwqI' %}

{: style="padding-top: 2em"}

Maybe I would find a CTF challenge on OSINT that I could solve, but there wasn't any. Most of the challenges I found were by DEFCON, and they were on site but had taken recordings which I binged on them for a while. A few minutes later, I had a light bulb moment; why don't I create my challenge. Ding!! Ding!! Ding!!

Excitement and fear rushed through my veins. I went ahead to prepare a storyline and did some research to make the challenge solvable.

## The Challenge

The platform I decided to use for hosting the challenge was the Facebook C.T.F (F.B.C.T.F). It was quite easy to set up; however, if you have some other service using port `80`, I would advise you to either shut down the running service or change the Apache service port from `80` to `1234` on the configuration file.

The storyline creation process was quite a challenge because I had to use publicly accessible data to correlate and make a story out of them. The storyline I came up with was of a young boy who was an orphan, being moved from one orphanage to another with him, always seeking to find a place he could call home. Later on, he sought vengeance on a former colleague who used to be at his sanctuary place for destroying the home's reputation.

while re-writing this post, I noticed the storyline was vague, but it was what I had at that moment.
{: .note}

A [guide](https://github.com/iAmG-r00t/OSINT-CTF/blob/master/PWN3RS%20OSINT%20CTF%20GUIDE.pdf) was provided to the players, where they were to follow a specific path from one country to the other while solving all seven levels.

Apart from the guide, a methodology (borrowed from Josh Huff's talk) and a link to the OSINT framework were provided.

1. Starting with the Known Data points.
2. Setting your Intelligence goals.
3. Gathering your tools.
4. Analyze how your data points are connected.
5. Pivoting, using new data points.
6. Repeat steps `3` to `5`.
7. Validate if your target data is correct.

{: .text-align-center}
Below are images to showcase how the playground looked like, with the challenges.
{: .faded}

![image2](/assets/img/blog/2018-10-17/image2.png){: .centered}

FBCTF Dashboard
{:.figcaption}

![image3](/assets/img/blog/2018-10-17/image3.png){: .centered}

FBCTF Task
{:.figcaption}

## Epilogue

It was an amazing experience. I got the opportunity to create something that allowed me to learn and share my knowledge. I am looking forward to doing more of this on different topics.

The first player who completed the challenge was [Antony](https://twitter.com/AntonyMutiga) Mutiga](https://twitter.com/AntonyMutiga). His write-up is attached in the resources section (the funny thing is that he was my teammate at the AfricaHackOn CTF event 2018, a story for another day).

I am happy to say this was a success, and I have provided all the configs of the challenge for anyone who wants to set it up.

The OSINT framework is enough to guide you in solving the challenges. Give it a try.
{: .note}

## Resources

1. [OSINT Framework.](https://osintframework.com/)
2. What I learned by being an OSINT creeper [John Huff](https://www.youtube.com/watch?v=6kBOCnOlwqI).
3. [FBCTF](https://github.com/facebook/fbctf).
4. FBCTF ([Categories and Challenges](https://github.com/iAmG-r00t/OSINT-CTF)) Export.
5. [Write-up](https://github.com/iAmG-r00t/OSINT-CTF) by [@AntonyMutiga](https://twitter.com/AntonyMutiga)