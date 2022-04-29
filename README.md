# scheme-event

Event programming with observers in Scheme

---

## Quickstart

```scheme
(import (event))

(define my-events1 (make-event))
(define my-events2 (make-event))
(define my-events3 (make-event))

(define my-mapped-events
  (event-map length my-events1))

(define my-folded-events
  (event-fold + 0 my-events2))

(define my-zipped-events
  (event-zip my-mapped-events
             my-folded-events
             my-events3))

(define my-filtered-events
  (event-filter even? my-zipped-events))

(event-for-each
  (lambda (x) (format #t "~a\n" x))
  my-filtered-events)
```

We've set up a small network of discrete events streams such that when you push event's onto `my-events1`, `my-events2` or `my-events3` (or even directly into intermediate event streams like `my-mapped-events`) they propagate through the network and end up in `event-for-each`.

The following code

```scheme
(event-push '(huey dewey louie) my-events1)
(event-push '(han-solo chewbacca) my-events1)

(event-push 1 my-events2)
(event-push 1 my-events2)
(event-push 3 my-events2)
(event-push 3 my-events2)

(event-push 1 my-events3)
(event-push 2 my-events3)
(event-push 3 my-events3)
(event-push 4 my-events3)
```

will output:

```
2
6
10
2
4
```
