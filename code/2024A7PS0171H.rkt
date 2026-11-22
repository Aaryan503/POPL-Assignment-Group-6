#lang racket/base

; (empty-tree? t): #t if t is the empty tree '(), #f otherwise.
; Base case: t is '().
(define (empty-tree? t)
  (null? t))

; (tree-value t): the value stored at the root of tree t.
; Accessor: the first element of (value left right).
(define (tree-value t)
  (car t))

; (tree-left t): the left subtree of tree t.
; Accessor: the second element of (value left right).
(define (tree-left t)
  (cadr t))

; (tree-right t): the right subtree of tree t.
; Accessor: the third element of (value left right).
(define (tree-right t)
  (caddr t))

; (my-reverse lst): the elements of lst in reverse order.
; Base case: lst is '(), so the result is the accumulator acc.
; Recursive case: cons (car lst) onto acc and continue with (cdr lst).
; Tail-recursive: elements are prepended to acc one by one.
(define (my-reverse lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        acc
        (loop (cdr rest) (cons (car rest) acc)))))
