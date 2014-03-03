;;;; opengl-example.asd

(asdf:defsystem #:opengl-example
  :serial t
  :description "Small example of using OpenGL from CCL"
  :author "Wim Oudshoorn <woudshoo+github@xs4all.nl>"
  :license "GPL"
  :depends-on (#:cl-opengl #:alexandria)
  :components ((:file "package")
               (:file "opengl-example")))

