##############################################################################
##
#W  readall.g                   GAP4 package `IdRel'             Chris Wensley
#W                                                             & Anne Heyworth

LoadPackage( "idrel", false ); 
idrel_examples_dir := DirectoriesPackageLibrary( "idrel", "examples" ); 

Read( Filename( idrel_examples_dir, "idrel_manual.g" ) ); 
Read( Filename( idrel_examples_dir, "sl42.g" ) ); 
