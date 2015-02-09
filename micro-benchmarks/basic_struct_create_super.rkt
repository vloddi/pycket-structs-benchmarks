#lang pycket

(define SIZE 20000000)

(struct posn (x y))
(struct 3dposn posn (z))

(define v (make-vector SIZE))

(time (let n-loop ([n (sub1 SIZE)])
  (vector-set! v n (3dposn n (+ 1 n) (+ 2 n)))
  (if (= 0 n)
      'done
      (n-loop (sub1 n)))))
