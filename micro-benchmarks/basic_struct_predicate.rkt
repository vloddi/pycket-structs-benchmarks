#lang pycket

(define SIZE 10000000)

(struct posn (x y))
(struct 3dposn posn (z))

(define v (make-vector SIZE))

(time (let n-loop ([n (sub1 SIZE)])
  (define p0 (posn n (+ 1 n)))
  (define p1 (3dposn n (+ 1 n) (+ 2 n)))
  (define res (posn? p0))
  (set! res (and res (3dposn? p0)))
  (set! res (and res (posn? p1)))
  (set! res (and res (3dposn? p1)))
  (vector-set! v n res)
  (if (= 0 n)
      'done
      (n-loop (sub1 n)))))