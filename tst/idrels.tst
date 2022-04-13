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
gap> q8R := FreeRelatorGroup( q8 );; 
gap> genq8R := GeneratorsOfGroup( q8R );; 
gap> q8Rlabs := [ "q", "r", "s", "t" ];; 


## Example 6.1.1
gap> q8seq := IdentityRelatorSequences( q8 );;
gap> Length( q8seq );
23
gap> PrintLnUsingLabels( q8seq[7], genfmq8, q8labs );
[ [ -11, id ], [ -12, B ], [ 11, A*B ], [ 12, a*B ] ]
gap> idsq8 := IdentitiesAmongRelators( q8 );;
gap> Length( idsq8 );
12
gap> PrintLnUsingLabels( idsq8, genfmq8, q8labs );
[ [ [ -9, id ], [ 9, a ] ], [ [ -10, id ], [ 10, b ] ], [ [ -12, id ], 
[ 11, a*b ], [ 11, a^2*b ], [ -12, a^2*b ], [ 10, id ] ], [ [ -12, id ], 
[ -12, A^2 ], [ 10, A^4 ], [ 9, id ] ], [ [ -11, id ], [ -11, A ], 
[ 12, B*A^2 ], [ -12, A^2 ], [ 9, id ] ], [ [ -11, id ], [ 12, B*A ], 
[ -12, A ], [ 9, id ], [ -11, a ] ], [ [ -11, id ], [ -12, B ], 
[ 11, A*B ], [ 12, a*B ] ], [ [ -11, id ], [ -11, b ], [ 12, B*A*b ], 
[ -12, A^2*b ], [ 9, b ] ], [ [ -12, id ], [ -11, b ], [ 12, B*A*b ], 
[ -12, A*b ], [ 11, A^2*b ], [ 12, b ] ], [ [ -11, id ], [ -12, B ], 
[ 11, A*B ], [ -12, A*B ], [ 10, A^3*B ], [ 9, B ] ], [ [ -11, id ], 
[ -11, b ], [ 12, B*A*b ], [ -12, A*b ], [ 9, b ], [ -12, a*b ], 
[ 10, A*b ], [ 9, b ], [ -12, a^2*b ] ], [ [ -9, id ], [ -12, B ], 
[ 11, A*B ], [ 12, B*A*B ], [ -12, A*B ], [ 9, B ], [ -11, a*B ], 
[ 12, B^2 ] ] ]
gap> idyseq8 := IdentityYSequences( q8 );; 
gap> for y in idyseq8 do 
>        PrintLnYSequence( y, genfmq8, q8labs, genq8R, q8Rlabs ); 
>    od; 
q8_Y2*(1*A), q^-1*(-1*A) + q*(1*id)) 
q8_Y1*(1*B), r^-1*(-1*B) + r*(1*id)) 
q8_Y5*(-1*b), r*(-1*b) + s*(-1*A + -1*id) + t^-1*(1*b + 1*id)) 
q8_Y3*(-1*a), q*(-1*a) + r*(-1*a) + t^-1*(1*A + 1*a)) 
q8_Y7*(1*B), q*(1*B) + s^-1*(-1*a*b + -1*B) + t^-1*(-1*b) + t*(1*id)) 
q8_Y8*(1*a*b), q*(1*a*b) + s^-1*(-1*a*b + -1*B) + t^-1*(-1*b) + t*(1*id)) 
q8_Y4*(1*a*b), s^-1*(-1*a*b) + s*(1*a^2) + t^-1*(-1*A) + t*(1*id)) 
q8_Y6*(1*A), q*(1*a*b) + s^-1*(-1*a*b + -1*A) + t^-1*(-1*a*B) + t*(1*id)) 
q8_Y9*(1*id), s^-1*(-1*b) + s*(1*B) + t^-1*(-1*a*B + -1*id) + t*(1*b + 1*a)) 
q8_Y10*(-1*a*B), q*(-1*a) + r*(-1*a^2) + s^-1*(1*a*B) + s*(-1*id) + t^-1*(
1*a + 1*id)) 
q8_Y15*(1*A), q*(2*a*b) + r*(1*b) + s^-1*(-1*a*b + -1*A) + t^-1*(-1*a*B + 
-1*B + -1*b) + t*(1*id)) 
q8_Y11*(1*a^2), q^-1*(-1*a^2) + q*(1*b) + s^-1*(-1*a*b) + s*(1*a*B) + t^-1*(
-1*a*B + -1*b) + t*(1*a + 1*id)) 

## Example 6.1.2
gap> PrintLnUsingLabels( RootIdentities(q8), genfmq8, q8labs );
[ [ [ -10, id ], [ 10, b ] ], [ [ -9, id ], [ 9, a ] ], [ [ -9, id ], 
[ 9, A ] ], [ [ -9, id ], [ 9, a^2 ] ] ]
gap> RootIdentities(s3);
[ [ [ -11, <identity ...> ], [ 11, s3_M1*s3_M2 ] ], 
  [ [ -10, <identity ...> ], [ 10, s3_M2 ] ], 
  [ [ -9, <identity ...> ], [ 9, s3_M1 ] ], 
  [ [ -9, <identity ...> ], [ 9, s3_M3 ] ] ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  idrels.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

