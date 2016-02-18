##############################################################################
##
#W  idrel_manual.tst               Idrel Package                 Chris Wensley
#W                                                             & Anne Heyworth
##
#Y  Copyright (C) 1999-2016 Anne Heyworth and Chris Wensley
##
gap> START_TEST( "Testing all example commands in the IdRel manual" );
gap> SetInfoLevel( InfoIdRel, 0 );;

## ====================== Rewriting Systems ===================== 

## Example 2.1 
gap> F := FreeGroup( 2 );;
gap> a := F.1;;
gap> b := F.2;;
gap> rels3 := [ a^3, b^2, a*b*a*b ]; 
[ f1^3, f2^2, (f1*f2)^2 ]
gap> s3 := F/rels3; 
<fp group on the generators [ f1, f2 ]>
gap> SetName( s3, "s3" );; 
gap> idrels3 := IdentitiesAmongRelators( s3 );;
gap> idy3 := IdentityYSequences( s3 );; 
gap> Length( idy3 ); 
18
gap> Y4 := idy3[4];
[ [ s3_R1^-1, f1^-1 ], [ s3_R1, <identity ...> ] ]
gap> Y6 := idy3[6];
[ [ s3_R3^-1, f1^-1 ], [ s3_R1, <identity ...> ], [ s3_R3^-1, f1 ], 
  [ s3_R2, f1^-1*f2^-1 ], [ s3_R1, f2^-1 ], [ s3_R3^-1, f1*f2^-1 ], 
  [ s3_R2, <identity ...> ], [ s3_R2, f1^-1 ] ]
gap> Y8 := idy3[8];
[ [ s3_R2^-1, f2^-1 ], [ s3_R2, <identity ...> ] ]
gap> Display( idrels3[1] );
[ ( s3_Y4*( s3_M2*s3_M1), s3_R1*( s3_M1 - <identity ...>) ), 
  ( s3_Y8*( s3_M2*s3_M1), s3_R2*( s3_M2 - <identity ...>) ), 
  ( s3_Y7*( s3_M2*s3_M1), s3_R3*( s3_M2 - s3_M1) ), 
  ( s3_Y6*( -s3_M2*s3_M1), s3_R1*( -s3_M2*s3_M1 - s3_M1) + s3_R2*( -s3_M1*s3_M\
2 - s3_M1 - <identity ...>) + s3_R3*( s3_M3 + s3_M2 + <identity ...>) ) ]
gap> rels := [ a^4, b^4, a*b*a*b^-1, a^2*b^2 ];;
gap> q8 := F/rels;;
gap> SetName( q8, "q8" );;
gap> frq8 := FreeRelatorGroup( q8 ); 
q8_R
gap> frhomq8 := FreeRelatorHomomorphism( q8 );
[ q8_R1, q8_R2, q8_R3, q8_R4 ] -> [ f1^4, f2^4, f1*f2*f1*f2^-1, f1^2*f2^2 ]
gap> mon := MonoidPresentationFpGroup( q8 );
monoid presentation for an fp-group with homomorphism
[ [ q8_M1, q8_M2, q8_M3, q8_M4 ], [ f1, f2, f1^-1, f2^-1 ] ]
gap> fgmon := FreeGroupOfPresentation( mon ); 
<free group on the generators [ q8_M1, q8_M2, q8_M3, q8_M4 ]>
gap> genfgmon := GeneratorsOfGroup( fgmon );;
gap> gprels := GroupRelatorsOfPresentation( mon ); 
[ q8_M1^4, q8_M2^4, q8_M1*q8_M2*q8_M1*q8_M4, q8_M1^2*q8_M2^2 ]
gap> invrels := InverseRelatorsOfPresentation( mon ); 
[ q8_M1*q8_M3, q8_M2*q8_M4, q8_M3*q8_M1, q8_M4*q8_M2 ]
gap> hompres := HomomorphismOfPresentation( mon ); 
[ q8_M1, q8_M2, q8_M3, q8_M4 ] -> [ f1, f2, f1^-1, f2^-1 ]
gap> rws := RewritingSystemFpGroup( q8 );
[ [ q8_M1*q8_M3, <identity ...> ], [ q8_M2*q8_M4, <identity ...> ], 
  [ q8_M3*q8_M1, <identity ...> ], [ q8_M4*q8_M2, <identity ...> ], 
  [ q8_M1^2*q8_M4, q8_M2 ], [ q8_M1^2*q8_M2, q8_M4 ], [ q8_M1^3, q8_M3 ], 
  [ q8_M4^2, q8_M1^2 ], [ q8_M4*q8_M3, q8_M1*q8_M4 ], 
  [ q8_M4*q8_M1, q8_M1*q8_M2 ], [ q8_M3*q8_M4, q8_M1*q8_M2 ], 
  [ q8_M3^2, q8_M1^2 ], [ q8_M3*q8_M2, q8_M1*q8_M4 ], 
  [ q8_M2*q8_M3, q8_M1*q8_M2 ], [ q8_M2^2, q8_M1^2 ], 
  [ q8_M2*q8_M1, q8_M1*q8_M4 ] ]
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
gap> r1 := RewriteReduce( r1 ); 
[ [ q8_M1*q8_M3, <identity ...> ], [ q8_M2^2, q8_M1^2 ], 
  [ q8_M2*q8_M4, <identity ...> ], [ q8_M3*q8_M1, <identity ...> ], 
  [ q8_M4*q8_M2, <identity ...> ], [ q8_M1^3, q8_M3 ], 
  [ q8_M1^2*q8_M2, q8_M4 ], [ q8_M1*q8_M2*q8_M1, q8_M2 ], 
  [ q8_M2*q8_M1*q8_M4, q8_M3 ] ]
