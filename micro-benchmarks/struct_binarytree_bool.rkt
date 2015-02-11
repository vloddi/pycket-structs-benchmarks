#lang pycket

(define SIZE 22)

(struct leaf (val))
(struct node leaf (left right))

(define (generate-tree item d)
  (if (= d 0)
    (leaf item)
    (let ([d2 (- d 1)])
      (node item (generate-tree item d2) (generate-tree item d2)))))

(collect-garbage)
(time (generate-tree #f SIZE))
