;; Health Education Program Contract
;; Manages educational programs, sessions, and participant tracking

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u300))
(define-constant ERR-PROGRAM-NOT-FOUND (err u301))
(define-constant ERR-SESSION-NOT-FOUND (err u302))
(define-constant ERR-INVALID-INPUT (err u303))
(define-constant ERR-ALREADY-ENROLLED (err u304))
(define-constant ERR-NOT-ENROLLED (err u305))

;; Data Variables
(define-data-var next-program-id uint u1)
(define-data-var next-session-id uint u1)
(define-data-var next-enrollment-id uint u1)
(define-data-var contract-admin principal CONTRACT-OWNER)

;; Data Maps
(define-map education-programs
  { program-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    target-audience: (string-ascii 100),
    objectives: (string-ascii 500),
    duration-weeks: uint,
    max-participants: uint,
    current-participants: uint,
    facilitator-id: uint,
    materials-hash: (string-ascii 64),
    status: (string-ascii 20),
    created-date: uint,
    start-date: uint,
    end-date: uint,
    created-by: principal
  }
)

(define-map education-sessions
  { session-id: uint }
  {
    program-id: uint,
    session-number: uint,
    title: (string-ascii 100),
    content-topics: (string-ascii 500),
    scheduled-date: uint,
    duration-minutes: uint,
    location: (string-ascii 100),
    facilitator-id: uint,
    max-attendees: uint,
    actual-attendees: uint,
    session-notes: (string-ascii 1000),
    materials-used: (string-ascii 500),
    status: (string-ascii 20),
    created-by: principal
  }
)

(define-map program-enrollments
  { enrollment-id: uint }
  {
    program-id: uint,
    participant-id: uint,
    enrollment-date: uint,
    completion-status: (string-ascii 20),
    attendance-count: uint,
    pre-assessment-score: uint,
    post-assessment-score: uint,
    feedback-rating: uint,
    feedback-comments: (string-ascii 500),
    certificate-issued: bool,
    enrolled-by: principal
  }
)

(define-map session-attendance
  { session-id: uint, participant-id: uint }
  {
    attendance-status: (string-ascii 20),
    arrival-time: uint,
    participation-level: (string-ascii 20),
    session-feedback: (string-ascii 500),
    knowledge-check-score: uint,
    recorded-by: principal
  }
)

;; Private Functions
(define-private (is-authorized (caller principal))
  (or (is-eq caller (var-get contract-admin))
      (is-eq caller CONTRACT-OWNER))
)

(define-private (is-valid-status (status (string-ascii 20)))
  (or (is-eq status "planned")
      (is-eq status "active")
      (is-eq status "completed")
      (is-eq status "cancelled"))
)

(define-private (is-valid-score (score uint))
  (<= score u100)
)

;; Public Functions

;; Create new education program
(define-public (create-education-program
  (title (string-ascii 100))
  (description (string-ascii 500))
  (target-audience (string-ascii 100))
  (objectives (string-ascii 500))
  (duration-weeks uint)
  (max-participants uint)
  (facilitator-id uint)
  (materials-hash (string-ascii 64))
  (start-date uint))
  (let
    (
      (program-id (var-get next-program-id))
      (end-date (+ start-date (* duration-weeks u1008))) ;; Approximate blocks per week
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> (len title) u0) ERR-INVALID-INPUT)
    (asserts! (> duration-weeks u0) ERR-INVALID-INPUT)
    (asserts! (> max-participants u0) ERR-INVALID-INPUT)
    (asserts! (> start-date block-height) ERR-INVALID-INPUT)

    (map-set education-programs
      { program-id: program-id }
      {
        title: title,
        description: description,
        target-audience: target-audience,
        objectives: objectives,
        duration-weeks: duration-weeks,
        max-participants: max-participants,
        current-participants: u0,
        facilitator-id: facilitator-id,
        materials-hash: materials-hash,
        status: "planned",
        created-date: block-height,
        start-date: start-date,
        end-date: end-date,
        created-by: tx-sender
      }
    )

    (var-set next-program-id (+ program-id u1))
    (ok program-id)
  )
)

;; Schedule education session
(define-public (schedule-education-session
  (program-id uint)
  (session-number uint)
  (title (string-ascii 100))
  (content-topics (string-ascii 500))
  (scheduled-date uint)
  (duration-minutes uint)
  (location (string-ascii 100))
  (facilitator-id uint)
  (max-attendees uint))
  (let
    (
      (session-id (var-get next-session-id))
      (program-data (unwrap! (map-get? education-programs { program-id: program-id }) ERR-PROGRAM-NOT-FOUND))
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> (len title) u0) ERR-INVALID-INPUT)
    (asserts! (> duration-minutes u0) ERR-INVALID-INPUT)
    (asserts! (> scheduled-date block-height) ERR-INVALID-INPUT)

    (map-set education-sessions
      { session-id: session-id }
      {
        program-id: program-id,
        session-number: session-number,
        title: title,
        content-topics: content-topics,
        scheduled-date: scheduled-date,
        duration-minutes: duration-minutes,
        location: location,
        facilitator-id: facilitator-id,
        max-attendees: max-attendees,
        actual-attendees: u0,
        session-notes: "",
        materials-used: "",
        status: "scheduled",
        created-by: tx-sender
      }
    )

    (var-set next-session-id (+ session-id u1))
    (ok session-id)
  )
)

