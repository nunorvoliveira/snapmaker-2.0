
# Snapmaker 2.0  

On this repository I'm adding some libraries and post-processor for using the Snapmaker 2.0 A350T CNC module with Fusion 360.

Inside the directory [Fusion 360](/Fusion%20360) you have all the needed files.

I'll try to keep all my improvements and additions here to be used by anyone who wants them.

All of this is based on my Snapmaker 2.0 A350T, but many things should be compatibles with other models such as tool libraries, post-processor, etc.

## Background

After being surprised by my wife's acquisition of the SM2.0 A350T, I started doing some 3D printing and laser engraving and kept postponing the CNC module as I had never used anything like it.

Sometime later I decided to give it a go and using Snapmaker Luban revealed challenging and limiting. I've decided to try Fusion 360 as everyone was talking about that software, and in a few hours, I was able to do what I had been trying for days. I committed to Fusion 360 as my software for the Snapmaker CNC module.

## Limitations

The more I worked with it, the more problems I was running into.

The available tool library didn’t match the tools I had (purchased with the machine), the post processor would make some weird stuff that was causing me problems, had me break some clamps, pieced of stock wood, tools, etc...

Below a small list of the things that I tried to fix when I started working on the post processor:

- Before starting the CNC program, right after setting the _work origin_ on the machine, the tool head would go to the starting point in a straight line. This means that if the stock wood was near it would collide with it as it would not raise the Z-axis in advance, damaging it and breaking tools.

- I could not add a pause between tool paths to be able to do some clean up and to check the work progress. It was still scary for me to leave the machine running for six hours trusting all was good, and so, having it pause at specific points in time was reassuring.

- By the end of every CNC program, the machine would travel at high speed to the _work origin_ before raising the Z-axis. This had me breaking many tools and clamps.

## CNC Experience

Many of the problems I was (and some I still am) facing can be caused by my inexperience in CNC. Before the SM2.0 A350T I had not had any contact with G-code or CNC machines since a class in school, 20 years ago where we learned the G-code to make a square with rounded corners by hand...

Please take that in consideration. All my learning and all my improvements are based on this lack of experience, and my need to have things working in a way that suits me better (as far as I know).

## Journey

While improving the tool library by measuring them by hand, I felt the need to improve the machine settings, and then to make a post-processor that was more reliable for my needs.

This got me digging around, learning supported G-code commands on the Snapmaker, learning about Fusion 360 post-processors, and eventually, I decided to create a completely new post-processor.

## Decision

With the decision of creating a new post-processor, I've also decided to share this with others to help anyone that could be struggling as I was on the very beginning.
Because of this, I've tried to make the post-processor as readable as possible, I added as many comments as I could, and I've implemented all features that I can (and may continue to do so).

I've also tried to be as detailed as possible on the machine configurations and I even added pictures of the machine with and without enclosure to make it more beautiful.

## Development Passion

Even though I had pretty much zero experience with CNC, I had always been a _"software programmer"_ (aka: a guy than can do some programming) making small utilities for a daily basis, for work, school, or home.

It all started in my dad's _ZX-Spectrum 48K_ and it went from there to _GW Basic_, _QBasic 1.0, 1.1, 4.5 and 7.1_, then to _Visual Basic 3, 4, 5, and 6_, _VB.NET_, some _PHP_ for some web experiences, _C#_, and now, apparently, _JavaScript_.

Because of this, and on the process of learning about Fusion 360 post-processors, I've implemented some things not because I needed them, but because they were possible, they were a challenge, and someone else may find them useful.

## Resources

To make this possible I had searched many hours on the internet. I have seen hundreds of YouTube videos about Snapmaker, Fusion 360, G-code, post-processors, and so on...

But there are 2 resources I was constantly going to:

- G-code Reference, by Snapmaker at [G-code Reference](https://snapmaker.github.io/Documentation/gcode/G000-G001)
- Post Processor Training Guide, by Autodesk at [Post Processor Training Guide](https://cam.autodesk.com/posts/posts/guides/Post%20Processor%20Training%20Guide.pdf)

## Disclaimer

As I mentioned above, I had close to zero experience in CNC. All this work was developed with as much care and attention as possible within the limits of my knowledge and limited experience.

So, I have to say it, **USE AT YOUR OWN RISK**.

I tested this as much as possible and I'm working with this post on all my CNC programs with zero problems, but I'm sure could not test everything to the absolute limit. There are many types of milling in Fusion 360 and I'm only using a few of them.

I recommend that you post your milling both with your current trusted post-processor and with this one and compare the output. By selecting the _Write extra comments_ and _Write warnings as comments_ options pretty much all lines will have a comment, except for the ones that are not changed by the post. This should give enough info to understand what's going on.

## Safety, Safety, Safety!

Regardless of all the above, please do use all safety measures. If you have the enclosure, please use it, and have the open-door sensors active. Don't go around the tool head when it's running, always use the safety glasses and all protective gear, and only change tools observing all safety recommendations. Even not being mandatory, an **emergency button** can be your best friend! Can't count the number of times I regretted not having one. It's a must! Trust me! Do as I say and not as I do!

For a complete list of safety measures, please visit Snapmaker site for [Snapmaker Safety Guidelines](https://support.snapmaker.com/hc/en-us/articles/4417389067671-1-Safety-Guidelines)

## Buy Me a Coffee?

If you want to support my work, feel free to buy me a coffee via PayPal.

[![Donate via PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate/?business=A89J2W3D4GAAS&no_recurring=1&currency_code=EUR)
