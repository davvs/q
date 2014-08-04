q
=

## Synopsis

This project is that should wrap shell command and when those commands complete, q will tell the user in a very verbose way

## Code Example

```
q sleep 15
```

(After that sleep 15 is executed, a verybose screen popup is shown in the screen and noises are played)

## Motivation

When running large batch scripts that takes a long time I always seem to forget to get back and check if they're done. q helps me to remind me that they're completed.

## Installation

```
git clone git@github.com:davvs/q.git
PATH=$PWD/q:$PATH
```

## API Reference

This README.md is the only docs at the moment.

## Tests

N/A

## Contributors

davvs

## License

Unlicense http://unlicense.org

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

