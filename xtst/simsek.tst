##############################################################################
##
#W  simsek.tst                 Idrel Package                     Chris Wensley
#W                                                             & Anne Heyworth
##
#Y  Copyright (C) 2018-2022 Anne Heyworth and Chris Wensley
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
gap> mq0 := MonoidPresentationFpGroup( q0 );
monoid presentation with group relators 
[ q0_M1^3, q0_M3^2, q0_M5^2, (q0_M1*q0_M3)^2, (q0_M3*q0_M5)^2 ]
gap> fmq0 := FreeGroupOfPresentation( mq0 ); 
<free group on the generators [ q0_M1, q0_M2, q0_M3, q0_M4, q0_M5, q0_M6 ]>
gap> gfmq0 := GeneratorsOfGroup( fmq0 );; 
gap> q0labs := [ "a", "A", "b", "B", "c", "C" ];;  
gap> SetMonoidPresentationLabels( q0, q0labs ); 
gap> gprels := GroupRelatorsOfPresentation( mq0 );;
gap> Perform( gprels, Display ); 
q0_M1^3
q0_M3^2
q0_M5^2
(q0_M1*q0_M3)^2
(q0_M3*q0_M5)^2
gap> invrels := InverseRelatorsOfPresentation( mq0 );; 
gap> Perform( invrels, Display ); 
q0_M1*q0_M2
q0_M3*q0_M4
q0_M5*q0_M6
q0_M2*q0_M1
q0_M4*q0_M3
q0_M6*q0_M5
gap> hompres := HomomorphismOfPresentation( mq0 ); 
[ q0_M1, q0_M2, q0_M3, q0_M4, q0_M5, q0_M6 ] -> 
[ f1, f1^-1, f2, f2^-1, f3, f3^-1 ]
gap> rws := RewritingSystemFpGroup( q0 );; 
gap> PrintLnUsingLabels( rws, gfmq0, q0labs );
[ [ a^-1, A ], [ A^-1, a ], [ b^-1, b ], [ B^-1, b ], [ B, b ], 
[ c^-1, c ], [ C^-1, c ], [ C, c ], [ a*A, id ], [ A*a, id ], 
[ b^2, id ], [ c^2, id ], [ a^2, A ], [ A^2, a ], [ b*a, A*b ], 
[ b*A, a*b ], [ c*b, b*c ], [ c*a*b, b*c*A ], [ c*A*b, b*c*a ] ]
gap> l0 := InitialLoggedRulesOfPresentation( mq0 );;
gap> PrintLnUsingLabels( l0, gfmq0, q0labs );
[ [ a^-1, [ ], A ], [ A^-1, [ ], a ], [ b^-1, [ ], B ], [ B^-1, 
[ ], b ], [ c^-1, [ ], C ], [ C^-1, [ ], c ], [ a*A, [ ], id ], 
[ A*a, [ ], id ], [ b^2, [ [ 14, id ] ], id ], [ b*B, [ ], id ], 
[ B*b, [ ], id ], [ c^2, [ [ 15, id ] ], id ], [ c*C, [ ], id ], 
[ C*c, [ ], id ], [ a^3, [ [ 13, id ] ], id ], [ (a*b)^2, [ [ 
16, id ] ], id ], 
[ (b*c)^2, [ [ 17, id ] ], id ] ]
gap> logrws := LoggedRewritingSystemFpGroup( q0 );; 
gap> PrintLnUsingLabels( logrws, gfmq0, q0labs );
[ [ a^-1, [ ], A ], [ A^-1, [ ], a ], [ b^-1, [ [ -14, b ] ], b ], 
[ B^-1, [ ], b ], [ B, [ [ -14, b ] ], b ], [ c^-1, [ [ -15, c ] ], c ], 
[ C^-1, [ ], c ], [ C, [ [ -15, c ] ], c ], [ a*A, [ ], id ], 
[ A*a, [ ], id ], [ b^2, [ [ 14, id ] ], id ], [ c^2, [ [ 15, id ] ], id ], 
[ a^2, [ [ 13, id ] ], A ], [ A^2, [ [ -13, id ] ], a ], [ b*a, 
[ [ -14, A*B ], [ 16, a ] ], A*b ], [ b*A, [ [ -16, id ], [ 14, A*B*A ] ], 
a*b ], [ c*b, [ [ -17, id ], [ 15, B*C*B ], [ 14, C*B ] ], b*c ], 
[ c*a*b, [ [ -17, id ], [ 15, B*C*B ], [ 16, a*C*B ] ], b*c*A ], 
[ c*A*b, [ [ -16, a*C ], [ 14, A*B*C ], [ -17, id ], [ 15, B*C*B ], 
[ 14, C*B ] ], b*c*a ] ]
gap> up := gfmq0[1];;
gap> um := gfmq0[2];;
gap> vp := gfmq0[3];;
gap> vm := gfmq0[4];;
gap> wp := gfmq0[5];;
gap> wm := gfmq0[6];;
gap> monrels := Concatenation( gprels, invrels );; 
gap> id := One( monrels[1] );; 
gap> r0 := List( monrels, r -> [ r, id ] );; 
gap> w0 := up^5 * vp^5 * wp^5; 
q0_M1^5*q0_M3^5*q0_M5^5
gap> w1 := OnePassReduceWord( w0, r0 ); 
q0_M1^2*q0_M3^3*q0_M5^3
gap> w2 := ReduceWordKB( w0, r0 ); 
q0_M1^2*q0_M3*q0_M5
gap> r1 := OnePassKB( mq0, r0 );; 
gap> PrintLnUsingLabels( r1, gfmq0, q0labs ); 
[ [ B, b ], [ C, c ], [ a*A, id ], [ A*a, id ], [ b^2, id ], 
[ b*B, id ], [ B*b, id ], [ c^2, id ], [ c*C, id ], [ C*c, id ], 
[ a^2, A ], [ a^3, id ], [ a*b*a, b ], [ a*b*a, B ], [ b*a*b, A ], 
[ b*c*b, c ], [ b*c*b, C ], [ c*b*c, b ], [ c*b*c, B ], [ b*a*b, a^2 ], 
[ c*b*c, a*b*a ], [ (a*b)^2, id ], [ (b*c)^2, id ] ]
gap> Length( r1 );
23
gap> r2 := KnuthBendix( mq0, r1 );;
gap> PrintLnUsingLabels( r2, gfmq0, q0labs );
[ [ B, b ], [ C, c ], [ a*A, id ], [ A*a, id ], [ b^2, id ], 
[ c^2, id ], [ a^2, A ], [ A^2, a ], [ b*a, A*b ], [ b*A, a*b ], 
[ c*b, b*c ], [ c*a*b, b*c*A ], [ c*A*b, b*c*a ] ]
gap> Length( r2 );           
13
gap> w2 := ReduceWordKB( w0, r2 );
q0_M2*q0_M3*q0_M5
gap> lw1 := LoggedReduceWordKB( w0, logrws );
[ [ [ 14, q0_M1^-5 ], [ 15, q0_M3^-3*q0_M1^-5 ], [ 13, <identity ...> ], 
      [ 14, q0_M1^-2 ], [ 15, q0_M3^-1*q0_M1^-2 ], [ 13, <identity ...> ] ], 
  q0_M2*q0_M3*q0_M5 ]
