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
gap> xx := F.1;;  yy := F.2;;  rr := F.3;; 
gap> rels := [ xx^2, yy^3, rr^2, (xx*rr)^2, (yy*rr)^2 ];; 
gap> q1 := F/rels;; 
gap> SetArrangementOfMonoidGenerators( q1, [2,-2,3,-3,1,-1] );
gap> SetName( q1, "q1" );
gap> frq1 := FreeRelatorGroup( q1 );;
gap> genq1 := GeneratorsOfGroup( q1 );;
gap> genfrq1 := GeneratorsOfGroup( frq1 );;
gap> frhomq1 := FreeRelatorHomomorphism( q1 ); 
[ q1_R1, q1_R2, q1_R3, q1_R4, q1_R5 ] -> 
[ f1^2, f2^3, f3^2, (f1*f3)^2, (f2*f3)^2 ]
gap> monq1 := MonoidPresentationFpGroup( q1 );
monoid presentation with group relators 
[ q1_M5^2, q1_M1^3, q1_M3^2, (q1_M5*q1_M3)^2, (q1_M1*q1_M3)^2 ]
gap> fgmon := FreeGroupOfPresentation( monq1 ); 
<free group on the generators [ q1_M1, q1_M2, q1_M3, q1_M4, q1_M5, q1_M6 ]>
gap> genfgmon := GeneratorsOfGroup( fgmon );; 
gap> gprels := GroupRelatorsOfPresentation( monq1 );;
gap> Print( "gprels = \n" );  PrintOneItemPerLine( gprels ); 
gprels = 
[ q1_M5^2,
  q1_M1^3,
  q1_M3^2,
  (q1_M5*q1_M3)^2,
  (q1_M1*q1_M3)^2 ]
gap> invrels := InverseRelatorsOfPresentation( monq1 );; 
gap> Print( "invrels = \n" );  PrintOneItemPerLine( invrels ); 
invrels = 
[ q1_M5*q1_M6,
  q1_M1*q1_M2,
  q1_M3*q1_M4,
  q1_M6*q1_M5,
  q1_M2*q1_M1,
  q1_M4*q1_M3 ]
gap> hompres := HomomorphismOfPresentation( monq1 ); 
[ q1_M1, q1_M2, q1_M3, q1_M4, q1_M5, q1_M6 ] -> 
[ f2, f2^-1, f3, f3^-1, f1, f1^-1 ]
gap> rws := RewritingSystemFpGroup( q1 );; 
gap> Print( "rws = \n" );  PrintOneItemPerLine( rws );
rws = 
[ [ q1_M1*q1_M2, <identity ...> ],
  [ q1_M2*q1_M1, <identity ...> ],
  [ q1_M5^2, <identity ...> ],
  [ q1_M3^2, <identity ...> ],
  [ q1_M2^2, q1_M1 ],
  [ q1_M1^2, q1_M2 ],
  [ q1_M5*q1_M2*q1_M3, q1_M3*q1_M5*q1_M1 ],
  [ q1_M5*q1_M1*q1_M3, q1_M3*q1_M5*q1_M2 ],
  [ q1_M5*q1_M3, q1_M3*q1_M5 ],
  [ q1_M3*q1_M2, q1_M1*q1_M3 ],
  [ q1_M3*q1_M1, q1_M2*q1_M3 ],
  [ q1_M6, q1_M5 ],
  [ q1_M4, q1_M3 ] ]

gap> l0 := InitialLoggedRules( q1); 
[ [ q1_M5*q1_M6, [  ], <identity ...> ], [ q1_M1*q1_M2, [  ], <identity ...> ]
    , [ q1_M3*q1_M4, [  ], <identity ...> ], 
  [ q1_M6*q1_M5, [  ], <identity ...> ], [ q1_M2*q1_M1, [  ], <identity ...> ]
    , [ q1_M4*q1_M3, [  ], <identity ...> ], 
  [ q1_M5^2, [ [ 7, <identity ...> ] ], <identity ...> ], 
  [ q1_M1^3, [ [ 8, <identity ...> ] ], <identity ...> ], 
  [ q1_M3^2, [ [ 9, <identity ...> ] ], <identity ...> ], 
  [ (q1_M5*q1_M3)^2, [ [ 10, <identity ...> ] ], <identity ...> ], 
  [ (q1_M1*q1_M3)^2, [ [ 11, <identity ...> ] ], <identity ...> ] ]
