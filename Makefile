.PHONY: all
all: cours misc

# Export cours notes project to html in ~/cours/html_public
cours: config.el
	emacs -Q --batch -l config.el --eval '(org-publish "cours")'

# Export misc notes project to html in ~/misc/html_public
misc: config.el
	emacs -Q --batch -l config.el --eval '(org-publish "misc")'

.PHONY: timetables
# Update ICS, convert them to org calendar files
# Require https://github.com/asoroa/ical2org.py
timetables: 
	wget $(CHRONOS_ICS) -O /tmp/chronos.ics
	wget $(OUTLOOK_ICS) -O /tmp/outlook.ics
	ical2orgpy /tmp/chronos.ics ~/org/roam/timetables/chronos.org
	ical2orgpy /tmp/outlook.ics ~/org/roam/timetables/outlook.org
