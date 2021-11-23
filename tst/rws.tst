##############################################################################
##
#W  rws.tst                  Idrel Package                       Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2021 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> ## SetInfoLevel( InfoIdRel, 0 );;

## Example 1.1 
gap> F := FreeGroup( 2 );;
gap> f := F.1;;  g := F.2;;
gap> rels3 := [ f^3, g^2, f*g*f*g ]; 
[ f1^3, f2^2, (f1*f2)^2 ]
gap> s3 := F/rels3; 
<fp group on the generators [ f1, f2 ]>
gap> SetName( s3, "s3" );; 
gap> idrels3 := IdentitiesAmongRelators( s3 );;
gap> Display( idrels3 );
[ [ [ s3_R1^-1, <identity ...> ], [ s3_R1, f1^-1 ] ], 
  [ [ s3_R2^-1, <identity ...> ], [ s3_R2, f2 ] ], 
  [ [ s3_R3^-1, <identity ...> ], [ s3_R3, f1*f2 ] ], 
  [ [ s3_R3^-1, <identity ...> ], [ s3_R1, f1 ], [ s3_R3^-1, f1^2 ], 
      [ s3_R2, f1^-1*f2^-1*f1 ], [ s3_R1, f2^-1*f1 ], 
      [ s3_R3^-1, f1*f2^-1*f1 ], [ s3_R2, f1 ], [ s3_R2, <identity ...> ] ] ]
gap> idyseq3 := IdentityYSequences( s3 );     
[ ( s3_Y1*( -s3_M1), s3_R1*( s3_M1 - <identity ...>) ), 
  ( s3_Y2*( <identity ...>), s3_R2*( s3_M2 - <identity ...>) ), 
  ( s3_Y3*( s3_M1), s3_R3*( s3_M2 - s3_M1) ), 
  ( s3_Y9*( -<identity ...>), s3_R1*( -s3_M2*s3_M1 - s3_M1) + s3_R2*( -s3_M1*s\
3_M2 - s3_M1 - <identity ...>) + s3_R3*( s3_M3 + s3_M2 + <identity ...>) ) ]

## Example 2.1.1
gap> rels8 := [ f^4, g^4, f*g*f*g^-1, f^2*g^2 ];;
gap> q8 := F/rels8;;
gap> SetName( q8, "q8" );;
gap> frq8 := FreeRelatorGroup( q8 ); 
q8_R
gap> frhomq8 := FreeRelatorHomomorphism( q8 );
[ q8_R1, q8_R2, q8_R3, q8_R4 ] -> [ f1^4, f2^4, f1*f2*f1*f2^-1, f1^2*f2^2 ]

## Example 2.1.2
gap> mon := MonoidPresentationFpGroup( q8 );
monoid presentation with group relators 
[ q8_M1^4, q8_M2^4, q8_M1*q8_M2*q8_M1*q8_M4, q8_M1^2*q8_M2^2 ]
gap> fgmon := FreeGroupOfPresentation( mon ); 
<free group on the generators [ q8_M1, q8_M2, q8_M3, q8_M4 ]>
gap> genfgmon := GeneratorsOfGroup( fgmon );;
gap> gprels := GroupRelatorsOfPresentation( mon ); 
[ q8_M1^4, q8_M2^4, q8_M1*q8_M2*q8_M1*q8_M4, q8_M1^2*q8_M2^2 ]
gap> invrels := InverseRelatorsOfPresentation( mon ); 
[ q8_M1*q8_M3, q8_M2*q8_M4, q8_M3*q8_M1, q8_M4*q8_M2 ]
gap> hompres := HomomorphismOfPresentation( mon ); 
[ q8_M1, q8_M2, q8_M3, q8_M4 ] -> [ f1, f2, f1^-1, f2^-1 ]

## Example 2.1.3 
gap> q8labs := [ "a", "b", "A", "B" ];; 
gap> SetMonoidGeneratorLabels( q8, q8labs );; 
gap> PrintUsingLabels( gprels[3]*gprels[4]^5, genfgmon, q8labs ); 
a*b*a*B*(a^2*b^2)^5
gap> PrintUsingLabels( gprels, genfgmon, q8labs ); 
[ a^4, b^4, a*b*a*B, a^2*b^2 ]

## Example 2.2.1
gap> rws := RewritingSystemFpGroup( q8 );;
gap> PrintUsingLabels( rws, genfgmon, q8labs );
[ [ a*A, id ], [ b*B, id ], [ A*a, id ], [ B*b, id ], [ a^2*B, b ], [ a^2*b, 
B ], [ a^3, A ], [ B^2, a^2 ], [ B*A, a*B ], [ B*a, a*b ], [ A*B, a*b ], [ 
A^2, a^2 ], [ A*b, a*B ], [ b*A, a*b ], [ b^2, a^2 ], [ b*a, a*B ] ]

