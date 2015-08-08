.PHONY: all build clean configure haddock hpc install repl run
shell = '$$SHELL'
all: install configure build haddock hpc

build:
	cabal build --jobs

clean: nix-clean
	cabal clean
	rm -f *.tix
	if test -d .cabal-sandbox; then cabal sandbox delete; fi
	if test -d .hpc; then rm -r .hpc; fi

configure:
	cabal configure --enable-tests

haddock:
	cabal haddock --hyperlink-source
# dist/doc/html/./index.html

install:
	cabal sandbox init
	cabal install --jobs --only-dependencies --reorder-goals

nix-clean:
	if test -e default.nix; then rm default.nix; fi
	if test -e shell.nix; then rm shell.nix; fi

nix-init: clean
	[ `cabal2nix --version` = "2.0" ] && cabal2nix --shell . > shell.nix;
	[ `cabal2nix --version` = "2.0" ] && cabal2nix . > default.nix;

nix-shell: nix-init
	nix-shell --command 'make install && $(shell)'
	make clean

repl:
	cabal repl lib:.

run:
	cabal run --jobs .

tags:
	hasktags -e .
