---
layout: post
title: 'AH-CTF 2019 iamfree'
image: /assets/img/blog/2022-08-14/image1.png
description: >
  Well, if it can be thought, it can be done. A problem can be overcome.
  - Yoko Ogawa, The Housekeeper and the Professor
category: ctf
tags: [re, pwn]
sitemap: false
---

I was second-guessing myself on releasing this post because I felt like it was too simple in general. But this is my log, we still have to log it despite its simplicity.
{:.note}

- Table of Contents
{:toc}

## Intro

I am still trying to be consistent on blogging 😃. In Other news, I finally attained my [Yellow Belt] (search for gr00t) from [pwn.college]. I am planning to get the Blue Belt before the end of the year. Received some interesting (neither sad or happy) news and solved an interview assessment (crossing my fingers on that one).

Alot has been going on but we still move. This post is for a challenge from the AfricaHackon CTF competition 2019. It was in my to do list for a very long time and after years of attaining knowledge on binary exploitation and reverse engineering, I went back to tackle and solve the challenge.

Sit down, relax and enjoy.

## Challenge

The challenge was under pwn category and two files, the source code and binary were provided.

Let's take a look at the source code. At first, when I was looking at the code (in 2019), I thought it was a buffer overflow challenge but when seeing it define `gets_s` that uses `fgets` which checks the input size, that option was out of the equation.

After the competition, the challenge creator gave us another clue, [Use After Free].

~~~c
/* File: 'iamfree.c' */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>

 #define gets_s(x, len) fgets((x), (len) + 1, stdin)

struct moves_t  {
  unsigned int king;
  unsigned int queen;
  unsigned int  pawn;
  unsigned int checkmate;

};

int main( int argc, char *argv[] ) {

  setuid(1007);  
  struct moves_t *myMove;
  int size = sizeof(struct moves_t);

  struct moves_t *play = malloc(size);
  printf("Let play a game of chess\n");
  
  while(1){
    
    printf("Make your move : ");
    gets_s(play,size);

    if(play->king == 0x46524545 && play->queen == 0x71756565 && play->pawn == 0x6e333e3a){

        free(myMove);
        printf("Nice move. I can't catchup\n");
    }
    else if(play->king == 0x4e455721 && play->queen == 0x4b494e47 && (unsigned char)((play->pawn   ) * sizeof(int) + 5) == 0x1){
      
        myMove = malloc(size);
        myMove->checkmate = play->checkmate;

        printf("King placed in order\n");
      
    }
    else if(play->king == 0x75733334 && play->queen == 0x66743352 && play->pawn == 0x66523333){

        printf("Brilliant. One last Move\n");

        if ((unsigned char)myMove->checkmate == (unsigned char)0x6d343137)
        {
          system("/bin/cat flag");
          return 0;
        }
    }
    else{
      printf("Wrong move\n");
    }
  }
  
  return 0;
}
~~~

Once again carefully looking at the source code, we can see a `struct` called `moves_t` with four members; `king`, `queen`, `pawn` and `checkmate` defined.

