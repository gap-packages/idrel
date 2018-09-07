##############################################################################
##
#W  testing.g                  IdRel Package                     Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2018, Chris Wensley and Anne Heyworth 
##

LoadPackage( "idrel" );

pkgname := "idrel";
pkgdir := DirectoriesPackageLibrary( pkgname, "tst" );
testfiles := 
    [ "1-rws.tst", "2-logrws.tst", "3-monpoly.tst", 
      "4-modpoly.tst", "5-idrels.tst" ];
testresult := true;
for ff in testfiles do
    fn := Filename( pkgdir, ff );
    Print( "#I  Testing ", fn, "\n" );
    if not Test( fn, rec(compareFunction := "uptowhitespace", 
                            showProgress := true ) ) then
        testresult := false;
    fi;
od;
if testresult then
    Print("#I  No errors detected while testing package ", pkgname, "\n");
else
    Print("#I  Errors detected while testing package ", pkgname, "\n");
fi;
