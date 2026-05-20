(define (problem a5)
    (:domain drones)

    (:objects

        d1 d2 - drone
        a1 a2 a3 a4 a5 a6 b1 b2 b3 b4 b5 b6 c1 c2 c3 c4 c5 c6 - site
        mode1 mode2 - mode
    )

    (:init

        ; grid system
        ;|  c  |  b  |  a  |
        ;|  6  |  6  |  6  |
        ;|  5  |  5  |  5  |
        ;|  4  |  4  |  4  |
        ;|  3  |  3  |  3  |
        ;|  2  |  2  |  2  |
        ;|  1  |  1  |  1  |

        ; Drones start landed
        (landed d1 a1)
        (landed d2 a2)

        (at d1 a1)
        (at d2 a2)

        (available a3)
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
        (= (min-pic-count d1) 6)
        (= (min-pic-count d2) 6)

        ; Energy below max so "<" holds
        (= (current-energy d1) 0)
        (= (current-energy d2) 0)
        (= (max-energy d1) 100)
        (= (max-energy d2) 100)

        ; Ready to take pictures
        (not-take-pic d1)
        (not-take-pic d2)

        ; Require each drone take 2 pictures at each site visited
        (= (min-site-pics d1 a2) 2)
        (= (min-site-pics d1 a3) 2)
        (= (min-site-pics d1 a4) 2)

        (= (min-site-pics d2 b4) 2)
        (= (min-site-pics d2 b5) 2)
        (= (min-site-pics d2 b6) 2)

        ; Initialize all site counters to 0
        (= (site-pic-count d1 a1) 0)
        (= (site-pic-count d1 a2) 0)
        (= (site-pic-count d1 a3) 0)
        (= (site-pic-count d1 a4) 0)
        (= (site-pic-count d1 a5) 0)
        (= (site-pic-count d1 a6) 0)

        (= (site-pic-count d1 b1) 0)
        (= (site-pic-count d1 b2) 0)
        (= (site-pic-count d1 b3) 0)
        (= (site-pic-count d1 b4) 0)
        (= (site-pic-count d1 b5) 0)
        (= (site-pic-count d1 b6) 0)

        (= (site-pic-count d1 c1) 0)
        (= (site-pic-count d1 c2) 0)
        (= (site-pic-count d1 c3) 0)
        (= (site-pic-count d1 c4) 0)
        (= (site-pic-count d1 c5) 0)
        (= (site-pic-count d1 c6) 0)

        (= (site-pic-count d2 a1) 0)
        (= (site-pic-count d2 a2) 0)
        (= (site-pic-count d2 a3) 0)
        (= (site-pic-count d2 a4) 0)
        (= (site-pic-count d2 a5) 0)
        (= (site-pic-count d2 a6) 0)

        (= (site-pic-count d2 b1) 0)
        (= (site-pic-count d2 b2) 0)
        (= (site-pic-count d2 b3) 0)
        (= (site-pic-count d2 b4) 0)
        (= (site-pic-count d2 b5) 0)
        (= (site-pic-count d2 b6) 0)

        (= (site-pic-count d2 c1) 0)
        (= (site-pic-count d2 c2) 0)
        (= (site-pic-count d2 c3) 0)
        (= (site-pic-count d2 c4) 0)
        (= (site-pic-count d2 c5) 0)
        (= (site-pic-count d2 c6) 0)

    )

    (:goal
        (and
            ; Each drone must take 6 pictures at the required sites and be landed at the other end of the grid
            (>= (current-pic-count d1) (min-pic-count d1))
            (>= (current-pic-count d2) (min-pic-count d2))
            (landed d2 c6)
            (landed d1 c5)
        )
    )
)