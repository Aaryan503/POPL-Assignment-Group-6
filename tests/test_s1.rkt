#lang racket/base
; tests/test_s1.rkt: alias for tests/test_q3.rkt.
(require racket/runtime-path)
(define-runtime-path test-file "test_q3.rkt")
(dynamic-require test-file #f)
