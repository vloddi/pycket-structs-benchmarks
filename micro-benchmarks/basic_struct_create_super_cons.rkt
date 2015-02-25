#lang pycket

(define SIZE 10000000)

(struct posn (x y next))
(struct 3dposn posn (z))

(collect-garbage)

(let ((v (time (let n-loop ([n (sub1 SIZE)]
                            [val '()]
                            [acc '()])
                 (when (= (remainder n (/ SIZE 10)) 0)
                   (collect-garbage))
                 (if (= 0 n)
                     acc
                     (n-loop
                      (sub1 n)
                      (3dposn n (+ 1 n) (+ 2 n))
                      (cons val acc)
                      ))))))
  ((lambda (x) '()) v))