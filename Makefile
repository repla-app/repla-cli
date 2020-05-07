SYMLINK_PATH = /usr/local/bin/repla
ORIGINAL_PATH = /Applications/Repla.app/Contents/Resources/Scripts/repla
LOCAL_PATH = Scripts/repla

.PHONY: ci ac autocorrect lint install_override uninstall_override runtime sign

ci: lint
ac: autocorrect

lint:
	rubocop

sign:
	# `ruby` fails notarization without the hardened runtime enabled, and
	# native extensions cannot be loaded without the entitlements.
	# To update the binary, run this and then commit directly to the repo.
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

