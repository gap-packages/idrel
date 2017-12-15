##############################################################################
##
#W  1-rws.tst                  Idrel Package                     Chris Wensley
#W                                                             & Anne Heyworth
##
#Y  Copyright (C) 1999-2017 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

## Example 1.1 
gap> F := FreeGroup( 2 );;
gap> a := F.1;;
gap> b := F.2;;
gap> rels3 := [ a^3, b^2, a*b*a*b ]; 
[ f1^3, f2^2, (f1*f2)^2 ]
gap> s3 := F/rels3; 
<fp group on the generators [ f1, f2 ]>
gap> SetName( s3, "s3" );; 
gap> idy3 := IdentityYSequences( s3 );; 
gap> Length( idy3 ); 
12
gap> Y1 := idy3[1];
[ 1, 4, [ [ s3_R1^-1, f1^-1 ], [ s3_R1, <identity ...> ] ] ]
gap> Y3 := idy3[3];
[ 3, 8, [ [ s3_R2^-1, f2^-1 ], [ s3_R2, <identity ...> ] ] ]
gap> Y5 := idy3[5];
[ 5, 9, [ [ s3_R3^-1, f2^-1 ], [ s3_R3, f1 ] ] ]
gap> Y11 := idy3[11];
[ 11, 6, [ [ s3_R3^-1, f1^-1 ], [ s3_R1, <identity ...> ], [ s3_R3^-1, f1 ], 
      [ s3_R2, f1^-1*f2^-1 ], [ s3_R1, f2^-1 ], [ s3_R3^-1, f1*f2^-1 ], 
      [ s3_R2, <identity ...> ], [ s3_R2, f1^-1 ] ] ]

gap> idrels3 := IdentitiesAmongRelators( s3 );;
gap> Display( idrels3[1] );
[ ( s3_Y1*( s3_M1), s3_R1*( s3_M1 - <identity ...>) ), 
  ( s3_Y3*( s3_M2), s3_R2*( s3_M2 - <identity ...>) ), 
  ( s3_Y5*( s3_M2*s3_M1), s3_R3*( s3_M2 - s3_M1) ), 
  ( s3_Y11*( -s3_M1), s3_R1*( -s3_M2*s3_M1 - s3_M1) + s3_R2*( -s3_M1*s3_M2 - s\
3_M1 - <identity ...>) + s3_R3*( s3_M3 + s3_M2 + <identity ...>) ) ]

## Example 2.1.1
gap> rels := [ a^4, b^4, a*b*a*b^-1, a^2*b^2 ];;
gap> q8 := F/rels;;
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

## Example 2.2.1
gap> rws := RewritingSystemFpGroup( q8 );
[ [ q8_M1*q8_M3, <identity ...> ], [ q8_M2*q8_M4, <identity ...> ], 
  [ q8_M3*q8_M1, <identity ...> ], [ q8_M4*q8_M2, <identity ...> ], 
  [ q8_M1^2*q8_M4, q8_M2 ], [ q8_M1^2*q8_M2, q8_M4 ], [ q8_M1^3, q8_M3 ], 
  [ q8_M4^2, q8_M1^2 ], [ q8_M4*q8_M3, q8_M1*q8_M4 ], 
  [ q8_M4*q8_M1, q8_M1*q8_M2 ], [ q8_M3*q8_M4, q8_M1*q8_M2 ], 
  [ q8_M3^2, q8_M1^2 ], [ q8_M3*q8_M2, q8_M1*q8_M4 ], 
  [ q8_M2*q8_M3, q8_M1*q8_M2 ], [ q8_M2^2, q8_M1^2 ], 
  [ q8_M2*q8_M1, q8_M1*q8_M4 ] ]

gap> T := F/[Comm(a,b)];              
<fp group of size infinity on the generators [ f1, f2 ]>
gap> SetName( T, "T" );                   
gap> SetArrangementOfMonoidGenerators( T, [1,-1,2,-2] );
gap> monT := MonoidPresentationFpGroup(T);              
monoid presentation with group relators [ T_M2*T_M4*T_M1*T_M3 ]
gap> rwsT := RewritingSystemFpGroup( T );               
[ [ T_M1*T_M2, <identity ...> ], [ T_M2*T_M1, <identity ...> ], 
  [ T_M3*T_M4, <identity ...> ], [ T_M4*T_M3, <identity ...> ], 
  [ T_M4*T_M2, T_M2*T_M4 ], [ T_M4*T_M1, T_M1*T_M4 ], 
  [ T_M3*T_M2, T_M2*T_M3 ], [ T_M3*T_M1, T_M1*T_M3 ] ]

## Example 2.2.2
gap> monrels := Concatenation( gprels, invrels ); 
[ q8_M1^4, q8_M2^4, q8_M1*q8_M2*q8_M1*q8_M4, q8_M1^2*q8_M2^2, q8_M1*q8_M3, 
  q8_M2*q8_M4, q8_M3*q8_M1, q8_M4*q8_M2 ]