gap> T := F/[Comm(f,g)];              
<fp group of size infinity on the generators [ f1, f2 ]>
gap> SetName( T, "T" );                   
gap> SetArrangementOfMonoidGenerators( T, [1,-1,2,-2] );
gap> Tlabs := [ "x", "y", "X", "Y" ];; 
gap> monT := MonoidPresentationFpGroup( T );              
monoid presentation with group relators [ T_M2*T_M4*T_M1*T_M3 ]
gap> fgmonT := FreeGroupOfPresentation( monT );; 
gap> genfgmonT := GeneratorsOfGroup( fgmonT );;
gap> SetMonoidGeneratorLabels( T, labs );; 
gap> rwsT := RewritingSystemFpGroup( T );;
gap> PrintUsingLabels( rwsT, genfgmonT, Tlabs );       
[ [ x*X, id ], [ X*x, id ], [ y*Y, id ], [ Y*y, id ], [ Y*X, X*Y ], [ Y*x, 
x*Y ], [ y*X, X*y ], [ y*x, x*y ] ]

## Example 2.2.2
gap> monrels := Concatenation( gprels, invrels );; 
gap> PrintUsingLabels( monrels, genfgmon, Tlabs );
[ x^4, X^4, x*X*x*Y, x^2*X^2, x*y, X*Y, y*x, Y*X ]
gap> id := One( monrels[1] );;
gap> r0 := List( monrels, r -> [ r, id ] );; 
gap> PrintUsingLabels( r0, genfgmon, Tlabs );     
[ [ x^4, id ], [ X^4, id ], [ x*X*x*Y, id ], [ x^2*X^2, id ], [ x*y, id ], [ 
X*Y, id ], [ y*x, id ], [ Y*X, id ] ]
gap> ap := genfgmon[1];;
gap> bp := genfgmon[2];;
gap> am := genfgmon[3];;
gap> bm := genfgmon[4];;
gap> w0 := bp^9 * ap^9;; 
gap> PrintUsingLabels( w0, genfgmon, Tlabs );
X^9*x^9
gap> w1 := OnePassReduceWord( w0, r0 );; 
gap> PrintUsingLabels( w1, genfgmon, Tlabs );
b^5*a^5
gap> w2 := ReduceWordKB( w0, r0 );; 
gap> PrintUsingLabels( w2, genfgmon, Tlabs );
b*a

## Example 2.2.3
gap> r1 := OnePassKB( r0 );;
gap> PrintUsingLabels( r1, genfgmon, labs );
[ [ a^4, id ], [ b^4, id ], [ a*b*a*B, id ], [ a^2*b^2, id ], [ a*A, id ], [ 
b*B, id ], [ A*a, id ], [ B*b, id ], [ b*a*B, a^3 ], [ a*b^2, a^3 ], [ b^2, 
a^2 ], [ a^3, A ], [ b^3, B ], [ a*b*a, b ], [ b^3, a^2*b ], [ b^2, a^2 ], [ 
a^2*b, B ], [ a^3, A ], [ b*a*B, A ], [ a*b^2, A ], [ b^3, B ] ]
gap> Length( r1 );
21
gap> r1 := RewriteReduce( r1 );; 
gap> PrintUsingLabels( r1, genfgmon, labs );
[ [ a*A, id ], [ b^2, a^2 ], [ b*B, id ], [ A*a, id ], [ B*b, id ], [ a^3, 
A ], [ a^2*b, B ], [ a*b*a, b ], [ b*a*B, A ] ]
gap> Length( r1 );
9
gap> r2 := KnuthBendix( r1 );;
gap> PrintUsingLabels( r2, genfgmon, labs );
[ [ a*A, id ], [ b*a, a*B ], [ b^2, a^2 ], [ b*A, a*b ], [ b*B, id ], [ A*a, 
id ], [ A*b, a*B ], [ A^2, a^2 ], [ A*B, a*b ], [ B*a, a*b ], [ B*b, id ], [ 
B*A, a*B ], [ B^2, a^2 ], [ a^3, A ], [ a^2*b, B ], [ a^2*B, b ] ]
gap> Length( r2 );
16
gap> w2 := ReduceWordKB( w0, r2 );
q8_M1*q8_M4

## Example 2.3.1
gap> elq8 := Elements( q8 ); 
[ <identity ...>, f1, f1^3, f2, f1^2*f2, f1^2, f1*f2, f1^3*f2 ]
gap> elmonq8 := ElementsOfMonoidPresentation( q8 );;
gap> PrintUsingLabels( elmonq8, genfgmon, labs );
[ id, a, b, A, B, a^2, a*b, a*B ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  rws.tst . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
