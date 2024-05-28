NAME=score
# only for png recipe
DPI=300

SHELL=/bin/bash

# false targets
.PHONY: svg eps pdf svgopt pdfcrop pngcrop svgcropcurves clean
svg: ${NAME}.svg
eps: ${NAME}.eps
pdf: ${NAME}.pdf
svgopt: ${NAME}_optimized.svg
pdfcrop: ${NAME}_cropped.pdf
pngcrop: ${NAME}_cropped.png
svgcropcurves: ${NAME}_cropped_curves.svg
svgxml: ${NAME}_mxml.svg

clean:
	@echo -e "\n\n### Cleaning ###\n\n"
	-rm ${NAME}.{eps,svg,pdf}
	-rm ${NAME}_optimized.svg

${NAME}.svg: ${NAME}.ly
	@echo -e "\n\n### SVG ###\n\n"
	lilypond -dbackend=svg -dno-point-and-click -djob-count=4 --format=svg ${NAME}.ly > log.txt 2>&1 || (rm score.svg; exit 1)

${NAME}.eps: ${NAME}.ly
	@echo -e "\n\n### EPS ###\n\n"
	lilypond -dbackend=eps -dno-point-and-click --format=eps ${NAME}.ly > log.txt 2>&1 || (rm score.eps; exit 1)

${NAME}.pdf: ${NAME}.ly
	@echo -e "\n\n### PDF ###\n\n"
	lilypond -dno-point-and-click --pdf ${NAME}.ly > log.txt 2>&1 || (rm score.pdf; exit 1)

${NAME}_cropped.pdf: ${NAME}.eps
	@echo -e "\n\n### PDF cropped ###\n\n"
	ps2pdf -dEPSCrop ${NAME}.eps ${NAME}_cropped.pdf

${NAME}_cropped.png: ${NAME}.eps
	@echo -e "\n\n### PNG cropped ###\n\n"
	gs -dSAFER -dEPSCrop -r${DPI} -sDEVICE=pngalpha -o ${NAME}_cropped.png ${NAME}.eps

${NAME}_cropped_curves.svg: ${NAME}_cropped.pdf
	@echo -e "\n\n### SVG cropped - curves ###\n\n"
	pdf2svg ${NAME}_cropped.pdf ${NAME}_cropped_curves.svg

${NAME}_optimized.svg: ${NAME}.svg
	@echo -e "\n\n### SVG cropped ###\n\n"

# 1. remove redundant tspan nodes causing font rendering trouble
# 2. optimize the svg with the svgo tool
	sed -i 's/<tspan>//g; s/<\/tspan>//g' ${NAME}.svg && \
	svgo -i ${NAME}.svg -o ${NAME}_optimized.svg

# 1. render with verovio
# 2. set bar numbers to invisible
${NAME}_mxml.svg: ${NAME}.xml
	@echo -e "\n\n### SVG/Verovio ###\n\n"
# fix minor chords
	sed -i 's|text="">minor</kind>|text="m">minor</kind>|g' ${NAME}.xml
	verovio ${NAME}.xml -o ${NAME}_mxml.svg --adjust-page-height --page-width 1250 --spacing-staff 5 --min-last-justification 0.2 --all-pages --header "none" && \
	python3 /bin/scripts/svg_concat.py -i *.svg -o ${NAME}_mxml.svg
	sed -i 's|, g.mNum{font-style:italic;}|{font-style:italic;} g.mNum{visibility:hidden;}|g' ${NAME}_mxml.svg
