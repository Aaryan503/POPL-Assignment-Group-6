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

; (inorder t): the list of values of t visited in inorder (left, root, right).
; Base case: t is '(), so the result is the accumulator acc.
; Recursive case: traverse the right subtree with acc, cons the root value onto
; that result, and then traverse the left subtree with the new accumulator.
; Accumulator-based traversal: no append is used.
(define (inorder t)
  (let loop ((current t) (acc '()))
    (if (empty-tree? current)
        acc
        (loop (tree-left current)
              (cons (tree-value current)
                    (loop (tree-right current) acc))))))

; (preorder t): the list of values of t visited in preorder (root, left, right).
; Base case: t is '(), so the result is the accumulator acc.
; Recursive case: traverse the right subtree with acc, then the left subtree
; with that result, and finally cons the root value onto the front.
; Accumulator-based traversal: no append is used.
(define (preorder t)
  (let loop ((current t) (acc '()))
    (if (empty-tree? current)
        acc
        (cons (tree-value current)
              (loop (tree-left current)
                    (loop (tree-right current) acc))))))

; (postorder t): the list of values of t visited in postorder (left, right, root).
; Base case: t is '(), so the result is the accumulator acc.
; Recursive case: cons the root value onto acc, traverse the right subtree with
; that result, and then traverse the left subtree.
; Accumulator-based traversal: no append is used.
(define (postorder t)
  (let loop ((current t) (acc '()))
    (if (empty-tree? current)
        acc
        (loop (tree-left current)
              (loop (tree-right current)
                    (cons (tree-value current) acc))))))

; (leaf? t): #t if t is a non-empty node whose left and right subtrees are both empty.
; Accessor check: empty-tree? on both left and right children.
(define (leaf? t)
  (and (not (empty-tree? t))
       (empty-tree? (tree-left t))
       (empty-tree? (tree-right t))))

; (height t): the height of binary tree t.
; Base case: the empty tree '() has height 0.
; Recursive case: 1 plus the maximum of the heights of the left and right subtrees.
(define (height t)
  (if (empty-tree? t)
      0
      (+ 1 (max (height (tree-left t))
                (height (tree-right t))))))

; (leaf-count t): the number of leaf nodes in binary tree t.
; Base cases: an empty tree has 0 leaves; a leaf node has 1 leaf.
; Recursive case: the sum of the leaf counts of the left and right subtrees.
(define (leaf-count t)
  (cond ((empty-tree? t) 0)
        ((leaf? t) 1)
        (else (+ (leaf-count (tree-left t))
                 (leaf-count (tree-right t))))))


