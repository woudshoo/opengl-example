;;;; opengl-example.asd

(asdf:defsystem #:opengl-example
  :serial t
  :description "Describe opengl-example here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:cl-opengl #:alexandria)
  :components ((:file "package")
               (:file "opengl-example")))

