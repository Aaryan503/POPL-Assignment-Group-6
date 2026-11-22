#lang racket/base
; tests/test_s2.rkt: tests for S2 (code/6_q4.rkt).
; Run: racket tests/test_s2.rkt   (from any directory)
; The solution file has no provide. So we instantiate it with
; dynamic-require and get its definitions through module->namespace.
; The harness lines use non-allowed built-ins (eval, strings, ports).
; This is permitted because the restriction applies to the solution file.
; The data helpers below use only the allowed built-ins.

(require racket/runtime-path)
(define-runtime-path solution-file "../code/6_q4.rkt")

(define ns (make-base-namespace))
(parameterize ((current-namespace ns))
  (dynamic-require solution-file #f))
(define (from-solution name)
  (parameterize ((current-namespace ns))
    (eval name (module->namespace solution-file))))

(define insert-if-short     (from-solution 'insert-if-short))
(define make-inserter       (from-solution 'make-inserter))
(define print-insert-result (from-solution 'print-insert-result))
(define my-length           (from-solution 'my-length))
(define my-reverse          (from-solution 'my-reverse))
(define my-map              (from-solution 'my-map))

; ---------- helpers (allowed built-ins only) ----------

; (same? a b): #t when a and b are the same nested list of atoms.
; Base cases: two empty lists are the same; two atoms are compared with eq?.
; Recursive case: two pairs are the same if their cars and cdrs are.
; The cdr call is in tail position, so long flat lists are safe.
(define (same? a b)
  (cond ((and (null? a) (null? b)) #t)
        ((and (pair? a) (pair? b))
         (and (same? (car a) (car b)) (same? (cdr a) (cdr b))))
        ((or (null? a) (null? b) (pair? a) (pair? b)) #f)
        (else (eq? a b))))

; (nest d inner): inner wrapped d times as (list ...).
; Base case: d = 0 gives inner. Recursive case: wrap once, d - 1 left.
(define (nest d inner)
  (if (= d 0)
      inner
      (nest (- d 1) (list inner))))

; (nest-with x d inner): inner wrapped d times as (list x ...).
; Base case: d = 0 gives inner. Recursive case: wrap once with x in front.
(define (nest-with x d inner)
  (if (= d 0)
      inner
      (nest-with x (- d 1) (list x inner))))

; (build-flat k): the list (1 2 ... k).
; Base case: i = 0 gives acc. Recursive case: cons i onto acc, i - 1 left.
(define (build-flat k)
  (let loop ((i k) (acc '()))
    (if (= i 0)
        acc
        (loop (- i 1) (cons i acc)))))

; (check name actual expected): print PASS or FAIL with the test name.
(define (check name actual expected)
  (display (if (same? actual expected) "PASS " "FAIL "))
  (display name)
  (newline))

; ---------- own helpers ----------
(check "my-length empty" (my-length '()) 0)                        ; 0
(check "my-length 3"     (my-length '(1 (2 3) ())) 3)              ; 3
(check "my-reverse"      (my-reverse '(1 2 3)) '(3 2 1))           ; (3 2 1)
(check "my-map square"   (my-map (lambda (v) (* v v)) '(1 2 3))
                         '(1 4 9))                                 ; (1 4 9)

; ---------- the four assignment examples ----------
(check "example 1" (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3)
       '((42 1 2) (3 4 5) (42 6) (42)))         ; ((42 1 2) (3 4 5) (42 6) (42))
(check "example 2" (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3)
       '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))    ; ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
(check "example 3" (insert-if-short 7 '() 3) '(7))                 ; (7)
(check "example 4" (insert-if-short 7 '() 0) '())                  ; ()

; ---------- edge cases ----------
; n = 0: no length is < 0, so nothing changes.
(check "n=0 nested" (insert-if-short 'z '((1 (2 ())) () (3)) 0)
       '((1 (2 ())) () (3)))                     ; ((1 (2 ())) () (3))
; Symbols as atoms and as x.
(check "symbols" (insert-if-short 'x '(a (b c) (d)) 2)
       '(a (b c) (x d)))                         ; (a (b c) (x d))

; Depth 100: 100 one-element lists around (). With n = 1, only the
; innermost () (length 0) gets x.
(check "depth 100, n=1" (insert-if-short 'a (nest 100 '()) 1)
       (nest 100 '(a)))                          ; same nesting, () -> (a)
; With n = 2, every list (lengths 1 and 0) gets x.
(check "depth 100, n=2" (insert-if-short 'a (nest 100 '()) 2)
       (nest-with 'a 100 '(a)))                  ; (a (a (a ... (a))))

; 10,000 flat elements.
(define flat (build-flat 10000))
(check "10k, n=10001" (insert-if-short 'x flat 10001)
       (cons 'x flat))                           ; (x 1 2 ... 10000)
(check "10k, n=5" (insert-if-short 'x flat 5) flat)                ; (1 2 ... 10000)
(check "10k length" (my-length (insert-if-short 'x flat 10001)) 10001) ; 10001

; ---------- make-inserter with other predicates ----------
(check "len = 2"
       ((make-inserter 'q (lambda (len) (= len 2))) '((1 2) (3) (4 5) ((6 7) 8 9)))
       '((q 1 2) (3) (q 4 5) ((q 6 7) 8 9)))     ; ((q 1 2) (3) (q 4 5) ((q 6 7) 8 9))
(check "len >= 3"
       ((make-inserter 'y (lambda (len) (>= len 3))) '(1 (2 3 4) ()))
       '(y 1 (y 2 3 4) ()))                      ; (y 1 (y 2 3 4) ())

; ---------- print-insert-result with stdin ----------
(define (run-with-input text)
  (let ((out (open-output-string)))
    (parameterize ((current-input-port (open-input-string text))
                   (current-output-port out))
      (print-insert-result))
    (get-output-string out)))
(display (if (string=? (run-with-input "42 ((1 2) (3 4 5) (6) ()) 3")
                       "((42 1 2) (3 4 5) (42 6) (42))\n")
             "PASS " "FAIL "))
(display "print-insert-result example 1")       ; ((42 1 2) (3 4 5) (42 6) (42))
(newline)
(display (if (string=? (run-with-input "7 () 0") "()\n") "PASS " "FAIL "))
(display "print-insert-result example 4")       ; ()
(newline)