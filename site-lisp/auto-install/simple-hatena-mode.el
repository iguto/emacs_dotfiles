;;; -*- coding: utf-8; mode: emacs-lisp; indent-tabs-mode: nil -*-
;;; simple-hatena-mode.el --- Emacs interface to Hatena::Diary Writer

;; Copyright (C) 2007 Kentaro Kuribayashi
;; Author: Kentaro Kuribayashi <kentarok@gmail.com>
;; Keywords: blog, hatena, ใ๕ฆ๕ช

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; * simple-hatena-mode.elใ๕ฎใใฆ

;; ใใ๕ใใๅฎด่ฅๅพ๕ฆใใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅใEmacsใใ็ฏๅธฅใใใ
;; ใ๕ฎใใ๕ฆ๕๕ใใโช๕ผ/ใ้๕ฎ่ฅๆใจจใ่โฆใ๕ฑ่ด้ใใใใ๕๏ผๅพ๏ฝ่ฅโชผ
;; ใใsimple-hatena-modeใๆ็ฎดใใ้ใsimple-hatena-modeใ๕ฆ
;; html-helper-modeใ๕ๆฌพ็ใโช่ฅใ๕ใ๕ฎ่๕ฒใใ๕ใ้ใ๕ั
;; html-helper-modeใๆ็ฎดใใๅ่ฎ๕ฉ่็ดๅ๕ถ๕ัใ้ใ
;;
;; ใใๆฝ้ดปใ่ฅ๕ฎ่๕ฌฎๆๅทณ่ใ๕ฎใใ๕๕ฆ็ฏใคธใ๕ใ่ฅๅพใ่ัใ ใใใ
;; http://coderepos.org/share/wiki/SimpleHatenaMode

;;; Code:

;;;; * ใ็ผ๏ผ่ฅๅพัณ

(defconst simple-hatena-version "0.15"
  "simple-hatena-mode.elใ๕็ผ๏ผ่ฅๅพัๆฝ")

(defun simple-hatena-version ()
  "simple-hatena-mode.elใ๕็ผ๏ผ่ฅๅพัๆฝ่ต๕ใใใใ"
  (interactive)
  (let ((version-string
         (format "simple-hatena-mode-v%s" simple-hatena-version)))
    (if (interactive-p)
        (message "%s" version-string)
      version-string)))

;;;; * ใ๕่ฅๅ๕ฎใใ๕ฎ้ดปๅธฅใใๅดๅ๕ซ็ด๕โ็ต

;; ใ๕ฎ้ดปๅธฅใใ้ชคๆฐ
(defvar simple-hatena-bin "hw.pl"
  "*ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅ๕ใ้ดปๆ็ตใใใ")

