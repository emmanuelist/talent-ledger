;; Talent Ledger
;; Version: 1.0.0
;; A secure, auditable reputation tracking contract with ownership controls and event logging
;; Built for production-grade talent assessment on Stacks blockchain

;; =================================
;; Constants
;; =================================

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-REPUTATION-UNDERFLOW (err u101))
(define-constant ERR-REPUTATION-OVERFLOW (err u102))
(define-constant ERR-INVALID-VALUE (err u103))
(define-constant ERR-TRANSFER-FAILED (err u104))
(define-constant ERR-SAME-OWNER (err u105))

;; Contract Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant MAX-REPUTATION-VALUE u340282366920938463463374607431768211455) ;; uint max
(define-constant MIN-REPUTATION-VALUE u0)

;; =================================
;; Data Variables
;; =================================

(define-data-var reputation-score uint u0)
(define-data-var owner principal CONTRACT-OWNER)
(define-data-var paused bool false)
(define-data-var total-awards uint u0)
(define-data-var total-deductions uint u0)

;; =================================
;; Data Maps
;; =================================

;; Track reputation history per address for analytics
(define-map user-reputation-history 
  principal 
  {
    awards: uint,
    deductions: uint,
    last-action-block: uint
  }
)

;; =================================
;; Private Functions
;; =================================

(define-private (is-contract-owner)
  (is-eq tx-sender (var-get owner))
)

(define-private (is-paused)
  (var-get paused)
)

(define-private (update-user-stats (operation (string-ascii 10)))
  (let
    (
      (current-stats (default-to 
        { awards: u0, deductions: u0, last-action-block: u0 }
        (map-get? user-reputation-history tx-sender)
      ))
    )
    (if (is-eq operation "award")
      (map-set user-reputation-history tx-sender {
        awards: (+ (get awards current-stats) u1),
        deductions: (get deductions current-stats),
        last-action-block: stacks-block-height
      })
      (map-set user-reputation-history tx-sender {
        awards: (get awards current-stats),
        deductions: (+ (get deductions current-stats) u1),
        last-action-block: stacks-block-height
      })
    )
  )
)

;; =================================
;; Read-Only Functions
;; =================================

(define-read-only (get-reputation-score)
  (ok (var-get reputation-score))
)

(define-read-only (get-owner)
  (ok (var-get owner))
)

(define-read-only (get-contract-owner)
  (ok CONTRACT-OWNER)
)

(define-read-only (is-paused-status)
  (ok (var-get paused))
)

(define-read-only (get-total-awards)
  (ok (var-get total-awards))
)

(define-read-only (get-total-deductions)
  (ok (var-get total-deductions))
)

(define-read-only (get-user-reputation-history (user principal))
  (ok (default-to 
    { awards: u0, deductions: u0, last-action-block: u0 }
    (map-get? user-reputation-history user)
  ))
)

(define-read-only (get-contract-info)
  (ok {
    reputation-score: (var-get reputation-score),
    owner: (var-get owner),
    paused: (var-get paused),
    total-awards: (var-get total-awards),
    total-deductions: (var-get total-deductions),
    contract-owner: CONTRACT-OWNER
  })
)

;; =================================
;; Public Functions
;; =================================

(define-public (award-reputation)
  (begin
    ;; Validations
    (asserts! (not (is-paused)) ERR-NOT-AUTHORIZED)
    (asserts! (< (var-get reputation-score) MAX-REPUTATION-VALUE) ERR-REPUTATION-OVERFLOW)
    
    ;; Update reputation score
    (var-set reputation-score (+ (var-get reputation-score) u1))
    (var-set total-awards (+ (var-get total-awards) u1))
    
    ;; Update user stats
    (update-user-stats "award")
    
    ;; Emit event
    (print {
      event: "reputation-awarded",
      reputation-score: (var-get reputation-score),
      user: tx-sender,
      block: stacks-block-height
    })
    
    (ok (var-get reputation-score))
  )
)