gap> r2 := KnuthBendix( r1 );
[ [ q8_M1*q8_M3, <identity ...> ], [ q8_M2*q8_M1, q8_M1*q8_M4 ], 
  [ q8_M2^2, q8_M1^2 ], [ q8_M2*q8_M3, q8_M1*q8_M2 ], 
  [ q8_M2*q8_M4, <identity ...> ], [ q8_M3*q8_M1, <identity ...> ], 
  [ q8_M3*q8_M2, q8_M1*q8_M4 ], [ q8_M3^2, q8_M1^2 ], 
  [ q8_M3*q8_M4, q8_M1*q8_M2 ], [ q8_M4*q8_M1, q8_M1*q8_M2 ], 
  [ q8_M4*q8_M2, <identity ...> ], [ q8_M4*q8_M3, q8_M1*q8_M4 ], 
  [ q8_M4^2, q8_M1^2 ], [ q8_M1^3, q8_M3 ], [ q8_M1^2*q8_M2, q8_M4 ], 
  [ q8_M1^2*q8_M4, q8_M2 ] ]
gap> w2 := ReduceWordKB( w0, r2 );
q8_M1*q8_M4
gap> elq8 := Elements( q8 ); 
[ <identity ...>, f1, f1^3, f2, f1^2*f2, f1^2, f1*f2, f1^3*f2 ]
gap> elmonq8 := ElementsOfMonoidPresentation( q8 );
[ <identity ...>, q8_M1, q8_M2, q8_M3, q8_M4, q8_M1^2, q8_M1*q8_M2, 
  q8_M1*q8_M4 ]