gap> logrws := LoggedRewritingSystemFpGroup( q1 );; 
gap> Print( "logrws = \n" );  PrintOneItemPerLine( logrws );
logrws = 
[ [ q1_M5^2, [ [ 7, <identity ...> ] ], <identity ...> ],
  [ q1_M3^2, [ [ 9, <identity ...> ] ], <identity ...> ],
  [ q1_M2*q1_M1, [  ], <identity ...> ],
  [ q1_M1*q1_M2, [  ], <identity ...> ],
  [ q1_M2^2, [ [ -8, <identity ...> ] ], q1_M1 ],
  [ q1_M1^2, [ [ 8, <identity ...> ] ], q1_M2 ],
  
[ q1_M5*q1_M2*q1_M3, 
  [ [ -11, q1_M1*q1_M6 ], [ 9, q1_M2*q1_M4*q1_M6 ], [ -9, <identity ...> ], 
      [ 10, q1_M5*q1_M4 ], [ -7, q1_M4 ] ], q1_M3*q1_M5*q1_M1 ],
  
[ q1_M5*q1_M1*q1_M3, 
  [ [ 7, <identity ...> ], [ -10, q1_M5 ], [ 11, q1_M1*q1_M6*q1_M4 ] ], 
  q1_M3*q1_M5*q1_M2 ],
  
[ q1_M5*q1_M3, [ [ -9, <identity ...> ], [ 10, q1_M5*q1_M4 ], [ -7, q1_M4 ] ],
  q1_M3*q1_M5 ],
  [ q1_M3*q1_M2, [ [ -11, q1_M1*q1_M4 ], [ 9, <identity ...> ] ], q1_M1*q1_M3 
 ],
  [ q1_M3*q1_M1, [ [ -9, q1_M2*q1_M4 ], [ 11, q1_M1 ] ], q1_M2*q1_M3 ],
  [ q1_M6, [ [ -7, <identity ...> ] ], q1_M5 ],
  [ q1_M4, [ [ -9, <identity ...> ] ], q1_M3 ] ]
