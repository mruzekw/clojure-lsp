all: debug-bin

# NOTE!
#
# Older versions of the clojure launcher script may not work with this Makefile
#
# If you see errors (e.g. file not found errors) please download and install 
# the latest version of the clojure launcher script for your platform from
#
# https://clojure.org/guides/getting_started#_clojure_installer_and_cli_tools

clean:
	rm -rf classes clojure-lsp clojure-lsp.jar docs/README.md

classes:
	clojure -X:javac

debug-bin: clean classes
	clojure -X:debug-jar
	clojure -X:bin

prod-bin: clean classes
	clojure -X:prod-jar
	clojure -X:bin

prod-native:
	./graalvm/native-unix-compile.sh

test: classes
	clojure -M:test

release:
	./release

integration-test:
	bb integration-test/run-all.clj ./clojure-lsp

local-webpage:
	cp -rf CHANGELOG.md README.md images docs
	docker login docker.pkg.github.com
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs docker.pkg.github.com/clojure-lsp/docs-image/docs-image

.PHONY: all debug-bin prod-bin prod-native test integration-test local-webpage clean release
