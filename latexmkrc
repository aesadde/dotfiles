$pdf_previewer = 'open -ga /Applications/Skim.app';
# $pdflatex = 'pdflatex -synctex=1 %O %S';
$pdflatex = 'pdflatex -synctex=1 %O %S -shell-escape -enable-write18';
$pdf_mode = 1;

# cleans extra files after done processing
$cleanup_mode = 1;
# other extensions to clean
$clean_ext = '*.aux,*.log,*.fls,*.dvi';
