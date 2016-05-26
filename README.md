# Silicon Compiler

* Author: **[Danyang Song (Arthur)](mailto:arthur_song@sfu.ca)**
* Instructor: [Annop Sarkar](http://www.cs.sfu.ca/~anoop/)

******

## Glance
* This project is for [CMPT-379(SFU)](http://anoopsarkar.github.io/compilers-class/).
* Target Language is **[Decaf](http://anoopsarkar.github.io/compilers-class/decafspec.html)**
* First Assignment is in ```./tools```

## Coding Issuses
* ```./include/global.h```
    * The *enum class* ```GT_LEXICAL_TOKEN``` triggers a defect in C++11 standard, see [CWG issue 1449](http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#1449). To avoid this issue, use a larger width-fixed type (in this case, using ```std::int32_t```).
* ```./tools/decaflex/answer/decaflex.lex```
    * Flex uses *'register' storage class* which is deprecated in C++11 standard. To avoid this issue, add ```-Wno-deprecated-register``` option in **makefile**.

## Features
