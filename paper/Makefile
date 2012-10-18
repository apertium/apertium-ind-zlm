all:
	pdflatex id-ms.coling2012.tex
	bibtex id-ms.coling2012.aux
	pdflatex id-ms.coling2012.tex
	pdflatex id-ms.coling2012.tex
architecture.pdf: architecture.obj
	tgif -print -eps architecture.obj
	epstopdf architecture.eps
