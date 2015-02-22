#lang pycket

(define SIZE 300000000)

(struct posn (x y))
(struct 3dposn posn (z))

(define p0 (posn 0 1))
(define p1 (3dposn 0 1 2))

(define res #f)

(collect-garbage)

(time (let n-loop ([n (sub1 SIZE)])
  (set! res (and (posn? p0) (posn? p1) (3dposn? p0) res))
  ; (when (= (remainder n 50000000) 0)
  ;   (collect-garbage))
  (if (= 0 n)
      'done
      (n-loop (sub1 n)))))
