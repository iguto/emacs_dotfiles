;;; -*- coding: utf-8; mode: emacs-lisp; indent-tabs-mode: nil -*-
;;; simple-hatena-mode.el --- Emacs interface to Hatena::Diary Writer

;; Copyright (C) 2007 Kentaro Kuribayashi
;; Author: Kentaro Kuribayashi <kentarok@gmail.com>
;; Keywords: blog, hatena, ������������

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

;; * simple-hatena-mode.el������ゃ��て

;; こ�������ッ�宴�若�吾�������「������������������ゃ�≪������若������ゃ�帥�若��をEmacsから篏帥��るよう
;; �������、������������������ゃ�≪�������/�違������若���ヨ��を膂≦��������贋�違��るため������＜�吾�ｃ�若�≪��
;; ド、simple-hatena-modeを提箴�し�障��。simple-hatena-mode�������
;; html-helper-mode�����款生�≪�若����������������臂������れ��������障��������с��
;; html-helper-modeが提箴�する各腮�������純�������������с���障��。
;;
;; �ゃ�潟�鴻���若�������荐�������号��膈�������ゃ��������������篁ヤ����������若�吾��ご荀с��ださい。
;; http://coderepos.org/share/wiki/SimpleHatenaMode

;;; Code:

;;;; * �眼�＜�若�吾�с��

(defconst simple-hatena-version "0.15"
  "simple-hatena-mode.el������眼�＜�若�吾�с�潟��")

(defun simple-hatena-version ()
  "simple-hatena-mode.el������眼�＜�若�吾�с�潟��茵����ずする。"
  (interactive)
  (let ((version-string
         (format "simple-hatena-mode-v%s" simple-hatena-version)))
    (if (interactive-p)
        (message "%s" version-string)
      version-string)))

;;;; * ������若�吟�������る������鴻�帥���ゃ�冴��������純�����┃絎�

;; ������鴻�帥���ゃ�阪��数
(defvar simple-hatena-bin "hw.pl"
  "*������������������ゃ�≪������若������ゃ�帥�若��������鴻��指絎�する。")

