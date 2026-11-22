#lang racket/base
; tests/test_q3.rkt: tests for S1 (code/6_q3.rkt).
; Run: racket tests/test_q3.rkt
;
; The solution file contains only definitions (no provide, per assignment rules).
; We instantiate it using dynamic-require and access its definitions via module->namespace.
; This keeps the solution file strictly compliant with the allowed built-in constraints.

(require racket/runtime-path)
(define-runtime-path solution-file "../code/6_q3.rkt")

(define ns (make-base-namespace))
(parameterize ((current-namespace ns))
  (dynamic-require solution-file #f))
(define (from-solution name)
  (parameterize ((current-namespace ns))
    (eval name (module->namespace solution-file))))

(define print-inorder           (from-solution 'print-inorder))
(define print-all-traversals    (from-solution 'print-all-traversals))
(define print-height-and-leaves (from-solution 'print-height-and-leaves))

; ---------- Helper to build a left-skewed tree of given depth ----------
; (build-left-skewed d): creates a left-skewed tree of depth d with values d down to 1.
; Base case: d = 0 gives '().
; Recursive case: node with value d, left child (build-left-skewed (- d 1)), right child '().
(define (build-left-skewed d)
  (if (= d 0)
      '()
      (list d (build-left-skewed (- d 1)) '())))

; ---------- Test Trees ----------
; t1 from assignment
(define t1
  '(4 (2 (1 () ()) (3 () ()))
      (6 (5 () ()) (7 () ()))))

; t2 from assignment
(define t2
  '(1 () (2 () (3 () ()))))

; t3 from assignment
(define t3
  '(a (b () ()) (c () ())))

; Single node
(define t-single
  '(5 () ()))

; Empty tree
(define t-empty
  '())

; Left-skewed tree of depth 1000
(define t-skewed-1000
  (build-left-skewed 1000))

; =====================================================================
; Running tests with expected outputs shown in comments
; =====================================================================

(display "=== Testing t1 ===")
(newline)
(print-inorder t1)
; Expected output:
; (1 2 3 4 5 6 7)

(print-all-traversals t1)
; Expected output:
; (1 2 3 4 5 6 7)
; (4 2 1 3 6 5 7)
; (1 3 2 5 7 6 4)

(print-height-and-leaves t1)
; Expected output:
; (3 4)

(display "=== Testing t2 ===")
(newline)
(print-inorder t2)
; Expected output:
; (1 2 3)

(print-all-traversals t2)
; Expected output:
; (1 2 3)
; (1 2 3)
; (3 2 1)

(print-height-and-leaves t2)
; Expected output:
; (3 1)

(display "=== Testing t3 ===")
(newline)
(print-inorder t3)
; Expected output:
; (b a c)

(print-all-traversals t3)
; Expected output:
; (b a c)
; (a b c)
; (b c a)

(print-height-and-leaves t3)
; Expected output:
; (2 2)

(display "=== Testing empty tree '() ===")
(newline)
(print-inorder t-empty)
; Expected output:
; ()

(print-all-traversals t-empty)
; Expected output:
; ()
; ()
; ()

(print-height-and-leaves t-empty)
; Expected output:
; (0 0)

(display "=== Testing single node (5 () ()) ===")
(newline)
(print-inorder t-single)
; Expected output:
; (5)

(print-all-traversals t-single)
; Expected output:
; (5)
; (5)
; (5)

(print-height-and-leaves t-single)
; Expected output:
; (1 1)

(display "=== Testing left-skewed tree of depth 1000 ===")
(newline)
(print-height-and-leaves t-skewed-1000)
; Expected output:
; (1000 1)

(display "Left-skewed height-and-leaves test passed.")
(newline)
