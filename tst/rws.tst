#############################################################################
##
#W  rws.tst                  Idrel Package                      Chris Wensley
#W                                                            & Anne Heyworth
#Y  Copyright (C) 1999-2024 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

## Example 1.1 
gap> F := FreeGroup( 2 );; 
gap> f := F.1;;  g := F.2;; 
gap> rels3 := [ f^3, g^2, f*g*f*g ]; 
[ f1^3, f2^2, (f1*f2)^2 ]
gap> s3 := F/rels3; 
<fp group on the generators [ f1, f2 ]>
gap> SetName( s3, "s3" );; 
gap> IdentitiesAmongRelators( s3 );
[ [ [ -1, <identity ...> ], [ 1, s3_M1 ] ], 
  [ [ -2, <identity ...> ], [ 2, s3_M2 ] ], 
  [ [ -3, <identity ...> ], [ 3, s3_M1*s3_M2 ] ], 
  [ [ 1, <identity ...> ], [ -3, s3_M1 ], [ 2, s3_M3*s3_M4 ], [ 1, s3_M4 ], 
      [ -3, <identity ...> ], [ 2, s3_M3*s3_M4*s3_M3 ], [ 2, s3_M3 ], 
      [ -3, s3_M3 ] ], 
  [ [ 1, <identity ...> ], [ -3, s3_M2 ], [ 2, s3_M3*s3_M4*s3_M3*s3_M2 ], 
      [ 2, s3_M3*s3_M2 ], [ 1, s3_M2 ], [ -3, <identity ...> ], [ 2, s3_M3 ], 
      [ -3, s3_M3 ] ] ]

## Example 2.1.1
gap> relq8 := [ f^4, g^4, f*g*f*g^-1, f^2*g^2 ];;
gap> q8 := F/relq8;;
gap> SetName( q8, "q8" );;
gap> q8R := FreeRelatorGroup( q8 ); 
q8_R
gap> genq8R := GeneratorsOfGroup( q8R );
[ q8_R1, q8_R2, q8_R3, q8_R4]
gap> homq8R := FreeRelatorHomomorphism( q8 );
[ q8_R1, q8_R2, q8_R3, q8_R4 ] -> [ f1^4, f2^4, f1*f2*f1*f2^-1, f1^2*f2^2 ]

## Example 2.1.2
gap> mq8 := MonoidPresentationFpGroup( q8 );
monoid presentation with group relators 
[ q8_M1^4, q8_M2^4, q8_M1*q8_M2*q8_M1*q8_M4, q8_M1^2*q8_M2^2 ]
gap> fmq8 := FreeGroupOfPresentation( mq8 ); 
<free group on the generators [ q8_M1, q8_M2, q8_M3, q8_M4 ]>
gap> genfmq8 := GeneratorsOfGroup( fmq8 );;
gap> gprels := GroupRelatorsOfPresentation( mq8 ); 
[ q8_M1^4, q8_M2^4, q8_M1*q8_M2*q8_M1*q8_M4, q8_M1^2*q8_M2^2 ]
gap> invrels := InverseRelatorsOfPresentation( mq8 ); 
[ q8_M1*q8_M3, q8_M2*q8_M4, q8_M3*q8_M1, q8_M4*q8_M2 ]
gap> hompres := HomomorphismOfPresentation( mq8 ); 
[ q8_M1, q8_M2, q8_M3, q8_M4 ] -> [ f1, f2, f1^-1, f2^-1 ]

## Example 2.1.3 
gap> q8labs := [ "a", "b", "A", "B" ];; 
gap> SetMonoidPresentationLabels( q8, q8labs );; 
gap> PrintLnUsingLabels( gprels, genfmq8, q8labs ); 
[ a^4, b^4, a*b*a*B, a^2*b^2 ]

## Example 2.1.4 
gap> q0 := InitialRulesOfPresentation( mq8 );;  
gap> PrintLnUsingLabels( q0, genfmq8, q8labs );
[ [ a^-1, A ], [ b^-1, B ], [ A^-1, a ], [ B^-1, b ], [ a*A, id ], 
[ b*B, id ], [ A*a, id ], [ B*b, id ], [ a^4, id ], [ a^2*b^2, id ], 
[ a*b*a*B, id ], [ b^4, id ] ]

## Example 2.2.1
gap> rws := RewritingSystemFpGroup( q8 );;
gap> Length( rws );
20
gap> PrintLnUsingLabels( rws, genfmq8, q8labs );
[ [ a^-1, A ], [ b^-1, B ], [ A^-1, a ], [ B^-1, b ], [ a*A, id ], 
[ b*B, id ], [ A*a, id ], [ B*b, id ], [ b*a, a*B ], [ b^2, a^2 ], 
[ b*A, a*b ], [ A*b, a*B ], [ A^2, a^2 ], [ A*B, a*b ], [ B*a, a*b ], 
[ B*A, a*B ], [ B^2, a^2 ], [ a^3, A ], [ a^2*b, B ], [ a^2*B, b ] ]

