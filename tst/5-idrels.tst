##############################################################################
##
#W  5-idrels.tst                   Idrel Package                 Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2018 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

## Example 6.1.1
gap> gseq8 := IdentityRelatorSequences( q8 );;
gap> Length( gseq8 );
19
gap> gseq8[1];
[ 1, 9, [ [ q8_R1^-1, <identity ...> ], [ q8_R1, f1^-1 ] ] ]
gap> idsq8 := IdentitiesAmongRelators( q8 );;
gap> Length( idsq8 );
7
gap> Display( idsq8 );
[ [ [ q8_R1^-1, <identity ...> ], [ q8_R1, f1^-1 ] ], 
  [ [ q8_R2^-1, <identity ...> ], [ q8_R4^-1, f2^-1 ], [ q8_R2, f1^-2*f2^-1 ],
      [ q8_R4, f2^-1 ] ], 
  [ [ q8_R1^-1, <identity ...> ], [ q8_R4^-1, f2^-1 ], [ q8_R3, f1^-1*f2^-1 ],
      [ q8_R3, f2^-1 ], [ q8_R3, f1*f2^-1 ], [ q8_R1^-1, f2^-1 ], 
      [ q8_R3, f1^-2*f2^-1 ], [ q8_R4, f2^-1 ] ], 
  [ [ q8_R3^-1, <identity ...> ], [ q8_R4^-1, f2^-1 ], [ q8_R3, f1^-1*f2^-1 ],
      [ q8_R4, f1*f2^-1 ] ], 
  [ [ q8_R4^-1, <identity ...> ], [ q8_R4^-1, f2^-1 ], [ q8_R3, f1^-1*f2^-1 ],
      [ q8_R3, f2^-1 ], [ q8_R4^-1, f2^-1 ], [ q8_R2, f1^-2*f2^-1 ], 
      [ q8_R4, f2^-1 ] ], 
  [ [ q8_R4^-1, <identity ...> ], [ q8_R3, f1*f2 ], [ q8_R1^-1, f2 ], 
      [ q8_R3, f1^-2*f2 ], [ q8_R4, f2 ] ], 
  [ [ q8_R4^-1, <identity ...> ], [ q8_R4^-1, f1^-2 ], [ q8_R2, f1^-4 ], 
      [ q8_R1, f1^-1 ] ] ]
gap> idyseq8 := IdentityYSequences( q8 );
[ ( q8_Y1*( -q8_M1), q8_R1*( q8_M1 - <identity ...>) ), 
  ( q8_Y5*( <identity ...>), q8_R2*( q8_M2 - <identity ...>) ), 
  ( q8_Y18*( q8_M2), q8_R1*( -q8_M2 - <identity ...>) + q8_R3*( q8_M1^2 + q8_M\
3 + q8_M1 + <identity ...>) ), 
  ( q8_Y8*( q8_M2), q8_R3*( q8_M3 - q8_M2) + q8_R4*( q8_M1 - <identity ...>) )
    , 
  ( q8_Y17*( -q8_M2), q8_R2*( -q8_M1^2) + q8_R3*( -q8_M3 - <identity ...>) + q\
8_R4*( q8_M2 + <identity ...>) ), 
  ( q8_Y11*( <identity ...>), q8_R1*( -q8_M2) + q8_R3*( q8_M1*q8_M2 + q8_M4) +\
 q8_R4*( q8_M2 - <identity ...>) ), 
  ( q8_Y10*( -q8_M1), q8_R1*( -<identity ...>) + q8_R2*( -q8_M1) + q8_R4*( q8_\
M3 + q8_M1) ) ]

## Example 6.1.2
gap> RootIdentities( q8 );
[ [ [ q8_R1^-1, <identity ...> ], [ q8_R1, f1^-1 ] ], 
  [ [ q8_R2^-1, <identity ...> ], [ q8_R4^-1, f2^-1 ], [ q8_R2, f1^-2*f2^-1 ],
      [ q8_R4, f2^-1 ] ] ]
gap> RootIdentities(s3);
[ [ [ s3_R1^-1, <identity ...> ], [ s3_R1, f1^-1 ] ], 
  [ [ s3_R2^-1, <identity ...> ], [ s3_R2, f2 ] ], 
  [ [ s3_R3^-1, <identity ...> ], [ s3_R3, f1*f2 ] ] ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  5-idrels.tst . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

