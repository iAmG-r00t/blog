---
layout: post
title: 'Out Of The Rabbit Hole Adventures: AppSec in the flesh'
image: /assets/img/blog/2020-02-24/image1.gif
description: >
  Intellectual growth should commence at birth and cease only at death.
  - Albert Einstein
category: ctf
tags: [re, appsec]
---

Aplogoies for any rough images, they were migrated from blogger.
{:.note title="APOLOGY"}

- Table of Contents
{:toc}

## Prologue

Hi, 👋 happy new year 🎉.  In my previous [post], I talked about the lessons I learned while learning to find bugs in a mobile application.

So I decided to write this blog post and bring the adventure to an end.

Last year I attended AfricaHackon. Despite not participating in the CTF contest as a player, I did try to solve the challenges, but this time I took more interest in the Mobile Apps, RE, and pwn challenges.

This post will focus on the mobile application and its challenges.

The players were provided an APK file. When I got hold of the APK file, I installed it on my test device, a Homepesa Sacco application with a login and register account when spawned.

There were six challenges, so before starting to solve the challenges, I decided to do some recon to understand the application.

## Recon

Below are the steps I usually follow to get to understand the application;

1. **Decompile the application** (one can use apktool or change the filename extension from dot apk to dot zip, then unzip it using any archive utility, e.g., 7zip, WinRAR, e.t.c ...); this allowed me to view the source code of the app.
2. **Read the manifest file** to identify application-defined permissions, look for any misconfigurations set, locate exported activities or services, and identify broadcast receivers and content providers.
3. **Used [drozer]** to identify any attack surface present and look for files that are being stored locally in the application directory.

## Challenges

Afterward, I decided to look at the challenges and focus on what is required, getting the flags. There were six challenges; I will explain how I was able to attain the flag for each challenge.

{: .text-align-center}
### Challenge 1: Manifestation

From the challenge title, it seemed like we were to look at the manifest file, but I never spotted it during my recon process. After consulting with the creator, he said the flag was a comment in the manifest file. One couldn't attain the flag for this challenge because it wasn't there. The application comments placed in the manifest file were removed when he compiled the source code.

{: .text-align-center}
### Challenge 2: Registration Payment Bypass

![image2)](/assets/img/blog/2020-02-24/image2.png){: .centered}

chall2: `challenge description`
{:.figcaption}

For the second challenge, I went ahead with registering an account, and during the last step of registration, one was required to make a registration payment. When reviewing the code, I saw the flag right there hardcoded in the `Home` class.

![image3](/assets/img/blog/2020-02-24/image3.png){: .centered}

chall2: `hardcoded flag`
{:.figcaption}

Most of the players went ahead and submitted this flag, but for me, I wasn't satisfied. This wasn't the proper way of attaining the flag. So I went ahead and reviewed the code. A `bitwise` database file was created when the **onCreate** method was called, and data was placed in the database during the account creation process.

![image4](/assets/img/blog/2020-02-24/image4.png){: .centered}

chall2: `onCreate method`
{:.figcaption}

The Alert statement was triggered after checking the `bitwise` database if the account status was active or not active, and if an account is active, it's when we are presented with our flag.

![image5](/assets/img/blog/2020-02-24/image5.png){: .centered}

chall2: `data being placed on database`
{:.figcaption}

![image6](/assets/img/blog/2020-02-24/image6.png){: .centered}

chall2: `Alert Statement`
{:.figcaption}

That being the logic, I went ahead and installed an SQLite DB editor android application, picked the application database `bitwise` went to the user's table where I changed the default value `0` of column `acstatus` to `1`.

{: .text-align-center}
![image7](/assets/img/blog/2020-02-24/image7.png)
![image8](/assets/img/blog/2020-02-24/image8.png)

chall2: `bitwise DB in SQLite DB Editor`
{:.figcaption}

When spawning the application again I was present with the alert Response message.

![image9](/assets/img/blog/2020-02-24/image9.png){: .centered}

chall2: `Alert message with flag.`
{:.figcaption}

**Flag2;** `P4ym3n7Bypa$$`

Remembering this challenge, there was an issue with payment verification while registering.
{:.note title="UPDATE"}

{: .text-align-center}
### Challenge 3: Spoiler! SQLPwned(Answer is entry point)

![image10](/assets/img/blog/2020-02-24/image10.png){: .centered}

chall3: `challenge description`
{:.figcaption}

This was a very interesting challenge. I learned a new attack vector before the event was about to end. The challenge had zero solves, so we were given a clue, try to log in with a correct email address but a wrong password. I did that, and I was presented with an alert box saying that I had entered the wrong password, prompting me if I wanted to recover the password. So I proceeded and placed my email on the recover password page and was sent a recovery link in the email address I provided.

Opening the email address in the browser, I was presented with a page where I was to set a new password to reset it.

![image11](/assets/img/blog/2020-02-24/image11.png){: .centered}

chall3: `Recover Password Page`
{:.figcaption}

Looking at the URL link; `http://159.203.60.168/recoverypassmy.php?id=9408` seems like we can test for SQL injection. I proceeded to test, and my tool of choice was [sqlmap].

Command: `sqlmap -u URL -b`

![image12](/assets/img/blog/2020-02-24/image12.png){: .centered}

chall3: `SQL Map`
{:.figcaption}

Boom, we have an SQL injection present, and we have our entry point **`recoverpassmy.php`**, our flag.

