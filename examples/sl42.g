##############################################################################
##
#W  sl42.g                         Idrel Package                 Chris Wensley
#W                                                             & Anne Heyworth
##  version 2.11, 21/09/2011
##
#Y  Copyright (C) 1999--2011 Anne Heyworth and Chris Wensley
##

idrel_save_level := InfoLevel( InfoIdRel );
SetInfoLevel( InfoIdRel, 1 );
Info( InfoIdRel, 1, "setting level of InfoIdRel to 1" );

F := FreeGroup( 2 );
Print( F, "\n" );
a := F.1;; b := F.2;;
rels := [ a^3, b^2, (a*b)^2 ];
Print( rels, "\n" );
s3 := F/rels;;
SetName( s3, "s3" );
ids := IdentitiesAmongRelators( s3 );
Print( "\n", Length(ids[1]), " identities found\n" );
SetInfoLevel( InfoIdRel, idrel_save_level );

Print( "\n============== end of output from: sl42.g =================\n\n" );
