ZSHIDE_DIR=$(HOME)/.zshide
PREFIX=$(HOME)/.local

install: $(ZSHIDE_DIR) tokens.txt
	cp zi.zsh $(PREFIX)/bin/zi
	cp `ls *.zsh | sed '/zi.zsh/d'` $(ZSHIDE_DIR)

$(ZSHIDE_DIR):
	mkdir $(ZSHIDE_DIR)

tokens.txt:
	cp tokens.txt.in tokens.txt