## =============== Logged Rewriting Systems ===================== 
gap> l0 := ListWithIdenticalEntries( 8, 0 );;
gap> for j in [1..8] do
>        r := r0[j];;
>        if (j<5) then
>           l0[j] := [ r[1], [ [j,id] ], r[2] ];;
>        else
>           l0[j] := [ r[1], [ ], r[2] ];;
>        fi;
>    od;
gap> l0; 
[ [ q8_M1^4, [ [ 1, <identity ...> ] ], <identity ...> ], 
  [ q8_M2^4, [ [ 2, <identity ...> ] ], <identity ...> ], 
  [ q8_M1*q8_M2*q8_M1*q8_M4, [ [ 3, <identity ...> ] ], <identity ...> ], 
  [ q8_M1^2*q8_M2^2, [ [ 4, <identity ...> ] ], <identity ...> ], 
  [ q8_M1*q8_M3, [  ], <identity ...> ], [ q8_M2*q8_M4, [  ], <identity ...> ]
    , [ q8_M3*q8_M1, [  ], <identity ...> ], 
  [ q8_M4*q8_M2, [  ], <identity ...> ] ]
gap> l1 := LoggedOnePassKB( l0 );;
gap> Length( l1 );
21
gap> l1 := LoggedRewriteReduce( l1 );
[ [ q8_M1*q8_M3, [  ], <identity ...> ], 
  [ q8_M2^2, [ [ -4, <identity ...> ], [ 2, q8_M1^-2 ] ], q8_M1^2 ], 
  [ q8_M2*q8_M4, [  ], <identity ...> ], [ q8_M3*q8_M1, [  ], <identity ...> ]
    , [ q8_M4*q8_M2, [  ], <identity ...> ], 
  [ q8_M1^3, [ [ 1, <identity ...> ] ], q8_M3 ], 
  [ q8_M1^2*q8_M2, [ [ 4, <identity ...> ] ], q8_M4 ], 
  [ q8_M1*q8_M2*q8_M1, [ [ 3, <identity ...> ] ], q8_M2 ], 
  [ q8_M2*q8_M1*q8_M4, [ [ 3, q8_M3^-1 ] ], q8_M3 ] ]
gap> l2 := LoggedKnuthBendix( l1 ); 
[ [ q8_M1*q8_M3, [  ], <identity ...> ], 
  [ q8_M2*q8_M1, [ [ 3, q8_M3^-1 ], [ -1, <identity ...> ], [ 4, q8_M1^-1 ] ],
      q8_M1*q8_M4 ], 
  [ q8_M2^2, [ [ -4, <identity ...> ], [ 2, q8_M1^-2 ] ], q8_M1^2 ], 
  [ q8_M2*q8_M3, [ [ -3, <identity ...> ] ], q8_M1*q8_M2 ], 
  [ q8_M2*q8_M4, [  ], <identity ...> ], [ q8_M3*q8_M1, [  ], <identity ...> ]
    , [ q8_M3*q8_M2, [ [ -1, <identity ...> ], [ 4, q8_M1^-1 ] ], q8_M1*q8_M4 
     ], [ q8_M3^2, [ [ -1, <identity ...> ] ], q8_M1^2 ], 
  [ q8_M3*q8_M4, 
      [ [ -1, <identity ...> ], [ -2, q8_M1^-2 ], [ 4, <identity ...> ], 
          [ 3, q8_M3^-1*q8_M2^-1 ], [ -3, <identity ...> ] ], q8_M1*q8_M2 ], 
  [ q8_M4*q8_M1, [ [ -4, <identity ...> ], [ 3, q8_M1^-1 ] ], q8_M1*q8_M2 ], 
  [ q8_M4*q8_M2, [  ], <identity ...> ], 
  [ q8_M4*q8_M3, [ [ -3, q8_M3^-1*q8_M4^-1 ] ], q8_M1*q8_M4 ], 
  [ q8_M4^2, [ [ -4, <identity ...> ] ], q8_M1^2 ], 
  [ q8_M1^3, [ [ 1, <identity ...> ] ], q8_M3 ], 
  [ q8_M1^2*q8_M2, [ [ 4, <identity ...> ] ], q8_M4 ], 
  [ q8_M1^2*q8_M4, [ [ -4, q8_M1^-2 ], [ 1, <identity ...> ] ], q8_M2 ] ]
