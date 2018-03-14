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
gap> lrws := LoggedRewritingSystemFpGroup( s3 );; 
gap> idrelsKB3 := IdentitiesAmongRelatorsKB( s3 );;
gap> Display( idrelsKB3 );
[ [ ( s3_Z1*( s3_M1), s3_R1*( s3_M1 - <identity ...>) ), 
      ( s3_Z3*( <identity ...>), s3_R2*( s3_M2 - <identity ...>) ), 
      ( s3_Z4*( s3_M1), s3_R3*( s3_M2 - s3_M1) ), 
      ( s3_Z17*( -s3_M3), s3_R1*( -s3_M2*s3_M1 - s3_M3) + s3_R2*( -s3_M3 - s3_\
\
M2 - s3_M1) + s3_R3*( s3_M3 + s3_M2 + <identity ...>) ) ], 
  [ ( s3_Z1*( s3_M1), s3_R1*( s3_M1 - <identity ...>) ), 
      ( s3_Z3*( <identity ...>), s3_R2*( s3_M2 - <identity ...>) ), 
      ( s3_Z4*( s3_M1), s3_R3*( s3_M2 - s3_M1) ), 
      ( s3_Z1*( -s3_M1*s3_M2*s3_M1 - s3_M1*s3_M3) + s3_Z3*( <identity ...>) + \
\
s3_Z4*( -s3_M1) + s3_Z17*( -s3_M3), s3_R1*( -s3_M2 - <identity ...>) + s3_R2*(\
\
 -s3_M3 - s3_M1 - <identity ...>) + s3_R3*( s3_M3 + s3_M1 + <identity ...>) ) 
     ] ]

gap> SetInfoLevel( InfoIdRel, idrel_save_level );;

#############################################################################
##
#E  idrelskb.tst . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
