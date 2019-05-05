# This makefile is used as a helper to easily execute several recurring actions

update:
	swift package update
	swift package generate-xcodeproj
	open *.xcodeproj

generate:
	swift package generate-xcodeproj
	open *.xcodeproj

run:
	swift build
	.build/debug/CocoaPodsEndgame snap

# Prints the list of possible targets. See: https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
help:
	@echo "Available targets:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
