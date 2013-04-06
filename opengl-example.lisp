;;;; opengl-example.lisp

(in-package #:opengl-example)

;;; "opengl-example" goes here. Hacks and glory await!

(defun show-demo ()
  (let ((window (make-window))
	(opengl-view (make-opengl-view)))
    (#/setContentView: window opengl-view)
    (#/orderFront: window nil)
    window))


(defun make-window ()
  (make-instance 'ns:ns-window
		 :width 300.0 :height 300.0))


(eval-when (:compile-toplevel :load-toplevel :execute)
  (objc:load-framework "OpenGL" :gl)
  (objc:defmethod (#/setWantsBestResolutionOpenGLSurface: :void)
      ((self ns:ns-object) (value :<BOOL>)))
  (setf cl-opengl-bindings:*gl-get-proc-address* #'cffi:foreign-symbol-pointer))


(defun make-opengl-view ()
  (let ((opengl-view (make-instance 'simple-gl-view)))
    (#/setPixelFormat: opengl-view (make-pixel-format))
    (#/setWantsBestResolutionOpenGLSurface: opengl-view 1)
    (#/autorelease opengl-view)))


(defun make-pixel-format ()
  (ccl:rlet ((attributes (:array (:unsigned 32) 3)))
    (setf (ccl:%get-long attributes 0) 99)
    (setf (ccl:%get-long attributes 4) #X3200)
    (setf (ccl:%get-long attributes 8) 0)
    (#/autorelease
     (#/initWithAttributes: (#/alloc ns:ns-opengl-pixel-format)
			    attributes))))


(defclass simple-gl-view (ns:ns-opengl-view)
  (vertex-array
   vertex-buffer
   shader-program)
  (:metaclass ns:+ns-object))


(objc:defmethod (#/prepareOpenGL :void) ((self simple-gl-view))
  (call-next-method)
  (with-slots (vertex-array vertex-buffer shader-program) self
    (setf vertex-array (cl-opengl:gen-vertex-array))
    (setf vertex-buffer (car (cl-opengl:gen-buffers 1)))
    (fill-buffer-with-demo-data vertex-buffer)
    (setf shader-program (make-shader-program))))


(defun fill-buffer-with-demo-data (vertex-buffer)
  (let ((array (cl-opengl:alloc-gl-array :float 9)))
    (loop :for index :from 0
       :for v :in '(-0.8 -0.8 -0.5
		    0.0  -0.8 -0.5
		    0.0   0.8 -0.5)
       :do
       (setf (gl:glaref array index) (coerce v 'single-float)))
    (cl-opengl:bind-buffer :array-buffer vertex-buffer)
    (cl-opengl:buffer-data :array-buffer :static-draw array)))


(defparameter *vertex-shader-source*
  "#version 330
layout (location=0) in vec4 position;

void main () {
  gl_Position = position;
}")

(defparameter *fragment-shader-source*
  "#version 330

out vec4 finalColor;

void main () {
  finalColor = vec4 (1.0, 0.0, 0.0, 1.0);
}")


(defun make-shader-program ()
  (let ((program (opengl:create-program))
	(vertex-shader (opengl:create-shader :vertex-shader))
	(fragment-shader (opengl:create-shader :fragment-shader)))
    (compile-shader vertex-shader *vertex-shader-source*)
    (compile-shader fragment-shader *fragment-shader-source*)
    (cl-opengl:attach-shader program vertex-shader)
    (cl-opengl:attach-shader program fragment-shader)
    (cl-opengl:link-program program)
    (cl-opengl:delete-shader vertex-shader)
    (cl-opengl:delete-shader fragment-shader)
    program))


(defun compile-shader (shader source)
  (cl-opengl:shader-source shader (alexandria:ensure-list source))
  (cl-opengl:compile-shader shader))


(objc:defmethod (#/drawRect: :void) ((self simple-gl-view) (rect :<NSR>ect))
  (with-slots (vertex-array vertex-buffer shader-program) self
    (cl-opengl:clear-color 1.0 1.0 0.5 1.0)
    (cl-opengl:clear :color-buffer-bit)
    
    (cl-opengl:bind-vertex-array vertex-array)
    (cl-opengl:bind-buffer :array-buffer vertex-buffer)
    (cl-opengl:enable-vertex-attrib-array 0)
    (cl-opengl:vertex-attrib-pointer 0 3 :float nil 0 0)

    (cl-opengl:use-program shader-program)
    (cl-opengl:draw-arrays :triangles 0 3)
    (cl-opengl:flush)))

