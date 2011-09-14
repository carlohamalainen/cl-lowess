(load "cl-lowess.lisp")

(defun print-vec-as-python-list (x print-name)
    (format t "~a = [" print-name)
    (loop for x-val across x do
          (format t "~,8f," x-val))
    (format t "]~%"))

(let* ((n 200)
       (x (apply #'vector (loop for i :below n       collect (/ (* 2 3.14 i) n))))
       (y (apply #'vector (loop for x-value across x collect (+ (sin x-value) (random 1.0)))))
       (ys (cl-lowess:lowess x y)))
    (print-vec-as-python-list x  "x")
    (print-vec-as-python-list y  "y")
    (print-vec-as-python-list ys "ys")
    (format t "import pylab as plt~%")
    (format t "plt.plot(x, y, label='xy')~%")
    (format t "plt.plot(x, ys, label='xys')~%")
    (format t "plt.legend()~%")
    (format t "plt.show()~%"))

(quit)
