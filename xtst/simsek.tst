##############################################################################
##
#W  simsek.tst                 Idrel Package                     Chris Wensley
#W                                                             & Anne Heyworth
##
#Y  Copyright (C) 2018 Anne Heyworth and Chris Wensley
##
##  runs an example emailed by Merve Simsek in June 2017 
##  to construct a logged rewrite system 

gap> idrel_save_level := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

gap> F := FreeGroup(3);;
gap> u := F.1;;  v := F.2;;  w := F.3;; 
gap> rels := [ u^3, v^2, w^2, (u*v)^2, (v*w)^2 ];; 
gap> q0 := F/rels;; 
gap> SetArrangementOfMonoidGenerators( q0, [1,-1,2,-2,3,-3] );
gap> SetName( q0, "q0" );
gap> frq0 := FreeRelatorGroup( q0 );;
gap> genq0 := GeneratorsOfGroup( q0 );;
gap> genfrq0 := GeneratorsOfGroup( frq0 );;
gap> frhomq0 := FreeRelatorHomomorphism( q0 ); 
[ q0_R1, q0_R2, q0_R3, q0_R4, q0_R5 ] -> 
[ f1^3, f2^2, f3^2, (f1*f2)^2, (f2*f3)^2 ]
gap> monq0 := MonoidPresentationFpGroup( q0 );
monoid presentation with group relators 
[ q0_M1^3, q0_M3^2, q0_M5^2, (q0_M1*q0_M3)^2, (q0_M3*q0_M5)^2 ]
gap> fgmon := FreeGroupOfPresentation( monq0 ); 
<free group on the generators [ q0_M1, q0_M2, q0_M3, q0_M4, q0_M5, q0_M6 ]>
gap> genfgmon := GeneratorsOfGroup( fgmon );; 
gap> gprels := GroupRelatorsOfPresentation( monq0 );;
gap> Perform( gprels, Display ); 
q0_M1^3
q0_M3^2
q0_M5^2
(q0_M1*q0_M3)^2
(q0_M3*q0_M5)^2
gap> invrels := InverseRelatorsOfPresentation( monq0 );; 
gap> Perform( invrels, Display ); 
q0_M1*q0_M2
q0_M3*q0_M4
q0_M5*q0_M6
q0_M2*q0_M1
q0_M4*q0_M3
q0_M6*q0_M5
gap> hompres := HomomorphismOfPresentation( monq0 ); 
[ q0_M1, q0_M2, q0_M3, q0_M4, q0_M5, q0_M6 ] -> 
[ f1, f1^-1, f2, f2^-1, f3, f3^-1 ]
gap> rws := RewritingSystemFpGroup( q0 );; 
gap> Perform( rws, Display );
[ q0_M1*q0_M2, <identity ...> ]
[ q0_M2*q0_M1, <identity ...> ]
[ q0_M5^2, <identity ...> ]
[ q0_M3^2, <identity ...> ]
[ q0_M2^2, q0_M1 ]
[ q0_M1^2, q0_M2 ]
[ q0_M5*q0_M2*q0_M3, q0_M3*q0_M5*q0_M1 ]
[ q0_M5*q0_M1*q0_M3, q0_M3*q0_M5*q0_M2 ]
[ q0_M5*q0_M3, q0_M3*q0_M5 ]
[ q0_M3*q0_M2, q0_M1*q0_M3 ]
[ q0_M3*q0_M1, q0_M2*q0_M3 ]
[ q0_M6, q0_M5 ]
[ q0_M4, q0_M3 ]
gap> l0 := InitialLoggedRules( q0);;
gap> Perform( l0, Display ); 
[ q0_M1*q0_M2, [  ], <identity ...> ]
[ q0_M3*q0_M4, [  ], <identity ...> ]
[ q0_M5*q0_M6, [  ], <identity ...> ]
[ q0_M2*q0_M1, [  ], <identity ...> ]
[ q0_M4*q0_M3, [  ], <identity ...> ]
[ q0_M6*q0_M5, [  ], <identity ...> ]
[ q0_M1^3, [ [ 7, <identity ...> ] ], <identity ...> ]
[ q0_M3^2, [ [ 8, <identity ...> ] ], <identity ...> ]
[ q0_M5^2, [ [ 9, <identity ...> ] ], <identity ...> ]
[ (q0_M1*q0_M3)^2, [ [ 10, <identity ...> ] ], <identity ...> ]
[ (q0_M3*q0_M5)^2, [ [ 11, <identity ...> ] ], <identity ...> ]
gap> logrws := LoggedRewritingSystemFpGroup( q0 );; 
gap> Perform( logrws, Display );
[ q0_M5^2, [ [ 9, <identity ...> ] ], <identity ...> ]
[ q0_M3^2, [ [ 8, <identity ...> ] ], <identity ...> ]
[ q0_M2*q0_M1, [  ], <identity ...> ]
[ q0_M1*q0_M2, [  ], <identity ...> ]
[ q0_M2^2, [ [ -7, <identity ...> ] ], q0_M1 ]
[ q0_M1^2, [ [ 7, <identity ...> ] ], q0_M2 ]
[ q0_M5*q0_M2*q0_M3, 
  [ [ -10, q0_M1*q0_M6 ], [ 8, q0_M2*q0_M4*q0_M6 ], [ -9, q0_M4*q0_M6 ], 
      [ 11, q0_M3 ], [ -8, <identity ...> ] ], q0_M3*q0_M5*q0_M1 ]
