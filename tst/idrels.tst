##############################################################################
##
#W  idrels.tst                   Idrel Package                   Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2022 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

## items defined in rws.tst 
gap> F := FreeGroup( 2 );;
gap> f := F.1;;  g := F.2;;
gap> rels3 := [ f^3, g^2, f*g*f*g ];; 
gap> s3 := F/rels3;; 
gap> SetName( s3, "s3" );; 
gap> rels8 := [ f^4, g^4, f*g*f*g^-1, f^2*g^2 ];;
gap> q8 := F/rels8;;
gap> SetName( q8, "q8" );;
gap> q8labs := [ "a", "b", "A", "B" ];; 
gap> SetMonoidPresentationLabels( q8, q8labs );; 
gap> mq8 := MonoidPresentationFpGroup( q8 );;
gap> fmq8 := FreeGroupOfPresentation( mq8 );; 
gap> genfmq8 := GeneratorsOfGroup( fmq8 );;


## Example 6.1.1
gap> q8seq := IdentityRelatorSequences( q8 );;
gap> Length( q8seq );
23
gap> q8seq[1];
[ [ -10, <identity ...> ], [ 10, q8_M2 ] ]
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
#E  idrels.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

