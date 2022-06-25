(lang dune 3.0)

(using ctypes 0.1)

(name variorum)

(generate_opam_files true)

(source
 (github patricoferris/ocaml-variorum))

(authors "Patrick Ferris")

(maintainers "Patrick Ferris")

(license MIT)

(documentation https://ocaml.org/p/variorum)

(package
 (name variorum)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
   ctypes
   conf-cmake))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
