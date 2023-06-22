# Makefile
#
# Run "make" (or "make all") to convert to all other formats
#
# Run "make clean" to delete converted files

MD_FILES = $(wildcard *.md)
PDF_FILES = $(patsubst %.md,%.pdf,$(MD_FILES))
HTML_FILES = $(patsubst %.md,%.html,$(MD_FILES))
OUTPUT_FILES = $(HTML_FILES) $(PDF_FILES)


#  Options

RM=rm

PANDOC=pandoc

PANDOC_OPTIONS=--number-sections --filter pandoc-crossref

PANDOC_HTML_OPTIONS=--standalone  --mathjax

PANDOC_PDF_OPTIONS=--default-image-extension=pdf --pdf-engine xelatex

PANDOC_EPUB_OPTIONS=--to epub3

PANDOC_BOOK_OPTIONS=--top-level-division=chapter --toc --toc-depth=2


#  Pattern matching rules

%.html: $(MD_FILES) Makefile
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) -o $@ $<

%.pdf: $(MD_FILES) Makefile
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) -o $@ $<


#  Targets and dependencies

all: html pdf
html : $(HTML_FILES)
pdf : $(PDF_FILES)


# Whole book

bookhtml : $(SOURCE_DOCS)
	rm -rf Book
	$(PANDOC) -t chunkedhtml $(PANDOC_OPTIONS) ${PANDOC_BOOK_OPTIONS} ${PANDOC_HTML_OPTIONS} -o Book $(MD_FILES)

bookpdf : ${SOURCE_DOCS}
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_BOOK_OPTIONS) $(PANDOC_PDF_OPTIONS) -o pdf/Book.pdf $(MD_FILES)

books: bookhtml bookpdf

clean:
	$(RM) $(OUTPUT_FILES)

usage:
	@echo "MD: $(MD_FILES)"
	@echo "HTML: $(HTML_FILES)"

.PHONY: all html pdf books
