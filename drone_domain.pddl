; Meagan Mann 20mmm27@queensu.ca
; Robin Andersen 19risa@queensu.ca
; This domain models drones performing field tasks. 
; Each drone can take off, fly between sites, take pictures, and land. 
; The domain keeps track of several numeric resources:
; Picture counts per site (must reach a minimum required number)
; Picture counts per drone (each drone must take a minimum number of pictures)
; Battery energy usage (increases whenever the drone flies or works and must stay below a maximum allowed limit)
; The problem file is designed so that 2 drones fly from one corner of the grid to the opposite
; and specific sites need to be photographed.
(define (domain drones)

    (:requirements :durative-actions :typing :fluents :timed-initial-literals :negative-preconditions :conditional-effects :equality :duration-inequalities
    )

    (:types
        drone site mode
        )

    (:predicates
        (landed ?d - drone ?s - site)
        (flying ?d - drone)
        (not-take-pic ?d - drone)
        (photographed ?s - site)
        (changing ?d - drone)
        (connected ?s1 - site ?s2 - site)
        (available ?s - site)
        (mode-change ?from - mode ?to - mode)
        (current-mode ?d - drone ?m - mode)
        (picture-site ?s - site)
        (at ?d - drone ?s - site)
    )

    (:functions
        (current-energy ?d - drone)
        (max-energy ?d - drone)

        ; total pictures per drone
        (current-pic-count ?d - drone)
        (min-pic-count ?d - drone)

        ; pictures required per site per drone
        (site-pic-count ?d - drone ?s - site)
        (min-site-pics ?d - drone ?s - site)
    )

    ; Must be landed at a site to takeoff
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

    ; Must be flying over a site to land
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

    ; Must be flying to move 
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
            (at end (increase (current-energy ?d) 1))
        )
    )

    ; Must be flying the whole duration of taking a pic
    ; Must be at a site to take a pic
    ; There is a minimum number of pictures needed per site
    (:durative-action take-pic
        :parameters (?d - drone ?s - site)
        :duration (= ?duration 1.5)
        :condition (and
            (at start (not-take-pic ?d))
            (over all (at ?d ?s))
            (over all (picture-site ?s))
            (over all (flying ?d))
            (at start (< (site-pic-count ?d ?s) (min-site-pics ?d ?s)))
            (at start (< (current-pic-count ?d) (min-pic-count ?d)))
            (at start (< (current-energy ?d) (max-energy ?d)))
        )
        :effect (and
            (at start (not (not-take-pic ?d)))
            (at end (not-take-pic ?d))
            (at end (photographed ?s))
            (at end (increase (site-pic-count ?d ?s) 1))
            (at end (increase (current-pic-count ?d) 1))
            (at end (increase (current-energy ?d) 1))
        )
    )


    ; transition between fly modes; move and take-pic
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