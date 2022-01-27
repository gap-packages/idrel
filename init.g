#############################################################################
##
#W  init.g                 GAP package `idrel'                  Chris Wensley
##                                                            & Anne Heyworth

##  read the function declarations

ReadPackage( "idrel", "lib/logrws.gd" ); 
ReadPackage( "idrel", "lib/monpoly.gd" ); 
ReadPackage( "idrel", "lib/modpoly.gd" );
ReadPackage( "idrel", "lib/idrels.gd" );

##  two integers  used by PrintLnUsingLabels 

IdRelOutputPos := 0; 
IdRelOutputDepth := 0; 
