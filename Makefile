FONT_NAME = 0xProto-custom
FAMILIES = Regular Italic Bold
SOURCE_DIR = sources
ROMAN_GLYPHS_FILE = $(SOURCE_DIR)/$(FONT_NAME).glyphspackage
ITALIC_GLYPHS_FILE = $(SOURCE_DIR)/$(FONT_NAME)-Italic.glyphspackage
OUTPUT_DIR = fonts
SCRIPTS_DIR = scripts

setup:
	uv sync

.PHONY: build
build:
	$(MAKE) clean
	$(MAKE) compile-all
	uv run python $(SCRIPTS_DIR)/add_stat.py $(OUTPUT_DIR)/$(FONT_NAME)-Regular.ttf $(OUTPUT_DIR)/$(FONT_NAME)-Bold.ttf $(OUTPUT_DIR)/$(FONT_NAME)-Italic.ttf

compile-roman: $(ROMAN_GLYPHS_FILE)
	uv run fontmake -a -g $(ROMAN_GLYPHS_FILE) -i --output-dir $(OUTPUT_DIR)

compile-italic: $(ITALIC_GLYPHS_FILE)
	uv run fontmake -a -g $(ITALIC_GLYPHS_FILE) --output-dir $(OUTPUT_DIR)

compile-all:
	$(MAKE) compile-roman
	$(MAKE) compile-italic

.PHONY: clean
clean:
	if [ -e $(OUTPUT_DIR) ]; then rm -rf $(OUTPUT_DIR); fi

install-otf: $(OUTPUT_DIR)
	@for family in $(FAMILIES); do \
		cp $(OUTPUT_DIR)/$(FONT_NAME)-$$family.otf $(HOME)/Library/Fonts; \
	done

.PHONY: install
install:
	$(MAKE) build && $(MAKE) install-otf


.PHONY: test
test:
	uv run fontbakery check-universal $(OUTPUT_DIR)/$(FONT_NAME)-*.ttf
