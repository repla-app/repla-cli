SHELL := /bin/bash
SYMLINK_PATH = /usr/local/bin/repla
ORIGINAL_PATH = /Applications/Repla.app/Contents/Resources/Scripts/repla
LOCAL_PATH = Scripts/repla

.PHONY: ci ac autocorrect lint install_override uninstall_override runtime sign loc gem_install

ci: gem_install lint
ac: autocorrect

lint:
	bundle exec rubocop

autocorrect:
	bundle exec rubocop -a

gem_install:
	bundle install --path vendor/bundle

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

install_override:
	rm -f "$(SYMLINK_PATH)"
	ln -s "${PWD}/$(LOCAL_PATH)" "$(SYMLINK_PATH)"

uninstall_override:
	rm -f "$(SYMLINK_PATH)"
	ln -s "$(ORIGINAL_PATH)" "$(SYMLINK_PATH)"