[ q0_M5*q0_M1*q0_M3, 
  [ [ 9, <identity ...> ], [ -11, <identity ...> ], [ 10, q0_M1*q0_M6*q0_M4 ] 
     ], q0_M3*q0_M5*q0_M2 ]
[ q0_M5*q0_M3, [ [ -9, q0_M4*q0_M6 ], [ 11, q0_M3 ], [ -8, <identity ...> ] ],
  q0_M3*q0_M5 ]
[ q0_M3*q0_M2, [ [ -10, q0_M1*q0_M4 ], [ 8, <identity ...> ] ], q0_M1*q0_M3 ]
[ q0_M3*q0_M1, [ [ -8, q0_M2*q0_M4 ], [ 10, q0_M1 ] ], q0_M2*q0_M3 ]
[ q0_M6, [ [ -9, <identity ...> ] ], q0_M5 ]
[ q0_M4, [ [ -8, <identity ...> ] ], q0_M3 ]
gap> up := genfgmon[1];;
gap> um := genfgmon[2];;
gap> vp := genfgmon[3];;
gap> vm := genfgmon[4];;
gap> wp := genfgmon[5];;
gap> wm := genfgmon[6];;
gap> monrels := Concatenation( gprels, invrels );; 
gap> id := One( monrels[1] );; 
gap> r0 := List( monrels, r -> [ r, id ] );; 
gap> w0 := up^5 * vp^5 * wp^5; 
q0_M1^5*q0_M3^5*q0_M5^5
gap> w1 := OnePassReduceWord( w0, r0 ); 
q0_M1^2*q0_M3^3*q0_M5^3
gap> w2 := ReduceWordKB( w0, r0 ); 
q0_M1^2*q0_M3*q0_M5
gap> r1 := OnePassKB( r0 );; 
gap> Perform( r1, Display ); 
[ q0_M1^3, <identity ...> ]
[ q0_M3^2, <identity ...> ]
[ q0_M5^2, <identity ...> ]
[ (q0_M1*q0_M3)^2, <identity ...> ]
[ (q0_M3*q0_M5)^2, <identity ...> ]
[ q0_M1*q0_M2, <identity ...> ]
[ q0_M3*q0_M4, <identity ...> ]
[ q0_M5*q0_M6, <identity ...> ]
[ q0_M2*q0_M1, <identity ...> ]
[ q0_M4*q0_M3, <identity ...> ]
[ q0_M6*q0_M5, <identity ...> ]
[ q0_M3*q0_M1*q0_M3, q0_M1^2 ]
[ q0_M1^2, q0_M2 ]
[ q0_M5*q0_M3*q0_M5, q0_M3 ]
[ q0_M4, q0_M3 ]
[ q0_M6, q0_M5 ]
[ q0_M1*q0_M3*q0_M1, q0_M3 ]
[ q0_M5*q0_M3*q0_M5, q0_M1*q0_M3*q0_M1 ]
[ q0_M1*q0_M3*q0_M1, q0_M4 ]
[ q0_M3*q0_M5*q0_M3, q0_M5 ]
[ q0_M3*q0_M5*q0_M3, q0_M6 ]
[ q0_M1^2, q0_M2 ]
[ q0_M3*q0_M1*q0_M3, q0_M2 ]
[ q0_M4, q0_M3 ]
[ q0_M5*q0_M3*q0_M5, q0_M4 ]
[ q0_M6, q0_M5 ]
gap> Length( r1 );
26
gap> r2 := KnuthBendix( r1 );;
gap> Perform( r2, Display );
[ q0_M4, q0_M3 ]
[ q0_M6, q0_M5 ]
[ q0_M1^2, q0_M2 ]
[ q0_M1*q0_M2, <identity ...> ]
[ q0_M2*q0_M1, <identity ...> ]
[ q0_M2^2, q0_M1 ]
[ q0_M3*q0_M1, q0_M2*q0_M3 ]
[ q0_M3*q0_M2, q0_M1*q0_M3 ]
[ q0_M3^2, <identity ...> ]
[ q0_M5*q0_M3, q0_M3*q0_M5 ]
[ q0_M5^2, <identity ...> ]
[ q0_M5*q0_M1*q0_M3, q0_M3*q0_M5*q0_M2 ]
[ q0_M5*q0_M2*q0_M3, q0_M3*q0_M5*q0_M1 ]
gap> Length( r2 );           
13
gap> w2 := ReduceWordKB( w0, r2 );
q0_M2*q0_M3*q0_M5
gap> lw1 := LoggedReduceWordKB( w0, logrws );
[ [ [ 9, q0_M3^-5*q0_M1^-5 ], [ 8, q0_M1^-5 ], [ 7, <identity ...> ], 
      [ 9, q0_M3^-3*q0_M1^-3*q0_M2^-1 ], [ 8, q0_M1^-3*q0_M2^-1 ], 
      [ 7, <identity ...> ] ], q0_M2*q0_M3*q0_M5 ]