(defvar simple-hatena-root "~/.hatena"
  "*ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅ๕ใ่ฅๅธฅ่๕ใใ๏ฝ๕๕ฆใ๕๕๕ฎ่ฅใๆ
็ตใใใ")

(defvar simple-hatena-default-id nil
  "*ใ๕ฆ๕ใ๕ฒัๆใใใใ๕ฒ๕ฎใ๕๕ฆ๕ชidใๆ็ตใใใ

ใใ๕คๆ้่๕ฌฎใใใ๕ใๅ ็ฟซใsimple-hatenaใใใใฏ
simple-hatena-group็ต่ตๆใ๕ฎ่๕ฌฎใใใidใ็ฏๅธฅใใใใใidใ้ๅพก
ใใ็ถฝ่ใใ๕ใ

ใใฎidใ็ดๆ็ผใใ๕ฎ๕ฆsimple-hatena-change-default-idใ็ต่ตใใใ")

(defvar simple-hatena-default-group nil
  "*ใใใ๕ฒ๕ฎใ้๕ฎ่ฅๅใๆ็ตใใใ")

(defvar simple-hatena-use-timestamp-permalink-flag t
  "*ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅ๕ใ่ฅใ๕ๆฝ๕ฆ๕ฎใๅธฅใ ใ้ดปๅธฅๆฝใ็ฏๅธฅ
ใใ๕ฒใใๆ็ตใใใใ๕ฒ้")

(defvar simple-hatena-time-offset nil
  "*ๆใคปใ่่ใใ้ใ๕ฒ๕ใใ๕ใ็ฅใใ
6 ใ๕ณโ็ตใใใ๕ๅ6ๆใ้ัๆใฃ๕ใคปใ๕ใ๕ๅฎดใใ")

;; ใ๕ฆ๕ใ๕ฒ๕ฎใใใ๕ใๆฟัณ
(defvar simple-hatena-option-useragent (simple-hatena-version)
  "*ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅ๕๕่ฅๅ๕่ฅๅพัๆฝใ๕ใๆฟัๆฝๆ็ตใ
ใใ

็ต่ตๆใ๕ฎ-aใ๕ใๆฟัๆฝ๕ใ๕ๆใใใใ")

(defvar simple-hatena-option-debug-flag nil
  "*ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅใใใใใ้โช่ฅใัฎ่ตใใใๅ๕ใๆ
็ตใใใใ๕ฒ้

ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅๅผฑฎ่ตๆใ๕ฎ-dใ๕ใๆฟัๆฝ๕ใ๕ใใใใใ้ใ
ใใ๕ ็ฟซใ็ต่ต่ๆใใใใใ๏ผ๕ณ๏ผ่ๅดใใ

ใใใใ้โช่ฅใใ๕ณ/ใ๕ใใใ๕ฎ๕ฆ
simple-hatena-toggle-debug-modeใ็ต่ตใใใ")

(defvar simple-hatena-option-timeout 30
  "*ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅ๕ๅธฅใ ใโช๕ใๆ็ตใใใ

็ต่ตๆใ๕ฎ-Tใ๕ใๆฟัๆฝ๕ใ๕ๆใใใใ")

(defvar simple-hatena-option-cookie-flag t
  "*ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅ๕๕ช้ใๆฝ๕ฎcookieใๅ๕ถ๕ใใใ๕ฒใ
ใๆ็ตใใใใ๕ฒ้

็ต่ตๆใ๕ฎ-cใ๕ใๆฟัๆฝ๕ใ๕ๆใใใใ")

(defvar simple-hatena-process-buffer-name "*SimpleHatena*"
  "*ใ๕ฆ๕ใ๕ฒ็ต่ตใใใใ๕ช็ฅ้ดป๕ใใใโฆใ")

;; ใ๕ช่ฅใใๆฝ
(setq simple-hatena-mode-map (make-keymap))

(define-key simple-hatena-mode-map (kbd "C-c C-v") 'simple-hatena-version)
(define-key simple-hatena-mode-map (kbd "C-c C-p") 'simple-hatena-submit)
(define-key simple-hatena-mode-map (kbd "C-c C-c") 'simple-hatena-trivial-submit)
(define-key simple-hatena-mode-map (kbd "C-c   *") 'simple-hatena-timestamp)
(define-key simple-hatena-mode-map (kbd "C-c C-i") 'simple-hatena-change-default-id)
(define-key simple-hatena-mode-map (kbd "C-c C-g") 'simple-hatena-change-default-group)
(define-key simple-hatena-mode-map (kbd "C-c C-n") 'simple-hatena-find-diary-for)
(define-key simple-hatena-mode-map (kbd "C-c C-b") 'simple-hatena-go-back)
(define-key simple-hatena-mode-map (kbd "C-c C-f") 'simple-hatena-go-forward)
(define-key simple-hatena-mode-map (kbd "C-c C-d") 'simple-hatena-toggle-debug-mode)
(define-key simple-hatena-mode-map (kbd "C-c C-e") 'simple-hatena-exit)
(define-key simple-hatena-mode-map (kbd       "*") 'simple-hatena-electric-asterisk)

;; ใใใฏ
(defvar simple-hatena-mode-hook nil
  "simple-hatena-mode้็ดฎๆใ๕ใใ๕ฆ")
(defvar simple-hatena-before-submit-hook nil
  "ๆใจจใๆ่ฎๅธฅใ็็ฟซใ๕ใใฏ")
(defvar simple-hatena-after-submit-hook nil
  "ๆใจจใๆ่ฎๅธฅใ็็ฟซพใ๕ใใฏ")

;; ใใ๕ฒๆฝใ๕ชใฏ

(defvar simple-hatena-font-lock-keywords nil)
(defvar simple-hatena-slag-face 'simple-hatena-slag-face)
(defvar simple-hatena-subtitle-face 'simple-hatena-subtitle-face)
(defvar simple-hatena-inline-face 'simple-hatena-inline-face)
(defvar simple-hatena-markup-face 'simple-hatena-markup-face)
(defvar simple-hatena-link-face 'simple-hatena-link-face)

(defface simple-hatena-slag-face
  '((((class color) (background light)) (:foreground "IndianRed"))
    (((class color) (background dark)) (:foreground "wheat")))
  "็ตจ้ ณๅๅดใฎ*ใๅธฅใ ใ้ดปๅธฅๆฝorใ้ดป๕ฒใฐ*้๕ใ๕ใัใ้ดป")

(defface simple-hatena-subtitle-face
  '((((class color) (background light)) (:foreground "DarkOliveGreen"))
    (((class color) (background dark)) (:foreground "wheat")))
  "็ตจ้ ณๅๅดใ๕ใัใ้ดป")

(defface simple-hatena-inline-face
  '((((class color) (background light)) (:foreground "MediumBlue" :bold t))
    (((class color) (background dark)) (:foreground "wheat" :bold t)))
  "id่็พใ[keyword:Emacs]่ใฎface")

(defface simple-hatena-markup-face
  '((((class color) (background light)) (:foreground "DarkOrange" :bold t))
    (((class color) (background dark)) (:foreground "IndianRed3" :bold t)))
  "ใ๕ฆ๕๕๕ใ่ฅ๕ฆโชใใ๕ใัใ้ดป")

(defface simple-hatena-link-face
  '((((class color) (background light)) (:foreground "DeepPink"))
    (((class color) (background dark)) (:foreground "wheat")))
  "ใ๕ๆฝ๕ฆ๕ใัใ้ดป")

;;;; * ็ต่

(eval-when-compile
  (require 'cl)
  (require 'derived)
  (require 'font-lock)
  (require 'html-helper-mode))

(defconst simple-hatena-filename-regex
   "/\\([^/]+\\)/\\(diary\\|group\\)/\\([^/]+\\)?/?\\([0-9][0-9][0-9][0-9]\\)-\\([01][0-9]\\)-\\([0-3][0-9]\\)\.txt"
  "ๆใจจใใ๏ผใ๕ฎ๕๕ช่้ ซ๕ๆใใใใใๅ ็ฟซใ็ฏใคธใ๕ใๆฝใใ๕ฆ้ดป๕ฎ
ใใใ๏ผใ๕ฑๅ ๅฎดๅ็ทใัใใ

  0. ใใใใใๅ๕ฝ
  1. ใ๕ฆ๕ชid
  2. diary/group
  3. 2ใgroupใ๕ ็ฟซใ๕ฆใ้๕ฎ่ฅๅใใใใั๕ๅ ็ฟซใฏnil
  4. ็ถด(YYYY)
  5. ๆ(MM)
  6. ๆฅ(DD)")

;; ใ๕ฆ๕ชIDใ๕๕ช่้ ซ๕พ
;; > http://d.hatena.ne.jp/keyword/%A4%CF%A4%C6%A4%CAID
;; > ็ดั็ตใใใใ๕จฐๆ็ตใ๕โช๕ฎใ๏ผใใใป0-9ใ๕ๅปญใ็ฅ-ใใ็ฅ_ใ(ใใใใ
;; ๅ่น)ใ๕ใใใใ3-32ๆ็ต็ญ๕้ดปใใฎ(ใใ ใๆๅใ๕็ตใ๕ฆโช๕ฎใ๏ผใใใง
;; ใใใใจ)ใใๆใใ
(defconst simple-hatena-id-regex
  "^[A-z][\-_A-z0-9]+[A-z0-9]$"
  "")

;; ใ๕ฆ๕๕้๕ฎ่ฅๅใ๕๕ช่้ ซ๕พ
;; > http://g.hatena.ne.jp/group?mode=append
;; > ้ใโช๕ฎใ๏ผใใใังใ้ใใโช๕ฎใ๏ผใใใๆๅปญใัตใใ3ๆ็ต็ฏใคธใ
;; > 24ๆ็ต็ฏใฅใ๕่น่ๆฉๅปญ้
;; ใ๕ๅพใใ๕ใใใ-ใใ็ฏๅธฅใใ
(defconst simple-hatena-group-regex
  "^[A-z][\-A-z0-9]+[A-z0-9]$"
  "")

;; simple-hatena-modeใใhtml-helper-modeใ๕ๆฌพ็ใโช่ฅใ๕ใ๕ฎ่๕ฒใใ
(define-derived-mode simple-hatena-mode html-helper-mode "Simple Hatena"
  "ใ๕ฆ๕๕ใใโช๕่ฅ๕ฒใๅธฅ่ฅใEmacsใใๅ๕ถ๕ใใใใ๕ใๆฝๅธฅใัค
ใ้ดปๆ็ฎดใใใโช่ฅใ

่๕ฌฎๆๅทณใ็ฏๅธฅๆ้ดป๕ฎใใ๕๕ฆ็ฏใคธใๅ็ั๕ใ๕
http://coderepos.org/share/wiki/SimpleHatenaMode"

  ;; ็ๆ๕ใใ๕ใใใใใ๏ผ๕ๅ ฑ
  (make-local-variable 'simple-hatena-local-current-buffer-info)
  (make-local-variable 'simple-hatena-local-current-buffer-id)
  (make-local-variable 'simple-hatena-local-current-buffer-type)
  (make-local-variable 'simple-hatena-local-current-buffer-group)
  (make-local-variable 'simple-hatena-local-current-buffer-year)
  (make-local-variable 'simple-hatena-local-current-buffer-month)
  (make-local-variable 'simple-hatena-local-current-buffer-day)

  (if (string-match simple-hatena-filename-regex (buffer-file-name))
      (progn
        (setq simple-hatena-local-current-buffer-info
              (match-string 0 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-id
              (match-string 1 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-type
              (match-string 2 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-group
              (match-string 3 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-year
              (match-string 4 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-month
              (match-string 5 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-day
              (match-string 6 (buffer-file-name)))
        (simple-hatena-update-modeline))
    (error "Current buffer isn't related to Hatena::Diary Writer data file"))

  ;; ใใ๕ฒๆฝใ๕ชใฏ
  (font-lock-add-keywords 'simple-hatena-mode
    (list
     (list  "^\\(\\*[*a-zA-Z0-9_-]*\\)\\(.*\\)$"
            '(1 simple-hatena-slag-face t)
            '(2 simple-hatena-subtitle-face t))
     ;; ็ถฝใ[]ใั่้ใ๕ใ๕ใใ้๕ใ๕ใใฎ
     (list "\\[[*a-zA-Z0-9_-]+\\(:[^\n]+\\)+\\]"
           '(0 simple-hatena-inline-face t))
     ;; ็ถฝใใใ[]ใั่้ใ๕ใ๕ใ๕ใใใใฎ
     (list "\\[?\\(id\\|a\\|b\\|d\\|f\\|g\\|graph\\|i\\|idea\\|map\\|question\\|r\\|isbn\\|asin\\)\\(:[a-zA-Z0-9_+:-]+\\)+\\]?"
           '(0 simple-hatena-inline-face t))
     (list  "^\\(:\\)[^:\n]+\\(:\\)"
            '(1 simple-hatena-markup-face t)
            '(2 simple-hatena-markup-face t))
     (list  "^\\([-+]+\\)"
            '(1 simple-hatena-markup-face t))
     (list  "\\(((\\).*\\())\\)"
            '(1 simple-hatena-markup-face t)
            '(2 simple-hatena-markup-face t))
     (list  "^\\(>>\\|<<\\|><!--\\|--><\\|>|?[^|]*|\\||?|<\\|=====?\\)"
            '(1 simple-hatena-markup-face t))
     (list  "\\(s?https?://\[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#\]+\\)"
            '(1 simple-hatena-link-face t))))
  (font-lock-mode 1)

  (use-local-map simple-hatena-mode-map)
  (run-hooks 'simple-hatena-mode-hook))

;; ใ๕ฆ๕ใ๕ฒใ่ฅๅธฅซsimple-hatena-modeใ้๕ถ๕ใ
;;
;; - ~/.hatena/hatena-id/diary/YYYY-MM-DD.txt
;; - ~/.hatena/hatena-id/group/group-name/YYYY-MM-DD.txt
;;
;; ใ๕ใใใ๏ผใ๕ฎ้ใใใใsimple-hatena-modeใ๕ฎใ
(add-to-list 'auto-mode-alist
             (cons simple-hatena-filename-regex 'simple-hatena-mode))

;;;; * ใๆฝใๆฝ

(defun simple-hatena-setup ()
  (interactive)
  "ใใ๏ฝ๕๕ฆใ๕่๕ใ็ฅใใโชใใใใ"
  (and
   ;; simple-hatena-bin
   (simple-hatena-setup-check-hatena-bin-exists-p)

   ;; hatena id(s)
   (simple-hatena-setup-id)

   ;; hatena group
   (if (y-or-n-p
        "Set up about `Hatena::Group' next? ")
       (simple-hatena-group-setup)
     (message "Enjoy!"))))

(defun simple-hatena-setup-check-hatena-bin-exists-p ()
  (if (file-executable-p simple-hatena-bin)
      t
    (progn
      (if (y-or-n-p
           (format
            "`Hatena Diary Writer' not found in %s. Are you sure to continue setup? "
            simple-hatena-bin))
          t
        (progn
          (when (y-or-n-p
                 "Open the documentation of simple-hatnea-mode in your browser? ")
            (browse-url "http://coderepos.org/share/wiki/SimpleHatenaMode"))
          (message "You must download and install `Hatena Diary Writer' first")
          nil)))))

(defun simple-hatena-setup-id ()
  (let
      ((ids (list)))
    (when (file-directory-p simple-hatena-root)
      (dolist (id (simple-hatena-internal-list-directories simple-hatena-root))
        (add-to-list 'ids id)))

    (when simple-hatena-default-id
      (add-to-list 'ids simple-hatena-default-id))

    (while
        (or (not ids) ;;FIXME incomprehensible.
            (y-or-n-p
             (format
              "Existing id(s): `%s'\nSet up other id? "
              (mapconcat 'identity
                         ids "', `"))))
      (add-to-list
       'ids (simple-hatena-read-string-and-match-check
             "Please input your other Hatena id: "
             simple-hatena-id-regex
             "`%s' is invalid as a Hatena id.")))

    (dolist (id ids)
      (simple-hatena-setup-id-create-directory-and-file id))
    ids))

(defun simple-hatena-setup-id-create-directory-and-file (id)
  (simple-hatena-setup-create-directory-and-file
   (expand-file-name
    (format "%s/%s/diary/config.txt"
            simple-hatena-root id))))

(defun simple-hatena-group-setup ()
  (interactive)
  "ใใ๏ฝ๕๕ฆใ๕๕ฎ๕ฆ๕๕้๕ฎ่ฅใ่ด้ต ใใใ"
  ;; hatena group(s)
  (simple-hatena-setup-group))

(defun simple-hatena-setup-group ()
  (let*
      ((groups (list))
       (id (condition-case err
               simple-hatena-local-current-buffer-id
             (error (simple-hatena-internal-completing-read-id
                     simple-hatena-root))))
       (group-dir (expand-file-name (format "%s/%s/group"
                                            simple-hatena-root id))))

    (unless (file-directory-p group-dir)
      (make-directory group-dir 'parents))

    (dolist (group (simple-hatena-internal-list-directories group-dir))
      (add-to-list 'groups group))

    (while
        (or (not groups)
            (y-or-n-p
             (format
              "Existing group(s): `%s'\nSet up other group? "
              (mapconcat 'identity
                         groups "', `"))))
      (add-to-list
       'groups (simple-hatena-read-string-and-match-check
                (format
                 "Please input a group name for id:%s: " id)
                simple-hatena-group-regex
             "`%s' is invalid as a group name.")))

    (dolist (group groups)
      (if (string-match simple-hatena-group-regex group)
          (simple-hatena-setup-group-create-directory-and-file id group)
        (message (format "`%s' is invalid as a group name." group))))))

(defun simple-hatena-setup-group-create-directory-and-file (id group)
  (simple-hatena-setup-create-directory-and-file
   (expand-file-name
    (format "%s/%s/group/%s/config.txt"
            simple-hatena-root id group))))

(defun simple-hatena-setup-create-directory-and-file (filename)
  "Set up a directory and file.

NOTE: Create intermediate directories as required."
  (let
      ((dirname (file-name-directory filename)))
    (unless (file-exists-p filename)
      (unless (file-directory-p dirname)
        (make-directory dirname 'parents))
      (append-to-file 1 1 filename))))

(defun simple-hatena-read-string-and-match-check (prompt regex
                                                         &optional errmsg)
  "Read a string from the minibuffer, prompting with string prompt,
and Cheking input value.

If non-nil, third args, you can set error message.

NOTE: Please refer to `format' for the format of the error
message."
  (let
      ((input nil)
       (errmsg (or errmsg
                   "Your input is invalid...")))
    (while
        (and
         (setq input (read-string prompt))
         (not (string-match regex input)))
      (message (format errmsg input))
      (sleep-for 1))
    input))

(defun simple-hatena (id)
  "็ต่ตๆใงๆ๕๕ใคปใ๕ใ๏ผใ๕ฎ้ใใ"
  (interactive
   (list
    (if simple-hatena-default-id
        simple-hatena-default-id
      (simple-hatena-internal-completing-read-id simple-hatena-root))))
  (simple-hatena-internal-safe-find-file (concat
               simple-hatena-root
               "/"
               id
               "/diary/"
               (simple-hatena-internal-make-diary-file-string 0))))

(defun simple-hatena-group (id group)
  "็ต่ตๆใงๆ๕๕ใคปใ๕ๆ็ตใใใใ้๕ฎ่ฅใ๕ฑ่ฎๅธฅใใใใ๕ใ๏ผใซ
ใ้ใใ"
  (interactive
   (if simple-hatena-default-id
       (list
        simple-hatena-default-id
        (if simple-hatena-default-group
            simple-hatena-default-group
          (simple-hatena-internal-completing-read-group simple-hatena-default-id)))
     (let ((id (simple-hatena-internal-completing-read-id simple-hatena-root)))
       (list
        id
        (if simple-hatena-default-group
            simple-hatena-default-group
          (simple-hatena-internal-completing-read-group id))))))
  (simple-hatena-internal-safe-find-file (concat
              simple-hatena-root
              "/"
              id
              "/group/"
              group
              "/"
              (simple-hatena-internal-make-diary-file-string 0))))

(defun simple-hatena-change-default-id ()
  "็ๆ๕๕ใใ๕ฒ๕ฎidใ็ดๆ็ผใใ"
  (interactive)
  (setq simple-hatena-default-id
        (simple-hatena-internal-completing-read-id simple-hatena-root))
  (message "Changed current default id to %s" simple-hatena-default-id))

(defun simple-hatena-change-default-group ()
  "็ๆ๕๕ใใ๕ฒ๕ฎใ้๕ฎ่ฅใ็ดๆ็ผใใ"
  (interactive)
  (if simple-hatena-default-id
      (setq simple-hatena-default-group
            (simple-hatena-internal-completing-read-group simple-hatena-default-id))
    (list (simple-hatena-change-default-id)
          (setq simple-hatena-default-group
                (simple-hatena-internal-completing-read-group simple-hatena-default-id))))
  (message "Change current default group to %s" simple-hatena-default-group))

(defun simple-hatena-submit ()
  "ใ๕ฆ๕๕ใใโช๕ผ/ใ้๕ฎ่ฅใ๕ฑ่ฎๅธฅใใ"
  (interactive)
  (simple-hatena-internal-do-submit))

(defun simple-hatena-trivial-submit ()
  "ใ๕ฆ๕๕ใใโช๕ผ/ใ้๕ฎ่ฅใ๕ฎใ๏ผใ๏ฝ๕ใๆ่ด้ใั่ฎๅธฅใใ"
  (interactive)
  (simple-hatena-internal-do-submit "-t"))

(defun simple-hatena-timestamp ()
  "็ต่ต็ฏ่๕๕ฎใ*ใๅธฅใ ใ้ดปๅธฅๆฝ*ใใๆๆฐดใฃใใ"
  (interactive)
  (insert (format-time-string "*%s*" (current-time))))

(defun simple-hatena-find-diary-for (date)
  "ๆ็ตใใใๆใคปใ๕ใจจใใใใ๏ผ่ต๕ใใใใ"
  (interactive "sDate(YYYY-MM-DD): ")
  (if (equal major-mode 'simple-hatena-mode)
      (if (string-match "^[0-9][0-9][0-9][0-9]-[01][0-9]-[0-3][0-9]$" date)
          (simple-hatena-internal-safe-find-file
           (concat (file-name-directory (buffer-file-name))
                   (concat date ".txt")))
        (error "Invalid date"))
    (error "Current major mode isn't simple-hatena-mode")))

(defun simple-hatena-go-forward (&optional i)
  "ๅใ๕ใคปใๆะฉๅใใใๅ่๕ผๆ้็พ๏ผใใๅ ็ฟซใ๕ฆใใ๕้ ใ็ทใ๕ใคปใ๕ฒะฉๅใใใ"
  (interactive "p")
  (if (not i)
      (simple-hatena-internal-go-for 1)
    (simple-hatena-internal-go-for i)))

(defun simple-hatena-go-back (&optional i)
  "็ฝจ๏ผ๕ใคปใๆะฉๅใใใๅ่๕ผๆ้็พ๏ผใใๅ ็ฟซใ๕ฆใใ๕้ ใๅใ๕ใคปใ๕ฒะฉๅใใใ"
  (interactive "p")
  (if (not i)
      (simple-hatena-internal-go-for -1)
    (simple-hatena-internal-go-for (- i))))

(defun simple-hatena-toggle-debug-mode ()
  "ใใใใ้โช่ฅใใ๕ณ/ใ๕ใใใ"
  (interactive)
  (if simple-hatena-option-debug-flag
      (progn
        (setq simple-hatena-option-debug-flag nil)
        (message "Debug mode off"))
    (progn
      (setq simple-hatena-option-debug-flag t)
      (message "Debug mode on"))))

(defun simple-hatena-exit ()
  "simple-hatena-modeใ๕๕ถ๕ใใ๕ใใใใใ๏ผๅ๕๕้ใใใ"
  (interactive)
  (dolist (buffer (buffer-list))
    (when (and
           (buffer-file-name buffer)
           (string-match simple-hatena-filename-regex (buffer-file-name buffer)))
      (when (buffer-modified-p buffer)
        (progn
          (save-current-buffer
            (set-buffer buffer)
            (save-buffer))))
      (kill-buffer buffer)))
  (message "simple-hatena-mode has been exited"))

(defun simple-hatena-electric-asterisk (arg)
  "้(ใโช้ดปๅธฅ๕้ดปฏ)ๆๅฏธใ๕ฎใใใๅธฅใ ใ้ดปๅธฅๆฝ็ฏใ็ตจ้ ณๅๅดใๆๆฐดใฃใใ

ใใใๆฝใ่ต้ ๕ช๕ฎใๅ ็ฟซใ๕ๅธฅใๅธฅใ ใ้ดปๅธฅๆฝใๆๆฐดใฃใใใ๕ปใ๕ ็ฟซ
ใ๕ฆ้็ตฝๆชใใโช้ดปๅธฅ๕้ดป๕ฆๆๆฐดใฃใใ"
  (interactive "*p")
  (if (and simple-hatena-use-timestamp-permalink-flag
           (zerop (current-column)))
      (simple-hatena-timestamp)
    (self-insert-command arg)))

;;;; * ๅ้๕โฝฐ

(defun simple-hatena-internal-safe-find-file (filename)
  "ๆ้ใใ็ผ๏ผ่ฅๅพัๆฝฎhtml-helper-modeใ๕ฆใใใ๕ฒ๕ฎใั้ดปๅฎด๕ฎใณ
ใ็ฏใ๏ฝ๕๕ๅใ๕ั้็ด๕ฉใใใ"
  (let ((html-helper-build-new-buffer nil))
    (find-file filename)))

(defun simple-hatena-internal-make-diary-file-string (i &optional date)
  "dateใๆ็ตใใใ๕ใ๕ๅ ็ฟซใ๕ฆ็ต่ตๆใงๆ๕๕ใคปใ่ๆฌ ้ดป๕ฎใๆใจจใใ๏ผใ๕ฐใ็ๆใใใ

   0: ็ฏๆฅ
   1: ๆๆฅ
  -1: ๆ๕ฅ

ๆ็ตใใใ๕ใๅ ็ฟซใ๕ฆใใ๕ใคปใ่ๆฌ ้ดป๕ฎใๆใจจใใ๏ผใ๕ฐใ็ๆใใใ"
  (apply (lambda (s min h d mon y &rest rest)
           (format-time-string "%Y-%m-%d.txt"
                               (encode-time s min h (+ d i) mon y)))
         (if date
             (append '(0 0 0) date)
           (apply (lambda (s min h d mon y &rest rest)
                    (list s min (- h (or simple-hatena-time-offset 0)) d mon y))
                  (decode-time)))))

(defun simple-hatena-internal-go-for (i)
  "็ถฃๆ้๕้ ใๅ็ทใ๕ใคปใ๕ใ๏ผใใใใใ๏ผๆะฉๅใใใ"
  (simple-hatena-internal-safe-find-file
   (concat
    (file-name-directory (buffer-file-name))
    (simple-hatena-internal-make-diary-file-string
     i
       (list (string-to-number simple-hatena-local-current-buffer-day)
             (string-to-number simple-hatena-local-current-buffer-month)
             (string-to-number simple-hatena-local-current-buffer-year))))))

(defun simple-hatena-internal-list-directories (dir)
  "dir็ญใ๕ฎใใใ๏ฝ๕๕ฆใ๕ใ๕้ดปใ๕ฎใ๕ฟใใ"
  (let ((dir-list nil))
    (dolist (file (directory-files dir t "^[^\.]") dir-list)
      (if (file-directory-p file)
          (progn
            (string-match "\\([^/]+\\)/?$" file)
            (setq dir-list (cons (match-string 1 file) dir-list)))))))

(defun simple-hatena-internal-completing-read-id (dir)
  "dir็ฏใคธใใใ๕ฆ๕ชidใๆ้ตๅดใ่็ตๅใฅใใใใ"
  (completing-read
   "Hatena id: " (simple-hatena-internal-list-directories simple-hatena-root) nil t))

(defun simple-hatena-internal-completing-read-group (id)
  "dir็ฏใคธใใใ้๕ฎ่ฅๅใๆ้ตๅดใ่็ตๅใฅใใใใ"
  (completing-read
   "Group: " (simple-hatena-internal-list-directories
              (concat simple-hatena-root "/" id "/group")) nil t))

(defun simple-hatena-internal-do-submit (&optional flag)
  "ใ๕ฆ๕๕ใใโชช/ใ้๕ฎ่ฅใๅพกใจจใๆ่ฎๅธฅใใ"
  (let ((max-mini-window-height 10)  ; hw.plใ่ต๕ใใใใ๏ผใ็ฅ่ฅๅพใ
                                     ; echoใ๕๕โช๕ณ๏ผ่ๅดใใใใใ
        (thisdir (file-name-directory (buffer-file-name))))
    (run-hooks 'simple-hatena-before-submit-hook)
    (when (buffer-modified-p)
      (save-buffer))
    (message "%s" "Now posting...")
    (let* ((buffer (get-buffer-create simple-hatena-process-buffer-name))
           (proc (get-buffer-process buffer)))
      (if (and
           proc
           (eq (process-status proc) 'run))
          (if (yes-or-no-p (format "A %s process is running; kill it?"
                                   (process-name proc)))
              (progn
                (interrupt-process proc)
                (sit-for 1)
                (delete-process proc))
            (error nil)))
      (with-current-buffer buffer
        (progn
          (erase-buffer)
          (buffer-disable-undo (current-buffer))
          (setq default-directory thisdir)))
      (make-comint-in-buffer
       "simple-hatena-submit" buffer shell-file-name nil
       shell-command-switch (simple-hatena-internal-build-command flag))
      (set-process-sentinel
       (get-buffer-process buffer)
       '(lambda (process signal)
          (if (string= signal "finished\n")
              (let ((max-mini-window-height 10))
                (display-message-or-buffer (process-buffer process))
                (run-hooks 'simple-hatena-after-submit-hook))))))))

(defun simple-hatena-internal-build-command (flag)
  "็ต่ตๅ๕ซ็ด๕ๆฝใๆฝๆ็ตๅใ็ฏๆใใใ"
  (let ((flag-list (list flag)))
    (if simple-hatena-option-debug-flag  (setq flag-list (cons "-d" flag-list)))
    (if simple-hatena-option-cookie-flag (setq flag-list (cons "-c" flag-list)))
    (simple-hatena-internal-join
     " "
     (cons simple-hatena-bin
           (append (simple-hatena-internal-build-option-list-from-alist) flag-list)))))

(defun simple-hatena-internal-build-option-list-from-alist ()
  "็ถฃๆ้ๅใใ๕ใๆฟัๆฝ๕๕้ดปใ็ฏๆใใใ"
  (let ((opts nil))
    (dolist (pair
             `(("-u" . ,simple-hatena-local-current-buffer-id)
               ("-g" . ,simple-hatena-local-current-buffer-group)
               ("-a" . ,simple-hatena-option-useragent)
               ("-T" . ,(format "%s" simple-hatena-option-timeout)))
             opts)
      (if (cdr pair)
           (setq opts (append opts (list (car pair) (cdr pair))))))))

(defun simple-hatena-internal-join (sep list)
  "่ต่ ๕๕็ๅ บใ๕ใ ใใใใ๕ฒ่ใใใใ๕ใ๏ฝใ๕งjoin็ต่"
  (if (<= (length list) 1)
      (car list)
    (concat (car list) sep (simple-hatena-internal-join sep (cdr list)))))

(defun simple-hatena-update-modeline ()
  "ใโช่ฅใ๕ฒใๆฝ๕๏ผ่ๅดๆ่ด้ใ"
  (let ((id
         (concat
          (if simple-hatena-local-current-buffer-group
              (format "g:%s:" simple-hatena-local-current-buffer-group)
            "")
          (format "id:%s" simple-hatena-local-current-buffer-id))))
    (setq mode-name (format "Simple Hatena [%s]" id))
    (force-mode-line-update)))

(provide 'simple-hatena-mode)

;;; simple-hatena-mode.el ends here