gap> p1 := PartialElementsOfMonoidPresentation( q0, 1 );; 
gap> Length( p1 ); 
5
gap> PrintLnUsingLabels( p1, gfmq0, q0labs );
[ id, a, A, b, c ]
gap> p2 := PartialElementsOfMonoidPresentation( q0, 2 );; 
gap> Length( p2 ); 
12
gap> PrintLnUsingLabels( p2, gfmq0, q0labs );
[ id, a, A, b, c, a*b, a*c, A*b, A*c, b*c, c*a, c*A ]
gap> T := GenerationTree( q0 );;
gap> Length( T );
22
gap> for i in [1..11] do 
>        PrintUsingLabels( T[i+i-1], gfmq0, q0labs ); 
>        Print( "   " ); 
>        PrintLnUsingLabels( T[i+i], gfmq0, q0labs );
>    od;
[ id, a ]   [ a, A ]
[ id, A ]   [ A, a ]
[ id, b ]   [ b, B ]
[ id, c ]   [ c, C ]
[ a, b ]   [ a*b, B ]
[ a, c ]   [ a*c, C ]
[ A, b ]   [ A*b, B ]
[ A, c ]   [ A*c, C ]
[ b, c ]   [ b*c, C ]
[ c, a ]   [ c*a, A ]
[ c, A ]   [ c*A, a ]
gap> seq0 := IdentityRelatorSequences( q0 );;
gap> Length( seq0 );                                  
25
gap> idsq0 := IdentitiesAmongRelators( q0 );; 
gap> Length( idsq0 ); 
17
gap> PrintLnUsingLabels( idsq0, gfmq0, q0labs );     
[ [ [ -13, id ], [ 13, a ] ], [ [ -14, id ], [ 14, b ] ], [ [ -15, id ], 
[ 15, c ] ], [ [ -16, id ], [ -14, A*B*A ] ], [ [ -13, id ], [ -14, A ], 
[ 16, a*b ], [ -14, A*B*a*b ], [ 16, a^2*b ], [ -14, A*B*a^2*b ], 
[ 16, a^3*b ], [ -13, b ] ], [ [ -17, id ], [ -17, B ], [ 15, B*C*B^2 ], 
[ 14, C*B^2 ], [ 14, id ], [ 15, id ] ], [ [ -17, id ], [ 15, B*C*B ], 
[ 14, C*B ], [ 14, id ], [ -17, b ], [ 15, B*C ] ], [ [ -17, id ], 
[ -17, c ], [ 15, B*C*B*c ], [ 14, C*B*c ], [ 14, c ], [ 15, b*c ] ], 
[ [ -17, id ], [ -17, c*a ], [ 15, B*C*B*c*a ], [ -17, B*A*B*C*B*c*a ], 
[ 15, B*C*B^2*A*B*C*B*c*a ], [ 14, C*B^2*A*B*C*B*c*a ], [ 14, A*B*C*B*c*a ], 
[ -17, B*c*a ], [ 15, B*C*B^2*c*a ], [ 14, C*B^2*c*a ], [ 14, c*a ], 
[ 15, id ] ], [ [ -16, id ], [ -14, A ], [ 16, a*b ], [ 14, a*b ] ], 
[ [ -14, id ], [ -17, c*a ], [ 15, B*C*B*c*a ], [ 14, A*B*C*B*c*a ], 
[ -17, B*c*a ], [ 15, B*C*B^2*c*a ], [ 14, C*B^2*c*a ], [ 14, c*a ] ], 
[ [ -14, id ], [ -17, c ], [ 15, B*C*B*c ], [ 14, C*B*c ], [ -17, B*c ], 
[ 15, B*C*B^2*c ], [ 14, C*B^2*c ], [ 14, c ] ], [ [ -16, id ], 
[ 13, id ], [ -16, a^2 ], [ 14, A*B*a ], [ -17, c*a ], [ 15, B*C*B*c*a ], 
[ 14, C*B*c*a ], [ 13, C*B*c*a ], [ -16, a*C*B*c*a ], [ 14, A*B*C*B*c*a ], 
[ -17, B*c*a ], [ 15, B*C*B^2*c*a ], [ 14, C*B^2*c*a ], [ 14, c*a ] ], 
[ [ -16, id ], [ -17, c*A ], [ 15, B*C*B*c*A ], [ 14, C*B*c*A ], 
[ -17, B*c*A ], [ 15, B*C*B^2*c*A ], [ 16, a*C*B^2*c*A ], [ 14, c*A ] ], 
[ [ -16, id ], [ -17, c ], [ 15, B*C*B*c ], [ 16, a*C*B*c ], [ -17, B*c ], 
[ 15, B*C*B^2*c ], [ 14, C*B^2*c ], [ 14, c ] ], [ [ -17, id ], 
[ -16, id ], [ 14, A*B*A ], [ -17, c*A ], [ 15, B*C*B*c*A ], [ 14, C*B*c*A ], 
[ -17, A*C*B*c*A ], [ 15, B*C*B*A*C*B*c*A ], [ 14, C*B*A*C*B*c*A ], 
[ -17, B*c*A ], [ 15, B*C*B^2*c*A ], [ 16, a*C*B^2*c*A ], [ 14, c*A ], 
[ 15, id ] ], [ [ -14, id ], [ -16, id ], [ 14, A*B*A ], [ -17, c*A ], 
[ 15, B*C*B*c*A ], [ 14, C*B*c*A ], [ -17, B*c*A ], [ 15, B*C*B^2*c*A ], 
[ 16, a*C*B^2*c*A ], [ 14, c*A ] ] ]

gap> SetInfoLevel( InfoIdRel, idrel_save_level );;

#############################################################################
##
#E  simsek.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
