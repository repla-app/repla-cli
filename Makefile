SHELL := /bin/bash
SYMLINK_PATH = /usr/local/bin/repla
ORIGINAL_PATH = /Applications/Repla.app/Contents/Resources/Scripts/repla
LOCAL_PATH = Scripts/repla

.PHONY: ci ac autocorrect lint install_override uninstall_override runtime sign loc

ci: irc_started lint irc_finished
ac: autocorrect

lint:
	rubocop

loc:
	cloc --vcs=git

sign:
	# `ruby` fails notarization without the hardened runtime enabled, and
	# native extensions cannot be loaded without the entitlements.
	# Theoretically this can be run to update the binary in place, but it's
	# easier just to copy and paste this command and run it on a separate
	# checkout of the `ruby` binary.
	codesign --force --options runtime --sign "Developer ID Application" \
		--entitlements ruby.entitlements bin/ruby

autocorrect:
	rubocop -a

install_override:
	rm -f "$(SYMLINK_PATH)"
	ln -s "${PWD}/$(LOCAL_PATH)" "$(SYMLINK_PATH)"

uninstall_override:
	rm -f "$(SYMLINK_PATH)"
	ln -s "$(ORIGINAL_PATH)" "$(SYMLINK_PATH)"

define irc_message
	remote=$$(git config --get remote.origin.url | tr -d '\n'); \
	if [[ $${remote}  =~ (https://|git@)github.com[/:](.*) ]]; then \
	  remote_subpath="$${BASH_REMATCH[2]}"; \
	  remote_subpath=$${remote_subpath%.git}; \
	  remote_url="https://github.com/$${remote_subpath}/pulls"; \
	else \
	  echo ""; \
	  exit 0; \
	fi; \
	( \
	echo "NICK repla-bot"; \
	echo "USER repla-bot 0.0.0.0 repla :Repla Bot"; \
	sleep 15; \
	echo "JOIN #repla-development"; \
	echo "PRIVMSG #repla-development :REPLABOT $1 $${remote_url}"; \
	echo "QUIT"; \
	) | nc irc.freenode.net 6667
endef

irc_started:
	@$(call irc_message,CISTARTED)

irc_finished:
	@$(call irc_message,CIFINISHED)
