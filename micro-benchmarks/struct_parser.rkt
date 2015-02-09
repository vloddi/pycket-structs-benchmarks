#lang pycket
(require compatibility/mlist)


; Sierpinsky Triangle (output is disabled)
(define input ">++++[<++++++++>-]>++++++++[>++++<-]>>++>>>+>>>+<<<<<<<<<<[-[->+<]>[-<+>>>.<<]>>>[[->++++++++[>++++<-]>.<<[->+<]+>[->++++++++++<<+>]>.[-]>]]+<<<[-[->+<]+>[-<+>>>-[->+<]++>[-<->]<<<]<<<<]++++++++++.+++.[-]<]+++++>++++[<++++++++>-]>++++++++[>++++<-]>>++>>>+>>>+<<<<<<<<<<[-[->+<]>[-<+>>>.<<]>>>[[->++++++++[>++++<-]>.<<[->+<]+>[->++++++++++<<+>]>.[-]>]]+<<<[-[->+<]+>[-<+>>>-[->+<]++>[-<->]<<<]<<<<]++++++++++.+++.[-]<]+++++>++++[<++++++++>-]>++++++++[>++++<-]>>++>>>+>>>+<<<<<<<<<<[-[->+<]>[-<+>>>.<<]>>>[[->++++++++[>++++<-]>.<<[->+<]+>[->++++++++++<<+>]>.[-]>]]+<<<[-[->+<]+>[-<+>>>-[->+<]++>[-<->]<<<]<<<<]++++++++++.+++.[-]<]+++++")


; global state
(struct state (data [ptr #:mutable]))
 
; creates a new state, with a byte array of 30000 zeros, and the pointer at index 0
(define (new-state) (state (list->mlist (build-list 30000 (lambda(x) 0))) 0))


; increment the data pointer
(define (increment-ptr a-state)
  (set-state-ptr! a-state (add1 (state-ptr a-state))))
 
; decrement the data pointer
(define (decrement-ptr a-state)
  (set-state-ptr! a-state (sub1 (state-ptr a-state))))

; increment the byte at the data pointer
(define (increment-byte a-state)
  (define v (state-data a-state))
  (define i (state-ptr a-state))
  (mlist-set! v i (add1 (mlist-ref v i))))
 
; decrement the byte at the data pointer
(define (decrement-byte a-state)
  (define v (state-data a-state))
  (define i (state-ptr a-state))
  (mlist-set! v i (sub1 (mlist-ref v i))))

; print the byte at the data pointer
(define (write-byte a-state)
  (define v (state-data a-state))
  (define i (state-ptr a-state))
  ;(display (integer->char (mlist-ref v i))))
  (integer->char (mlist-ref v i)))


; work with mutable lists
(define (mlist-set! mlist k val)
    (if (zero? k)
        (set-mcar! mlist val)
        (mlist-set! (mcdr mlist) (- k 1) val)))


; current state
(define current-state (make-parameter (new-state)))

; loop
(define (loop s i)
  (case (string-ref s i)
    ['#\> (increment-ptr (current-state))]
    ['#\< (decrement-ptr (current-state))]
    ['#\+ (increment-byte (current-state))]
    ['#\- (decrement-byte (current-state))]
    ['#\. (write-byte (current-state))]
    ;['#\, (read-byte (current-state))]
    ['#\[
      (define j (second-bracket-pos s (add1 i) 0))
      (unless (= (mlist-ref (state-data (current-state)) (state-ptr (current-state))) 0)
       (subloop (substring s (add1 i) j)))
      (set! i j)])
  (when (< (add1 i) (string-length s))
      (loop s (add1 i))))
 
; subloop
(define (subloop s)
  (loop s 0)
  (unless (= (mlist-ref (state-data (current-state)) (state-ptr (current-state))) 0)
    (subloop s)))

(define (second-bracket-pos s i prev)
  (when (eq? (string-ref s i) '#\[) (set! prev (add1 prev)))
  (if (eq? (string-ref s i) '#\])
      (if (= 0 prev)
           i
           (second-bracket-pos s (add1 i) (sub1 prev)))
           (second-bracket-pos s (add1 i) prev)))

(time (loop input 0))
