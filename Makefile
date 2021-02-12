.PHONY: all
all: cours misc

# Output in ~/cours/html_public
cours: config.el
	emacs -Q --batch -l config.el --eval '(org-publish "cours")'

# Output in ~/misc/html_public
misc: config.el
	emacs -Q --batch -l config.el --eval '(org-publish "misc")'
