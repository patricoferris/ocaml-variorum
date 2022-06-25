ocaml-varorium
--------------

*Status: WIP and Experimental*

Bindings to the [variorum](https://github.com/llnl/variorum/) library, a tool for hardware-level feature control.

> ... a platform-agnostic library exposing monitor and control interfaces for several features in hardware architectures

## Installation

For now you will have to clone this repository (recursively to pick up the vendored source for `varorium`) and install its two dependencies `hwloc` and `jansson`. After that, in theory, it should be just a `dune build` away. You'll need a fairly new `dune` version as this library uses the new ctypes stanza. 
