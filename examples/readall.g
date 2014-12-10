##############################################################################
##
#W  readall.g                   GAP4 package `IdRel'             Chris Wensley
#W                                                             & Anne Heyworth
##  version 2.11, 21/09/2011 
##
#Y  Copyright (C) 2011, Emma Moore and Chris Wensley,  
#Y  School of Computer Science, Bangor University, U.K. 
##  

LoadPackage( "idrel", false ); 
idrel_examples_dir := DirectoriesPackageLibrary( "idrel", "examples" ); 

Read( Filename( idrel_examples_dir, "idrel_manual.g" ) ); 
Read( Filename( idrel_examples_dir, "sl42.g" ) ); 
