

;;;; Preferences

(define gnc:*arg-show-usage*
  (gnc:make-config-var
   "Generate an argument summary."
   (lambda (var value) (if (boolean? value) (list value) #f))
   eq?
   #f))

(define gnc:*arg-show-help*
  (gnc:make-config-var
   "Generate an argument summary."
   (lambda (var value) (if (boolean? value) (list value) #f))
   eq?
   #f))

(define gnc:*debugging?*
  (gnc:make-config-var
   "Enable debugging code."
   (lambda (var value) (if (boolean? value) (list value) #f))
   eq?
   #f))

(define gnc:*startup-dir*
  (gnc:make-config-var
   "Location of initial lowest level scheme startup files."
   (lambda (var value)
     ;; You can't change the startup dir from here.  It's considered
     ;; hard-coded once known -- see startup/init.scm.
     #f)
   string=?
   gnc:_startup-dir-default_))

(define gnc:*config-dir*
  (gnc:make-config-var
   "Configuration directory."
   (lambda (var value) (if (string? value) (list value) #f))
   string=?
   gnc:_config-dir-default_))

(define gnc:*share-dir*
  (gnc:make-config-var
   "Shared files directory."
   (lambda (var value) (if (string? value) (list value) #f))
   string=?
   gnc:_share-dir-default_))

(define gnc:*load-path*
  (gnc:make-config-var
   "A list of strings indicating the load path for (gnc:load name).
Any path element enclosed in parentheses will automatically be
expanded to that directory and all its subdirectories whenever this
variable is modified.  The symbol element default will expand to the default directory.  i.e. (gnc:config-var-value-set! gnc:*load-path* '(\"/my/dir/\" default))"
   (lambda (var value)
     (if (not (list? value))
         #f
         (let ((result (gnc:_load-path-update_ var value)))
           (if (list? result)
               (list result)
               #f))))
   equal?
   (list 
    (string-append "(" (getenv "HOME") "/.gnucash/scm)")
    (string-append "(" gnc:_share-dir-default_ "/scm)"))))

(define gnc:*doc-path*
  (gnc:make-config-var
   "A list of strings indicating where to look for html and parsed-html files
Any path element enclosed in parentheses will automatically be
expanded to that directory and all its subdirectories whenever this
variable is modified.  The symbol element default will expand to the
default directory.  i.e. (gnc:config-var-value-set! gnc:*doc-path*
'(\"/my/dir/\" default))"
   (lambda (var value)
     (if (not (list? value))
         #f
         (let ((result (gnc:_doc-path-update_ var value)))
           (if (list? result)
               (list result)
               #f))))
   equal?
   (list
    (string-append "(" (getenv "HOME") "/.gnucash/doc)")    
    (string-append "(" gnc:_share-dir-default_ "/Docs)")
    (string-append "(" gnc:_share-dir-default_ "/Reports)"))))

(define gnc:*prefs*
  (list
   
   (cons
    "usage"
    (cons 'boolean
          (lambda (val)
            (gnc:config-var-value-set! gnc:*arg-show-usage* #f val))))
   (cons
    "help"
    (cons 'boolean
          (lambda (val)
            (gnc:config-var-value-set! gnc:*arg-show-help* #f val))))
   (cons
    "debug"
    (cons 'boolean
          (lambda (val)
            (gnc:config-var-value-set! gnc:*debugging?* #f val))))
   
   (cons
    "startup-dir"
    (cons 'string
          (lambda (val)
            (gnc:config-var-value-set! gnc:*startup-dir* #f val))))
   
   (cons
    "config-dir"
    (cons 'string
          (lambda (val)
            (gnc:config-var-value-set! gnc:*config-dir* #f val))))
   
   (cons
    "share-dir"
    (cons 'string
          (lambda (val)
            (gnc:config-var-value-set! gnc:*share-dir* #f val))))
   

   (cons
    "load-path"
    (cons 'string
          (lambda (val)
            (let ((path-list
                   (call-with-input-string val (lambda (port) (read port)))))
              (if (list? path-list)
                  (gnc:config-var-value-set! gnc:*load-path* #f path-list)
                  (begin
                    (gnc:error "non-list given for --load-path: " val)
                    (gnc:shutdown 1)))))))
   
   (cons
    "doc-path"
    (cons 'string
          (lambda (val)
            (let ((path-list
                   (call-with-input-string val (lambda (port) (read port)))))
              (if (list? path-list)
                  (gnc:config-var-value-set! gnc:*doc-path* #f path-list)
                  (begin
                    (gnc:error "non-list given for --doc-path: " val)
                    (gnc:shutdown 1)))))))
   
   (cons "load-user-config" (cons 'boolean gnc:load-user-config-if-needed))
   (cons "load-system-config" (cons 'boolean gnc:load-system-config-if-needed))))