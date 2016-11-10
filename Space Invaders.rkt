;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |Space Invaders (1)|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;;; Space Invaders

(require 2htdp/image)
(require 2htdp/universe)

;; An Invader is a Posn 
;; INTERP: represents the location of the invader

;; A Bullet is a Posn 
;; INTERP: represents the location of a bullet

;; A Location is a Posn 
;; INTERP: represents a location of a spaceship

;;; Template
;; posn-fn : Posn -> ???
#; (define (posn-fn a-posn)
     ...(posn-x a-posn)...
     ...(posn-y a-posn)...)

;; A Direction is one of: 
;; - 'left
;; - 'right 
;; INTERP: represent the direction of movement for the spaceship

(define LEFT 'left)
(define RIGHT 'right)

;;; Template
;; direction-fn : Direction -> ???
#; (define (direction-fn dir)
     (cond
       [(symbol=? LEFT) ...]
       [(symbol=? RIGHT) ...]))

(define-struct ship (dir loc))
;; A Ship is (make-ship Direction Location) 
;; INTERP: represent the spaceship with its current direction 
;;         and movement

;;; Template
;; ship-fn : Ship -> ???
#; (define (ship-fn a-ship)
     ...(direction-fn (ship-dir a-ship))...
     ...(posn-fn (ship-loc a-ship))...)

;; A List of Invaders (LoI) is one of 
;; - empty 
;; - (cons Invader LoI)

;;; Template
;; loi-fn : LoI -> ???
#; (define (loi-fn a-loi)
     (cond
       [(empty? a-loi) ...]
       [(cons? a-loi)...(posn-fn (first a-loi))...
                     ...(loi-fn (rest a-loi))...]))

;; A List of Bullets (LoB) is one of 
;; - empty
;; - (cons Bullet LoB)

;;; Template
;; lob-fn : LoB -> ???
#; (define (lob-fn a-lob)
     (cond
       [(empty? a-lob) ...]
       [(cons? a-lob)...(posn-fn (first a-lob))...
                     ...(lob-fn (rest a-lob))...]))

;; A Life is a Int
;; INTERP: represents the number of available spaceship lives

;; A Score is a NonNegInt
;; INTERP: represents the running score of the game

;;A TickCount is a NonNegInt
;; INTERP: represents the number of ticks since the start of the game 

(define-struct world (ship
                      invaders
                      ship-bullets
                      invader-bullets
                      lives
                      score
                      tick-count))

;; A World is (make-world Ship LoI LoB LoB Life Score TickCount) 
;; INTERP: represent the ship, the current list of invaders,
;;         the inflight spaceship bullets,
;;         the inflight invader bullets,
;;         the number of available spaceship lives,
;;         the running score of the game and
;;         the number of ticks since the start of the game

;;; Template
;; world-fn : World -> ???
#; (define (world-fn a-world)
     ...(ship-fn (world-ship a-world))...
     ...(loi-fn (world-invaders a-world))...
     ...(lob-fn (world-ship-bullets a-world))...
     ...(lob-fn (world-invader-bullets a-world))...
     ...(world-lives a-world)...
     ...(world-score a-world)...
     ...(world-tick-count a-world)...)

(define WIDTH 500) 
(define HEIGHT 500) 

(define MAX-SHIP-BULLETS 3)

(define MAX-INVADER-BULLETS 10)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define SPACESHIP-BULLET-IMAGE (circle 2 'solid 'black))

(define SHIP-WIDTH 25)

(define SHIP-HEIGHT 15)

(define SPACESHIP-IMAGE (rectangle SHIP-WIDTH SHIP-HEIGHT 'solid 'black))

(define INVADER-SIDE 20)

(define INVADER-IMAGE (square INVADER-SIDE 'solid 'red))

(define INVADER-BULLET-IMAGE (circle 2 'solid 'red))

(define SHIP-SPEED 10)

(define BULLET-SPEED 10)

(define INVADER-SPEED 5)

(define SCORE-PER-HIT 5)

(define BULLET-RADIUS 2)

