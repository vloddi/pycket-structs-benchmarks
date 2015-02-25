#lang pycket

(define SIZE 100000000)

(struct posn (x y z) #:mutable)
(define p (posn 1 2 3))

(define v (make-vector SIZE))

(collect-garbage)

(time (let n-loop ([n (sub1 SIZE)])
  (set-posn-x! p n)
  (vector-set! v n (posn-x p))
  (set-posn-y! p (+ 1 n))
  (vector-set! v n (posn-y p))
  (set-posn-z! p (+ 2 n))
  (vector-set! v n (posn-z p))
  ; (when (= (remainder n 20000000) 0)
  ;     (collect-garbage))
  (if (= 0 n)
      'done
      (n-loop (sub1 n)))))