;; Enroll participant in program
(define-public (enroll-participant
  (program-id uint)
  (participant-id uint)
  (pre-assessment-score uint))
  (let
    (
      (enrollment-id (var-get next-enrollment-id))
      (program-data (unwrap! (map-get? education-programs { program-id: program-id }) ERR-PROGRAM-NOT-FOUND))
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-valid-score pre-assessment-score) ERR-INVALID-INPUT)
    (asserts! (< (get current-participants program-data) (get max-participants program-data)) ERR-INVALID-INPUT)

    (map-set program-enrollments
      { enrollment-id: enrollment-id }
      {
        program-id: program-id,
        participant-id: participant-id,
        enrollment-date: block-height,
        completion-status: "enrolled",
        attendance-count: u0,
        pre-assessment-score: pre-assessment-score,
        post-assessment-score: u0,
        feedback-rating: u0,
        feedback-comments: "",
        certificate-issued: false,
        enrolled-by: tx-sender
      }
    )

    ;; Update program participant count
    (map-set education-programs
      { program-id: program-id }
      (merge program-data {
        current-participants: (+ (get current-participants program-data) u1)
      })
    )

    (var-set next-enrollment-id (+ enrollment-id u1))
    (ok enrollment-id)
  )
)

;; Record session attendance
(define-public (record-session-attendance
  (session-id uint)
  (participant-id uint)
  (attendance-status (string-ascii 20))
  (participation-level (string-ascii 20))
  (knowledge-check-score uint))
  (begin
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? education-sessions { session-id: session-id })) ERR-SESSION-NOT-FOUND)
    (asserts! (is-valid-score knowledge-check-score) ERR-INVALID-INPUT)

    (map-set session-attendance
      { session-id: session-id, participant-id: participant-id }
      {
        attendance-status: attendance-status,
        arrival-time: block-height,
        participation-level: participation-level,
        session-feedback: "",
        knowledge-check-score: knowledge-check-score,
        recorded-by: tx-sender
      }
    )
    (ok true)
  )
)

;; Complete program enrollment
(define-public (complete-program-enrollment
  (enrollment-id uint)
  (post-assessment-score uint)
  (feedback-rating uint)
  (feedback-comments (string-ascii 500)))
  (let
    (
      (enrollment-data (unwrap! (map-get? program-enrollments { enrollment-id: enrollment-id }) ERR-NOT-ENROLLED))
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-valid-score post-assessment-score) ERR-INVALID-INPUT)
    (asserts! (and (>= feedback-rating u1) (<= feedback-rating u5)) ERR-INVALID-INPUT)

    (map-set program-enrollments
      { enrollment-id: enrollment-id }
      (merge enrollment-data {
        completion-status: "completed",
        post-assessment-score: post-assessment-score,
        feedback-rating: feedback-rating,
        feedback-comments: feedback-comments,
        certificate-issued: (>= post-assessment-score u70) ;; 70% passing score
      })
    )
    (ok true)
  )
)

;; Update program status
(define-public (update-program-status
  (program-id uint)
  (new-status (string-ascii 20)))
  (let
    (
      (program-data (unwrap! (map-get? education-programs { program-id: program-id }) ERR-PROGRAM-NOT-FOUND))
    )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-valid-status new-status) ERR-INVALID-INPUT)

    (map-set education-programs
      { program-id: program-id }
      (merge program-data {
        status: new-status
      })
    )
    (ok true)
  )
)

;; Read-only functions

;; Get education program
(define-read-only (get-education-program (program-id uint))
  (map-get? education-programs { program-id: program-id })
)

;; Get education session
(define-read-only (get-education-session (session-id uint))
  (map-get? education-sessions { session-id: session-id })
)

;; Get program enrollment
(define-read-only (get-program-enrollment (enrollment-id uint))
  (map-get? program-enrollments { enrollment-id: enrollment-id })
)

;; Get session attendance
(define-read-only (get-session-attendance (session-id uint) (participant-id uint))
  (map-get? session-attendance { session-id: session-id, participant-id: participant-id })
)

;; Get next IDs
(define-read-only (get-next-program-id)
  (var-get next-program-id)
)

(define-read-only (get-next-session-id)
  (var-get next-session-id)
)

(define-read-only (get-next-enrollment-id)
  (var-get next-enrollment-id)
)
