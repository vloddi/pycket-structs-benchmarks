#lang pycket

(define SIZE 30000000)

(struct posn (x y))
(struct 3dposn posn (z))

(define v (make-vector SIZE))

(collect-garbage)

(time (let n-loop ([n (sub1 SIZE)])
  (vector-set! v n (3dposn #f (+ 1 n) #f))
  ; (when (= (remainder n 5000000) 0)
  ;     (collect-garbage))
  (if (= 0 n)
      'done
      (n-loop (sub1 n)))))