gap> IdentityYSequencesKB( q1 );
[ [ 1, [ [ q1_R2^-1, <identity ...> ], [ q1_R2, f2 ] ] ], 
  [ 2, [ [ q1_R2, <identity ...> ], [ q1_R2^-1, f2^-1 ] ] ], 
  [ 7, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R3^-1, f2^-1*f3^-2 ], 
          [ q1_R3, <identity ...> ], [ q1_R3, f2^-1 ] ] ], 
  [ 4, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R5, f2*f3^-1 ], 
          [ q1_R5^-1, <identity ...> ], [ q1_R3, f2^-1*f3^-1*f2^-1 ] ] ], 
  [ 5, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R3, f2^-1*f3^-1*f2^-1 ], 
          [ q1_R3^-1, <identity ...> ], [ q1_R5, f2*f3^-1 ] ] ], 
  [ 11, 
      [ [ q1_R1^-1, <identity ...> ], [ q1_R3^-1, f1^-1 ], 
          [ q1_R4, f1*f3^-1*f1^-1 ], [ q1_R1^-1, f3^-1*f1^-1 ], 
          [ q1_R3^-1, <identity ...> ], [ q1_R4, f1*f3^-1 ] ] ], 
  [ 18, 
      [ [ q1_R1, <identity ...> ], [ q1_R4^-1, f1 ], [ q1_R3, f3 ], 
          [ q1_R3^-1, f3 ], [ q1_R4, f1 ], [ q1_R1^-1, <identity ...> ] ] ], 
  [ 8, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R5^-1, f2*f3^-2 ], 
          [ q1_R3, f3^-1 ], [ q1_R3^-1, f2^-1*f3^-1 ], [ q1_R5, f2 ], 
          [ q1_R3, f2 ] ] ], 
  [ 19, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R5^-1, f2*f1^-1*f3^-2 ], 
          [ q1_R3, <identity ...> ], [ q1_R3^-1, f2^-1*f3^-1*f1^-1 ], 
          [ q1_R5, f2*f1^-1 ], [ q1_R3, f2*f1^-1 ] ] ], 
  [ 12, 
      [ [ q1_R1^-1, <identity ...> ], [ q1_R1, f1^-1 ], 
          [ q1_R4^-1, <identity ...> ], [ q1_R5, f2*f1^-1*f3^-1*f1^-1 ], 
          [ q1_R3^-1, <identity ...> ], [ q1_R4, f1*f3^-1 ], 
          [ q1_R5^-1, f2*f3^-1 ], [ q1_R3, <identity ...> ] ] ], 
  [ 9, 
      [ [ q1_R1, <identity ...> ], [ q1_R4^-1, f1 ], [ q1_R3, f3 ], 
          [ q1_R5^-1, f2*f3^-1*f1^-1*f3 ], [ q1_R3, f1^-1*f3 ], 
          [ q1_R1, f3 ], [ q1_R4^-1, f1*f3 ], [ q1_R5, f2*f1^-1 ] ] ], 
  [ 6, 
      [ [ q1_R2^-1, <identity ...> ], [ q1_R3^-1, f2^-1 ], 
          [ q1_R5, f2*f3^-1*f2^-1 ], [ q1_R3^-1, <identity ...> ], 
          [ q1_R5, f2*f3^-1 ], [ q1_R2^-1, f3^-1 ], [ q1_R3^-1, f2^-1*f3^-1 ],
          [ q1_R5, f2 ] ] ], 
  [ 3, 
      [ [ q1_R2, <identity ...> ], [ q1_R5^-1, f2^2 ], 
          [ q1_R3, f2^-1*f3^-1*f2 ], [ q1_R5^-1, f2 ], [ q1_R3, f2^-1*f3^-1 ],
          [ q1_R2, f3^-1 ], [ q1_R5^-1, f2*f3^-1 ], [ q1_R3, <identity ...> ] 
         ] ], 
  [ 10, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R1, f3^-2 ], 
          [ q1_R4^-1, f1*f3^-2 ], [ q1_R3, f3^-1 ], [ q1_R1, f3^-1 ], 
          [ q1_R4^-1, f1*f3^-1 ], [ q1_R3, <identity ...> ], [ q1_R3, f1^-1 ] 
         ] ], 
  [ 16, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R1, f3^-2 ], 
          [ q1_R4^-1, f1*f3^-2 ], [ q1_R3, f3^-1 ], 
          [ q1_R3^-1, f2^-1*f3^-1*f1^-1*f3^-1 ], [ q1_R4, f1 ], 
          [ q1_R1^-1, <identity ...> ], [ q1_R3, f2^-1*f1^-1 ] ] ], 
  [ 14, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R4, f1*f3*f1*f2^-1 ], 
          [ q1_R1^-1, f3*f1*f2^-1 ], 
          [ q1_R3^-1, f2^-1*f3^-1*f2^-1*f1^-1*f3*f1*f2^-1 ], 
          [ q1_R5, f1^-1*f3*f1*f2^-1 ], [ q1_R3^-1, f3*f1*f2^-1 ], 
          [ q1_R4, f1^2*f2^-1 ], [ q1_R1^-1, f1*f2^-1 ] ] ], 
  [ 13, 
      [ [ q1_R1^-1, <identity ...> ], [ q1_R5^-1, f2*f1^-2 ], 
          [ q1_R3, f2^-1*f3^-1*f1^-2 ], [ q1_R3^-1, f1^-1 ], 
          [ q1_R4, f1*f3^-1*f1^-1 ], [ q1_R1^-1, f3^-1*f1^-1 ], 
          [ q1_R3^-1, <identity ...> ], [ q1_R4, f1*f3^-1 ], 
          [ q1_R3^-1, f2^-1*f3^-1 ], [ q1_R5, f2 ] ] ], 
  [ 17, [ [ q1_R2^-1, <identity ...> ], [ q1_R1, f1 ], [ q1_R4^-1, f1^2 ], 
          [ q1_R3, f3*f1 ], [ q1_R3^-1, f2^-1*f3^-1*f1^-1*f3*f1 ], 
          [ q1_R5, f2*f1^-1*f3*f1 ], [ q1_R3^-1, f2^-1*f3^-1*f2*f1^-1*f3*f1 ],
          [ q1_R5, f2^2*f1^-1*f3*f1 ], [ q1_R2^-1, f1^-1*f3*f1 ], 
          [ q1_R1, f3*f1 ], [ q1_R4^-1, f1*f3*f1 ], [ q1_R5, f2 ] ] ], 
  [ 15, [ [ q1_R2, <identity ...> ], [ q1_R5^-1, f2 ], [ q1_R4, f1*f3*f1 ], 
          [ q1_R1^-1, f3*f1 ], [ q1_R5^-1, f2*f3^-1*f2^-1*f1^-1*f3*f1 ], 
          [ q1_R3, f2^-1*f1^-1*f3*f1 ], [ q1_R2, f1^-1*f3*f1 ], 
          [ q1_R5^-1, f2*f1^-1*f3*f1 ], [ q1_R3, f2^-1*f3^-1*f1^-1*f3*f1 ], 
          [ q1_R3^-1, f3*f1 ], [ q1_R4, f1^2 ], [ q1_R1^-1, f1 ] ] ] ]
