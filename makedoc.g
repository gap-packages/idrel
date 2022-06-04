##  makedoc.g for the package IdRel,
##  This builds the documentation of the IdRel package. 
##  Needs: GAPDoc & AutoDoc packages, latex, pdflatex, mkindex
##  call this with GAP from within the package root directory 

LoadPackage("idrel");
LoadPackage("AutoDoc"); 

AutoDoc(rec( 
    gapdoc := rec( 
        LaTeXOptions := rec( 
            EarlyExtraPreamble := """
                \usepackage[pdftex]{graphicx} 
                """ 
        ), 
    ),
    scaffold := rec(
        includes := [ "intro.xml",    "rws.xml",      "logrws.xml", 
                      "monpoly.xml",  "modpoly.xml",  "idrels.xml" ],
        bib := "bib.xml", 
        entities := rec( 
            idrel := "<Package>IdRel</Package>", 
            AutoDoc := "<Package>AutoDoc</Package>" 
        )
    )
));

# Create VERSION file for "make towww"
PrintTo( "VERSION", GAPInfo.PackageInfoCurrent.Version );
