How to test base64.vim
=====================

All tests for base64.vim modules are now written with [themis.vim](https://github.com/thinca/vim-themis).  When you want to run tests, you should install it in advance.

```sh
$ cd /path/to/base64.vim
$ git clone https://github.com/thinca/vim-themis.git
```

Now you can run tests with `themis` executable file.

```sh
$ ./vim-themis/bin/themis
```

Please read [a documentation of themis.vim](https://github.com/thinca/vim-themis/blob/master/doc/themis.txt) for more detail.