gap> w0; 
q8_M2^9*q8_M1^9
gap> lw1 := LoggedOnePassReduceWord( w0, l0 );
[ [ [ 1, q8_M2^-9 ], [ 2, <identity ...> ] ], q8_M2^5*q8_M1^5 ]
gap> lw2 := LoggedReduceWordKB( w0, l0 ); 
[ [ [ 1, q8_M2^-9 ], [ 2, <identity ...> ], [ 1, q8_M2^-5 ], 
      [ 2, <identity ...> ] ], q8_M2*q8_M1 ]
gap> lw2 := LoggedReduceWordKB( w0, l2 ); 
[ [ [ 3, q8_M3^-1*q8_M2^-8 ], [ -1, q8_M2^-8 ], [ 4, q8_M1^-1*q8_M2^-8 ], 
      [ -4, <identity ...> ], [ 2, q8_M1^-2 ], 
      [ -4, q8_M1^-1*q8_M2^-6*q8_M1^-2 ], [ 3, q8_M1^-2*q8_M2^-6*q8_M1^-2 ], 
      [ 1, q8_M2^-1*q8_M1^-2*q8_M2^-6*q8_M1^-2 ], [ 4, <identity ...> ], 
      [ 3, q8_M3^-1*q8_M2^-4*q8_M4^-1 ], [ -1, q8_M2^-4*q8_M4^-1 ], 
      [ 4, q8_M1^-1*q8_M2^-4*q8_M4^-1 ], [ -4, q8_M4^-1 ], 
      [ 2, q8_M1^-2*q8_M4^-1 ], 
      [ -3, q8_M1^-1*q8_M4^-1*q8_M1^-1*q8_M2^-2*q8_M1^-2*q8_M4^-1 ], 
      [ -4, <identity ...> ], [ 3, q8_M1^-1 ], 
      [ 1, q8_M2^-1*q8_M1^-2*q8_M4^-1*q8_M1^-1*q8_M2^-1*(q8_M2^-1*q8_M1^-1)^2 
         ], [ 4, q8_M4^-1*q8_M1^-1*q8_M2^-1*(q8_M2^-1*q8_M1^-1)^2 ], 
      [ 3, q8_M3^-1*q8_M1^-1 ], [ -1, q8_M1^-1 ], [ 4, q8_M1^-2 ], 
      [ -4, q8_M4^-1*q8_M1^-2 ], [ 2, q8_M1^-2*q8_M4^-1*q8_M1^-2 ], 
      [ -4, q8_M1^-2 ], [ 3, q8_M1^-3 ], [ -4, q8_M1^-2*q8_M2^-1*q8_M1^-3 ], 
      [ 1, <identity ...> ], [ 3, q8_M3^-2 ], [ -1, q8_M3^-1 ], 
      [ 4, q8_M1^-1*q8_M3^-1 ], [ -4, <identity ...> ], [ 3, q8_M1^-1 ], 
      [ 3, q8_M3^-1*q8_M1^-1 ], [ -1, q8_M1^-1 ], [ 4, q8_M1^-2 ], 
      [ -4, q8_M1^-2 ], [ 3, q8_M1^-3 ], [ 1, <identity ...> ], 
      [ -1, <identity ...> ], [ 4, q8_M1^-1 ] ], q8_M1*q8_M4 ]