gap> T := F/[Comm(f,g)];              
<fp group of size infinity on the generators [ f1, f2 ]>
gap> SetName( T, "T" );                   
gap> SetArrangementOfMonoidGenerators( T, [1,-1,2,-2] );
gap> Tlabs := [ "x", "X", "y", "Y" ];; 
gap> mT := MonoidPresentationFpGroup( T );              
monoid presentation with group relators [ T_M2*T_M4*T_M1*T_M3 ]
gap> fgmT := FreeGroupOfPresentation( mT );; 
gap> genfgmT := GeneratorsOfGroup( fgmT );;
gap> SetMonoidPresentationLabels( T, Tlabs );; 
gap> rwsT := RewritingSystemFpGroup( T );;
gap> PrintLnUsingLabels( rwsT, genfgmT, Tlabs );       
[ [ x^-1, X ], [ X^-1, x ], [ y^-1, Y ], [ Y^-1, y ], [ x*X, id ], 
[ X*x, id ], [ y*Y, id ], [ Y*y, id ], [ y*x, x*y ], [ y*X, X*y ], 
[ Y*x, x*Y ], [ Y*X, X*Y ] ]

## Example 2.2.2
gap> a := genfmq8[1];;  b := genfmq8[2];; 
gap> A := genfmq8[3];;  B := genfmq8[4];; 
gap> w0 := b^9 * a^-9;; 
gap> PrintLnUsingLabels( w0, genfmq8, q8labs ); 
b^9*a^-9
gap> w1 := OnePassReduceWord( w0, rws );; 
gap> PrintLnUsingLabels( w1, genfmq8, q8labs ); 
B*b^5*a*b*a^-8
gap> w2 := ReduceWordKB( w0, rws );; 
gap> PrintLnUsingLabels( w2, genfmq8, q8labs ); 
a*b

## Example 2.2.3
gap> q1 := OnePassKB( mq8, q0 );; 
gap> Length( q1 ); 
22
gap> PrintLnUsingLabels( q1, genfmq8, q8labs ); 
[ [ a^-1, A ], [ b^-1, B ], [ A^-1, a ], [ B^-1, b ], [ a*A, id ], 
[ b*B, id ], [ A*a, id ], [ B*b, id ], [ b^2, a^2 ], [ a^3, A ], 
[ a^2*b, B ], [ a*b*a, b ], [ a*b^2, A ], [ b*a*B, A ], [ b^3, B ], 
[ a*b^2, a^3 ], [ b*a*B, a^3 ], [ b^3, a^2*b ], [ a^4, id ], 
[ a^2*b^2, id ], [ a*b*a*B, id ], [ b^4, id ] ] 

## Example 2.2.4 
gap> q2 := RewriteReduce( mq8, q1 );; 
gap> Length( q2 ); 
13
gap> PrintLnUsingLabels( q2, genfmq8, q8labs ); 
[ [ a^-1, A ], [ b^-1, B ], [ A^-1, a ], [ B^-1, b ], [ a*A, id ], 
[ b*B, id ], [ A*a, id ], [ B*b, id ], [ b^2, a^2 ], [ a^3, A ], 
[ a^2*b, B ], [ a*b*a, b ], [ b*a*B, A ] ]

## Example 2.2.5 
gap> q3 := KnuthBendix( mq8, q0 );; 
gap> Length( q3 ); 
20
gap> PrintLnUsingLabels( q3, genfmq8, q8labs ); 
[ [ a^-1, A ], [ b^-1, B ], [ A^-1, a ], [ B^-1, b ], [ a*A, id ], 
[ b*B, id ], [ A*a, id ], [ B*b, id ], [ b*a, a*B ], [ b^2, a^2 ], 
[ b*A, a*b ], [ A*b, a*B ], [ A^2, a^2 ], [ A*B, a*b ], [ B*a, a*b ], 
[ B*A, a*B ], [ B^2, a^2 ], [ a^3, A ], [ a^2*b, B ], [ a^2*B, b ] ]

## Example 2.3.1
gap> elmq8 := ElementsOfMonoidPresentation( q8 );; 
gap> PrintLnUsingLabels( elmq8, genfmq8, q8labs ); 
[ id, a, b, A, B, a^2, a*b, a*B ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

############################################################################
##
#E  rws.tst . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