gap> id := One( monrels[1] );;
gap> r0 := List( monrels, r -> [ r, id ] ); 
[ [ q8_M1^4, <identity ...> ], [ q8_M2^4, <identity ...> ], 
  [ q8_M1*q8_M2*q8_M1*q8_M4, <identity ...> ], 
  [ q8_M1^2*q8_M2^2, <identity ...> ], [ q8_M1*q8_M3, <identity ...> ], 
  [ q8_M2*q8_M4, <identity ...> ], [ q8_M3*q8_M1, <identity ...> ], 
  [ q8_M4*q8_M2, <identity ...> ] ]
gap> ap := genfgmon[1];;
gap> bp := genfgmon[2];;
gap> am := genfgmon[3];;
gap> bm := genfgmon[4];;
gap> w0 := bp^9 * ap^9; 
q8_M2^9*q8_M1^9
gap> w1 := OnePassReduceWord( w0, r0 ); 
q8_M2^5*q8_M1^5
gap> w2 := ReduceWordKB( w0, r0 ); 
q8_M2*q8_M1

## Example 2.2.3
gap> r1 := OnePassKB( r0 );
[ [ q8_M1^4, <identity ...> ], [ q8_M2^4, <identity ...> ], 
  [ q8_M1*q8_M2*q8_M1*q8_M4, <identity ...> ], 
  [ q8_M1^2*q8_M2^2, <identity ...> ], [ q8_M1*q8_M3, <identity ...> ], 
  [ q8_M2*q8_M4, <identity ...> ], [ q8_M3*q8_M1, <identity ...> ], 
  [ q8_M4*q8_M2, <identity ...> ], [ q8_M2*q8_M1*q8_M4, q8_M1^3 ], 
  [ q8_M1*q8_M2^2, q8_M1^3 ], [ q8_M2^2, q8_M1^2 ], [ q8_M1^3, q8_M3 ], 
  [ q8_M2^3, q8_M4 ], [ q8_M1*q8_M2*q8_M1, q8_M2 ], 
  [ q8_M2^3, q8_M1^2*q8_M2 ], [ q8_M2^2, q8_M1^2 ], [ q8_M1^2*q8_M2, q8_M4 ], 
  [ q8_M1^3, q8_M3 ], [ q8_M2*q8_M1*q8_M4, q8_M3 ], [ q8_M1*q8_M2^2, q8_M3 ], 
  [ q8_M2^3, q8_M4 ] ]
gap> Length( r1 );
21
gap> r1 := RewriteReduce( r1 ); 
[ [ q8_M1*q8_M3, <identity ...> ], [ q8_M2^2, q8_M1^2 ], 
  [ q8_M2*q8_M4, <identity ...> ], [ q8_M3*q8_M1, <identity ...> ], 
  [ q8_M4*q8_M2, <identity ...> ], [ q8_M1^3, q8_M3 ], 
  [ q8_M1^2*q8_M2, q8_M4 ], [ q8_M1*q8_M2*q8_M1, q8_M2 ], 
  [ q8_M2*q8_M1*q8_M4, q8_M3 ] ]
gap> Length( r1 );
9
gap> r2 := KnuthBendix( r1 );
[ [ q8_M1*q8_M3, <identity ...> ], [ q8_M2*q8_M1, q8_M1*q8_M4 ], 
  [ q8_M2^2, q8_M1^2 ], [ q8_M2*q8_M3, q8_M1*q8_M2 ], 
  [ q8_M2*q8_M4, <identity ...> ], [ q8_M3*q8_M1, <identity ...> ], 
  [ q8_M3*q8_M2, q8_M1*q8_M4 ], [ q8_M3^2, q8_M1^2 ], 
  [ q8_M3*q8_M4, q8_M1*q8_M2 ], [ q8_M4*q8_M1, q8_M1*q8_M2 ], 
  [ q8_M4*q8_M2, <identity ...> ], [ q8_M4*q8_M3, q8_M1*q8_M4 ], 
  [ q8_M4^2, q8_M1^2 ], [ q8_M1^3, q8_M3 ], [ q8_M1^2*q8_M2, q8_M4 ], 
  [ q8_M1^2*q8_M4, q8_M2 ] ]
gap> Length( r2 );
16
gap> w2 := ReduceWordKB( w0, r2 );
q8_M1*q8_M4

## Example 2.3.1
gap> elq8 := Elements( q8 ); 
[ <identity ...>, f1, f1^3, f2, f1^2*f2, f1^2, f1*f2, f1^3*f2 ]
gap> elmonq8 := ElementsOfMonoidPresentation( q8 );
[ <identity ...>, q8_M1, q8_M2, q8_M3, q8_M4, q8_M1^2, q8_M1*q8_M2, 
  q8_M1*q8_M4 ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  1-rws.tst . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
