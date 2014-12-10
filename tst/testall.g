##############################################################################
##
#W  testall.g                  IdRel Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 2.12, 23/04/2012
##
#Y  Copyright (C) 1999-2012, Chris Wensley and Anne Heyworth 
##

LoadPackage( "idrel" );
idrel_tst_dir := DirectoriesPackageLibrary( "idrel", "tst" ); 
tnam := Filename( idrel_tst_dir, "idrel_manual.tst" );
ss := InputTextString( StringFile( tnam ) );; 
Test( ss ); 
