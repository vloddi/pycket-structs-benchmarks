#lang pycket

(define SIZE 15000000)
(struct posn (x y))

(define v (make-vector SIZE))

(collect-garbage)

(time (let n-loop ([n (sub1 SIZE)])
  (vector-set! v n (posn (+ 1 n) (+ 2 n)))
  (if (= 0 n)
      'done
      (n-loop (sub1 n)))))