gap> PartialElementsOfMonoidPresentation( q0, 1 );  Length( last );
[ <identity ...>, q0_M1, q0_M2, q0_M3, q0_M5 ]
5
gap> PartialElementsOfMonoidPresentation( q0, 2 );  Length( last );
[ <identity ...>, q0_M1, q0_M2, q0_M3, q0_M5, q0_M1*q0_M3, q0_M1*q0_M5, 
  q0_M2*q0_M3, q0_M2*q0_M5, q0_M3*q0_M5, q0_M5*q0_M1, q0_M5*q0_M2 ]
12
gap> T := GenerationTree( q0 );;
gap> ##  22 = 2*(12-1)
gap> Length( T );
22
gap> for i in [1..11] do Print( T[i+i-1], "   ", T[i+i], "\n" ); od;
[ <identity ...>, q0_M1 ]   [ q0_M1, q0_M2 ]
[ <identity ...>, q0_M2 ]   [ q0_M2, q0_M1 ]
[ <identity ...>, q0_M3 ]   [ q0_M3, q0_M4 ]
[ <identity ...>, q0_M5 ]   [ q0_M5, q0_M6 ]
[ q0_M1, q0_M3 ]   [ q0_M1*q0_M3, q0_M4 ]
[ q0_M1, q0_M5 ]   [ q0_M1*q0_M5, q0_M6 ]
[ q0_M2, q0_M3 ]   [ q0_M2*q0_M3, q0_M4 ]
[ q0_M2, q0_M5 ]   [ q0_M2*q0_M5, q0_M6 ]
[ q0_M3, q0_M5 ]   [ q0_M3*q0_M5, q0_M6 ]
[ q0_M5, q0_M1 ]   [ q0_M5*q0_M1, q0_M2 ]
[ q0_M5, q0_M2 ]   [ q0_M5*q0_M2, q0_M1 ]
gap> seq0 := IdentityRelatorSequences( q0 );;
gap> Length( seq0 );                                  
24
gap> idsq0 := IdentitiesAmongRelators( q0 );;
gap> Perform( idsq0, Display );
[ [ q0_R1^-1, <identity ...> ], [ q0_R1, f1^-1 ] ]
[ [ q0_R2^-1, <identity ...> ], [ q0_R2, f2 ] ]
[ [ q0_R3^-1, <identity ...> ], [ q0_R3, f3 ] ]
[ [ q0_R4^-1, <identity ...> ], [ q0_R2^-1, f1^-1 ], [ q0_R4, f1*f2 ], 
  [ q0_R2, f1*f2 ] ]
[ [ q0_R5^-1, <identity ...> ], [ q0_R3^-1, f2^-1 ], [ q0_R5, f2*f3 ], 
  [ q0_R3, f2*f3 ] ]
[ [ q0_R1^-1, <identity ...> ], [ q0_R2^-1, f1^-1 ], [ q0_R4, f1*f2 ], 
  [ q0_R2^-1, f1^-1*f2^-1*f1*f2 ], [ q0_R4, f1^2*f2 ], [ q0_R1^-1, f2 ], 
  [ q0_R2^-1, f1^-1*f2^-1*f1^-1*f2 ], [ q0_R4, f2 ] ]
[ [ q0_R2^-1, <identity ...> ], [ q0_R3^-1, f2^-1 ], [ q0_R5, f2*f3 ], 
  [ q0_R2^-1, f3 ], [ q0_R3^-1, f2^-1*f3^-1*f2^-1*f3 ], [ q0_R5, f3 ] ]
