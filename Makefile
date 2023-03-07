XCODEBUILD := xcodebuild
PROJECT = App/MySports.xcodeproj
BUILD_FLAGS = -project $(PROJECT) -scheme $(SCHEME) -destination $(DESTINATION)
SCHEME ?= $(TARGET)
TARGET ?= MySports
PLATFORM ?= iOS

ifeq ($(PLATFORM), iOS)
	DESTINATION ?= 'platform=iOS Simulator,name=iPhone 14 Pro,OS=16.2'
endif

XCPRETTY :=
ifneq ($(shell type -p xcpretty),)
	XCPRETTY += | xcpretty -c && exit $${PIPESTATUS[0]}
endif

build: 
	$(XCODEBUILD) $(BUILD_FLAGS) $(XCPRETTY)

test:
	$(XCODEBUILD) test $(BUILD_FLAGS) $(XCPRETTY)

clean:
	$(XCODEBUILD) clean $(BUILD_FLAGS) $(XCPRETTY)

bootstrap:
	brew update
	brew unlink swiftlint || true
	brew install swiftlint
	brew link --overwrite swiftlint

lint:
	swiftlint lint --reporter json --strict

.PHONY: test clean dependencies lint cocoapods