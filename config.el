;;; config.el --- leaf subset                        -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Keywords: convenience
;; License: Apache-2.0

;;; Commentary:

;; leaf subset

;;; Code:

(defun config-normalizer/:require (name key val rest body)
  val)
(defalias 'config-normalizer/:when 'config-normalizer/:require)
(defalias 'config-normalizer/:preface 'config-normalizer/:require)
(defalias 'config-normalizer/:config 'config-normalizer/:require)

(defun config-handler/:require (name key val rest body)
  `(,@(when val `((require ',name))) ,@body))

(defun config-handler/:when (name key val rest body)
  `((when ,val ,@body)))

(defun config-handler/:preface (name key val rest body)
  `(,val ,@body))

(defun config-handler/:config (name key val rest body)
  `(,val ,@body))

(defun config-plist-sort (plist)
  (let (sorted-plist)
    (dolist (key config-keywords)
      (when (plist-member plist key)
        (push key sorted-plist)
        (push (plist-get plist key) sorted-plist)))
    (nreverse sorted-plist)))

(defun config-process-keywords (name plist raw)
  (when plist
    (let* ((key (pop plist))
           (val (pop plist))
           (normalizer-fn (intern (format "config-normalizer/%s" key)))
           (handler-fn (intern (format "config-handler/%s" key)))
           body)
      (setq val (funcall normalizer-fn name key val plist body))
      (setq body (config-process-keywords name plist raw))
      (funcall handler-fn name key val plist body))))

(defmacro config (name &rest args)
  (declare (indent defun))
  (let ((args* (config-sort-plist args)))
    `(prog1 ',name
       ,@(config-process-keywords name args* args*))))

(provide 'config)
;;; config.el ends here