Inside the main function it sets and defines several variables;
  - `userid` (don't remember why, looks like user access control)
  - struct `moves_t` pointer `myMove`
  - size (of size of struct `moves_t`)
  - struct `moves_t` pointer `play` (allocated with memory of size variable)

Then we have a printf statement that will print the string, `Let play a game of chess` then strats a never ending while loop.

Insides our while loop we have one printf statement that will print the string `Make your move : `, then wait for our input of size 16 is copied to the struct pointer `play`.

We then have four if statements that each compare our struct member to specific hex data.

- If we pass the first if statement, a `free` operation will be performed on our struct pointer `myMove` and the program will print the string, `Nice move. I can't catchup.`.
- If we pass the second if statement our struct pointer `myMove` will be allocated data, then the struct member `checkmate` for `myMove` will be the same as for what the `play` pointer holds and the program will print the string, `King placed in order`.
- If we pass the third if statement, we end up in the last if statement.
- If we pass the last if statement, the program runs a system command `/bin/cat` against file `flag` that will output its content.

## Use After Free

Our main goal is to pass the last if statement to get the flag. To better understand how to reach our goal we need to understand how [Use After Free] works.

In C, the `malloc()` function will allocate memory on the heap and return a pointer to the address of the allocated memory. Then there is the `free()` function that will deallocate the address of the memory allocation presented by the pointer returned from `malloc()`. When a block of memory is freed the memory stored at that space remains there until modified or overwritten.

This becomes a bug/vulnerability when the pointer of the deallocated memory address is still being used again after being freed.

## Exploitation

This section is going to include screenshots that I think will better describe the bug.
{:.note}

I came to realize while debugging the program under GDB, is that the hex values are not just random but they are actual ASCII strings 🤦🏾‍♂️. Didn't think of trying to decode them with [CyberChef] - The Cyber Swiss Army Knife by GCHQ.

Lets proceed and inspect our two struct pointers in the heap with GDB to better understand how to solve the challenge.

![image2](/assets/img/blog/2022-08-14/image2.png){: .centered}

partial main function program in assembly
{:.figcaption}

At the variable definations section, we can see right after `malloc` being called the address to the allocated memory which is stored at `eax` being moved to a DWORD (4 bytes) pointer at `ebp-0x14` (which is the `play` pointer struct).

![image3](/assets/img/blog/2022-08-14/image3.png){: .align-right}

To confirm this if we proceed inside our infinite loop, we can see right before `fgets` being called three variables being pushed to the stack; `stdin` address that was moved to `eax` from `ebx+0x38`, the `size` that was moved to `edx` from `ebp+0x10` and our `play` pointer `ebp-0x14`.

Which we can see are the arguments being passed to `fgets`.

{: style="padding-top: 2em"}

When we set our break point right after `fgets` can see our input pointer address to the heap at `ebp-0x14`.

![image4](/assets/img/blog/2022-08-14/image4.png)

Verifying our input pointer `play`
{:.figcaption}

We are going to proceed an inspect the the second pointer after malloc and then after `myMove->checkmate = play->checkmate being` executed.

![image5](/assets/img/blog/2022-08-14/image5.png){: .centered}

First two if statements in assembly
{:.figcaption}

![image6](/assets/img/blog/2022-08-14/image6.png){: .centered}

After malloc invocation, heap inspection
{:.figcaption}

![image7](/assets/img/blog/2022-08-14/image7.png){: .centered}

After `myMove->checkmate = play->checkmate` invocation, heap inspection
{:.figcaption}

~~~py
# File: 'sol.py'
#!/usr/bin/env python3
"""
Creates an exploit
AH CTF19 pwn; iamfree
"""

def convert(data):
    out = ''
    for x in data.split(' '):
        out += bytes.fromhex(x[2:]).decode()[::-1]                                                                                                                                                                                                                              
    return out

KING = '0x4e455721 0x4b494e47 0x4141413f 0x6d343137'
FREE = '0x46524545 0x71756565 0x6e333e3a'
PAWN = '0x75733334 0x66743352 0x66523333'

print(f'KING: {convert(KING)}')
print(f'FREE: {convert(FREE)}')
print(f'PAWN: {convert(PAWN)}')

# solution 1; KING then PAWN
# solution 2; KING, FREE then PAWN
~~~

{: style="padding-top: 1em"}

![image8](/assets/img/blog/2022-08-14/image8.png){: .align-left}

{: style="padding-top: 2em"}

While debugging the program under GDB, I came to realize that program has two solutions.

Where there is the expected solution which was more like a UAF. While the unexpected solution is that you don't really need to invoke `free` because from our inspection after invoking `malloc` we can see that the pointer already contains the data required to pass the last if statement. 

That being said even when you call free the data will still be there and the pointer can still be used to pass the last if statement.

## Conclusion

I learnt afew things when playing around with this program and I do hope you have too. Would like to thank the creator [@icrackthecode].

## Resources

- 6Point6 [Common Software Vulnerabilities, PartII: Explaining the Use After Free](https://6point6.co.uk/insights/common-software-vulnerabilities-part-ii-explaining-the-use-after-free/)
- Orange Cyberdefense [Linux Heap Exploitation Intro Series: Used and Abused - Use After Free](https://sensepost.com/blog/2017/linux-heap-exploitation-intro-series-used-and-abused-use-after-free/)
- LiveOverflow [The Heap: How do use-after-free exploits work?](https://www.youtube.com/watch?v=ZHghwsTRyzQ)
- CryptoCat [Exploiting a Use-After-Free (UAF) Vulnerability](https://www.youtube.com/watch?v=YGQAvJ__12k)
- Marcus Hutchins [Introduction to Use-After-Free Vulnerabilities (Part: 1)](https://www.youtube.com/watch?v=PKqMsaKGdlM)


[Yellow Belt]: https://pwn.college/belts
[pwn.college]: https://pwn.college
[Use After Free]: https://owasp.org/www-community/vulnerabilities/Using_freed_memory
[CyberChef]: https://gchq.github.io/CyberChef/
[@icrackthecode]: https://twitter.com/icrackthecode