(defvar simple-hatena-root "~/.hatena"
  "*������������������ゃ�≪������若������ゃ�帥�若��������若�帥��臀������デ�ｃ����������������������������若��を指
絎�する。")

(defvar simple-hatena-default-id nil
  "*������������������т戎うデフ�����������������������������idを指絎�する。

こ��������違��荐������され�������る�翫��、simple-hatenaあるいは
simple-hatena-group絎�茵�時�������荐������されたidが篏帥��れるため、idを�御��
する綽�荀�が�������。

このidを紊��眼��る������������simple-hatena-change-default-idを絎�茵�する。")

(defvar simple-hatena-default-group nil
  "*デフ�������������違������若��名を指絎�する。")

(defvar simple-hatena-use-timestamp-permalink-flag t
  "*������������������ゃ�≪������若������ゃ�帥�若��������若��������潟�������������帥�ゃ���鴻�帥�潟��を篏帥��
か�������かを指絎�するフ������違��")

(defvar simple-hatena-time-offset nil
  "*�ヤ��を荐�膊�する際������������る��������祉��ト。
6 �����┃絎�する�������前6時�障�у���ャ������ヤ���������������宴��れる")

;; ������������������������たす��������激�с��
(defvar simple-hatena-option-useragent (simple-hatena-version)
  "*������������������ゃ�≪������若������ゃ�帥�若�����������若�吟������若�吾�с�潟����������激�с�潟��指絎�す
る。

絎�茵�時�������-a��������激�с�潟������������戎われる。")

(defvar simple-hatena-option-debug-flag nil
  "*������������������ゃ�≪������若������ゃ�帥�若��、デバッ�違�≪�若���у��茵�するか�������を指
絎�するフ������違��

������������������ゃ�≪������若������ゃ�帥�弱��茵�時�������-d��������激�с�潟��������������たされ、�障��、
そ������翫��、絎�茵�腟�果をバッフ�＜�����；腓冴��る。

デバッ�違�≪�若��を�������/�������する������������
simple-hatena-toggle-debug-modeを絎�茵�する。")

(defvar simple-hatena-option-timeout 30
  "*������������������ゃ�≪������若������ゃ�帥�若������帥�ゃ���≪�������を指絎�する。

絎�茵�時�������-T��������激�с�潟������������戎われる。")

(defvar simple-hatena-option-cookie-flag t
  "*������������������ゃ�≪������若������ゃ�帥�若�����������違�ゃ�潟�������cookieを������������るか�������か
を指絎�するフ������違��

絎�茵�時�������-c��������激�с�潟������������戎われる。")

(defvar simple-hatena-process-buffer-name "*SimpleHatena*"
  "*�������������������絎�茵�するプ������祉�鴻�������ッフ�≦��。")

;; ������若���ゃ�潟��
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

;; フック
(defvar simple-hatena-mode-hook nil
  "simple-hatena-mode開紮�時�������ッ�������")
(defvar simple-hatena-before-submit-hook nil
  "�ヨ��を投腮帥��る�翫���������ック")
(defvar simple-hatena-after-submit-hook nil
  "�ヨ��を投腮帥��た�翫���������ック")

;; フ������潟���������ク

(defvar simple-hatena-font-lock-keywords nil)
(defvar simple-hatena-slag-face 'simple-hatena-slag-face)
(defvar simple-hatena-subtitle-face 'simple-hatena-subtitle-face)
(defvar simple-hatena-inline-face 'simple-hatena-inline-face)
(defvar simple-hatena-markup-face 'simple-hatena-markup-face)
(defvar simple-hatena-link-face 'simple-hatena-link-face)

(defface simple-hatena-slag-face
  '((((class color) (background light)) (:foreground "IndianRed"))
    (((class color) (background dark)) (:foreground "wheat")))
  "絨頳��冴��の*�帥�ゃ���鴻�帥�潟��or�鴻�������グ*���������������с�ゃ�鴻��")

(defface simple-hatena-subtitle-face
  '((((class color) (background light)) (:foreground "DarkOliveGreen"))
    (((class color) (background dark)) (:foreground "wheat")))
  "絨頳��冴����������с�ゃ�鴻��")

(defface simple-hatena-inline-face
  '((((class color) (background light)) (:foreground "MediumBlue" :bold t))
    (((class color) (background dark)) (:foreground "wheat" :bold t)))
  "id荐�羈�や[keyword:Emacs]膈�のface")

(defface simple-hatena-markup-face
  '((((class color) (background light)) (:foreground "DarkOrange" :bold t))
    (((class color) (background dark)) (:foreground "IndianRed3" :bold t)))
  "�����������������������若������≪��プ��������с�ゃ�鴻��")

(defface simple-hatena-link-face
  '((((class color) (background light)) (:foreground "DeepPink"))
    (((class color) (background dark)) (:foreground "wheat")))
  "������潟�������������с�ゃ�鴻��")

;;;; * 絎�茖�

(eval-when-compile
  (require 'cl)
  (require 'derived)
  (require 'font-lock)
  (require 'html-helper-mode))

(defconst simple-hatena-filename-regex
   "/\\([^/]+\\)/\\(diary\\|group\\)/\\([^/]+\\)?/?\\([0-9][0-9][0-9][0-9]\\)-\\([01][0-9]\\)-\\([0-3][0-9]\\)\.txt"
  "�ヨ��フ�＜�ゃ��������������荀頫����憗��マッチした�翫��、篁ヤ��������ゃ�潟��ッ������鴻�������
りフ�＜�ゃ��������宴��取緇��с��る。

  0. マッチした�������
  1. ������������id
  2. diary/group
  3. 2がgroup������翫����������違������若��名。そう�с��������翫��はnil
  4. 綛�(YYYY)
  5. 月(MM)
  6. 日(DD)")

;; ������������ID���������荀頫������
;; > http://d.hatena.ne.jp/keyword/%A4%CF%A4%C6%A4%CAID
;; > 紊ф��絖�あるい�������文絖�������≪��������＜��ット・0-9������医���祉��-」�祉��_」(いずれも
;; 半茹�)�������ずれかを3-32文絖�筝�����鴻��もの(ただし最初�������絖�������≪��������＜��ットで
;; あること)から成る。
(defconst simple-hatena-id-regex
  "^[A-z][\-_A-z0-9]+[A-z0-9]$"
  "")

;; ����������������違������若��名���������荀頫������
;; > http://g.hatena.ne.jp/group?mode=append
;; > 鐚��≪��������＜��ット�у���障��、�≪��������＜��ットか�医���х��わる3文絖�篁ヤ��、
;; > 24文絖�篁ュ���������茹��掩�医��鐚�
;; ������吾��れ�������るが「-」も篏帥��る。
(defconst simple-hatena-group-regex
  "^[A-z][\-A-z0-9]+[A-z0-9]$"
  "")

;; simple-hatena-modeを、html-helper-mode�����款生�≪�若����������������臂������る。
(define-derived-mode simple-hatena-mode html-helper-mode "Simple Hatena"
  "������������������ゃ�≪������若������ゃ�帥�若��、Emacsから������������るため������ゃ�潟�帥���с��
�鴻��提箴�する�≪�若��。

荐�������号��や篏帥���鴻������ゃ��������������篁ヤ��を参�с��������������
http://coderepos.org/share/wiki/SimpleHatenaMode"

  ;; �憜�������い�������るバッフ�＜�������報
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

  ;; フ������潟���������ク
  (font-lock-add-keywords 'simple-hatena-mode
    (list
     (list  "^\\(\\*[*a-zA-Z0-9_-]*\\)\\(.*\\)$"
            '(1 simple-hatena-slag-face t)
            '(2 simple-hatena-subtitle-face t))
     ;; 綽�ず[]�у�蚊�障����������������れ�違��������������もの
     (list "\\[[*a-zA-Z0-9_-]+\\(:[^\n]+\\)+\\]"
           '(0 simple-hatena-inline-face t))
     ;; 綽�ずしも[]�у�蚊�障�����������������������よいもの
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

;; ��������������������若�帥��simple-hatena-modeを������������る
;;
;; - ~/.hatena/hatena-id/diary/YYYY-MM-DD.txt
;; - ~/.hatena/hatena-id/group/group-name/YYYY-MM-DD.txt
;;
;; �������うフ�＜�ゃ�������開いたら、simple-hatena-mode�������る
(add-to-list 'auto-mode-alist
             (cons simple-hatena-filename-regex 'simple-hatena-mode))

;;;; * �潟���潟��

(defun simple-hatena-setup ()
  (interactive)
  "デ�ｃ�������������������臀�������祉��ト�≪��プする。"
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
  "デ�ｃ��������������������������������������違������若��を菴遵��する。"
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
  "絎�茵��ョ憜�����������ヤ����������＜�ゃ�������開く。"
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
  "絎�茵��ョ憜�����������ヤ���������指絎�された�違������若���������腮帥��るため��������＜�ゃ��
を開く。"
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
  "�憜������������フ������������idを紊��眼��る。"
  (interactive)
  (setq simple-hatena-default-id
        (simple-hatena-internal-completing-read-id simple-hatena-root))
  (message "Changed current default id to %s" simple-hatena-default-id))

(defun simple-hatena-change-default-group ()
  "�憜������������フ�������������違������若��を紊��眼��る。"
  (interactive)
  (if simple-hatena-default-id
      (setq simple-hatena-default-group
            (simple-hatena-internal-completing-read-group simple-hatena-default-id))
    (list (simple-hatena-change-default-id)
          (setq simple-hatena-default-group
                (simple-hatena-internal-completing-read-group simple-hatena-default-id))))
  (message "Change current default group to %s" simple-hatena-default-group))

(defun simple-hatena-submit ()
  "������������������ゃ�≪�������/�違������若���������腮帥��る。"
  (interactive)
  (simple-hatena-internal-do-submit))

(defun simple-hatena-trivial-submit ()
  "������������������ゃ�≪�������/�違������若����������＜���ｃ�������た�贋�違���ф��腮帥��る。"
  (interactive)
  (simple-hatena-internal-do-submit "-t"))

(defun simple-hatena-timestamp ()
  "絎�茵�篏�臀�����������「*�帥�ゃ���鴻�帥�潟��*」を�水�ャ��る。"
  (interactive)
  (insert (format-time-string "*%s*" (current-time))))

(defun simple-hatena-find-diary-for (date)
  "指絎�された�ヤ��������ヨ��バッフ�＜��茵����ずする。"
  (interactive "sDate(YYYY-MM-DD): ")
  (if (equal major-mode 'simple-hatena-mode)
      (if (string-match "^[0-9][0-9][0-9][0-9]-[01][0-9]-[0-3][0-9]$" date)
          (simple-hatena-internal-safe-find-file
           (concat (file-name-directory (buffer-file-name))
                   (concat date ".txt")))
        (error "Invalid date"))
    (error "Current major mode isn't simple-hatena-mode")))

(defun simple-hatena-go-forward (&optional i)
  "前������ヤ���悟Щ動する。前臀�������違��羝＜��れた�翫���������そ������違��け緇�������ヤ�������Щ動する。"
  (interactive "p")
  (if (not i)
      (simple-hatena-internal-go-for 1)
    (simple-hatena-internal-go-for i)))

(defun simple-hatena-go-back (&optional i)
  "罨＜������ヤ���悟Щ動する。前臀�������違��羝＜��れた�翫���������そ������違��け前������ヤ�������Щ動する。"
  (interactive "p")
  (if (not i)
      (simple-hatena-internal-go-for -1)
    (simple-hatena-internal-go-for (- i))))

(defun simple-hatena-toggle-debug-mode ()
  "デバッ�違�≪�若��を�������/�������する。"
  (interactive)
  (if simple-hatena-option-debug-flag
      (progn
        (setq simple-hatena-option-debug-flag nil)
        (message "Debug mode off"))
    (progn
      (setq simple-hatena-option-debug-flag t)
      (message "Debug mode on"))))

(defun simple-hatena-exit ()
  "simple-hatena-mode�����������������れ�������るバッフ�＜���������������ゃ��る。"
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
  "鐚�(�≪�鴻�帥������鴻��)�寂���������り、�帥�ゃ���鴻�帥�潟��篁�き絨頳��冴��を�水�ャ��る。

ポ�ゃ�潟��が茵�������������る�翫��������帥���帥�ゃ���鴻�帥�潟��を�水�ャ��、そ�������������翫��
�������通絽檎��り�≪�鴻�帥������鴻��������水�ャ��る。"
  (interactive "*p")
  (if (and simple-hatena-use-timestamp-permalink-flag
           (zerop (current-column)))
      (simple-hatena-timestamp)
    (self-insert-command arg)))

;;;; * 内������∽��

(defun simple-hatena-internal-safe-find-file (filename)
  "�違��い�眼�＜�若�吾�с�潟��html-helper-mode�������デフ�������������с�鴻�宴�������ン
を篏��ｃ�����������吟��������с���紙����する。"
  (let ((html-helper-build-new-buffer nil))
    (find-file filename)))

(defun simple-hatena-internal-make-diary-file-string (i &optional date)
  "dateが指絎�され���������������翫���������絎�茵��ョ憜�����������ヤ��を莎欠�鴻�������た�ヨ��フ�＜�ゃ�������を生成する。

   0: 篁�日
   1: 明日
  -1: �������

指絎�され�������る�翫���������そ������ヤ��を莎欠�鴻�������た�ヨ��フ�＜�ゃ�������を生成する。"
  (apply (lambda (s min h d mon y &rest rest)
           (format-time-string "%Y-%m-%d.txt"
                               (encode-time s min h (+ d i) mon y)))
         (if date
             (append '(0 0 0) date)
           (apply (lambda (s min h d mon y &rest rest)
                    (list s min (- h (or simple-hatena-time-offset 0)) d mon y))
                  (decode-time)))))

(defun simple-hatena-internal-go-for (i)
  "綣��違������違��け前緇�������ヤ����������＜�ゅ��バッフ�＜�悟Щ動する。"
  (simple-hatena-internal-safe-find-file
   (concat
    (file-name-directory (buffer-file-name))
    (simple-hatena-internal-make-diary-file-string
     i
       (list (string-to-number simple-hatena-local-current-buffer-day)
             (string-to-number simple-hatena-local-current-buffer-month)
             (string-to-number simple-hatena-local-current-buffer-year))))))

(defun simple-hatena-internal-list-directories (dir)
  "dir筝��������るデ�ｃ�������������������������鴻����������������す。"
  (let ((dir-list nil))
    (dolist (file (directory-files dir t "^[^\.]") dir-list)
      (if (file-directory-p file)
          (progn
            (string-match "\\([^/]+\\)/?$" file)
            (setq dir-list (cons (match-string 1 file) dir-list)))))))

(defun simple-hatena-internal-completing-read-id (dir)
  "dir篁ヤ��から������������idを�遵�冴��、茖�絎��ュ��させる。"
  (completing-read
   "Hatena id: " (simple-hatena-internal-list-directories simple-hatena-root) nil t))

(defun simple-hatena-internal-completing-read-group (id)
  "dir篁ヤ��から�違������若��名を�遵�冴��、茖�絎��ュ��させる。"
  (completing-read
   "Group: " (simple-hatena-internal-list-directories
              (concat simple-hatena-root "/" id "/group")) nil t))

(defun simple-hatena-internal-do-submit (&optional flag)
  "������������������ゃ�≪��/�違������若���御�ヨ��を投腮帥��る。"
  (let ((max-mini-window-height 10)  ; hw.plが茵����ずする�＜���祉�若�吾��、
                                     ; echo�����������≪�����；腓冴��せるため。
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
  "絎�茵�������純������潟���潟��文絖�列を篏�成する。"
  (let ((flag-list (list flag)))
    (if simple-hatena-option-debug-flag  (setq flag-list (cons "-d" flag-list)))
    (if simple-hatena-option-cookie-flag (setq flag-list (cons "-c" flag-list)))
    (simple-hatena-internal-join
     " "
     (cons simple-hatena-bin
           (append (simple-hatena-internal-build-option-list-from-alist) flag-list)))))

(defun simple-hatena-internal-build-option-list-from-alist ()
  "綣��違��取る��������激�с�潟�����������鴻��を篏�成する。"
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
  "荵�莠������������堺���������だろうけ�������荀��ゃ��ら��������ｃ���������join絎�茖�"
  (if (<= (length list) 1)
      (car list)
    (concat (car list) sep (simple-hatena-internal-join sep (cdr list)))))

(defun simple-hatena-update-modeline ()
  "�≪�若��������ゃ�潟�����；腓冴���贋�違��る"
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