gap> bp := genfgmon[1];;
gap> bm := genfgmon[2];;
gap> cp := genfgmon[3];;
gap> cm := genfgmon[4];;
gap> ap := genfgmon[5];;
gap> am := genfgmon[6];;
gap> monrels := Concatenation( gprels, invrels );; 
gap> id := One( monrels[1] );;
gap> r0 := List( monrels, r -> [ r, id ] );; 
gap> w0 := ap^5 * bp^5 * cp^5; 
q1_M5^5*q1_M1^5*q1_M3^5
gap> w1 := OnePassReduceWord( w0, r0 ); 
q1_M5^3*q1_M1^2*q1_M3^3
gap> w2 := ReduceWordKB( w0, r0 ); 
q1_M5*q1_M1^2*q1_M3
gap> r1 := OnePassKB( r0 );
[ [ q1_M5^2, <identity ...> ], [ q1_M1^3, <identity ...> ], 
  [ q1_M3^2, <identity ...> ], [ (q1_M5*q1_M3)^2, <identity ...> ], 
  [ (q1_M1*q1_M3)^2, <identity ...> ], [ q1_M5*q1_M6, <identity ...> ], 
  [ q1_M1*q1_M2, <identity ...> ], [ q1_M3*q1_M4, <identity ...> ], 
  [ q1_M6*q1_M5, <identity ...> ], [ q1_M2*q1_M1, <identity ...> ], 
  [ q1_M4*q1_M3, <identity ...> ], [ q1_M3*q1_M5*q1_M3, q1_M5 ], 
  [ q1_M6, q1_M5 ], [ q1_M3*q1_M1*q1_M3, q1_M1^2 ], [ q1_M1^2, q1_M2 ], 
  [ q1_M4, q1_M3 ], [ q1_M5*q1_M3*q1_M5, q1_M3 ], 
  [ q1_M5*q1_M3*q1_M5, q1_M4 ], [ q1_M1*q1_M3*q1_M1, q1_M3 ], 
  [ q1_M1*q1_M3*q1_M1, q1_M4 ], [ q1_M6, q1_M5 ], 
  [ q1_M3*q1_M5*q1_M3, q1_M6 ], [ q1_M1^2, q1_M2 ], 
  [ q1_M3*q1_M1*q1_M3, q1_M2 ], [ q1_M4, q1_M3 ] ]
gap> Length( r1 );
25
gap> r2 := KnuthBendix( r1 );
[ [ q1_M4, q1_M3 ], [ q1_M6, q1_M5 ], [ q1_M1^2, q1_M2 ], 
  [ q1_M1*q1_M2, <identity ...> ], [ q1_M2*q1_M1, <identity ...> ], 
  [ q1_M2^2, q1_M1 ], [ q1_M3*q1_M1, q1_M2*q1_M3 ], 
  [ q1_M3*q1_M2, q1_M1*q1_M3 ], [ q1_M3^2, <identity ...> ], 
  [ q1_M5*q1_M3, q1_M3*q1_M5 ], [ q1_M5^2, <identity ...> ], 
  [ q1_M5*q1_M1*q1_M3, q1_M3*q1_M5*q1_M2 ], 
  [ q1_M5*q1_M2*q1_M3, q1_M3*q1_M5*q1_M1 ] ]
