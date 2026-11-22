#lang racket/base

; (my-length lst): the number of top-level elements of lst.
; Base case: lst is '(), so the result is the accumulator acc.
; Recursive case: add 1 to acc and continue with (cdr lst).
; Tail-recursive: the recursive call is the last action.
(define (my-length lst)
  (let loop ((rest lst) (acc 0))
    (if (null? rest)
        acc
        (loop (cdr rest) (+ acc 1)))))

; (my-reverse lst): the elements of lst in the opposite order.
; Base case: lst is '(), so the result is the accumulator acc.
; Recursive case: cons (car lst) onto acc and continue with (cdr lst).
; Tail-recursive: the first element goes to the bottom of acc.
(define (my-reverse lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        acc
        (loop (cdr rest) (cons (car rest) acc)))))

; (my-map f lst): the list of (f e) for each element e of lst, in order.
; Base case: lst is '(), so the result is (my-reverse acc).
; Recursive case: cons (f (car lst)) onto acc and continue with (cdr lst).
; Tail-recursive: acc holds the results in reverse order, and the
; final my-reverse puts them back in order. The stack does not grow with
; the list length, so a 10,000-element list is safe.
(define (my-map f lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        (my-reverse acc)
        (loop (cdr rest) (cons (f (car rest)) acc)))))

; (list-like? e): #t when e is a list (empty or non-empty), #f for an atom.
; '() counts as a list of length 0, not as an atom.
(define (list-like? e)
  (or (null? e) (pair? e)))

; (make-inserter x len-ok?): a function of one list. It puts x at the
; front of every list, at every level of nesting, whose ORIGINAL length
; satisfies len-ok?.
; Base case: an atom element stays the same.
; Recursive case: each sublist element is processed by the same inserter.
; Then, if (len-ok? (my-length lst)) holds, x is consed onto the result.
; letrec lets the inner function call itself.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((inner (my-map (lambda (e)
                                     (if (list-like? e)
                                         (insert e)
                                         e))
                                   lst)))
                (if (len-ok? (my-length lst))
                    (cons x inner)
                    inner)))))
    insert))

; (insert-if-short x lst n): lst with x put at the front of every list
; whose original length is less than n. It is the inserter whose
; length test is (< len n), applied to lst.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

; (print-insert-result): read x, then lst, then n from standard input,
; and display (insert-if-short x lst n) followed by a newline.
; let* evaluates the three reads in order, so x is read first.
; Nothing else is printed.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))