(define SHIP-INIT (make-ship 'left (make-posn 250 480)))

(define INVADERS-INIT 
  (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20) 
        (make-posn 220 20) (make-posn 260 20) (make-posn 300 20) 
        (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
        (make-posn 100 50) (make-posn 140 50) (make-posn 180 50) 
        (make-posn 220 50) (make-posn 260 50) (make-posn 300 50) 
        (make-posn 340 50) (make-posn 380 50) (make-posn 420 50)
        (make-posn 100 80) (make-posn 140 80) (make-posn 180 80) 
        (make-posn 220 80) (make-posn 260 80) (make-posn 300 80) 
        (make-posn 340 80) (make-posn 380 80) (make-posn 420 80)
        (make-posn 100 110) (make-posn 140 110) (make-posn 180 110) 
        (make-posn 220 110) (make-posn 260 110) (make-posn 300 110) 
        (make-posn 340 110) (make-posn 380 110) (make-posn 420 110)))

(define TICK-INIT 0)

(define WORLD-INIT (make-world SHIP-INIT
                               INVADERS-INIT
                               empty
                               empty
                               2
                               0
                               TICK-INIT))




;;; Signature
;; convert-any->one : Any -> Int

;;; Purpose
;; Given any data type, returns 1

(define (convert-any->one a-posn)
  1)

;;; Tests
(check-expect (convert-any->one (make-posn 0 40)) 1)

;;; Signature
;; list-length : LoI -> NonNegInt

;;; Purpose
;; Given a list of invaders counts the number of elements in the list

(define (list-length a-loi)
  (foldr + 0 (map convert-any->one a-loi)))

;;; Tests
(check-expect (list-length empty) 0)

(check-expect (list-length (cons (make-posn 12 10)  empty)) 1)

(check-expect
 (list-length (cons (make-posn 12 10) (cons (make-posn 12 1) empty))) 2)

;;; Signature
;; lookup : Lof[X] Number -> X
;; WHERE: Lof[X] is not empty
;; WHERE: 0 <= Number < length of Lof[X]

;;; Purpose
;; Given a list and an index return
;; the element of the list at the given index

;;; Examples
;; (lookup (cons "c" (cons "d" (cons "e" empty))) 0) => "c"
;; (lookup (cons "a" (cons "b" empty)) 1) => "b"

(define (lookup list n)
  (cond
    [(= 0 n) (first list)]
    [else (lookup (rest list) (- n 1))]))

;;; Tests
(check-expect (lookup (cons "c" (cons "d" (cons "e" empty))) 0) "c")
(check-expect (lookup (cons "a" (cons "b" empty)) 1) "b")

;;; Signature
;; ship-draw : Ship Image -> Image

;;; Purpose
;; Given a ship and a background draws the ship on the background

(define (ship-draw a-ship background)
  (place-image SPACESHIP-IMAGE
               (posn-x (ship-loc a-ship))
               (posn-y (ship-loc a-ship))
               background))

;;; Tests
(check-expect (ship-draw (make-ship LEFT (make-posn 50 60)) BACKGROUND)
              (place-image SPACESHIP-IMAGE 50 60 BACKGROUND))
(check-expect (ship-draw (make-ship RIGHT (make-posn 200 300)) BACKGROUND) 
              (place-image SPACESHIP-IMAGE 200 300 BACKGROUND))

;;; Signature
;; draw-inv : Invader Image -> Image

;;; Purpose
;; Given an invader and a background
;; draws the invader on the background

(define (draw-inv an-invader a-background)
  (place-image INVADER-IMAGE
               (posn-x an-invader)
               (posn-y an-invader)
               a-background))

;;; Tests
(check-expect (draw-inv (make-posn 50 50) BACKGROUND)
              (place-image INVADER-IMAGE
                           50 50 BACKGROUND))


;;; Signature
;; invaders-draw : LoI Image -> Image

;;; Purpose
;; Given a list of invaders and a background
;; draw all the invaders on the background

(define (invaders-draw loi background)
  (foldr draw-inv background loi))

;;; Tests
(check-expect (invaders-draw empty BACKGROUND) BACKGROUND)
(check-expect (invaders-draw (cons (make-posn 45 60) empty) BACKGROUND)
              (place-image INVADER-IMAGE 45 60 BACKGROUND))
(check-expect (invaders-draw
               (cons (make-posn 45 60)
                     (cons (make-posn 70 90) empty)) BACKGROUND)
              (place-image INVADER-IMAGE 45 60
                           (place-image INVADER-IMAGE 70 90 BACKGROUND)))

;;; Signature
;; draw-ship-bullet : Bullet Image -> Image

;;; Purpose
;; Given a ship bullet and a background
;; draws the ship bullet on the background

(define (draw-ship-bullet a-ship-bullet a-background)
  (place-image SPACESHIP-BULLET-IMAGE
               (posn-x a-ship-bullet)
               (posn-y a-ship-bullet)
               a-background))

;;; Tests
(check-expect (draw-ship-bullet (make-posn 50 50) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE
                           50 50 BACKGROUND))

;;; Signature
;; ship-bullets-draw : LoB Image -> Image

;;; Purpose
;; Given a list of ship bullets and a background
;; draws all the bullets on the background


(define (ship-bullets-draw lob background)
  (foldr draw-ship-bullet background lob))

;;; Tests
(check-expect (ship-bullets-draw empty BACKGROUND) BACKGROUND)

(check-expect (ship-bullets-draw (cons (make-posn 45 60) empty) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 45 60 BACKGROUND))

(check-expect (ship-bullets-draw
               (cons (make-posn 45 60)
                     (cons (make-posn 70 90) empty)) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 45 60
                           (place-image SPACESHIP-BULLET-IMAGE
                                        70 90 BACKGROUND)))

;;; Signature
;; draw-invader-bullet : Bullet Image -> Image

;;; Purpose
;; Given an invader bullet and a background
;; draws the invader bullet on the background

(define (draw-invader-bullet an-invader-bullet a-background)
  (place-image INVADER-BULLET-IMAGE
               (posn-x an-invader-bullet)
               (posn-y an-invader-bullet)
               a-background))

;;; Tests
(check-expect (draw-invader-bullet (make-posn 50 50) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE
                           50 50 BACKGROUND))

;;; Signature
;; invader-bullets-draw : LoB Image -> Image

;;; Purpose
;; Given a list of invader bullets and a background
;; draws all the invader bullets on the background


(define (invader-bullets-draw lob background)
  (foldr draw-invader-bullet background lob))

;;; Tests
(check-expect (invader-bullets-draw empty BACKGROUND) BACKGROUND)
(check-expect (invader-bullets-draw
               (cons (make-posn 45 60) empty) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 45 60 BACKGROUND))
(check-expect (invader-bullets-draw
               (cons (make-posn 45 60)
                     (cons (make-posn 70 90) empty)) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 45 60
                           (place-image INVADER-BULLET-IMAGE 70 90 BACKGROUND)))

;;; Signature
;; score-draw : Score Image -> Image

;;; Purpose
;; Given a score and a background draws the score on the background

(define (score-draw a-score img)
  (place-image
   (text (string-append "Score: " (number->string a-score)) 12 "indigo")
   460 20
   img))

;;; Tests
(check-expect (score-draw 20 BACKGROUND)
              (place-image (text "Score: 20" 12 "indigo")
                           460 20
                           BACKGROUND))

;;; Signature
;; lives-draw : Life Image -> Image

;;; Purpose
;; Given a life and a background draws the life on the background

(define (lives-draw a-life img)
  (cond
    [(< a-life 0)
     (place-image
      (text "You lose :P" 12 "indigo") 35 494 img)]
    [else
     (place-image
      (text (string-append "Lives: " (number->string a-life)) 12 "indigo")
      35 494
      img)]))

;;; Tests
(check-expect (lives-draw -1 BACKGROUND)
              (place-image (text "You lose :P"
                                 12 "indigo")
                           35 494
                           BACKGROUND))

(check-expect (lives-draw 2 BACKGROUND)
              (place-image (text "Lives: 2" 12 "indigo")
                           35 494
                           BACKGROUND))

;;; Signature
;; world-draw : World -> Image

;;; Purpose
;; Given a world and a background
;; draws all the components of the world on the background

(define (world-draw a-world)
  (score-draw
   (world-score a-world)
   (lives-draw
    (world-lives a-world)
    (ship-draw
     (world-ship a-world)
     (invaders-draw
      (world-invaders a-world) 
      (ship-bullets-draw
       (world-ship-bullets a-world)
       (invader-bullets-draw
        (world-invader-bullets a-world) BACKGROUND)))))))


;;; Tests
(check-expect (world-draw (make-world (make-ship LEFT (make-posn 25 40))
                                      (cons (make-posn 70 80) empty)
                                      (cons (make-posn 90 100) empty)
                                      (cons (make-posn 300 225) empty) 3 40 3))
              (place-image
               (text (string-append "Score: " (number->string 40)) 12 "indigo")
               460 20
               (place-image
                SPACESHIP-IMAGE 25 40
                (place-image
                 (text
                  (string-append "Lives: "
                                 (number->string 3)) 12 "indigo")
                 35 494
                 (place-image
                  INVADER-IMAGE
                  70 80
                  (place-image
                   SPACESHIP-BULLET-IMAGE
                   90 100
                   (place-image
                    INVADER-BULLET-IMAGE
                    300 225 BACKGROUND)))))))

;;; Signature
;; move-spaceship: Ship -> Ship

;;; Purpose
;; move the ship in the appropriate direction
;; unless it hits the boundary of the world


(define (move-spaceship a-ship)
  (cond
    [(and (<= (- (posn-x (ship-loc a-ship))
                 (/ SHIP-WIDTH 2)) 0)
          (symbol=? LEFT (ship-dir a-ship))) a-ship]
    
    [(and (>= (+ (posn-x (ship-loc a-ship))
                 (/ SHIP-WIDTH 2)) WIDTH)
          (symbol=? RIGHT (ship-dir a-ship))) a-ship]
    
    [(symbol=? LEFT (ship-dir a-ship)) (make-ship
                                         LEFT
                                         (make-posn
                                          (-
                                           (posn-x (ship-loc a-ship))
                                           SHIP-SPEED)
                                          (posn-y (ship-loc a-ship))))]
    
    [(symbol=? RIGHT (ship-dir a-ship)) (make-ship
                                          RIGHT
                                          (make-posn
                                           (+
                                            (posn-x (ship-loc a-ship))
                                            SHIP-SPEED)
                                           (posn-y (ship-loc a-ship))))]))

;;; Tests:

(check-expect (move-spaceship (make-ship LEFT (make-posn 7.5 480)))
              (make-ship LEFT (make-posn 7.5 480)))

(check-expect (move-spaceship (make-ship RIGHT (make-posn 492.5 480)))
              (make-ship RIGHT (make-posn 492.5 480)))

(check-expect (move-spaceship (make-ship LEFT (make-posn 100 480)))
              (make-ship LEFT (make-posn 90 480)))

(check-expect (move-spaceship (make-ship RIGHT (make-posn 140 480)))
              (make-ship RIGHT (make-posn 150 480)))


;;; Signature
;; change-direction : Ship Key-Event -> Ship

;;; Purpose
;; change the ship's direction if the user presses the left or right arrow key

(define (change-direction a-ship key-event)
  (cond
    [(key=? key-event "left") (make-ship LEFT (ship-loc a-ship))]
    [(key=? key-event "right") (make-ship RIGHT (ship-loc a-ship))]
    [else a-ship]))

;;; Tests
(check-expect (change-direction (make-ship RIGHT (make-posn 60 70)) "left")
              (make-ship LEFT (make-posn 60 70)))
(check-expect (change-direction (make-ship LEFT (make-posn 80 90)) "right")
              (make-ship RIGHT (make-posn 80 90)))
(check-expect (change-direction (make-ship RIGHT (make-posn 30 40)) "down")
              (make-ship RIGHT (make-posn 30 40)))

;;; Signature
;; ship-fire : Ship LoB Key-Event -> LoB

;;; Purpose
;; Given a ship and a list of ship bullets
;; fires a bullet from the ship at its current location
;; when the user presses the space key
;; unless there are already 3 spaceship bullets in the list


(define (ship-fire a-ship lob key-event)
  (cond
    [(key=? key-event " ")
     (cond
       [(>= (list-length lob) MAX-SHIP-BULLETS) lob]
       [else (cons (make-posn (posn-x (ship-loc a-ship))
                              (- (posn-y (ship-loc a-ship)) BULLET-RADIUS)) lob)])]
    [else lob]))

;;; Tests
(check-expect (ship-fire (make-ship LEFT (make-posn 250 40)) empty " ") 
              (cons (make-posn 250 38) empty))

(check-expect (ship-fire (make-ship RIGHT (make-posn 300 25))
                         (cons (make-posn 200 400) empty) " ") 
              (cons (make-posn 300 23) (cons (make-posn 200 400) empty)))

(check-expect (ship-fire (make-ship LEFT (make-posn 20 50))
                         (cons (make-posn 40 20)
                               (cons (make-posn 400 380)
                                     (cons (make-posn 200 200) empty))) " ")
              (cons (make-posn 40 20)
                    (cons (make-posn 400 380)
                          (cons (make-posn 200 200) empty))))

(check-expect (ship-fire (make-ship LEFT (make-posn 200 300))
                         (cons (make-posn 45 65) empty) "left")
              (cons (make-posn 45 65) empty))

;;; Signature
;; key-handler : World Key-Event -> World

;;; Purpose
;; Handle things when the user hits a key on the keyboard.

(define (key-handler w ke)
  (cond 
    [(or (key=? ke "left")
         (key=? ke "right")
         (key=? ke " "))
     (make-world (change-direction (world-ship w) ke)
                 (world-invaders w)
                 (ship-fire (world-ship w) (world-ship-bullets w) ke)
                 (world-invader-bullets w)
                 (world-lives w)
                 (world-score w)
                 (world-tick-count w))]
    [else w]))

(check-expect (key-handler WORLD-INIT "right")
              (make-world (make-ship RIGHT (make-posn 250 480))
                          (world-invaders WORLD-INIT)
                          (world-ship-bullets WORLD-INIT)
                          (world-invader-bullets WORLD-INIT)
                          (world-lives WORLD-INIT)
                          (world-score WORLD-INIT)
                          (world-tick-count WORLD-INIT)))

(check-expect (key-handler WORLD-INIT " ")
              (make-world (world-ship WORLD-INIT)
                          (world-invaders WORLD-INIT)
                          (cons (make-posn 250 478) empty)
                          (world-invader-bullets WORLD-INIT)
                          (world-lives WORLD-INIT)
                          (world-score WORLD-INIT)
                          (world-tick-count WORLD-INIT)))

(check-expect (key-handler WORLD-INIT "p")
              WORLD-INIT)



;;;Signature
;; move-ship-bullet : Bullet -> Bullet

;;;Purpose
;; Given a ship bullet moves the bullet upwards by SPEED units

(define (move-ship-bullet a-bullet)
  (make-posn (posn-x a-bullet)
             (- (posn-y a-bullet) BULLET-SPEED)))

;;; Tests
(check-expect (move-ship-bullet (make-posn 10 200)) (make-posn 10 190))

;;; Signature
;; move-spaceship-bullets : LoB -> LoB

;;; Purpose
;; move each spaceship bullet in the list upwards by SPEED units

(define (move-spaceship-bullets a-lob)
  (map move-ship-bullet a-lob))

;;; Tests
(check-expect (move-spaceship-bullets empty) empty)

(check-expect (move-spaceship-bullets
               (cons (make-posn 45 60)
                     (cons (make-posn 300 200) empty)))
              (cons (make-posn 45 50)
                    (cons (make-posn 300 190) empty)))

;;; Signature
;; move-invader-bullet : Bullet -> Bullet

;;; Purpose
;; Given an invader bullet
;; moves the bullet downwards by SPEED units

(define (move-invader-bullet a-bullet)
  (make-posn (posn-x a-bullet)
             (+ (posn-y a-bullet) BULLET-SPEED)))
;;; Tests
(check-expect (move-invader-bullet (make-posn 45 60)) (make-posn 45 70))

;;; Signature
;; move-invader-bullets : LoB -> LoB

;;; Purpose
;; move each bullet in the list downwards by SPEED units

(define (move-invader-bullets lob)
  (map move-invader-bullet lob))

;;; Tests
(check-expect (move-invader-bullets empty) empty)
(check-expect (move-invader-bullets (cons (make-posn 45 60)
                                          (cons (make-posn 300 200) empty)))
              (cons (make-posn 45 70) (cons (make-posn 300 210) empty)))


;;; Signature
;; move-invader : Invader -> Invader

;;; Purpose
;; Given an invader moves the invader downwards by SPEED units

(define (move-invader an-invader)
  (make-posn (posn-x an-invader)
             (+ (posn-y an-invader) INVADER-SPEED)))
;;; Tests
(check-expect (move-invader (make-posn 50 60)) (make-posn 50 65))


;;; Signature
;; move-invaders : LoI -> LoI

;;; Purpose
;; move each invader in the list downwards by SPEED units

(define (move-invaders loi)
  (map move-invader loi))

;;; Tests
(check-expect (move-invaders empty) empty)
(check-expect (move-invaders (list (make-posn 60 70) (make-posn 300 200)))
              (list (make-posn 60 75) (make-posn 300 205)))

;;; Signature
;; move-every-10-ticks : TickCount LoI -> LoI

;;; Purpose
;; Given a list of invaders,moves the invaders after every
;; 10 ticks and returns the list of invaders

(define (move-every-10-ticks a-tick-count a-loi)
  (cond
    [(= 0 a-tick-count) a-loi]
    [(= 0 (remainder a-tick-count 10)) (move-invaders a-loi)]
    [else a-loi]))

;;; Tests

(check-expect (move-every-10-ticks 0 (list (make-posn 40 30)))
              (list (make-posn 40 30)))
(check-expect (move-every-10-ticks 10 (list (make-posn 40 30)))
              (list (make-posn 40 35)))
(check-expect (move-every-10-ticks 18 (list (make-posn 40 30)))
              (list (make-posn 40 30)))


;;; Signature
;; move-world : World -> World

;;; Purpose
;; moves all the parts of the world appropriately

(define (move-world w)
  (make-world (move-spaceship (world-ship w))
              (move-every-10-ticks (world-tick-count w) (world-invaders w)) 
              (move-spaceship-bullets (world-ship-bullets w))
              (move-invader-bullets (world-invader-bullets w))
              (world-lives w)
              (world-score w)
              (world-tick-count w)))

;;; Tests
(check-expect (move-world (make-world (make-ship RIGHT (make-posn 40 50))
                                      (cons (make-posn 70 80) empty)
                                      (cons (make-posn 90 100) empty)
                                      (cons (make-posn 200 300) empty)
                                      2 20 4))
              (make-world (make-ship RIGHT (make-posn 50 50))
                          (cons (make-posn 70 80) empty)
                          (cons (make-posn 90 90) empty)
                          (cons (make-posn 200 310) empty) 2 20 4))

;;; Signature
;; invader-fire : Invader LoB -> LoB

;;; Purpose
;; Given an invader and list of invader bullets
;; fire a bullet from the position of the given invader
;; unless there are already 10 bullets in the list

(define (invader-fire an-invader lob)
  (cond
    [(>= (list-length lob) MAX-INVADER-BULLETS) lob]
    [else (cons (make-posn (posn-x an-invader)
                           (+ (posn-y an-invader) BULLET-RADIUS)) lob)]))

;;; Tests
(check-expect (invader-fire
               (make-posn 200 200)
               (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20) 
                     (make-posn 220 20) (make-posn 260 20) (make-posn 300 20) 
                     (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
                     (make-posn 100 50) (make-posn 140 50) (make-posn 180 50) 
                     (make-posn 220 50) (make-posn 260 50) (make-posn 300 50)))
              (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20) 
                    (make-posn 220 20) (make-posn 260 20) (make-posn 300 20) 
                    (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
                    (make-posn 100 50) (make-posn 140 50) (make-posn 180 50) 
                    (make-posn 220 50) (make-posn 260 50) (make-posn 300 50)))

(check-expect (invader-fire (make-posn 50 60) empty)
              (cons (make-posn 50 62) empty))

(check-expect (invader-fire (make-posn 50 60) (cons (make-posn 300 400) empty))
              (cons (make-posn 50 62) (cons (make-posn 300 400) empty)))

;;; Signature
;; select-random : LoI -> Invader
;; WHERE: LoI is non-empty

;;; Purpose
;; Given a list of invaders selects a random invader from the list 

(define (select-random loi)
  (lookup loi (random (list-length loi))))

(check-random (select-random (list (make-posn 40 20)
                                   (make-posn 50 60)
                                   (make-posn 100 100)
                                   (make-posn 300 300)))
              (lookup (list (make-posn 40 20)
                            (make-posn 50 60)
                            (make-posn 100 100)
                            (make-posn 300 300))
                      (random 4)))

;;; Signature
;; invaders-fire : LoB LoI -> LoB

;;; Purpose
;; Given a list of invader bullets and a list of invaders
;; fire a bullet from the position of a random invader in the list

(define (invaders-fire lob loi)
  (invader-fire (select-random loi) lob))


;;; Tests
(check-random (invaders-fire (list (make-posn 30 40)
                                   (make-posn 50 50)
                                   (make-posn 60 70)) 
                             (list (make-posn 70 80)
                                   (make-posn 90 100)
                                   (make-posn 20 10)))
              (invader-fire (select-random
                             (list (make-posn 70 80)
                                   (make-posn 90 100)
                                   (make-posn 20 10)))
                            (list (make-posn 30 40)
                                  (make-posn 50 50)
                                  (make-posn 60 70))))

;;; Signature
;; bullet-hit-invader? : Invader Bullet -> Boolean

;;; Purpose
;; Given an invader and a bullet return true
;; if the bullet hit the invader, false otherwise

(define (bullet-hit-invader? an-invader a-bullet)
  (and (and (>= (+ (posn-y a-bullet) BULLET-RADIUS) (- (posn-y an-invader)
                                           (/ INVADER-SIDE 2)))
            (<= (- (posn-y a-bullet) BULLET-RADIUS) (+ (posn-y an-invader)
                                           (/ INVADER-SIDE 2))))
       (and (<= (posn-x a-bullet) (+ (/ INVADER-SIDE 2)
                                     (posn-x an-invader)))
            (>= (posn-x a-bullet) (- (posn-x an-invader)
                                     (/ INVADER-SIDE 2))))))

;;; Tests
(check-expect (bullet-hit-invader? (make-posn 250 45)
                                   (make-posn 245 50)) #true)
(check-expect (bullet-hit-invader? (make-posn 250 45)
                                   (make-posn 30 200)) #false)

;;; Signature
;; invader-hit? : Invader LoB -> Boolean

;;; Purpose
;; Given an invader and a list of bullets
;; return true if any of the bullets in the list hit the invader,
;; false otherwise

(define (invader-hit? an-invader lob)
  (cond
    [(empty? lob) #false]
    [(cons? lob) (or (bullet-hit-invader? an-invader (first lob))
                     (invader-hit? an-invader (rest lob)))]))

;;; Tests
(check-expect (invader-hit? (make-posn 300 200) empty) #false)
(check-expect (invader-hit? (make-posn 300 200)
                            (cons (make-posn 305 205)
                                  (cons (make-posn 45 50) empty))) #true)
(check-expect (invader-hit? (make-posn 300 200)
                            (cons (make-posn 450 350)
                                  (cons (make-posn 45 50) empty))) #false)

;;; Signature
;; any-invader-hit? : LoI LoB -> Boolean

;;; Purpose
;; Given a list of invaders and a list of ship bullets
;; return true if any of the invaders were hit


(define (any-invader-hit? loi lob)
  (cond
    [(empty? loi) #false]
    [else
     (or (invader-hit? (first loi) lob)
         (any-invader-hit? (rest loi) lob))]))

;;; Tests
(check-expect (any-invader-hit? empty (list (make-posn 40 40))) #false)
(check-expect (any-invader-hit? (list (make-posn 50 50)
                                      (make-posn 100 100)) empty)
              #false)
(check-expect (any-invader-hit? (list (make-posn 50 50) (make-posn 100 100))
                                (list (make-posn 50 50)))
              #true)


;;; Signature
;; remove-hits : LoI LoB -> LoI

;;; Purpose
;; Given a list of invaders and a list of ship bullets
;; remove any invaders from the list
;; that have been hit by a bullet

(define (remove-hits loi lob)
  (cond
    [(empty? loi) loi]
    [(cons? loi) (cond
                   [(invader-hit? (first loi) lob)
                    (remove-hits (rest loi) lob)]
                   [else (cons (first loi)
                               (remove-hits (rest loi) lob))])]))

;;; Tests
(check-expect (remove-hits empty (cons (make-posn 30 40) empty)) empty)

(check-expect (remove-hits (cons (make-posn 50 60)
                                 (cons (make-posn 400 300) empty))
                           (cons (make-posn 55 65)
                                 (cons (make-posn 200 200) empty)))
              (cons (make-posn 400 300) empty))

(check-expect (remove-hits (cons (make-posn 50 60)
                                 (cons (make-posn 400 300) empty))
                           (cons (make-posn 20 20)
                                 (cons (make-posn 450 350) empty)))
              (cons (make-posn 50 60) (cons (make-posn 400 300) empty)))

(check-expect (remove-hits (cons (make-posn 50 60)
                                 (cons (make-posn 400 300) empty))
                           (cons (make-posn 20 20)
                                 (cons (make-posn 405 295) empty)))
              (cons (make-posn 50 60) empty))

;;; Signature
;; add-to-score : World -> World

;;; Purpose
;; add 5 points to the running score
;; each time any invader is hit by a spaceship bullet

(define (add-to-score w)
  (cond
    [(any-invader-hit? (world-invaders w) (world-ship-bullets w))
     (make-world (world-ship w) (world-invaders w) (world-ship-bullets w)
                 (world-invader-bullets w) (world-lives w)
                 (+ (world-score w) SCORE-PER-HIT) (world-tick-count w))]
    [else w]))

;;; Tests

(check-expect (add-to-score (make-world (make-ship RIGHT (make-posn 40 480))
                                        (list (make-posn 300 200))
                                        (list (make-posn 305 205))
                                        (list (make-posn 40 40))
                                        2 30 6))
              (make-world (make-ship RIGHT (make-posn 40 480))
                          (list (make-posn 300 200))
                          (list (make-posn 305 205))
                          (list (make-posn 40 40))
                          2 35 6))

(check-expect (add-to-score (make-world (make-ship RIGHT (make-posn 40 480))
                                        (list (make-posn 300 200))
                                        (list (make-posn 350 250))
                                        (list (make-posn 40 40))
                                        2 30 8))
              (make-world (make-ship RIGHT (make-posn 40 480))
                          (list (make-posn 300 200))
                          (list (make-posn 350 250))
                          (list (make-posn 40 40))
                          2 30 8))

(check-expect (add-to-score (make-world (make-ship RIGHT (make-posn 40 480))
                                        (list (make-posn 300 200))
                                        (list (make-posn 305 205))
                                        (list (make-posn 40 40))
                                        2 30 10))
              (make-world (make-ship RIGHT (make-posn 40 480))
                          (list (make-posn 300 200))
                          (list (make-posn 305 205))
                          (list (make-posn 40 40))
                          2 35 10))

;;; Signature
;; bullet-hit? : Bullet LoI -> Boolean

;;; Purpose
;; Given a bullet and a list of invaders
;; return true if the bullet has hit any of the invaders in the list,
;; false otherwise


(define (bullet-hit? a-bullet loi)
  (cond
    [(empty? loi) #false]
    [(cons? loi) (or (bullet-hit-invader? (first loi) a-bullet)
                     (bullet-hit? a-bullet (rest loi)))]))

;;; Tests
(check-expect (bullet-hit? (make-posn 40 50) empty) #false)
(check-expect (bullet-hit? (make-posn 40 50)
                           (list (make-posn 45 55)
                                 (make-posn 100 400))) #true)


;;; Signature
;; remove-bullets : LoB LoI -> LoB

;;; Purpose
;; Given a list of bullets and a list of invaders
;; remove any bullets in the list that have hit an invader


(define (remove-bullets lob loi)
  (cond
    [(empty? lob) lob]
    [(cons? lob) (cond
                   [(bullet-hit? (first lob) loi)
                    (remove-bullets (rest lob) loi)]
                   [else (cons (first lob)
                               (remove-bullets (rest lob) loi))])]))

;;; Tests
(check-expect (remove-bullets empty (cons (make-posn 30 40) empty)) empty)

(check-expect (remove-bullets (cons (make-posn 50 60)
                                    (cons (make-posn 400 300) empty))
                              (cons (make-posn 55 65)
                                    (cons (make-posn 200 200) empty)))
              (cons (make-posn 400 300) empty))

(check-expect (remove-bullets (cons (make-posn 50 60)
                                    (cons (make-posn 400 300) empty))
                              (cons (make-posn 20 20)
                                    (cons (make-posn 450 350) empty)))
              (cons (make-posn 50 60) (cons (make-posn 400 300) empty)))

(check-expect (remove-bullets (cons (make-posn 50 60)
                                    (cons (make-posn 400 300) empty))
                              (cons (make-posn 20 20)
                                    (cons (make-posn 405 295) empty)))
              (cons (make-posn 50 60) empty))

;;; Signature
;; bullet-in-bounds? : Bullet -> Boolean

;;; Purpose
;; Given a bullet returns true if the bullet is in bounds
;; of the world, else return false

(define (bullet-in-bounds? a-bullet)
  (not (or (<= (- (posn-y a-bullet) 2) 0)
           (>= (+ (posn-y a-bullet) 2) HEIGHT))))

;;; Tests
(check-expect (bullet-in-bounds? (make-posn 600 700)) #false)
(check-expect (bullet-in-bounds? (make-posn 200 -50)) #false)
(check-expect (bullet-in-bounds? (make-posn 300 400)) #true)

;;; Signature
;; remove-out-of-bounds : LoB -> LoB

;;; Purpose
;; Given a list of bullets remove all the bullets in the list
;; that are out of bounds of the world

(define (remove-out-of-bounds lob)
  (filter bullet-in-bounds? lob))

;;; Tests
(check-expect (remove-out-of-bounds empty) empty)

(check-expect (remove-out-of-bounds
               (cons (make-posn 200 300)
                     (cons (make-posn 50 60) empty)))
              (cons (make-posn 200 300) (cons (make-posn 50 60) empty)))

(check-expect (remove-out-of-bounds
               (cons (make-posn 300 600)
                     (cons (make-posn 200 90) empty)))
              (cons (make-posn 200 90) empty))

(check-expect (remove-out-of-bounds
               (cons (make-posn 250 250)
                     (cons (make-posn 20 -300) empty)))
              (cons (make-posn 250 250) empty))

;;; Signature
;; remove-hits-and-out-of-bounds: World -> World

;;; Purpose
;; remove any invaders that have been hit by a spaceship bullet.
;; remove any spaceship bullets that have hit an invader
;; Remove any bullets that are out of bounds

(define (remove-hits-and-out-of-bounds w)
  (make-world (world-ship w) (remove-hits
                              (world-invaders w)
                              (world-ship-bullets w))
              (remove-out-of-bounds (remove-bullets
                                     (world-ship-bullets w)
                                     (world-invaders w)))
              (remove-out-of-bounds (world-invader-bullets w))
              (world-lives w)
              (world-score w)
              (world-tick-count w)))

;;; Tests
(check-expect (remove-hits-and-out-of-bounds
               (make-world (make-ship RIGHT (make-posn 200 480))
                           (list (make-posn 40 50)
                                 (make-posn 30 20) (make-posn 300 300))
                           (list (make-posn 35 45)
                                 (make-posn 400 400) (make-posn 20 505))
                           (list (make-posn 200 120)
                                 (make-posn 60 -40)
                                 (make-posn 10 10))
                           2 20 12)) 
              (make-world (make-ship RIGHT (make-posn 200 480))
                          (list (make-posn 30 20) (make-posn 300 300))
                          (list (make-posn 400 400))
                          (list (make-posn 200 120)
                                (make-posn 10 10))
                          2 20 12))


;;; Signature
;; bullet-hit-ship? : Ship Bullet -> Boolean

;;; Purpose
;; Given a ship and a bullet return true
;; if the bullet hit the ship, false otherwise

(define (bullet-hit-ship? a-ship a-bullet)
  (and
   (>= (posn-x a-bullet) (- (posn-x (ship-loc a-ship)) (+
                                                        (/ SHIP-WIDTH 2)
                                                        BULLET-RADIUS)))
   (<= (posn-x a-bullet) (+ (posn-x (ship-loc a-ship)) (+
                                                        (/ SHIP-WIDTH 2)
                                                        BULLET-RADIUS)))
   (>= (posn-y a-bullet) (- (posn-y (ship-loc a-ship)) (+
                                                        (/ SHIP-HEIGHT 2)
                                                        BULLET-RADIUS)))
   (<= (posn-y a-bullet) (+ (posn-y (ship-loc a-ship)) (+
                                                        (/ SHIP-HEIGHT 2)
                                                        BULLET-RADIUS)))))

;;; Tests
(check-expect (bullet-hit-ship? (make-ship RIGHT (make-posn 240 50))
                                (make-posn 245 50)) #true)
(check-expect (bullet-hit-ship? (make-ship LEFT (make-posn 240 50))
                                (make-posn 30 200)) #false)
(check-expect (bullet-hit-ship? (make-ship LEFT (make-posn 300 400))
                                (make-posn 312 391)) #true)

;;; Signature:
;; inv-bullet-hit-ship : Ship LoB -> LoB

;;; Purpose:
;; Given a ship and a list of bullets, return the list of bullets that have
;; not hit the ship.

(define (inv-bullet-hit-ship ship lob)
  (cond
    [(empty? lob) empty]
    [(bullet-hit-ship? ship (first lob))
     (inv-bullet-hit-ship ship (rest lob))]
    [else (cons (first lob) (inv-bullet-hit-ship ship (rest lob)))]))

;;; Tests:
(check-expect
 (inv-bullet-hit-ship
  (make-ship LEFT (make-posn 240 480))
  (list (make-posn 400 300) (make-posn 300 290) (make-posn 240 470)))
 (list (make-posn 400 300) (make-posn 300 290) (make-posn 240 470)))

(check-expect
 (inv-bullet-hit-ship
  (make-ship LEFT (make-posn 240 480))
  (list (make-posn 400 300) (make-posn 300 290) (make-posn 240 481)))
 (list (make-posn 400 300) (make-posn 300 290)))


;;; Signature
;; ship-hit? : Ship LoB -> Boolean

;;; Purpose
;; Given a ship and a list of bullets
;; return true if any of the bullets in the list hit the ship, false otherwise

(define (ship-hit? a-ship lob)
  (cond
    [(empty? lob) #false]
    [(cons? lob) (or (bullet-hit-ship? a-ship (first lob))
                     (ship-hit? a-ship (rest lob)))]))

;;; Tests
(check-expect (ship-hit? (make-ship LEFT
                                    (make-posn 300 200))
                         empty) #false)

(check-expect (ship-hit? (make-ship RIGHT
                                    (make-posn 300 200))
                         (cons (make-posn 305 205)
                               (cons (make-posn 45 50) empty))) #true)

(check-expect (ship-hit? (make-ship LEFT (make-posn 300 200))
                         (cons (make-posn 450 350)
                               (cons (make-posn 45 50) empty))) #false)

;;; Signature
;; remove-lives : World -> World

;;; Purpose
;; Subtracts one spaceship life every time
;; an invader bullet hits the spaceship
;; and removes bullets that hit the ship

(define (remove-lives w)
  (cond
    [(ship-hit? (world-ship w) (world-invader-bullets w))
     (make-world (world-ship w) (world-invaders w)
                 (world-ship-bullets w)
                 (inv-bullet-hit-ship (world-ship w) (world-invader-bullets w))
                 (- (world-lives w) 1)
                 (world-score w)
                 (world-tick-count w))]
    [else w]))

;;; Tests
(check-expect (remove-lives (make-world
                             (make-ship RIGHT (make-posn 20 480))
                             (list (make-posn 200 200))
                             (list (make-posn 300 300))
                             (list (make-posn 400 400))
                             2 30 16))
              (make-world
               (make-ship RIGHT (make-posn 20 480))
               (list (make-posn 200 200))
               (list (make-posn 300 300))
               (list (make-posn 400 400))
               2 30 16))

(check-expect (remove-lives (make-world
                             (make-ship RIGHT (make-posn 20 480))
                             (list (make-posn 200 200))
                             (list (make-posn 300 300))
                             (list (make-posn 20 478))
                             2 30 18))
              (make-world
               (make-ship RIGHT (make-posn 20 480))
               (list (make-posn 200 200))
               (list (make-posn 300 300))
               empty
               1 30 18))

;;; Signature
;; invaders-at-bottom? : LoI Ship -> Boolean

;;; Purpose
;; Given a list of invaders returns true if any of the invaders in the list
;; have reached the y-coordinate of the ship, else returns false


(define (invaders-at-bottom? loi a-ship)
  (cond
    [(empty? loi) #false]
    [else
     (or (>= (+ (posn-y (first loi)) (/ INVADER-SIDE 2))
             (- (posn-y (ship-loc a-ship)) (/ SHIP-HEIGHT 2)))
         (invaders-at-bottom? (rest loi) a-ship))]))

;;; Tests
(check-expect (invaders-at-bottom? empty
                                   (make-ship RIGHT (make-posn 30 480)))
              #false)
(check-expect (invaders-at-bottom? (list (make-posn 40 300)
                                         (make-posn 200 200))
                                   (make-ship RIGHT (make-posn 30 480)))
              #false)

(check-expect (invaders-at-bottom? (list (make-posn 40 462.5)
                                         (make-posn 200 200))
                                   (make-ship RIGHT (make-posn 30 480)))
              #true)


;; Signature
;;  tick-adder : TickCount -> TickCount

;;; Purpose
;; Increases the tick count by 1

(define (tick-adder a-tick-count)
  (+ 1 a-tick-count))

;; Test:
(check-expect (tick-adder 0) 1)
(check-expect (tick-adder 1) 2)


;;; Signature
;; update-world : World -> World

;;; Purpose
;; Given a world execute all functions
;; to update world for on-tick call

(define (update-world w)
  (move-world
   (remove-hits-and-out-of-bounds
    (add-to-score
     (remove-lives (make-world (world-ship w)
                               (world-invaders w)
                               (world-ship-bullets w)
                               (invaders-fire
                                (world-invader-bullets w)
                                (world-invaders w))
                               (world-lives w)
                               (world-score w)
                               (tick-adder
                                (world-tick-count w))))))))

;;; Tests
(check-random (update-world WORLD-INIT)
              (move-world (remove-hits-and-out-of-bounds
                           (add-to-score
                            (remove-lives
                             (make-world
                              (world-ship WORLD-INIT)
                              (world-invaders WORLD-INIT)
                              (world-ship-bullets WORLD-INIT)
                              (invaders-fire (world-invader-bullets WORLD-INIT)
                                             (world-invaders WORLD-INIT))
                              (world-lives WORLD-INIT)
                              (world-score WORLD-INIT)
                              (tick-adder (world-tick-count WORLD-INIT))))))))


(check-expect (update-world (make-world SHIP-INIT
                                        (list
                                         (make-posn 100 20)
                                         (make-posn 140 20)
                                         (make-posn 180 20) 
                                         (make-posn 220 20)
                                         (make-posn 260 20)
                                         (make-posn 300 20) 
                                         (make-posn 340 20)
                                         (make-posn 380 20)
                                         (make-posn 420 20)
                                         (make-posn 100 50))
                                        empty
                                        (list
                                         (make-posn 100 20)
                                         (make-posn 140 30)
                                         (make-posn 180 40) 
                                         (make-posn 220 50)
                                         (make-posn 260 60)
                                         (make-posn 300 70) 
                                         (make-posn 340 80)
                                         (make-posn 380 90)
                                         (make-posn 420 100)
                                         (make-posn 100 110)) 2 30 11))
              (make-world (make-ship 'left (make-posn 240 480))
                          (list
                           (make-posn 100 20)
                           (make-posn 140 20)
                           (make-posn 180 20) 
                           (make-posn 220 20)
                           (make-posn 260 20)
                           (make-posn 300 20) 
                           (make-posn 340 20)
                           (make-posn 380 20)
                           (make-posn 420 20)
                           (make-posn 100 50))
                          empty
                          (list
                           (make-posn 100 30)
                           (make-posn 140 40)
                           (make-posn 180 50) 
                           (make-posn 220 60)
                           (make-posn 260 70)
                           (make-posn 300 80) 
                           (make-posn 340 90)
                           (make-posn 380 100)
                           (make-posn 420 110)
                           (make-posn 100 120)) 2 30 12))




;;; Signature
;; end-game? : World -> Boolean

;;; Purpose
;; Given a world returns true if ship has been hit 3 times
;; or all invaders have been hit,
;; or any invader has reached the bottom of the world,
;; else returns false

(define (end-game? w)
  (or (= (world-lives w) -1)
      (empty? (world-invaders w))
      (invaders-at-bottom? (world-invaders w) (world-ship w))))

;;; Tests
(check-expect (end-game? (make-world
                          (make-ship RIGHT (make-posn 50 50))
                          empty
                          (cons
                           (make-posn 200 100) empty)
                          (cons
                           (make-posn 300 400) empty) 2 30 20)) #true)

(check-expect (end-game? (make-world (make-ship LEFT (make-posn 50 50))
                                     (cons (make-posn 300 10) empty)
                                     (cons (make-posn 400 400) empty)
                                     (cons (make-posn 45 45) empty)
                                     2 30 22))
              #false)

(check-expect (end-game? (make-world (make-ship LEFT (make-posn 50 50))
                                     (cons (make-posn 300 10) empty)
                                     (cons (make-posn 400 400) empty)
                                     (cons (make-posn 200 100) empty)
                                     2 30 24))
              #false)

(check-expect (end-game? (make-world (make-ship LEFT (make-posn 50 480))
                                     (cons (make-posn 300 480) empty)
                                     (cons (make-posn 20 20) empty)
                                     (cons (make-posn 70 80) empty)
                                     2 30 26))
              #true)

(check-expect (end-game? (make-world (make-ship LEFT (make-posn 50 480))
                                     (cons (make-posn 300 480) empty)
                                     (cons (make-posn 20 20) empty)
                                     (cons (make-posn 70 80) empty)
                                     -1 30 28))
              #true)

(big-bang WORLD-INIT
          (on-draw world-draw)
          (on-tick update-world .1)
          (on-key key-handler)
          (stop-when end-game?))