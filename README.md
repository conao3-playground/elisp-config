# elisp-config

`config` is subset of [leaf](https://github.com/conao3/leaf.el).

Sample repository for [leafのつくりかた](https://a.conao3.com/blog/2023/b275-bb4c/).

# Usage

`M-x eval-buffer` in `config.el`.

Then, you can use `config` macro.

```elisp
(ppp-macroexpand
 (config test
   :config (setq test-config 1)
   :preface (setq test-preface 1)
   :when (executable-find "rg")
   :require t))
;;=> (prog1 'test
;;     (setq test-preface 1)
;;     (when (executable-find "rg")
;;       (require 'test)
;;       (setq test-config 1)))
```