gap> LoggedRewritingSystemFpGroup( q8 );
[ [ q8_M4*q8_M2, [  ], <identity ...> ], [ q8_M3*q8_M1, [  ], <identity ...> ]
    , [ q8_M2*q8_M4, [  ], <identity ...> ], 
  [ q8_M1*q8_M3, [  ], <identity ...> ], 
  [ q8_M1^2*q8_M4, [ [ -8, q8_M1^-2 ], [ 5, <identity ...> ] ], q8_M2 ], 
  [ q8_M1^2*q8_M2, [ [ 8, <identity ...> ] ], q8_M4 ], 
  [ q8_M1^3, [ [ 5, <identity ...> ] ], q8_M3 ], 
  [ q8_M4^2, [ [ -8, <identity ...> ] ], q8_M1^2 ], 
  [ q8_M4*q8_M3, [ [ -7, q8_M3^-1*q8_M4^-1 ] ], q8_M1*q8_M4 ], 
  [ q8_M4*q8_M1, [ [ -8, <identity ...> ], [ 7, q8_M1^-1 ] ], q8_M1*q8_M2 ], 
  [ q8_M3*q8_M4, 
      [ [ -5, <identity ...> ], [ -6, q8_M1^-2 ], [ 8, <identity ...> ], 
          [ 7, q8_M3^-1*q8_M2^-1 ], [ -7, <identity ...> ] ], q8_M1*q8_M2 ], 
  [ q8_M3^2, [ [ -5, <identity ...> ] ], q8_M1^2 ], 
  [ q8_M3*q8_M2, [ [ -5, <identity ...> ], [ 8, q8_M1^-1 ] ], q8_M1*q8_M4 ], 
  [ q8_M2*q8_M3, [ [ -7, <identity ...> ] ], q8_M1*q8_M2 ], 
  [ q8_M2^2, [ [ -8, <identity ...> ], [ 6, q8_M1^-2 ] ], q8_M1^2 ], 
  [ q8_M2*q8_M1, [ [ 7, q8_M3^-1 ], [ -5, <identity ...> ], [ 8, q8_M1^-1 ] ],
      q8_M1*q8_M4 ] ]

## ====================== Monoid Polynomials ==================== 
gap> rels := RelatorsOfFpGroup( q8 ); 
[ f1^4, f2^4, f1*f2*f1*f2^-1, f1^2*f2^2 ]
gap> freeq8 := FreeGroupOfFpGroup( q8 );; 
gap> gens := GeneratorsOfGroup( freeq8 );;
gap> famfree := ElementsFamily( FamilyObj( freeq8 ) );; 
gap> famfree!.monoidPolyFam := MonoidPolyFam;; 
gap> cg := [6,7];; 
gap> pg := MonoidPolyFromCoeffsWords( cg, gens );; 
gap> Print( pg, "\n" ); 
7*f2 + 6*f1
gap> cr := [3,4,-5,-2];;
gap> pr := MonoidPolyFromCoeffsWords( cr, rels );; 
gap> Print( pr, "\n" );
4*f2^4 - 5*f1*f2*f1*f2^-1 - 2*f1^2*f2^2 + 3*f1^4
gap> Print( ZeroMonoidPoly( freeq8 ), "\n" );
zero monpoly 
gap> Coeffs( pr );
[ 4, -5, -2, 3 ]
gap> Terms( pr );
[ [ 4, f2^4 ], [ -5, f1*f2*f1*f2^-1 ], [ -2, f1^2*f2^2 ], [ 3, f1^4 ] ]
gap> Words( pr );
[ f2^4, f1*f2*f1*f2^-1, f1^2*f2^2, f1^4 ]
gap> LeadTerm( pr );
[ 4, f2^4 ]
gap> LeadCoeffMonoidPoly( pr );
4
gap> mpr := Monic( pr );; 
gap> Print( mpr, "\n" ); 
 f2^4 - 5/4*f1*f2*f1*f2^-1 - 1/2*f1^2*f2^2 + 3/4*f1^4
gap> w := gens[1]^gens[2]; 
f2^-1*f1*f2
gap> cw := 3/4;;  
gap> wpg := AddTermMonoidPoly( pg, cw, w );;
gap> Print( wpg, "\n" );
3/4*f2^-1*f1*f2 + 7*f2 + 6*f1
gap> pg = pg; 
true
gap> pg = pr;
false
gap> prcw := pr * cw;;
gap> Print( prcw, "\n" ); 
3*f2^4 - 15/4*f1*f2*f1*f2^-1 - 3/2*f1^2*f2^2 + 9/4*f1^4
gap> cwpr := cw * pr;;
gap> Print( cwpr, "\n" ); 
3*f2^4 - 15/4*f1*f2*f1*f2^-1 - 3/2*f1^2*f2^2 + 9/4*f1^4
gap> [ pr = prcw, prcw = cwpr ];
[ false, true ]
gap> Print( pg + pr, "\n" );
4*f2^4 - 5*f1*f2*f1*f2^-1 - 2*f1^2*f2^2 + 3*f1^4 + 7*f2 + 6*f1
gap> Print( pg - pr, "\n" );
 - 4*f2^4 + 5*f1*f2*f1*f2^-1 + 2*f1^2*f2^2 - 3*f1^4 + 7*f2 + 6*f1
