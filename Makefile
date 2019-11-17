ZSHIDE_DIR=$(HOME)/.zshide
PREFIX=$(HOME)/.local

install: $(ZSHIDE_DIR) tokens.txt
	cp zi.zsh $(PREFIX)/bin/zi
	cp lang-*.zsh $(ZSHIDE_DIR)
	cp proj-*.zsh $(ZSHIDE_DIR)
	cp github-*.zsh $(ZSHIDE_DIR)
	cp tokens.txt $(ZSHIDE_DIR)
	
$(ZSHIDE_DIR):
	mkdir $(ZSHIDE_DIR)

tokens.txt:
	cp tokens.txt.in tokens.txt
