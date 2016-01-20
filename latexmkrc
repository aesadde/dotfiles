$pdf_previewer = 'open -ga /Applications/Skim.app' ;
$pdflatex = 'pdflatex -synctex=1 %O %S';
$pdf_mode = 1;

# cleans extra files after done processing
$cleanup_mode = 1;
# other extensions to clean
$clean_ext = '*.aux,*.log,*.fls,*.dvi';