gap> Print( pg * w, "\n" );
6*f1*f2^-1*f1*f2 + 7*f1*f2
gap> Print( pg * pr, "\n" );
28*f2^5 - 35*(f2*f1)^2*f2^-1 - 14*f2*f1^2*f2^2 + 21*f2*f1^4 + 24*f1*f2^4 - 
30*f1^2*f2*f1*f2^-1 - 12*f1^3*f2^2 + 18*f1^5
gap> Length( pr );
4
gap> pr > 3*pr; 
false
gap> pr > pg;
true
gap> M := genfgmon; 
[ q8_M1, q8_M2, q8_M3, q8_M4 ]
gap> mp1 := MonoidPolyFromCoeffsWords( [9,-7,5], [M[1]*M[3], M[2]^3, M[4]*M[3]*M[2]] );; 
gap> Print( mp1, "\n" ); 
5*q8_M4*q8_M3*q8_M2 - 7*q8_M2^3 + 9*q8_M1*q8_M3
gap> rmp1 := ReduceMonoidPoly( mp1, r2 );;
gap> Print( rmp1, "\n" ); 
 - 7*q8_M4 + 5*q8_M1 + 9*<identity ...>

## ====================== Module Polynomials ==================== 
gap> frq8 := FreeRelatorGroup( q8 );; 
gap> genfrq8 := GeneratorsOfGroup( frq8 ); 
[ q8_R1, q8_R2, q8_R3, q8_R4 ]
gap> Print( rmp1, "\n" ); 
 - 7*q8_M4 + 5*q8_M1 + 9*<identity ...>
gap> mp2 := MonoidPolyFromCoeffsWords( [4,-5], [ M[4], M[1] ] );;
gap> Print( mp2, "\n" ); 
4*q8_M4 - 5*q8_M1
gap> s1 := ModulePoly( [ genfrq8[4], genfrq8[1] ], [ rmp1, mp2 ] );
q8_R1*(4*q8_M4 - 5*q8_M1) + q8_R4*( - 7*q8_M4 + 5*q8_M1 + 9*<identity ...>)
gap> s2 := ModulePoly( [ genfrq8[3], genfrq8[2], genfrq8[1] ], 
>       [ -1*rmp1, 3*mp2, (rmp1+mp2) ] );
q8_R1*( - 3*q8_M4 + 9*<identity ...>) + q8_R2*(12*q8_M4 - 15*q8_M1) + q8_R3*(
7*q8_M4 - 5*q8_M1 - 9*<identity ...>)
gap> zeromp := ZeroModulePoly( frq8, freeq8 );
zero modpoly 
gap> [ Length(s1), Length(s2) ];
[ 2, 3 ]
gap> One( s1 );
<identity ...>
gap> Terms( s1 );
[ [ q8_R1, <monpoly> ], [ q8_R4, <monpoly> ] ]
gap> Print( LeadTerm( s1 ), "\n" );
[ q8_R4,  - 7*q8_M4 + 5*q8_M1 + 9*<identity ...> ]
gap> Print( LeadTerm( s2 ), "\n" );
[ q8_R3, 7*q8_M4 - 5*q8_M1 - 9*<identity ...> ]
gap> Print( LeadMonoidPoly( s1 ), "\n" );
 - 7*q8_M4 + 5*q8_M1 + 9*<identity ...>
