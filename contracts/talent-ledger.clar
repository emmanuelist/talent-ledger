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