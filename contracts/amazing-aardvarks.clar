;; Implement trait enforces that this contract must have all methods described
;; in the trait and must adhere to the typing of all args
(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; This allows us to use built in methods:
;; nft-mint? , nft-transfer?, nft-get-owner? and nft-burn?
(define-non-fungible-token amazing-aardvarks uint)

(define-data-var last-token-id uint u0)

(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
  (ok none)
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? amazing-aardvarks token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    ;; #[filter(token-id, recipient)]
    (nft-transfer? amazing-aardvarks token-id sender recipient)
  )
)

(define-public (mint (recipient principal))
  (let
    (
      (new-token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) err-owner-only)
    ;; #[filter(token-id, recipient)]
    (try! (nft-mint? amazing-aardvarks new-token-id recipient))
    (var-set last-token-id new-token-id)
    (ok new-token-id)
  )
)
