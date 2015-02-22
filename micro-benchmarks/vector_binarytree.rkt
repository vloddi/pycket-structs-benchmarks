#lang pycket

(define SIZE 22)

(define (generate-tree item d)
  (if (= d 0)
    item
    (let ([item2 (* item 2)]
          [d2 (sub1 d)])
      (vector item (generate-tree (sub1 item2) d2) (generate-tree item2 d2)))))

(collect-garbage)
(time (generate-tree 1 SIZE))
