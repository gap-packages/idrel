##############################################################################
##
#W  testall.g                  IdRel Package                     Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2021, Chris Wensley and Anne Heyworth 
##

LoadPackage( "idrel" );
dir := DirectoriesPackageLibrary( "idrel", "tst" );
TestDirectory(dir, rec(exitGAP := true,
    testOptions:=rec(compareFunction := "uptowhitespace")));
FORCE_QUIT_GAP(1);
