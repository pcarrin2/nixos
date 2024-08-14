;;; init.el -*- lexical-binding: t; -*-

( doom!

  :completion
  company

  :ui
  doom
  doom-dashboard
  hl-todo
  (popup +defaults)

  :editor
  (evil +everywhere)
  fold
  (format +onsave)
  snippets
  word-wrap

  :emacs
  undo

  :checkers
  syntax
  
  :tools
  (eval +overlay)
  (lsp +peek)
  tree-sitter

  :lang
  data
  emacs-lisp
  common-lisp
  json
  nix
  (python +lsp +pyright)
  (rust +lsp)
  (sh +lsp +bash)
  web
  yaml

  :config
  (default +bindings +smartparens)
)
