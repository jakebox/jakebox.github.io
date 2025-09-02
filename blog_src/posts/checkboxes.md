---
layout: post.njk
title: "Straightforward Emacs: Show all unchecked Org Mode checkboxes"
excerpt: Writing a simple Emacs Lisp function to allow me to view all unchecked Org Mode checkboxes. A daily problem solved simply.
date: 2022-08-17
---

> This is my first Straightforward Emacs blog post. Inspired by my video series, these posts will contain brief, descriptive write-ups of my favorite Emacs functions and features, problems I’ve solved, and short instructional guides. Many posts center on solving real world problems, especially with Org Mode, which I use to organize much of my work and personal life. I hope these posts will help you create and find solutions to your own problems.

Recently I was creating a packing list using Emacs’ Org Mode. I had multiple headings for each item category (clothing, toiletries, etc), with lists under each heading.

{% image "/assets/images/checkboxes_1.png", "Description of photo", "rounded shadow" %}

Org sparse tree features are one way to make this search. But I decided to write a very small function using `occur`, allowing me to quickly generate an interactive list of all the unchecked checkboxes in a given Org file.

> From EmacsWiki: Occur lists all lines of the current buffer that match a regexp that you give it.

Using `occur`, we can get something that looks like this:

{% image "/assets/images/checkboxes_2.png", "Description of photo", "rounded shadow" %}

What’s nice about `Occur` is that it’s interactive — you can easily jump to a line and make modifications.

You can manually achieve this result by running `M-x occur` and typing in the regex, but I wanted to bind this search to a key, so I wrote a very small function:

```emacs-lisp
(defun jakebox/org-occur-unchecked-boxes ()
  ""
  (interactive)
  (occur "\\[ \\]")) ;; Match [ ]
```

Sure, there are more complex and comprehensive ways of doing things, but I like this function as an example of how a problem can be solved quickly and easily with Emacs. Someone with little programming knowledge could work their way around to a solution like this.
