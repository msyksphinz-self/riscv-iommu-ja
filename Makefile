REVMARK ?= 'This document is Ratified. See http://riscv.org/spec-state for details.'
DATE    ?= $(shell date +%Y-%m-%d)
VERSION ?= v1.0

XTRA_ADOC_OPTS :=
ASCIIDOCTOR_PDF := asciidoctor-pdf
ASCIIDOCTOR_HTML := asciidoctor
OPTIONS := --trace \
           -a compress \
           -a mathematical-format=svg \
           -a revnumber=${VERSION} \
           -a revremark=${REVMARK} \
           -a revdate=${DATE} \
           -a pdf-fontsdir=docs-resources/fonts \
           -a pdf-theme=docs-resources/themes/riscv-pdf.yml \
           $(XTRA_ADOC_OPTS) \
           --failure-level=ERROR

REQUIRES := --require=asciidoctor-diagram \
            --require=asciidoctor-lists

SRC = source/iommu_ja.adoc

# --require=asciidoctor-bibtex
# --require=asciidoctor-mathematical

all:
	asciidoctor -b docbook $(SRC)
	pandoc -f docbook -t markdown_strict source/iommu_ja.xml -o iommu_ja.md
	bundle exec $(ASCIIDOCTOR_HTML) $(SRC) -r asciidoctor-diagram -D html
	bundle exec $(ASCIIDOCTOR_PDF)  -a scripts=cjk -a pdf-theme=default-with-fallback-font $(SRC) $(REQUIRES) $(OPTIONS) -o pdf/iommu_ja.pdf

#	bundle install --path vendor/bundle
#	asciidoctor-pdf source/iommu_ja.adoc -o pdf/iommu_ja.pdf