gap> Length( idsq0 );
7
gap> idsKBq0 := IdentitiesAmongRelatorsKB( q0 );;
gap> Perform( idsKBq0, Display );
[ [ q0_R1^-1, f1^-1 ], [ q0_R1, <identity ...> ] ]
[ [ q0_R2^-1, <identity ...> ], [ q0_R4^-1, f1*f2^-2 ], [ q0_R2, f2^-1 ], 
  [ q0_R2^-1, f1^-1*f2^-1 ], [ q0_R4, f1 ], [ q0_R2, f1 ] ]
[ [ q0_R2^-1, <identity ...> ], [ q0_R2, f2^-1 ], 
  [ q0_R5^-1, <identity ...> ], [ q0_R3, f2^-1*f3^-1*f2^-1 ], 
  [ q0_R2^-1, f1^-1*f2^-1*f3^-1*f2^-1 ], [ q0_R5, <identity ...> ], 
  [ q0_R3^-1, <identity ...> ], [ q0_R2, f1^-1*f3^-1 ] ]
[ [ q0_R2^-1, <identity ...> ], [ q0_R4^-1, f1*f3^-1*f2^-2 ], 
  [ q0_R5, f2^-1 ], [ q0_R3^-1, f2^-1 ], [ q0_R2, <identity ...> ], 
  [ q0_R5^-1, f2 ], [ q0_R3, f2^-1*f3^-1 ], [ q0_R2^-1, f1^-1*f2^-1*f3^-1 ], 
  [ q0_R4, f1*f3^-1 ], [ q0_R2, f1*f3^-1 ] ]
[ [ q0_R2^-1, f1 ], [ q0_R4, f1*f2^-1*f1 ], [ q0_R4^-1, f1 ], 
  [ q0_R2, f1^-1*f2^-1 ] ]
[ [ q0_R3^-1, <identity ...> ], [ q0_R3, f3^-1 ], [ q0_R5^-1, f3^-1 ], 
  [ q0_R4, f1*f3^-1*f2^-1*f3^-1 ], [ q0_R3^-1, f2^-1*f3^-1 ], [ q0_R5, f2 ], 
  [ q0_R2^-1, <identity ...> ], [ q0_R3, f2^-1 ], [ q0_R4^-1, f1*f2^-1 ], 
  [ q0_R2, <identity ...> ] ]
[ [ q0_R1, <identity ...> ], [ q0_R4^-1, f1^2 ], [ q0_R2, f1^-1*f2^-1*f1 ], 
  [ q0_R4^-1, f1 ], [ q0_R2, f1^-1*f2^-1 ], [ q0_R1, f2^-1 ], 
  [ q0_R4^-1, f1*f2^-1 ], [ q0_R2, <identity ...> ] ]
[ [ q0_R2, <identity ...> ], [ q0_R5^-1, f2 ], [ q0_R3, f2^-1*f3^-1 ], 
  [ q0_R4^-1, f1*f2^-1*f3^-1 ], [ q0_R2, f3^-1 ], [ q0_R3, <identity ...> ], 
  [ q0_R5^-1, <identity ...> ], [ q0_R4, f1*f3^-1*f2^-1 ] ]
[ [ q0_R3^-1, <identity ...> ], [ q0_R3^-1, f2^-1*f3^-2 ], 
  [ q0_R5, f2*f3^-1 ], [ q0_R2^-1, f3^-1 ], [ q0_R3^-1, f2^-1*f3^-1 ], 
  [ q0_R5, f2 ], [ q0_R2^-1, <identity ...> ], [ q0_R3, f2^-1 ] ]
[ [ q0_R3^-1, <identity ...> ], [ q0_R4^-1, f1*f3^-2 ], 
  [ q0_R2, f1^-1*f2^-1*f3^-2 ], [ q0_R3^-1, f2^-1*f3^-2 ], 
  [ q0_R5, f2*f3^-1 ], [ q0_R2^-1, f3^-1 ], [ q0_R3^-1, f2^-1*f3^-1 ], 
  [ q0_R5, f2 ], [ q0_R2^-1, <identity ...> ], [ q0_R3, f2^-1 ], 
  [ q0_R2^-1, f1^-1*f2^-1 ], [ q0_R4, f1 ] ]
[ [ q0_R4^-1, f1*f3^-1*f2^-1 ], [ q0_R5, <identity ...> ], 
  [ q0_R3^-1, <identity ...> ], [ q0_R2^-1, f1^-1*f2^-1*f1^-1*f3^-1 ], 
  [ q0_R4, f3^-1 ], [ q0_R3^-1, f2^-1*f3^-1 ], [ q0_R5, f2 ], 
  [ q0_R2^-1, <identity ...> ] ]
gap> Length( idsKBq0 );
11

gap> SetInfoLevel( InfoIdRel, idrel_save_level );;

#############################################################################
##
#E  simsek.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
