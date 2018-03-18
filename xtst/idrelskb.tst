##############################################################################
##
#W  idrelskb.tst                  Idrel Package                  Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2018 Anne Heyworth and Chris Wensley
##

gap> idrel_save_level := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

gap> F := FreeGroup( 2 );;
gap> a := F.1;;
gap> b := F.2;;
gap> rels3 := [ a^3, b^2, a*b*a*b ]; 
[ f1^3, f2^2, (f1*f2)^2 ]
gap> s3 := F/rels3; 
<fp group on the generators [ f1, f2 ]>
gap> SetName( s3, "s3" );; 
gap> mon3 := MonoidPresentationFpGroup( s3 );; 
gap> elmon3 := ElementsOfMonoidPresentation( s3 );; 
gap> lrws3 := LoggedRewritingSystemFpGroup( s3 );; 
gap> idrelsKB3 := IdentitiesAmongRelatorsKB( s3 );;
gap> Display( idrelsKB3 );
[ [ [ s3_R1^-1, f1^-1 ], [ s3_R1, <identity ...> ] ], 
  [ [ s3_R2^-1, <identity ...> ], [ s3_R3^-1, f1*f2^-2 ], [ s3_R2, f2^-1 ], 
      [ s3_R3, f1 ] ], 
  [ [ s3_R2^-1, <identity ...> ], [ s3_R3, f1*f2^-1 ], 
      [ s3_R2, <identity ...> ], [ s3_R3^-1, <identity ...> ] ], 
  [ [ s3_R2, <identity ...> ], [ s3_R3^-1, <identity ...> ], 
      [ s3_R1, f2^-1*f1^-1 ], [ s3_R3^-1, f1*f2^-1*f1^-1 ], [ s3_R2, f1^-1 ], 
      [ s3_R1, <identity ...> ], [ s3_R3^-1, f1 ], [ s3_R2, f1^-1*f2^-1 ] ] ]

gap> rels8 := [ a^4, b^4, a*b*a*b^-1, a^2*b^2 ];;
gap> q8 := F/rels8;;
gap> SetName( q8, "q8" ); 
gap> mon8 := MonoidPresentationFpGroup( q8 );; 
gap> elmon8 := ElementsOfMonoidPresentation( q8 );; 
gap> lrws8 := LoggedRewritingSystemFpGroup( q8 );; 
gap> idrelsKB8 := IdentitiesAmongRelatorsKB( q8 );;
gap> Display( idrelsKB8 );
[ [ [ q8_R1^-1, <identity ...> ], [ q8_R1, f1^-1 ] ], 
  [ [ q8_R3^-1, f1^-1 ], [ q8_R3^-1, f1^-2 ], [ q8_R1, <identity ...> ], 
      [ q8_R3^-1, f1 ], [ q8_R1, f2^-1 ], [ q8_R3^-1, <identity ...> ] ], 
  [ [ q8_R3, f1*f2 ], [ q8_R4^-1, <identity ...> ], [ q8_R3^-1, f1^-2 ], 
      [ q8_R4, f1^-1 ] ], 
  [ [ q8_R2^-1, f1^-3 ], [ q8_R4, f1^-1 ], [ q8_R3, <identity ...> ], 
      [ q8_R3^-1, f1*f2^-1 ], [ q8_R4^-1, <identity ...> ], [ q8_R2, f1^-2 ] ]
    , [ [ q8_R4^-1, f2 ], [ q8_R2, f1^-2*f2 ], [ q8_R4^-1, <identity ...> ], 
      [ q8_R3, f1^-1 ], [ q8_R3, <identity ...> ] ], 
  [ [ q8_R4^-1, <identity ...> ], [ q8_R3^-1, f1^-2 ], 
      [ q8_R1, <identity ...> ], [ q8_R3^-1, f1 ], [ q8_R4, f2^-1 ] ], 
  [ [ q8_R4^-1, <identity ...> ], [ q8_R4^-1, f1^-2 ], [ q8_R2, f1^-4 ], 
      [ q8_R1, <identity ...> ] ], 
  [ [ q8_R4, f1^-1 ], [ q8_R3, f1*f2 ], [ q8_R1^-1, f2 ], 
      [ q8_R2^-1, f1^-2*f2 ], [ q8_R4, f2 ], [ q8_R3, f1 ], [ q8_R3^-1, f2 ], 
      [ q8_R4^-1, <identity ...> ], [ q8_R3, f1^-1 ], [ q8_R4^-1, f1^-1 ], 
      [ q8_R2, f1^-3 ] ] ]

gap> SetInfoLevel( InfoIdRel, idrel_save_level );;

#############################################################################
##
#E  idrelskb.tst . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
