## OpenGL Example using CCL on OSX

This code contains more or less the bare minimum to create an NSOpenGLView
with Common Lisp using CCL's Cocoa bridge.

However, in contrast to some other examples I found this code will

* Not use SDL, nor GLUT, it will use Cocoa methods to create and manage the OpenGL Context.
* Use the OpenGL 3.2 Core profile, not the legacy profile.
* Will render at the full Retina display resolution.
* Use Vertex Arrays and Vertex Buffers to render the triangle instead of direct mode.
* Use a trivial shader program to render the triangle.

But besides that the code is very minimal, does not do any error checking etc.  

In order to let it run:

1. Start CCL
2. Type

   ```
   (require "COCOA")
   (ql:quicload "opengl-example") ;; or any other method to load this system
   (opengl-example:show-demo)
   ```

For some background see [OpenGL with CCL on OSX](http://ironhead.xs4all.nl/blog/posts/OpenGL-with-CCL-on-OSX.html)

