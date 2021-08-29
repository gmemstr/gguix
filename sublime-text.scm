(define-module (sublime-text)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (nonguix build-system binary)
  #:use-module (nonguix licenses))

(define-public sublime-text (package
  (name "sublime-text")
  (version "4113")
  (source (origin
      (method url-fetch)
      (uri (string-append "https://download.sublimetext.com/sublime_text_build_" version "_x64.tar.xz"))
      (sha256
        (base32
    "13679mnmigy1sgj355zs4si6gnx42rgjl4rn5d6gqgj5qq7zj3lh"))))
  (build-system binary-build-system)
  (arguments
    `(#:patchelf-plan
      `(("sublime_text" ("libc" "gcc:lib"
       "libGL"
       "libX11"
       "libz"
       "glu"
       "out"
       "glib"
       "cairo"
       "gtk"
       "pango"))
  ("libssl.so.1.1" ("gcc:lib" "libz" "libc" "out"))
  ("libcrypto.so.1.1" ("gcc:lib" "libz" "libc" "out"))
  ("crash_reporter" ("gcc:lib" "libc" "out"))
  ("plugin_host-3.3" ("gcc:lib" "libc" "out"))
  ("plugin_host-3.8" ("gcc:lib" "libc" "out")))
      #:install-plan
      '(("." "usr/share/sublime-text/" #:exclude ("libssl.so.1.1" "libcrypto.so.1.1"))
   ("libcrypto.so.1.1" "lib/")
   ("libssl.so.1.1" "lib/"))
      #:strip-binaries? #f
      #:validate-runpath? #f
      #:phases
      (modify-phases %standard-phases
         (add-after 'install 'install-symlink
        (lambda* (#:key outputs #:allow-other-keys)
           (let ((out (string-append (assoc-ref outputs "out"))))
                 (mkdir (string-append out "/bin"))
                 (symlink (string-append out "/usr/share/sublime-text/sublime_text")
              (string-append out "/bin/subl")) #t))))
      ))
  (inputs
    `(("gcc:lib" ,gcc "lib")
      ("libX11" ,libx11)
      ("libGL" ,mesa)
      ("glu" ,glu)
      ("glib" ,glib)
      ("libz" ,zlib)
      ("gtk" ,gtk+)
      ("cairo" ,cairo)
      ("pango" ,pango)))
  (synopsis "Install Sublime Text 4.")
  (description "Install the superfast text editor.")
  (home-page "https://sublimetext.com")
  (license (nonfree "https://www.sublimetext.com/eula"))))

sublime-text
