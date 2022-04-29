(library (event)
  (export event-filter
          event-fold
          event-for-each
          event-map
          event-push
          event-zip
          make-event)
  (import (chezscheme))
  (define (make-event)
    (let ([fs '()])
      (cons
        (lambda (x) (for-each (lambda (f) (f x)) fs))
        (lambda (f) (set! fs (cons f fs))))))
  (define (event-push x event) ((car event) x))
  (define (event-for-each action event) ((cdr event) action))
  (define (event-zip event1 event2 . events)
    (let ([new-event (make-event)])
      (for-each
        (lambda (event)
          (event-for-each
            (lambda (x) (event-push x new-event))
            event))
        (cons* event1 event2 events))
      new-event))
  (define (event-map f event)
    (let ([new-event (make-event)])
      (event-for-each
        (lambda (x) (event-push (f x) new-event))
        event)
      new-event))
  (define (event-fold reducer state event)
    (let ([new-event (make-event)])
      (event-for-each
        (lambda (x)
          (event-push
            (begin (set! state (reducer state x)) state)
            new-event))
        event)
      new-event))
  (define (event-filter predicate event)
    (let ([new-event (make-event)])
      (event-for-each
        (lambda (x) (when (predicate x) (event-push x new-event)))
        event)
      new-event)))
