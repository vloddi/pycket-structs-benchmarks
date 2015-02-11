#lang racket/base 
(require racket/flonum)

(define-struct rand (seed tran) #:mutable)
(define (new-rand) (make-rand 0.0 314159265.0))

; Constants
(define r23 (expt 0.5 23))
(define t23 (expt 2.0 23))
(define r46 (expt r23 2))
(define t46 (expt t23 2))

(define (randlc/a x a) 
  (let* ([a1 (round (* r23 a))]
         [a2 (- a (* t23 a1))]
         [x1 (round (* r23 x))]
         [x2 (- x (* t23 x1))]
         [t1 (+ (* a1 x2) (* a2 x1))]
         [t2 (round (* r23 t1))]
         [z (- t1 (* t23 t2))]
         [t3 (+ (* t23 z) (* a2 x2))]
         [t4 (round (* r46 t3))]
         [r (- t3 (* t46 t4))])
    r))

(define (power/r rng a n)
  (let loop ([pow 1.0]
             [seed (rand-seed rng)]
             [nj n]
             [aj a])
    (if (not (zero? nj))
      (let* ([njmod2 (= (modulo nj 2) 1)]
             [seed (if njmod2 (randlc/a pow aj) seed)]
             [pow  (if njmod2 seed pow)])
          (let ([seed (randlc/a aj aj)])
            (loop pow seed (quotient nj 2) seed)))
      (begin
        (set-rand-seed! rng seed)
        pow))))

;;;
(define SIZE 10000000)
(define v (make-vector 10000000))

(collect-garbage)

(time
  (for ([i (sub1 SIZE)])
    (vector-set! v i (power/r (new-rand) 314159265.0 0))))
