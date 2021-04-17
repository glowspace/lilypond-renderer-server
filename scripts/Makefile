#   make NAME=<jiné_jméno> <cíle>
NAME=score
# only for png recipe
DPI=300

SHELL=/bin/bash

# false targets
.PHONY: svg eps pdf svgcrop pdfcrop pngcrop svgcropcurves clean
svg: ${NAME}.svg
eps: ${NAME}.eps
pdf: ${NAME}.pdf
svgcrop: ${NAME}_cropped.svg
pdfcrop: ${NAME}_cropped.pdf
pngcrop: ${NAME}_cropped.png
svgcropcurves: ${NAME}_cropped_curves.svg

clean:
# Znak „@“ před příkazem zajistí, že make nebude vypisovat text 
# spouštěného příkazu, což je např. zde nežádoucí, neboť ve výpisu 
# překladu chceme vidět jen naši formátovanou zprávu.
	@echo -e "\n\n### Uklid ###\n\n"
# Znak „-“ před příkazem zajistí, že případné selhání příkazu (např. 
# zde „rm ...“ selže, pokud některý ze zadaných souborů již neexistuje) 
# nezpůsobí zastavení provádění zbytku Makefile (např. zde nám nevadí, 
# že se nepodařilo smazat soubory, které stejně neexistují).
	-rm ${NAME}.{eps,svg,pdf}
	-rm ${NAME}_cropped.svg

${NAME}.svg: ${NAME}.ly
	@echo -e "\n\n### SVG ###\n\n"
	lilypond -dbackend=svg -dno-point-and-click -djob-count=4 --format=svg ${NAME}.ly > log.txt 2>&1 || (rm score.svg; exit 1)

${NAME}.eps: ${NAME}.ly
	@echo -e "\n\n### EPS ###\n\n"
	lilypond -dbackend=eps -dno-point-and-click --format=eps ${NAME}.ly > log.txt 2>&1 || (rm score.eps; exit 1)

${NAME}.pdf: ${NAME}.ly
	@echo -e "\n\n### PDF ###\n\n"
	lilypond -dbackend=eps -dno-point-and-click --pdf ${NAME}.ly > log.txt 2>&1 || (rm score.pdf; exit 1)

${NAME}_cropped.pdf: ${NAME}.eps
	@echo -e "\n\n### PDF cropped ###\n\n"
	ps2pdf -dEPSCrop ${NAME}.eps ${NAME}_cropped.pdf

${NAME}_cropped.png: ${NAME}.eps
	@echo -e "\n\n### PNG cropped ###\n\n"
	gs -dSAFER -dEPSCrop -r${DPI} -sDEVICE=pngalpha -o ${NAME}_cropped.png ${NAME}.eps

${NAME}_cropped_curves.svg: ${NAME}_cropped.pdf
	@echo -e "\n\n### SVG cropped - curves ###\n\n"
	pdf2svg ${NAME}_cropped.pdf ${NAME}_cropped_curves.svg

${NAME}_cropped.svg: ${NAME}.svg
	@echo -e "\n\n### SVG cropped ###\n\n"

# 1. compute new svg box from EPS file
# 2. replace it within the svg file (and remove width and height attributes)
# 3. remove redundant tspan nodes causing font rendering trouble on Flutter
# 4. optimize the svg with the svgo tool
	sed -i 's/<tspan>//g; s/<\/tspan>//g' ${NAME}.svg && \
	inkscape -z --export-area-drawing --export-plain-svg=${NAME}_cropped_tmp.svg ${NAME}.svg && \
	svgo -i ${NAME}_cropped_tmp.svg -o ${NAME}_cropped.svg

# && rm ${NAME}_cropped_tmp.svg

# svgbox="$(shell cat -v ${NAME}.eps | grep %%BoundingBox | /bin/scripts/svg_bbox.py)" && 
# xmlstarlet ed -N svg='http://www.w3.org/2000/svg' -d '//svg:svg/@width' -d '//svg:svg/@height' -u '//svg:svg/@viewBox' -v "$$svgbox" ${NAME}.svg | 