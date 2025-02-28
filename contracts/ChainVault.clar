;; ChainVault - Decentralized Document Registry
;; Manages document records on the Stacks blockchain

(define-data-var registry-counter uint u1)
(define-map registry 
    { record-id: uint } 
    { 
        creator: principal, 
        reference: (string-ascii 256), 
        validity: uint 
    })

(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_RECORD_NOT_FOUND (err u101))
(define-constant ERR_RECORD_COLLISION (err u102))
(define-constant ERR_INVALID_TIMEFRAME (err u103))

;; Register a new document
(define-public (register-document (reference (string-ascii 256)) (validity uint))
    (begin
        (let ((record-id (var-get registry-counter)))
            (if (is-some (map-get? registry { record-id: record-id }))
                ERR_RECORD_COLLISION
                (if (> validity stacks-block-height)
                    (if (is-some (as-max-len? reference u256))
                        (begin
                            (map-set registry 
                                { record-id: record-id } 
                                { creator: tx-sender, reference: reference, validity: validity }
                            )
                            (var-set registry-counter (+ record-id u1))
                            (ok record-id)
                        )
                        ERR_UNAUTHORIZED
                    )
                    ERR_INVALID_TIMEFRAME
                )
            )
        )
    )
)

;; Retrieve document details by ID
(define-public (retrieve-document (record-id uint))
    (match (map-get? registry { record-id: record-id })
        document-data
        (if (<= (get validity document-data) stacks-block-height)
            ERR_INVALID_TIMEFRAME
            (ok document-data))
        ERR_RECORD_NOT_FOUND
    )
)

;; Update document reference or validity period (Only document creator can do this)
(define-public (modify-document (record-id uint) (new-reference (string-ascii 256)) (new-validity uint))
    (let ((current-count (var-get registry-counter)))
        (if (>= record-id current-count)
            ERR_RECORD_NOT_FOUND
            (match (map-get? registry { record-id: record-id })
                document-data
                (if (is-eq (get creator document-data) tx-sender)
                    (if (> new-validity stacks-block-height)
                        (if (is-some (as-max-len? new-reference u256))
                            (begin
                                (map-set registry 
                                    { record-id: record-id } 
                                    { creator: tx-sender, reference: new-reference, validity: new-validity }
                                )
                                (ok true)
                            )
                            ERR_UNAUTHORIZED
                        )
                        ERR_INVALID_TIMEFRAME
                    )
                    ERR_UNAUTHORIZED
                )
                ERR_RECORD_NOT_FOUND
            )
        )
    )
)

;; Remove document from registry (Only document creator can do this)
(define-public (revoke-document (record-id uint))
    (let ((current-count (var-get registry-counter)))
        (if (>= record-id current-count)
            ERR_RECORD_NOT_FOUND
            (match (map-get? registry { record-id: record-id })
                document-data
                (if (is-eq (get creator document-data) tx-sender)
                    (begin
                        (map-delete registry { record-id: record-id })
                        (ok true)
                    )
                    ERR_UNAUTHORIZED
                )
                ERR_RECORD_NOT_FOUND
            )
        )
    )
)