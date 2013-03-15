; (declaim (optimize (speed 3) (safety 0) (debug 0)))

(asdf:oos 'asdf:load-op :cffi)

(defpackage :cl-lowess
  (:use :common-lisp :cffi)
  (:export :lowess))
(in-package :cl-lowess)

(pushnew (truename ".") *foreign-library-directories* :test #'equal)
(cffi:load-foreign-library "liblowess.so")

; int lowess(double *x, double *y, size_t n,
;            double f, size_t nsteps,
;            double delta, double *ys, double *rw, double *res)
(defcfun ("lowess" %lowess) :int 
  (x        :pointer)
  (y        :pointer)
  (n        :unsigned-long)
  (f        :double)
  (nsteps   :unsigned-long)
  (delta    :double)
  (ys       :pointer)
  (rw       :pointer)
  (res      :pointer))

(defun lowess (x y)
   (assert (= (length x) (length y)))
   (let* ((n        (length x))
          (c-x      (foreign-alloc :double :count n))
          (c-y      (foreign-alloc :double :count n))
          (c-ys     (foreign-alloc :double :count n))
          (c-rw     (foreign-alloc :double :count n))
          (c-res    (foreign-alloc :double :count n))
          (f        (coerce 0.66 'double-float))
          (nsteps   3)
          (delta    (coerce (* 0.01 (aref y (- (length y) 1)))
			    'double-float))) ;; (coerce 0.3  'double-float)))
     (loop for i :below n do
           (setf (mem-aref c-x :double i) (coerce (aref x i) 'double-float))
           (setf (mem-aref c-y :double i) (coerce (aref y i) 'double-float)))

     (%lowess c-x c-y n f nsteps delta c-ys c-rw c-res)

     (let ((ys (make-sequence 'vector n)))
       (loop for i :below n do
             (setf (aref ys i) (mem-aref c-ys :double i)))
       (foreign-free c-x)
       (foreign-free c-y)
       (foreign-free c-ys)
       (foreign-free c-rw)
       (foreign-free c-res)
       ys)))



