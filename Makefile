ZSHIDE_DIR=$(HOME)/.zshide
PREFIX=$(HOME)/.local
SUBDIRS = t

install: $(ZSHIDE_DIR)
	cp zi.zsh $(PREFIX)/bin/zi
	cp `ls *.zsh | sed '/zi.zsh/d'` $(ZSHIDE_DIR)
	for d in $(SUBDIRS); do \
	    cp -R $$d $(ZSHIDE_DIR); \
	done

$(ZSHIDE_DIR):
	mkdir $(ZSHIDE_DIR)
