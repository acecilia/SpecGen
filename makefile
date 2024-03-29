VERSION = 0.0.1
.DEFAULT_GOAL := install
.PHONY: formatCode generateFixtures generateFixturesData help install listTargets prepareRelease release run test uninstall update updatePhony

# Shell to use, with bash strict mode. See: http://redsymbol.net/articles/unofficial-bash-strict-mode/
SHELL = /bin/bash -eou pipefail
# Do not print commands being executed | Warn on undefined variables
MAKEFLAGS = --silent --warn-undefined-variables

# Constants
export packagePath = $(shell pwd)
fixtureTestsPath = Tests/FixtureTests
export cartfilesPath = $(fixtureTestsPath)/cartfiles
export mainCartfilePath = $(fixtureTestsPath)/Cartfile
export fixturesDataPath = $(fixtureTestsPath)/FixturesData
export fixturesPath = $(fixtureTestsPath)/Fixtures
export testsPath = build/FixtureTests

# Fixtures
export WithCarthage = WithCarthage
export WithoutCarthage = WithoutCarthage
export WithCarthageAndSpecGen = WithCarthageAndSpecGen
export WithCarthageAndSpecGenWithoutStart = WithCarthageAndSpecGenWithoutStart
export fixtureNames = $(WithCarthage) $(WithoutCarthage) $(WithCarthageAndSpecGen) $(WithCarthageAndSpecGenWithoutStart)

# Generates the fixture data necessary for runnning specgen
generateFixturesData:
	. scripts/generateFixturesData.sh

# Runs specgen on the fixture data, generating the fixtures
generateFixtures:
	. scripts/generateFixtures.sh $(fixturesPath)

# Runs specgen on the fixture data and compares the output with the existing fixtures
test:
	. scripts/generateFixtures.sh $(testsPath)
	. scripts/test.sh

# Update dependencies and reload the xcode project
update:
	rm -Rf *.xcodeproj
	swift package update
	swift package generate-xcodeproj
	open *.xcodeproj

# Run in a specific directory
run:
	# Put in here the path to the folder where you want to run specgen
	(cd 'Tests/Fixtures/Tests/WithCarthage' && swift run --package-path $(packagePath) specgen bootstrap)

install:
	swift build -c release
	cp -f .build/release/specgen /usr/local/bin/specgen

uninstall:
	rm /usr/local/bin/specgen

formatCode:
	swiftformat .

prepareRelease: updatePhony formatCode
	sed -i '' 's|\(let version = Version("\)\(.*\)\(")\)|\1$(VERSION)\3|' Sources/specgen/main.swift

release:
	git tag $(VERSION)
	git push origin --tags

listTargets:
	set +o pipefail && $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]'

# Add all targets to .PHONY
updatePhony:
	sed -i '' "s/^\.PHONY:.*/.PHONY: $$($(MAKE) listTargets | xargs)/g" makefile

# Prints the list of possible targets. See: https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
help:
	echo "Available targets:"
	$(MAKE) listTargets