gap> Length( r2 );           
13
gap> w2 := ReduceWordKB( w0, r2 );
q1_M3*q1_M5*q1_M1

gap> lw1 := LoggedReduceWordKB( w0, logrws );
[ [ [ 7, <identity ...> ], [ 9, q1_M1^-5*q1_M5^-3 ], [ 8, q1_M5^-3 ], 
  [ 7, <identity ...> ], [ 9, q1_M1^-3*q1_M2^-1*q1_M5^-1 ], [ 8, q1_M5^-1 ], 
  [ -11, q1_M1*q1_M6 ], [ 9, q1_M2*q1_M4*q1_M6 ], [ -9, <identity ...> ], 
  [ 10, q1_M5*q1_M4 ], [ -7, q1_M4 ] ],
  q1_M3*q1_M5*q1_M1 ]

gap> PartialElementsOfMonoidPresentation( q1, 1 );  Length( last );
[ <identity ...>, q1_M1, q1_M2, q1_M3, q1_M5 ]
5
gap> PartialElementsOfMonoidPresentation( q1, 2 );  Length( last );
[ <identity ...>, q1_M1, q1_M2, q1_M3, q1_M5, q1_M1*q1_M3, q1_M1*q1_M5, 
  q1_M2*q1_M3, q1_M2*q1_M5, q1_M3*q1_M5, q1_M5*q1_M1, q1_M5*q1_M2 ]
