;;; init.el --- In the beginning...
;;
;; "Only philosophers embark on this perilous expedition to the outermost
;; reaches of language and existence. Some of them fall off, but others cling
;; on desperately and yell at the people nestling deep in the snug softness,
;; stuffing themselves with delicious food and drink. 'Ladies and Gentlemen,'
;; they yell, 'we are floating in space!' But none of the people down there
;; care."
;;
;; - Jostein Gardner, "Sophie's World"

(setq dotfiles-dir (file-name-directory
                     (or (buffer-file-name) load-file-name)))

(add-to-list 'load-path dotfiles-dir)
