#lang racket/base

(define SIZE 15000000)

(define-struct rand (seed) #:mutable #:property prop:procedure
  (lambda (self) (remainder (* (rand-seed self) 1103515245) 65536)))
(define r (rand 1))

(collect-garbage)

(time (let n-loop ([n (sub1 SIZE)])
        (set-rand-seed! r (r))
        ; (when (= (remainder n 5000000) 0)
        ;   (collect-garbage))
        (if (= 0 n)
            'done
            (n-loop (sub1 n)))))