**Flag3;** `recoverpassmy.php`

{: .text-align-center}
### Challenge 4: Prove Yourself, Exploit!

![image13](/assets/img/blog/2020-02-24/image13.png){: .centered}

chall4: `challenge description`
{:.figcaption}

For the next challenge, I used the SQL injection to enumerate the tables in the database, then found an admin table, dumped its contents, and found the md5hash for the admin.

Command for enumerating DB tables: `sqlmap -u URL --tables`

![image14](/assets/img/blog/2020-02-24/image14.png){: .centered}

chall4: `Enumerated tables`
{:.figcaption}

Command for dumping table contents: `sqlmap -u URL --dump -D homepesa -T admin`

![image15](/assets/img/blog/2020-02-24/image15.png)

chall4: `Admin table contents`
{:.figcaption}

**Flag4;** `e64b78fc3bc91bcbc7dc232ba8ec59e0`  

{: .text-align-center}
### Challenge 5: Let's catthehash

![image16](/assets/img/blog/2020-02-24/image16.png){: .centered}

chall5: `challenge description`
{:.figcaption}

This will be short. Md5 hash isn't the best encryption. The best thing about sqlmap is that it's capable of decrypting/cracking hashes with either a custom (which you feed it) or default wordlist. But there are also other ways of decrypting md5 hashes.

![image17](/assets/img/blog/2020-02-24/image17.png){: .centered}

chall5: `sqlmap brute-forcing md5 hash`
{:.figcaption}

**Flag5;** `Admin123`

{: .text-align-center}
### Challenge 6: Our SMS Gateway Pwned??

![image18](/assets/img/blog/2020-02-24/image18.png){: .centered}

chall6: `challenge description`
{:.figcaption}

Obtaining the flag for the last challenge was tough. I stared at the code for a while, and the way I found the flag was more on checking each class involved in sending SMS.

I would love to point out that the way I solved this challenge was not the proper way from the creator's point of view. He mentioned that one had to intercept or do a man-in-the-middle attack on the SMS request to solve the challenge. For me, I found the flag hardcoded in the code.

The issue being SMS gateway owned, SMS-gateway qual to an API, this being my theory I looked at various classes starting from the **`MobilesasaClient`** class where it has a field for `flag 3`.

![image19](/assets/img/blog/2020-02-24/image19.png){: .centered}

chall6: `MobilesasaClient Class`
{:.figcaption}

When I saw this, I knew that I was close. So I decided to look at the **`MySMSBroadcastReceiver`** class, where there was nothing interesting. But after sitting down and looking at the **`MobilesasaClient`** class, I noticed a small detail I had missed **`sendSMS`**. I used that to query for any other string containing the exact string and found the flag in the **`ConfirmPhone`** class.

![image20](/assets/img/blog/2020-02-24/image20.png){: .centered}

chall6: `ConfirmPhone class with flag`
{:.figcaption}

**Flag6:** `N37w0rk@n@lysisM0bileS@s@`

As we can note, the flag states we should have done a network analysis to solve the challenge. Next time I will have that in mind.

## Epilogue

I enjoyed solving the challenges where I got the opportunity to learn something new. I would love to thank the creator [@shellcode254] and the [@AfricaHackon] team.


## Resources

> The following will get you started, Enjoy.

- [Android Explorations](https://nelenkov.blogspot.com/)
- [Android Hacking and Security](https://github.com/nixawk/pentest-wiki/tree/master/2.Vulnerability-Assessment/Android-Assessment)
- [Mobile App Pentest Cheatsheet](https://github.com/tanprathan/MobileApp-Pentest-Cheatsheet)
- [Awesome Android Security](https://github.com/ashishb/android-security-awesome)
- [Android Reports and Resources](https://github.com/B3nac/Android-Reports-and-Resources)
- [Static Analysis of android applications](https://tthtlc.wordpress.com/2011/09/01/static-analysis-of-android-applications/)
- [Mobile Application Hacking Diary Ep.1](https://www.exploit-db.com/papers/26620)
- [Mobile Application Hacking Diary Ep.2](https://www.exploit-db.com/papers/44145)
- [Android Stuff and Security Research](http://www.mulliner.org/android/)
- [Mobile App CTFs](https://github.com/xtiankisutsa/awesome-mobile-CTF)
- [Learn Android Security](https://androidtamer.com/learn_android_security)
- [Hacking Android Apps with Frida](https://android.jlelse.eu/hacking-android-app-with-frida-a85516f4f8b7)
- [Introduction to Android Hacking by @0XTEKNOGEEK](https://www.hackerone.com/blog/androidhackingmonth-intro-to-android-hacking)
- [Mobile Security Testing Guide](https://mobile-security.gitbook.io/mobile-security-testing-guide/)
- [Mobile Hacking Crash Course](https://www.hacker101.com/sessions/mobile_crash_course.html)
- [Somedev's Way](https://twitter.com/s0md3v/status/1150845512838332416)
- [Elliot Alderson Way](https://twitter.com/fs0c131y/status/1129680329994907648)

[post]: /blog/scripts/2019-04-17-rabbit-hole-adventures-appsec-teaser/
[drozer]: https://labs.f-secure.com/tools/drozer/
[sqlmap]: https://github.com/sqlmapproject/sqlmap
[@shellcode254]: https://twitter.com/shellcode254
[@AfricaHackon]: https://twitter.com/AfricaHackon