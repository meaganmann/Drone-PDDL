(define (problem a5)
    (:domain drones)

    (:objects

        d1 d2 - drone
        a1 a2 a3 a4 a5 a6 b1 b2 b3 b4 b5 b6 c1 c2 c3 c4 c5 c6 - site
        mode1 mode2 - mode
    )

    (:init
        ; Drones start landed
        (landed d1 a2)
        (landed d2 a3)

        ; grid system
        ;|  c  |  b  |  a  |
        ;|  6  |  6  |  6  |
        ;|  5  |  5  |  5  |
        ;|  4  |  4  |  4  |
        ;|  3  |  3  |  3  |
        ;|  2  |  2  |  2  |
        ;|  1  |  1  |  1  |

        ; One drone starts at a2, the other at a3 
        ; a1 is available because it is the charging site

        (at d1 a2)
        (at d2 a3)

        (available a1)

        (available a4)
        (available a5)
        (available a6)
        (available b1)
        (available b2)
        (available b3)
        (available b4)
        (available b5)
        (available b6)
        (available c1)
        (available c2)
        (available c3)
        (available c4)
        (available c5)
        (available c6)

        ; charge site
        (charge-site a1) ;return to home, connect everything to charge site

        (return a2 a1)
        (return a3 a1)
        (return a4 a1)
        (return a5 a1)
        (return a6 a1)
        (return b1 a1)
        (return b2 a1)
        (return b3 a1)
        (return b4 a1)
        (return b5 a1)
        (return b6 a1)
        (return c1 a1)
        (return c2 a1)
        (return c3 a1)
        (return c4 a1)
        (return c5 a1)
        (return c6 a1)

        (resume a1 a2)
        (resume a1 a3)
        (resume a1 a4)
        (resume a1 a5)
        (resume a1 a6)
        (resume a1 b1)
        (resume a1 b2)
        (resume a1 b3)
        (resume a1 b4)
        (resume a1 b5)
        (resume a1 b6)
        (resume a1 c1)
        (resume a1 c2)
        (resume a1 c3)
        (resume a1 c4)
        (resume a1 c5)
        (resume a1 c6)

        ; Connectivity graph
        (connected a1 a2)
        (connected a2 a3)
        (connected a3 a4)
        (connected a4 a5)
        (connected a5 a6)
        (connected a6 b6)
        (connected b6 b5)
        (connected b5 b4)
        (connected b4 b3)
        (connected b3 b2)
        (connected b2 b1)
        (connected b1 c1)
        (connected c1 c2)
        (connected c2 c3)
        (connected c3 c4)
        (connected c4 c5)
        (connected c5 c6)

        (picture-site a2)
        (picture-site a3)
        (picture-site a4)
        (picture-site a5)
        (picture-site a6)
        (picture-site b1)
        (picture-site b2)
        (picture-site b3)
        (picture-site b4)
        (picture-site b5)
        (picture-site b6)
        (picture-site c1)
        (picture-site c2)
        (picture-site c3)
        (picture-site c4)
        (picture-site c5)
        (picture-site c6)

        ; Modes
        (mode-change mode1 mode2)
        (mode-change mode2 mode1)
        (current-mode d1 mode1)
        (current-mode d2 mode1)

        ; Picture & energy setup
        (= (current-pic-count d1) 0)
        (= (current-pic-count d2) 0)
        (= (min-pic-count d1) 2)
        (= (min-pic-count d2) 2)

        ; Energy below max so "<" holds
        (= (current-energy d1) 5)
        (= (current-energy d2) 5)
        (= (max-energy d1) 15)
        (= (max-energy d2) 15)

        ; Ready to take pictures
        (not-take-pic d1)
        (not-take-pic d2)
        ; (not (pic-taken d1 a2))
        ; (not (pic-taken d1 a3))
        ; (not (pic-taken d1 a4))
        ; (not (pic-taken d1 a5))
        ; (not (pic-taken d1 a6))
        ; (not (pic-taken d1 a2))
        ; (not (pic-taken d1 a3))
        ; (not (pic-taken d1 a4))
        ; (not (pic-taken d1 a5))
        ; (not (pic-taken d1 a6))
    )

    (:goal
        (and
            ; Each drone must take 2 pictures and be landed
            (>= (current-pic-count d1) 2)
            (>= (current-pic-count d2) 2)
            (landed d1 a2)
            (landed d2 a3)
        )
    )
)