# Tutorial-Ish

Starting a project like this can feel overwhelming. That's why I’ve put together this semi-tutorial to give you a quick introduction to optimizing for size. The limits of QR codes require your entire program to fit inside a binary that's less than 3 kilobytes. Size optimization on this scale introduces numerous challenges, especially since many high-level languages can't fit within such a small footprint. For example, even a simple "Hello World" program in C takes up a hefty 297 kilobytes!

There are a few strategies to work around this limitation. The key is using languages that allow you to either have fine-grain control over the binary size or offload much of the processing to the host device. This makes assembly language ideal for binary optimization, or HTML and JavaScript perfect for web apps.

But how can users actually interact with your program? Obviously, you want to make it easy for them. While you could use a binary QR code, this adds extra steps for your users. I recommend a much simpler approach: using the [Data URI Scheme](https://developer.mozilla.org/en-US/docs/Web/URI/Schemes/data). This scheme supports both webpages and native binaries (with the "text/html" and "application/octet-stream" media types, respectively).

While using the Data URI Scheme reduces your program size from 3kB to 2kB (a significant saving!), it allows your users to simply scan your QR code and have your program open or download automatically with no additional steps!

---

## Assembly: The Key to Small Binaries

Assembly is one of the best ways to build native binaries small enough to fit inside a QR code—unless you’re willing to do some major tweaking with your preferred compiler. The advantage of assembly is that it provides near-total control over binary size. However, it's important to note that assembly is architecture (and operating system) specific. 

This specificity is both a blessing and a curse. On the one hand, you can create a program for any platform you desire, whether that’s a common system like x64 Windows or something more niche, like the TI-84 Graphing Calculator or the Nintendo GameBoy. On the other hand, you’re limited to a single system. 

For example, Say Cheese is platform-agnostic, meaning you can build a program for virtually anything. The downside is, I can't cover every possible platform in detail. If you’re new to assembly programming and looking for a starting point, I highly recommend checking out [Some Assembly Required](https://github.com/hackclub/some-assembly-required), an approachable introduction to assembly programming.

If you're developing for Linux and struggling to get your ELF file smaller than 3kB, check out this [incredible guide](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html) for ELF size optimization!

---

## HTML + JavaScript: Offloading for Smaller Files

JavaScript is an interpreted language, meaning the heavy lifting is done by another program—typically a browser (or Node, Bun, or Deno if you prefer a more adventurous approach). JavaScript’s ability to offload functionality allows it to fit into much smaller file sizes compared to a typical binary.

However, this offloading doesn't completely negate the strict size constraints of a QR code. Even the [Hackatime dashboard](https://waka.hackclub.com), used for [High Seas](https://highseas.hackclub.com), has a base file (`base.js`) that is 33kB—10x bigger than the QR code limit!

The main way to combat size in JavaScript and HTML is by **minifying**. Minification removes unnecessary whitespace, long variable names, and comments, making the code harder to read but drastically reducing its size. While I’m too lazy to build a custom minifier for this tutorial, I suggest searching for one online (there are plenty of good options available).

---

## Turning Your Website into a QR Code

If you're ready to convert your website into a QR code, you can do so easily using the programs available at [Html-To-QR](https://github.com/The-UnknownHacker/Html-To-QR). This tool will allow you to create a QR code from your html file directly. Make sure if you use this tool that your html file is under the file limit otherwise the tool will fail

---

Now that you know the basics of size optimization, you’re ready to start building small, efficient programs that can fit perfectly into QR codes. Happy coding!