gap> Print( LeadMonoidPoly( s2 ), "\n" );
7*q8_M4 - 5*q8_M1 - 9*<identity ...>
gap> mp0 := MonoidPolyFromCoeffsWords( [6], [ M[2] ] );;
gap> s0 := AddTermModulePoly( s1, genfrq8[3], mp0 ); 
q8_R1*(4*q8_M4 - 5*q8_M1) + q8_R3*(6*q8_M2) + q8_R4*( - 7*q8_M4 + 5*q8_M1 + 
9*<identity ...>)
gap> Print( s1 + s2, "\n" );
q8_R1*( q8_M4 - 5*q8_M1 + 9*<identity ...>) + q8_R2*(12*q8_M4 - 
15*q8_M1) + q8_R3*(7*q8_M4 - 5*q8_M1 - 9*<identity ...>) + q8_R4*( - 
7*q8_M4 + 5*q8_M1 + 9*<identity ...>)
gap> Print( s1 - s0, "\n" );
q8_R3*( - 6*q8_M2)
gap> Print( s1 * 1/2, "\n" );
q8_R1*(2*q8_M4 - 5/2*q8_M1) + q8_R4*( - 7/2*q8_M4 + 5/2*q8_M1 + 9/
2*<identity ...>)
gap> Print( s1 * M[1], "\n" );
q8_R1*(4*q8_M4*q8_M1 - 5*q8_M1^2) + q8_R4*( - 7*q8_M4*q8_M1 + 5*q8_M1^2 + 
9*q8_M1)

## ================= Identities among relators ========================== 
gap> yseqs := IdentityYSequences( q8 );;
gap> Length( yseqs );
32
gap> polys := IdentityModulePolys( q8 );;
gap> Length( polys );
22
gap> idsq8 := IdentitiesAmongRelators( q8 );;
gap> Length( idsq8 );
2
gap> Length( idsq8[1] );
7
gap> Display( idsq8[1] );
[ ( q8_Y3*( q8_M1*q8_M4), q8_R1*( q8_M1 - <identity ...>) ), 
  ( q8_Y10*( -q8_M1*q8_M4), q8_R2*( q8_M2 - <identity ...>) ), 
  ( q8_Y17*( <identity ...>), q8_R1*( -q8_M3 - q8_M2) + q8_R3*( q8_M1^2 + q8_M\
3 + q8_M1 + <identity ...>) ), 
  ( q8_Y31*( q8_M1*q8_M4), q8_R3*( q8_M3 - q8_M2) + q8_R4*( q8_M1 - <identity \
...>) ), 
  ( q8_Y32*( -q8_M1*q8_M4), q8_R2*( -q8_M1^2) + q8_R3*( -q8_M3 - <identity ...\
>) + q8_R4*( q8_M2 + <identity ...>) ), 
  ( q8_Y12*( q8_M1*q8_M4), q8_R1*( -q8_M2) + q8_R3*( q8_M1*q8_M2 + q8_M4) + q8\
_R4*( q8_M2 - <identity ...>) ), 
  ( q8_Y16*( -<identity ...>), q8_R1*( -<identity ...>) + q8_R2*( -q8_M1) + q8\
_R4*( q8_M3 + q8_M1) ) ]
gap> RootIdentities( q8 );
[ ( q8_Y3*( q8_M1*q8_M4), q8_R1*( q8_M1 - <identity ...>) ), 
  ( q8_Y10*( -q8_M1*q8_M4), q8_R2*( q8_M2 - <identity ...>) ) ]
gap> RootIdentities(s3);
[ ( s3_Y4*( s3_M2*s3_M1), s3_R1*( s3_M1 - <identity ...>) ), 
  ( s3_Y8*( s3_M2*s3_M1), s3_R2*( s3_M2 - <identity ...>) ), 
  ( s3_Y7*( s3_M2*s3_M1), s3_R3*( s3_M2 - s3_M1) ) ]
gap> STOP_TEST( "idrel_manual.tst", 43500 );
