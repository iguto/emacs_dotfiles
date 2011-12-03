;; ============================================================
;; load-path追加
;; ============================================================
;; normal-top-level-add-subdirs-to-load-pathを指定すると、ディレクトリを再帰的にたどってくれます。
(let ((default-directory "~/.emacs.d/site-lisp/"))
  (setq load-path (cons default-directory load-path))
  (normal-top-level-add-subdirs-to-load-path))
;; ============================================================
;; 個別に設定していた頃のload-path設定
;; ============================================================
;; (add-to-list 'load-path "~/.emacs.d/site-lisp")
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/auto-install")
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp")
(add-to-list 'load-path "/usr/share23/emacs/site-lisp/emacs-mozc")
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/remember-el")


;; ;; 最新のorg-mode statableへのパス
(add-to-list 'load-path "~/.emacs.d/site-lisp/org-7.5/lisp")
(add-to-list 'load-path "~/.emacs.d/site-lisp/org-7.5/contrib/lisp")

;; ;; evernote-mode
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/evernote-mode-0_30")

;; howm へのパス
(add-to-list 'load-path "/usr/share/emacs/site-lisp/howm")

;; ===========================================================
;; 補完に関する設定
;; ===========================================================
;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
;; 単語単位で補完する
;; p_hでpublic_htmlが補完できる． 区切り文字には .-_ が使える
(partial-completion-mode t)

;; ============================================================
;; 表示/設定
;; ============================================================
;; (tool-bar-mode nil)                  ; ツールバー非表示
;;(set-scroll-bar-mode nil)            ; スクロールバー非表示

(set-background-color "black")
(set-foreground-color "white")
(set-face-foreground 'font-lock-comment-face "green")
(set-face-foreground 'font-lock-string-face "blue")
(set-face-foreground 'font-lock-keyword-face "PaleGreen")
(set-face-foreground 'font-lock-function-name-face "green")
(set-face-foreground 'font-lock-warning-face "gold")
(set-face-background 'region "RosyBrown")
;;(set-frame-background-color "white")
;; (set-face-background 'modeline "skyblue")
(set-face-background 'modeline "purple")
(set-face-background 'highlight "gray")

;; ----現在行に色をつける----
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background "ForestGreen"))
    (tool-bar-mode     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(setq hl-line-face 'underline) ; 下線
(global-hl-line-mode t)

;; ---- 対応する括弧を強調 ----
(show-paren-mode t)

;; ----下のエリアでの入力キー表示速度を早くする----
(setq echo-keystrokes 0.1)
(setq max-lisp-eval-depth 1000)

;; ========================================
;; org-mode用の設定(font-lock-mode)
;; ========================================
(add-hook 'org-mode-hook 'turn-on-font-lock) ;；org-mode の強調表示を有効にする
;; ----最近使ったファイルを記憶----
;; ********************
;; M-x recentf-open-files で最近開いたファイル一覧をバッファに表示する
;; 先頭10ファイルは数字を押して直接開ける
;; それ以前のファイルは移動してRETして開く
;; EmacsのバッファなのでC-sで検索できる
;; ********************
(require 'recentf-ext)
;; 最近使ったファイルを5000件記憶
(setq recentf-max-saved-items 5000)
;; 最近使ったファイルに加えないファイルを正規表現で指定する
(setq recentf-exclude '("TAGS$" "/var/tmp/"))

;; ---- ファイルの自動バックアップ ----
;; バックアップファイルを一箇所にまとめる

;; ============================================================
;; 機能追加
;; ============================================================

;; ========================================
;; クリップボード
;; ========================================
(setq x-select-enable-clipboard t)

;; ========================================
;; flymake
;; ========================================
;; ;; ---- リアルタイム文法チェック 
;; ;;  flymake for ruby
(require 'flymake)
; I don't like the default colors :)
(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")
; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))
(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook
 'ruby-mode-hook
 '(lambda ()
    ; Don't want flymake mode for ruby regions in rhtml files
    (if (not (null buffer-file-name)) (flymake-mode))))

;; ;; ========================================
;; ;; flymake c++
;; ;; ========================================
;; (defun flymake-cc-init ()
;;   (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;          (local-file  (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;     (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))

;; (push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)

;; (add-hook 'c++-mode-hook
;;           '(lambda ()
;;              (flymake-mode t)))


;; ;; ;; flymake for c++
;; ;; (require 'flymake)

;; ;; (defun flymake-simple-generic-init (cmd &optional opts)
;; ;;   (let* ((temp-file  (flymake-init-create-temp-buffer-copy
;; ;;                       'flymake-create-temp-inplace))
;; ;;          (local-file (file-relative-name
;; ;;                       temp-file
;; ;;                       (file-name-directory buffer-file-name))))
;; ;;     (list cmd (append opts (list local-file)))))

;; ;; ;; Makefile が無くてもC/C++のチェック
;; ;; (defun flymake-simple-make-or-generic-init (cmd &optional opts)
;; ;;   (if (file-exists-p "Makefile")
;; ;;       (flymake-simple-make-init)
;; ;;     (flymake-simple-generic-init cmd opts)))

;; ;; (defun flymake-c-init ()
;; ;;   (flymake-simple-make-or-generic-init
;; ;;    "gcc" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))

;; ;; (defun flymake-cc-init ()
;; ;;   (flymake-simple-make-or-generic-init
;; ;;    "g++" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))

;; ;; (push '("\\.[cC]\\'" flymake-c-init) flymake-allowed-file-name-masks)
;; ;; (push '("\\.\\(?:cc\|cpp\|CC\|CPP\\)\\'" flymake-cc-init) flymake-allowed-file-name-masks)

;; ============================================================
;; キーボードマクロ
;; ============================================================

;; ;; カーソル位置の上の行に新しい行を挿入する
;; (fset 'insert-newline-at-prevline
;;    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("" 0 "%d")) arg)))
;; ;; キー割り当て: C-O
;; (global-set-key "\C-O" 'insert-newline-at-prevline)

;; 現在の次の行を開く
(fset 'open-nextline
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("" 0 "%d")) arg)))
(global-set-key "\C-o" 'nil)

;; ============================================================
;; コマンド拡張?
;; ============================================================

;; ;; 略語展開、補完コマンドをM-x hippie-expandとしてまとめる
;; (setq hippie-expand-try-functions-list
;;        '(try-complete-file-name-partically   ;ファイル名の一部
;; 	 try-complete-file-name-	     ;ファ入り名全体
;; 	 try-expand-all-abbrevs	             ;動的略語展開(カレントバッファ)
;; 	 try-expand-all-abbrevs-all-buffers  ;動的略語展開(全バッファ)
;; 	 try-expand-all-abbrevs-from-kill    ;動的略語展開(キルリング M-w/C-wから)
;; 	 try-complete-lisp-symbol-partically ;Lispシンボルの一部
;; 	 try-complete-lisp-symbol	     ;Lispシンボル名全体
;; 	 ))
;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(ac-auto-start t)
;;  '(global-auto-complete-mode t))
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  )


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(c-default-style (quote ((c-mode . "") (c++-mode . "") (java-mode . "java") (awk-mode . "awk") (other . "gnu"))))
 '(org-agenda-files nil)
 '(org-export-html-with-timestamp t)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "Ricty")))))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;; ========================================
;; c++ mode
;; ========================================
;; (add-hook 'c++-mode-hook
;;     '(lambda()
;;        (c-set-style "cc-mode")
;;        (setq c-tab-always-indent nil)	;tabキーでインデント
;; 	   ;; nil でtab挿入 (not自動インデント)
;;        (setq tab-width 2)

;;        )
;; )

; C

;; (add-hook 'c-mode-hook

;;        '(lambda()
;; 	   (setq c-default-style "k&r")
;;            (setq c-basic-offset tab-width)
;;          ))
;; ; タブ幅
(setq-default tab-width 2)
; タブ幅の倍数
;; (setq tab-stop-list
;;     '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))

;; (setq c-auto-indent nil) ; 全自動インデントを無効
;; (setq tab-width 2)
;; (setq indent-tabs-mode 't)
;; (setq ruby-indent-level tab-width)


;; (defun indent-set ()
;;   (setq indent-tabs-mode nil) ; インデントをタブではなくてスペースで
;;   (setq c-basic-offset   2  ) ; ブロック内のインデント数
;;   (setq tab-width        2  ) ; タブのインデント数
;; )

(add-hook 'c-mode-common-hook
          '(lambda ()
             ;; センテンスの終了である ';' を入力したら、自動改行+インデント
             (c-toggle-auto-hungry-state 1)
             ;; RET キーで自動改行+インデント
             (define-key c-mode-base-map "\C-m" 'newline-and-indent)
			 (c-set-offset 'inline-open 0)
			 (c-set-offset 'inline-close 0)

))
(setq tab-width 2) ; タブ記号のインデント深さ
;( setq c-tab-width 2 )
( setq c-basic-offset 2)

(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
(defface my-face-b-2 '((t (:background "gray26"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("　" 0 my-face-b-1 append)
     ("\t" 0 my-face-b-2 append)
     ("[ ]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
(if font-lock-mode
nil
(font-lock-mode t))) t)


;; C-h をバックスペースに。
(global-set-key "\C-h" 'backward-delete-char)


;; ========================================
;; ========================================
;;   別ファイルに分けたい内容
;; ========================================
;; ========================================

;; 外部elのインストールが必要な設定
;; ========================================
;; sticky
;; ========================================
;; ----大文字入力をshiftを離したあとでもできるようにする----
;; sitickyを読み込む
;; (require 'sticky)
;; 日本語キーボードで、shitfキーをshiftキーとして使う(shift以外をshiftにも置き換えられるが置き換えない)
;; (use-sticky-key ";" sticky-alist:ja)

;; ----バッファ切替、ファイルを開くときの指定方法を拡張----
;; ------------------------------
;; (iswitch-mode t)
;; ------------------------------
;; ------------------------------
;; コマンドがidoに置き換わる
;; (ido-mode t)
;; ;; バッファ名 ファイル名入力がすべてidoに代わる
;; (ido-everywhere t)
;; -------------------------------

;; ========================================
;; anything
;; ========================================
;; ---- anything.el ----
(require 'anything-startup)
(require 'anything-config)
(add-to-list 'anything-sources 'anything-c-source-emacs-commands) ;;'anything-c-source-complex-command-history)



(defun my-anything ()
  "Anything command for you.
It is automatically generated by `anything-migrate-sources'."
  (interactive)
  (anything-other-buffer
	 '(anything-c-source-buffers+
		 anything-c-source-recentf
		 anything-c-source-files-in-current-dir+
		 anything-c-source-locate)
    "*my-anything*"))
(define-key global-map (kbd "C-x b") 'my-anything)

;; ========================================
;; elisp install
;; ========================================
;; ----emacsから自動でlispをインストールできるようにする----
;; install-elispを読み込む
(require 'install-elisp)
;; install-elispがdlするlispの保存先を指定する
(setq install-elisp-repository-directory "~/.emacs.d/site-lisp/auto-install")

;; ---- 上位版の設定 ----
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/site-lisp/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

;; ;; ---- さらに上位版 ----
;; ;; 参考URL: http://d.hatena.ne.jp/rubikitch/20101209
;; ;; (save-window-excursion (shell-command (format "emacs-test -l %s %s &" buffer-file-name buffer-file-name)))
;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get/")
;; (require 'el-get)
;; (load "2010-12-09-095707.el-get-ext.el")
;; ;; 初期化ファイルのワイルドカードを指定する
;; (setq el-get-init-files-pattern "~/emacs/init.d/[0-9]*.el")
;; (setq el-get-sources (el-get:packages))
;; (el-get)

;; ========================================
;; 補完機能
;; ========================================
;; auto-completeを読み込む
(require 'auto-complete)
(global-auto-complete-mode t)


;; ;; 略語から定型文の挿入
;; (require 'yasnippet-config)
;; ;; 推奨設定を関数にまとめている??
;; (yas/setup "~/.emacs.d/plugins/yasnippet-0.6.1c")

;; ----------------------------------------
;; popwin  http://d.hatena.ne.jp/m2ym/searchdiary?word=*[Emacs]
;; ----------------------------------------
;; default setting
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

;; settiong for popup *anything* buffer
(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)

;; for dired buffer
(push '(dired-mode :position top) popwin:special-display-config)

(require 'dired-x)

;; ----------------------------------------
;; one-key  http://d.hatena.ne.jp/tomoya/20090415/1239809615
;; ----------------------------------------
;; (require 'one-key-default)              ;one-key.elも読み込む
;; (require 'one-key-config)
;; (one-key-default-setup-keys)

;; ----------------------------------------
;; tramp  リモートファイルを編集する
;; ----------------------------------------

(require 'tramp)
(setq tramp-default-method "scpx")

;; ========================================
;; rsense
;; Ruby開発支援ツール
;; メソッド補完やドキュメント参照ができる
;; ========================================
;; (setq rsense-home (expand-file-name "~/.emacs.d/site-lisp/rsense"))
;; (add-to-list 'load-path (concat rsense-home "/etc"))
;; (add-to-list 'load-path (concat rsense-home "/etc"))
;; (require 'rsense)

;; (setq rsense-home (expand-file-name "~/.emacs.d/site-lisp/rsense-0.3"))
;; (add-to-list 'load-path (concat rsense-home "/etc"))
;; (require 'rsense)
;; (add-hook 'ruby-mode-hook
;;     '(lambda ()
;;         ;; .や::を入力直後から補完開始
;;         (add-to-list 'ac-sources 'ac-source-rsense-method)
;; 		(add-to-list 'ac-sources 'ac-source-rsense-constans)
;; 		;; C-x . で補完出来るようにキーを設定
;;         (define-key ruby-mode-map (kbd "C-x .") 'ac-complete-rsense)))

;; ==========================================
;; remember-el
;; ==========================================
(define-key global-map "\C-cr" 'org-remember)

;; ==========================================
;; caroo.el カクー Webのドローツール
;; ==========================================
(require 'cacoo)
(global-set-key (kbd "M--") 'toggle-cacoo-minor-mode)
(setq cacoo:api-key "D3OEYjRAfLAlmuk7K8lW")
(require 'cacoo-plugins)      ; 追加機能
;; 追加設定
(setq cacoo:img-dir-ok t) ; 画像フォルダは確認無しで作る

;; ----------------------------------------
;; org-mode, はてなフォトライフ,html imgタグの記法にcacoo.elを対応させる
;; ---------------------------------------
(setq cacoo:img-regexp
     '("\$latex \displaystyle img:\\(.*\\)\$[^]\n\r]*$latex " ; imgのデフォルト記法
       "\$latex \displaystyle f:\\(.*\\)\$[^]\n\t]*$"   ; はてなフォトライフ記法
       "<img src=[\"']\\(.*\\)[\"'][ ]*\\/>[^\n\t]*$latex " ; HTMLのimgタグ
       "\$latex \displaystyle .*\\[\\(.*\\)\$\\][^]\n\r]*$" ;org-modeの記法
       ))
;; 邪魔なアンダーラインを消すための設定
(defadvice toggle-cacoo-minor-mode
    (around my-toggle-cacoo-minor activate)
    (if (string-equal mode-name "Org")
        (if cacoo-minor-mode
            (progn
              ad-do-it
              (set-face-underline-p 'org-link t))
          (progn
            (set-face-underline-p 'org-link nil)
            ad-do-it))
      ad-do-it))

;; ========================================
;; org-remenber メモツール
;; 参考:http://d.hatena.ne.jp/rubikitch/20090121/1232468026
;; ========================================
(require 'org-install)
(setq org-startup-truncated nil)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(org-remember-insinuate)
(setq org-directory "~/memo/")
(setq org-default-notes-file (concat org-directory "agenda.org"))
(setq org-remember-templates
      '(("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
        ("Bug" ?b "** TODO %?   :bug:\n   %i\n   %a\n   %t" nil "Inbox")
        ("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")
        ))

;; ========================================
;; org-agendaモードへのキーバインド

(define-key global-map "\C-ca" 'org-agenda)
;; ========================================
;; agendaの休日表示設定
;; ========================================
(setq org-agenda-files (list org-default-notes-file
                             (format-time-string "~/memo/holidays.%Y.org")))


;; ============================================================
;; edit-grep
;; ============================================================
(require 'grep-edit)

;; ========================================
;; evernote-mode
;; ========================================
(require ' evernote-mode)
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)
(global-set-key "\C-cep" 'evernote-post-region)
(global-set-key "\C-ceb" 'evernote-browser)

;; ============================================================
;; ruby-block endに対応するブロックを示す
;; ============================================================
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

;; ============================================================
;; 行番号兼スクロールバー
;; ============================================================
;;(require 'yalinum)
;; (global-linum-mode t)
;;(global-yalinum-mode t)

;; ============================================================
;; mozc
;; ============================================================
(load-library "mozc")
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
; (global-set-key (kbd "C-o") 'toggle-input-method)

;===================================
; Dired
;===================================
;; (require 'ls-lisp)
;; (let (current-load-list)
;;   (defadvice insert-directory
;;     (around reset-locale activate compile)
;;     (let ((system-time-locale "C"))
;;       ad-do-it)))

;; ============================================================
;; html-helper-mode
;; ============================================================
(require 'html-helper-mode)
(autoload 'htmp-helper-mode "html-helper-mode" "Yay HTML" t)

;; ============================================================
;; simple-hatena-mode
;; ============================================================
;; http://coderepos.org/share/wiki/SimpleHatenaMode
(require 'simple-hatena-mode)
(setq simple-hatena-default-id "hi_igu")
;; はてダラスクリプトのパス(デフォルト値: hw.pl)
;; (setq simple-hatena-bin "~/bin/hw.pl")

;; ============================================================
;; howm  メモ機能
;; ============================================================
;(setq howm-menu-lang 'ja)
;(require 'howm-mode)

;; ============================================================
;; 文字コード
;; ============================================================
(set-language-environment "japanese")
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; ============================================================
;; フォント
;; ============================================================
(add-to-list 'default-frame-alist '(font . "ricty-11"))

;; ;; ============================================================
;; ;; Rsense
;; ;; ============================================================
;; (setq rsense-home "/opt/rsense-0.3")
;; (add-to-list 'load-path (concat rsense-home "/etc"))
;; (require 'rsense)
;; ;; C-c . で補完
;; (add-hook 'ruby-mode-hook
;; 					(lambda ()
;; 						(local-set-key (kbd "C-c .") 'rsense-complete)))

;; ;; 自動補完
;; ;; (add-hook 'ruby-mode-hook
;; ;;           (lambda ()
;; ;;             (add-to-list 'ac-sources 'ac-source-rsense-method)
;; ;;             (add-to-list 'ac-sources 'ac-source-rsense-constant)))



;; ============================================================
;; flymake c/c++
;; ============================================================

(setq gcc-warning-options
      '("-Wall" "-Wextra" "-Wformat=2" "-Wstrict-aliasing=2" "-Wcast-qual"
      "-Wcast-align" "-Wwrite-strings" "-Wfloat-equal"
      "-Wpointer-arith" "-Wswitch-enum"
      ))

(setq gxx-warning-options
      `(,@gcc-warning-options "-Woverloaded-virtual" "-Weffc++")
      )

(setq gcc-cpu-options '("-msse" "-msse2" "-mmmx"))

(defun flymake-c-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name)))
       )
    (list "gcc" `(,@gcc-warning-options ,@gcc-cpu-options "-fsyntax-only" "-std=c99" ,local-file))
    ))
(push '(".+\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
(add-hook 'c-mode-hook '(lambda () (flymake-mode t)) )

(defun flymake-c++-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" `(,@gxx-warning-options ,@gcc-cpu-options "-fsyntax-only" "-std=c++0x" ,local-file))
    ))
(push '(".+\\.h$" flymake-c++-init) flymake-allowed-file-name-masks)
(push '(".+\\.cpp$" flymake-c++-init) flymake-allowed-file-name-masks)
(add-hook 'c++-mode-hook '(lambda () (flymake-mode t)) )

;; ============================================================
;; htmlize ソースコードの色付け 2011.07.12
;; ============================================================

;;; dmacro.el の設定  キー操作の繰り返しを C-t で
(defconst *dmacro-key* "\C-t" "繰返し指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)

;; ============================================================
;; csv-mode
;; ============================================================
;;; 20081206 csv-mode.el
;;; http://d.hatena.ne.jp/amt/20081206/CsvMode4Emacs
;;(add-to-list 'load-path "~/install/elisp/cvs-mode-el/")
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

;; ============================================================
;; magit git tool
;; ============================================================
(require 'magit)

