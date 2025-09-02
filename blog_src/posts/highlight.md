---
layout: post.njk
title: "Straightforward Emacs: Automatically Highlight Buffer Text"
excerpt: "Using hl-prog-extra to automatically highlight instances of text in an Emacs buffer."
date: 2022-08-24
---

A habit I've picked up from my time writing journalism is using the letters `TK` to signify material that is not yet filled in. Many journalists use TK in place of underscores (`_________`), or a block of Xs (XXXXXXXXXX). TK, short for "to come," is easy to search for, as few English words contain a T followed by a K, and stands out visually.

Regardless of its origin and utility, I use TKTKTKTK in my writing, much of which I do in **Emacs' Org Mode**. The letters alone stand out enough, but I wanted to make it even more eye-catching in my Emacs buffer.

After some searching and trial and error, I worked out a great solution using the [hl-prog-extra](https://codeberg.org/ideasman42/emacs-hl-prog-extra) package, available on [MELPA](https://melpa.org/#/hl-prog-extra).

Here is the result:

{% image "/assets/images/highlight_tktktk.png", "Draft of this post. Each TK is highlighted automatically.", "rounded shadow" %}

From `hl-prog-extra`'s source code:

> This package provides an easy way to highlight words in programming modes,
> where terms can be highlighted on code, comments or strings.

---

Though designed for use with programming modes, the package works well for **highlighting any arbitrary text in an Emacs buffer**. I wanted to highlight any number of TKs in a row when I write in Org Mode. To do this, I first wrote a **regular expression**:

```emacs-lisp
"\\(TK\\)+"
```

The parenthesis define a character group, so a T and a K together. The `\` are escape characters. And the `+` means, any number of this group. Pretty simple.

After that, I installed `M-x package-install <RET> hl-prog-extra <RET>` and configured `hl-prog-extra`. To specify what strings I'd like highlighted, I modify the `hl-prog-extra-list` variable. It should be set to a list of lists with configuration properties. Sounds like a lot, but after seeing how mine is set up you should be able to make your own easily.

```emacs-lisp
(setq hl-prog-extra-list
	  (list
	   ;; Match TKs in quotation marks (hl-prog-extra sees them as strings)
	   '("\\(TK\\)+" 0 string '(:weight bold :inherit font-lock-warning-face))
	   ;; Match TKs not in quotation marks
	   '("\\(TK\\)+" 0 nil '(:weight bold :inherit font-lock-warning-face)))))
```

In each sub-list, as I think of it, first comes the _regular expression_ (regex). Then comes the regex _subexpression_ --- 0 means use the whole thing. Next is the _context_.

To match the TK in any situation, I need to use two highlight contexts --- one for strings (`string`), which will match TKs in quotes ("TKTKTK"), and one for TKs not in quotation marks (`nil`). This repetition is needed because, as I mentioned, `hl-prog-extra` is designed for writing code. Not ideal but it's fine.

Finally is the _face_ configuration, another list with arguments/attributes. For more information on face attributes, see [GNU Emacs Manual Face Attributes](https://www.gnu.org/software/emacs/manual/html_node/elisp/Face-Attributes.html). `:inherit` is an easy way to define your face here, it will just make your highlight take on another face's properties (foreground color, underline, etc). In the above example I highlight TK with whatever my current theme makes the warning face look like. Warning should stand out nicely with any theme.

With that done, I just needed to **automatically activate `hl-prog-extra-mode` in Org Mode**. This is done with a simple hook:

```emacs-lisp
;; Using `add-hook'
(add-hook 'org-mode-hook #'hl-prog-extra-mode)

;; Or for `use-package' users:
:hook (org-mode . hl-prog-extra-mode)
```

And with that, everything is configured! For those who are interested, here is my full configuration using `use-package`.

```emacs-lisp
(use-package hl-prog-extra
  :commands (hl-prog-extra-mode)
  :config
  (setq hl-prog-extra-list
		(list
		 ;; Match TKs in quotation marks (hl-prog-extra sees them as strings)
		 '("\\(TK\\)+" 0 string '(:weight bold :inherit font-lock-warning-face))
		 ;; Match TKs not in quotation marks
		 '("\\(TK\\)+" 0 nil '(:weight bold :inherit font-lock-warning-face)))))
```

This simple setup is **lightweight and has tons of potential uses**. Want to highlight every instance of a certain name when writing a script? Want to highlight a specific variable when explaining some code? It's all easy to do with `hl-prog-extra`.
