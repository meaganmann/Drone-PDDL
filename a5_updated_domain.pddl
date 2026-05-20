
(define (domain drones)

    (:requirements :durative-actions :typing :fluents :timed-initial-literals :negative-preconditions :conditional-effects :equality :duration-inequalities
    )

    (:types
        drone site mode
        ;time
        )

    (:predicates
        (landed ?d - drone ?s - site)
        (flying ?d - drone)
        (not-take-pic ?d - drone)
        (pic-taken ?d - drone ?s - site)
        (changing ?d - drone)
        (connected ?s1 - site ?s2 - site)
        (available ?s - site)
        (mode-change ?from - mode ?to - mode)
        (current-mode ?d - drone ?m - mode)
        (picture-site ?s - site)
        (return ?from - site ?to - site)
        (charge-site ?s - site)
        (at ?d - drone ?s - site)
        (resume ?to - site ?from - site)
        (last-work-site ?d - drone ?from - site)
    )

    (:functions
        (current-energy ?d - drone)
        (max-energy ?d - drone)
        (current-pic-count ?d - drone)
        (min-pic-count ?d - drone)
    )

    (:durative-action takeoff
        :parameters (?d - drone ?s - site)
        :duration (= ?duration 0.5)
        :condition (and
            (at start (landed ?d ?s))
            (at start (< (current-energy ?d) (max-energy ?d)))
        )
        :effect (and
            (at end (flying ?d))
            (at end (increase (current-energy ?d) 1))
            (at end (not (landed ?d ?s)))
        )
    )

    (:durative-action land
        :parameters (?d - drone ?s - site)
        :duration (= ?duration 0.5)
        :condition (and
            (at start (flying ?d))
            (at start (at ?d ?s))
            (at start (< (current-energy ?d) (max-energy ?d)))
        )
        :effect (and
            (at start (not (flying ?d)))
            (at end (landed ?d ?s))
            (at end (increase (current-energy ?d) 1))

        )
    )

    ; must be landed to charge - removed available because return to home and return from home do the availability check already
    (:durative-action charge
        :parameters (?d - drone ?s - site)
        :duration (= ?duration 3)
        :condition (and
            (at start (available ?s)) ; one drone per station
            (at start (landed ?d ?s))
            ;(over all (landed ?d ?s))
            (over all (charge-site ?s))
            ; (over all (at ?d ?s))
            (at start (<= (current-energy ?d) (max-energy ?d))) ; can be less than or equal to mex energy used
        )
        :effect (and
            (at end (assign (current-energy ?d) 0))
        )
    )

    ; ;must be flying to return to home 
    ; (:durative-action return-to-home
    ;     :parameters (?d - drone ?from - site ?to - site)
    ;     :duration (= ?duration 5)
    ;     :condition (and
    ;         (at start (flying ?d))
    ;         (at start (available ?to)) ; charge site has to be available
    ;         (at start (charge-site ?to))
    ;         (over all (return ?from ?to))
    ;         (at start (<= (current-energy ?d) (max-energy ?d)))
    ;         (at start (at ?d ?from))
    ;     )
    ;     :effect (and
    ;         (at start (flying ?d))
    ;         (at start (not (at ?d ?from)))
    ;         (at start (not (available ?to))) ; reserve charge site
    ;         (at end (available ?from)) ; free the space that the drone was at previously
    ;         (at end (charge-site ?to))
    ;         (at end (at ?d ?to))
    ;         (at end (increase (current-energy ?d) 2))
    ;         (at end (last-work-site ?d ?from)) ; save previous location so return from home can find it
    ;     )
    ; )

    ; ;must be flying to return from home 
    ; (:durative-action return-from-home
    ;     :parameters (?d - drone ?from - site ?to - site)
    ;     :duration (= ?duration 5)
    ;     :condition (and
    ;         (at start (flying ?d))
    ;         (at start (available ?to)) ; previous location has to be free
    ;         (at start (charge-site ?from))
    ;         (at start (last-work-site ?d ?to))
    ;         (over all (resume ?from ?to))
    ;         (at start (<= (current-energy ?d) (max-energy ?d)))
    ;         (at start (at ?d ?from))
    ;     )
    ;     :effect (and
    ;         (at start (flying ?d))
    ;         (at start (last-work-site ?d ?to))
    ;         (at start (not (at ?d ?from)))
    ;         (at start (not(available ?to))) ; reserve previous location
    ;         (at end (available ?from)) ; charge site is unoccupied again
    ;         (at end (at ?d ?to))
    ;         (at end (increase (current-energy ?d) 2))
    ;         (at end (not (last-work-site ?d ?to))) ; remove last work site 
    ;     )
    ; )

    ; must be flying to move 
    (:durative-action move
        :parameters (?d - drone ?from - site ?to - site)
        :duration (= ?duration 2)
        :condition (and
            (at start (flying ?d))
            (at start (available ?to))
            (at start (at ?d ?from))
            (over all (connected ?from ?to))
            (at start (< (current-energy ?d) (max-energy ?d)))
        )
        :effect (and
            (at start (not (at ?d ?from)))
            (at start (flying ?d))
            (at start (not(available ?to))) ; reserve space
            (at end (at ?d ?to))
            (at end (available ?from)) ; free space where the drone was
            (at end (increase (current-energy ?d) 2))
        )
    )

    ; must be flying to take a pic 
    ; changed availability since handled by moving
    (:durative-action take-pic
        :parameters (?d - drone ?s - site)
        :duration (= ?duration 1.5)
        :condition (and
            ; (at start (available ?s))
            (at start (not-take-pic ?d))
            (over all (at ?d ?s))
            (over all (picture-site ?s))
            (over all (flying ?d))
            (at start (< (current-pic-count ?d) (min-pic-count ?d)))
            (at start (< (current-energy ?d) (max-energy ?d)))
        )
        :effect (and
            (at start (not (not-take-pic ?d)))
            ; (at start (not (available ?s)))
            (at end (not-take-pic ?d))
            ; (at end (available ?s))
            (at end (increase (current-pic-count ?d) 1))
            (at end (increase (current-energy ?d) 3))
        )
    )


    ; transition between fly nodes 
    (:durative-action transition
        :parameters (?d - drone ?from - mode ?to - mode)
        :duration (= ?duration 0.1)
        :condition (and
            (at start (mode-change ?from ?to))
            (at start (current-mode ?d ?from))
            (at end (current-mode ?d ?to))
        )
        :effect (and
            (at start (changing ?d))
            (at end (not (changing ?d)))
        )
    )
)