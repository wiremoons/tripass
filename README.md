
## Tripass Program Overview

A simple command line program that uses a dictionary of three letter
words, that are combined to form a unique randomly generated password
string. In addition, a dictionary of 10 marks (ie symbols '>'; '@';
'-', etc) are randomly selected from and combined with randomly
generated digits. These are all put together, to create a password
that should be easy to remember, but very very hard to guess.

The program is written in Rust, so should be available to use on all
major operating systems as well, giving a consistent and trustworthy
tool on any computer.

The program is open source, and can be checked by anyone to ensure it
does not include any code that should not be there.

## How Secure Are the Generated Passwords?

The three letter word dictionary used to generate passwords has
exactly 1,311 unique words. So for a generated three word password
(e.g., word1.word2.word3), the total combinations are:

```
1311×1311×1311 = 2,253,130,231
```

So that is over 2.2 billion password variations available, before the
additional possibilities are added for the 10 different symbols also
being used, and the random generated numbers as well. On top of that,
the three letter words case is altered to use lower and upper case
letter for the words chosen - further increasing the massive number of
unique possibilities available.

## License

The program is licensed under the "MIT License" see
http://opensource.org/licenses/MIT for more details.

Copy of the [tripass license](./LICENSE)
