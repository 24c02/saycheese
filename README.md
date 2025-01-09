<img src="https://github.com/commonkestrel/saycheese/raw/main/static/say-cheese.png" alt="Say Cheese logo" width="100" align="left" />

# Say Cheese


Say Cheese is a You Ship We Ship program
focused on creating games and programs that can fit inside a single QR code.

The QR code standard is a collection of many different versions,
with the largest being version 40, encoding a measly 3 kilobytes of data.
For reference, the cute little icon at the top of this README is a whopping 74 kilobytes.
This means you have to fit a fully functioning program into a package over 20x smaller than a logo.

The amazing thing about this YSWS is it is completely platform agnostic!
That means you can creat a program for x64 Linux,
an ARM Mac, or even a TI calculator!
If it fits inside a QR code, we want to see it!

While you can *technically* store binary inside a QR code,
we recommend storing your program inside a [data uri](https://developer.mozilla.org/en-US/docs/Web/URI/Schemes/data).
This allows your browser to automatically download a binary program,
or automatically load your webpage with HTML.
Unfortunately, the default QR reader on some devices (looking at you Apple) incorrectly identifies these,
so you may have to download an external app to scan it.
In addition, encoding a binary into a data uri does limit the size to an even smaller size, just a bit over 2Kb.

There are two main methods to creating programs this small: HMTL+JS or an assembly language:

## HTML+JS

Creating a program with HTML and JavaScript is a wonderful way to fit a program into a small size!
This is because much of the work is already being handled by your browser.

Check out the HTML+JS [example](./examples/web/) for a starting place!

## Assembly

Creating your program in Assembly is just about the only way to create an executable small enough to fit inside a QR code. 
While it is possible with a language such as C or C++,
it requires lots of complicated compiler settings and optimizations.

Check out the assembly [example](./examples/asm/) for a starting place!
