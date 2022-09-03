SWIFT = $(shell which swift)
DEV_TOOLS_BUILD_FLAGS = --configuration release --package-path ./DevTools

.PHONY: dev
dev:
	$(SWIFT) build $(DEV_TOOLS_BUILD_FLAGS) --product xcbeautify

.PHONY: test
test:
	$(SWIFT) test 2>&1 | xcbeautify