12
gap> T := GenerationTree(q1);;
gap> ##  22 = 2*(12-1)
gap> Length( T );
22
gap> for i in [1..11] do Print( T[i+i-1], "   ", T[i+i], "\n" ); od;
[ <identity ...>, q1_M1 ]   [ q1_M1, q1_M2 ]
[ <identity ...>, q1_M2 ]   [ q1_M2, q1_M1 ]
[ <identity ...>, q1_M3 ]   [ q1_M3, q1_M4 ]
[ <identity ...>, q1_M5 ]   [ q1_M5, q1_M6 ]
[ q1_M1, q1_M3 ]   [ q1_M1*q1_M3, q1_M4 ]
[ q1_M1, q1_M5 ]   [ q1_M1*q1_M5, q1_M6 ]
[ q1_M2, q1_M3 ]   [ q1_M2*q1_M3, q1_M4 ]
[ q1_M2, q1_M5 ]   [ q1_M2*q1_M5, q1_M6 ]
[ q1_M3, q1_M5 ]   [ q1_M3*q1_M5, q1_M6 ]
[ q1_M5, q1_M1 ]   [ q1_M5*q1_M1, q1_M2 ]
[ q1_M5, q1_M2 ]   [ q1_M5*q1_M2, q1_M1 ]
gap> idsq1 := IdentityYSequences( q1 );                                  
[ [ 1, 32, [ [ q1_R1^-1, <identity ...> ], [ q1_R1, f1 ] ] ], 
  [ 2, 40, [ [ q1_R2^-1, <identity ...> ], [ q1_R2, f2^-1 ] ] ], 
  [ 3, 9, [ [ q1_R3^-1, <identity ...> ], [ q1_R3, f3 ] ] ], 
  [ 4, 34, [ [ q1_R4^-1, <identity ...> ], [ q1_R1, f1 ], [ q1_R4, f1^2 ], 
          [ q1_R1^-1, f1 ] ] ], 
  [ 5, 1, 
      [ [ q1_R4^-1, <identity ...> ], [ q1_R3^-1, <identity ...> ], 
          [ q1_R4, f1*f3^-1 ], [ q1_R3, <identity ...> ] ] ], 
  [ 6, 11, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R3^-1, f2^-1 ], [ q1_R5, f2*f3 ], 
          [ q1_R3, f2*f3 ] ] ], 
  [ 7, 43, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R3^-1, f1*f2^-1 ], 
          [ q1_R5, f2*f1^-1*f3^-2*f1*f2^-1 ], [ q1_R3, f1*f2^-1 ] ] ], 
  [ 8, 2, [ [ q1_R5^-1, <identity ...> ], [ q1_R3^-1, f2^-1*f3^-1*f2^-1 ], 
          [ q1_R5, <identity ...> ], [ q1_R3, <identity ...> ] ] ], 
  [ 9, 33, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R3^-1, f1 ], 
          [ q1_R4, f1*f3^-1*f1 ], [ q1_R1^-1, f3^-1*f1 ], [ q1_R4, f1^2 ], 
          [ q1_R1^-1, f1 ] ] ], 
  [ 10, 41, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R5^-1, <identity ...> ], 
          [ q1_R3, f2^-1*f3^-1*f2^-1 ], [ q1_R3^-1, f1*f2^-1 ], 
          [ q1_R5, f2*f1^-1*f3^-2*f1*f2^-1 ], [ q1_R3, f1*f2^-1 ] ] ], 
  [ 11, 30, 
      [ [ q1_R4^-1, <identity ...> ], [ q1_R1, f1 ], [ q1_R3^-1, f3^-1*f1 ], 
          [ q1_R4, f1*f3^-2*f1 ], [ q1_R1^-1, f3^-2*f1 ], [ q1_R3, f1 ] ] ], 
  [ 12, 10, 
      [ [ q1_R4^-1, <identity ...> ], [ q1_R3^-1, <identity ...> ], 
          [ q1_R4, f1*f3^-1 ], [ q1_R1^-1, f3^-1 ], [ q1_R3, f3 ], 
          [ q1_R1, f3 ] ] ], 
  [ 13, 35, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R1, f1 ], [ q1_R4^-1, f1^2 ], 
          [ q1_R5, f2*f1^-1*f3^-1*f1 ], [ q1_R4, f1^2 ], [ q1_R1^-1, f1 ] ] ],
  [ 14, 5, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R2, f2 ], 
          [ q1_R3^-1, f2^-1*f3^-1*f2^2 ], [ q1_R5, f2^3 ], [ q1_R2^-1, f2 ], 
          [ q1_R3, <identity ...> ] ] ], 
  [ 15, 27, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R3^-1, f2^-1 ], [ q1_R5, f2*f3 ], 
          [ q1_R2^-1, f2^-1*f3 ], [ q1_R3, f2^-2*f3 ], [ q1_R2, f2^-1*f3 ] ] ]
    , 
  [ 16, 24, 
      [ [ q1_R2^-1, <identity ...> ], [ q1_R3^-1, f2^-1 ], [ q1_R5, f2*f3 ], 
          [ q1_R2^-1, f2^-1*f3 ], [ q1_R3^-1, f2^-1*f3^-1*f2^-2*f3 ], 
          [ q1_R5, f2^-1*f3 ], [ q1_R3^-1, f2^-1*f3^-1*f2^-1*f3 ], 
          [ q1_R5, f3 ] ] ], 
  [ 17, 8, 
      [ [ q1_R2^-1, <identity ...> ], [ q1_R3^-1, f2^-1 ], [ q1_R5, f2*f3 ], 
          [ q1_R3^-1, f2^-1*f3^-1*f2*f3 ], [ q1_R5, f2^2*f3 ], 
          [ q1_R2^-1, f3 ], [ q1_R3^-1, f2^-1*f3^-1*f2^-1*f3 ], [ q1_R5, f3 ] 
         ] ], 
  [ 18, 16, 
      [ [ q1_R2^-1, <identity ...> ], [ q1_R3^-1, f2^-1 ], [ q1_R5, f2*f3 ], 
          [ q1_R3^-1, f2^-1*f3^-1*f2*f3 ], [ q1_R5, f2^2*f3 ], 
          [ q1_R3^-1, f2^-1*f3^-1*f2^2*f3 ], [ q1_R5, f2^3*f3 ], 
          [ q1_R2^-1, f2*f3 ] ] ], 
  [ 19, 37, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R1, f1*f2 ], [ q1_R4^-1, f1^2*f2 ],
          [ q1_R3, f2^-1*f3^-1*f1^-1*f3^-1*f1*f2 ], [ q1_R3^-1, f3^-1*f1*f2 ],
          [ q1_R4, f1*f3^-2*f1*f2 ], [ q1_R1^-1, f3^-2*f1*f2 ], 
          [ q1_R3, f1*f2 ] ] ], 
  [ 20, 13, 
      [ [ q1_R3^-1, <identity ...> ], [ q1_R3^-1, f1 ], 
          [ q1_R4, f1*f3^-1*f1 ], [ q1_R1^-1, f3^-1*f1 ], 
          [ q1_R3^-1, f3^-1*f1 ], [ q1_R4, f1*f3^-2*f1 ], 
          [ q1_R1^-1, f3^-2*f1 ], [ q1_R3, f1 ] ] ], 
  [ 21, 31, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R1, f1 ], [ q1_R4^-1, f1^2 ], 
          [ q1_R5, f2*f1^-1*f3^-1*f1 ], [ q1_R3^-1, f3^-1*f1 ], 
          [ q1_R4, f1*f3^-2*f1 ], [ q1_R1^-1, f3^-2*f1 ], [ q1_R3, f1 ] ] ], 
  [ 22, 38, 
      [ [ q1_R4^-1, <identity ...> ], [ q1_R3^-1, <identity ...> ], 
          [ q1_R4, f1*f3^-1 ], [ q1_R1^-1, f3^-1 ], [ q1_R1, f1*f2 ], 
          [ q1_R4^-1, f1^2*f2 ], [ q1_R5, f2*f1^-1*f3^-1*f1*f2 ], 
          [ q1_R1, f2*f1^-1*f3^-1*f1*f2 ], [ q1_R5^-1, f2*f1^-1*f3^-1*f1*f2 ],
          [ q1_R3, f2^-1*f3^-1*f1^-1*f3^-1*f1*f2 ], [ q1_R3^-1, f3^-1*f1*f2 ],
          [ q1_R4, f1*f3^-2*f1*f2 ], [ q1_R1^-1, f3^-2*f1*f2 ], 
          [ q1_R3, f1*f2 ] ] ], 
  [ 23, 42, 
      [ [ q1_R4^-1, <identity ...> ], [ q1_R3^-1, <identity ...> ], 
          [ q1_R4, f1*f3^-1 ], [ q1_R1^-1, f3^-1 ], 
          [ q1_R5^-1, <identity ...> ], [ q1_R3, f2^-1*f3^-1*f2^-1 ], 
          [ q1_R3^-1, f1*f2^-1 ], [ q1_R4, f1*f3^-1*f1*f2^-1 ], 
          [ q1_R1^-1, f3^-1*f1*f2^-1 ], [ q1_R1, f2^-1*f1^-1*f3^-1*f1*f2^-1 ],
          [ q1_R1, f3^-1*f1*f2^-1 ], [ q1_R4^-1, f1*f3^-1*f1*f2^-1 ], 
          [ q1_R5, f2*f1^-1*f3^-2*f1*f2^-1 ], [ q1_R3, f1*f2^-1 ] ] ], 
  [ 24, 39, 
      [ [ q1_R5^-1, <identity ...> ], [ q1_R2, f2 ], [ q1_R5^-1, f2^2 ], 
          [ q1_R3, f2^-1*f3^-1*f2 ], [ q1_R3^-1, f1*f2 ], 
          [ q1_R4, f1*f3^-1*f1*f2 ], [ q1_R1^-1, f3^-1*f1*f2 ], 
          [ q1_R2, f1^-1*f3^-1*f1*f2 ], [ q1_R5^-1, f2*f1^-1*f3^-1*f1*f2 ], 
          [ q1_R3, f2^-1*f3^-1*f1^-1*f3^-1*f1*f2 ], [ q1_R3^-1, f3^-1*f1*f2 ],
          [ q1_R4, f1*f3^-2*f1*f2 ], [ q1_R1^-1, f3^-2*f1*f2 ], 
          [ q1_R3, f1*f2 ] ] ] ]

gap> SetInfoLevel( InfoIdRel, idrel_save_level );;

#############################################################################
##
#E  simsek.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
