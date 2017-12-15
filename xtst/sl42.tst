##############################################################################
##
#W  sl42.tst                       Idrel Package                 Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999--2017 Anne Heyworth and Chris Wensley
##

gap> idrel_save_level := InfoLevel( InfoIdRel );;
gap> SetInfoLevel( InfoIdRel, 0 );;

gap> F := FreeGroup( 2 );;
gap> a := F.1;; b := F.2;;
gap> rels := [ a^3, b^2, (a*b)^2 ];
[ f1^3, f2^2, (f1*f2)^2 ]
gap> s3 := F/rels;;
gap> SetName( s3, "s3" );
gap> ids := IdentitiesAmongRelators( s3 );
[ [ ( s3_Y1*( s3_M1), s3_R1*( s3_M1 - <identity ...>) ), 
      ( s3_Y3*( s3_M2), s3_R2*( s3_M2 - <identity ...>) ), 
      ( s3_Y5*( s3_M2*s3_M1), s3_R3*( s3_M2 - s3_M1) ), 
      ( s3_Y11*( -s3_M1), s3_R1*( -s3_M2*s3_M1 - s3_M1) + s3_R2*( -s3_M1*s3_M2\
\
 - s3_M1 - <identity ...>) + s3_R3*( s3_M3 + s3_M2 + <identity ...>) ) ], 
  [ ( s3_Y1*( s3_M1), s3_R1*( s3_M1 - <identity ...>) ), 
      ( s3_Y3*( s3_M2), s3_R2*( s3_M2 - <identity ...>) ), 
      ( s3_Y5*( s3_M2*s3_M1), s3_R3*( s3_M2 - s3_M1) ), 
      ( s3_Y1*( -s3_M1*s3_M2*s3_M1 + s3_M1) + s3_Y3*( s3_M2*s3_M3) + s3_Y5*( -\
\
s3_M2*s3_M1) + s3_Y11*( -s3_M1), s3_R1*( -s3_M2 - <identity ...>) + s3_R2*( -s\
\
3_M3 - s3_M1 - <identity ...>) + s3_R3*( s3_M3 + s3_M1 + <identity ...>) ) ] ]

gap> SetInfoLevel( InfoIdRel, idrel_save_level );;

#############################################################################
##
#E  sl42.tst . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
