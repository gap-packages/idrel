##############################################################################
##
#W  logrws.tst                   Idrel Package                   Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2022 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );; 

## items defined in rws.tst 
gap> F := FreeGroup( 2 );;
gap> f := F.1;;  g := F.2;;
gap> rels8 := [ f^4, g^4, f*g*f*g^-1, f^2*g^2 ];;
gap> q8 := F/rels8;;
gap> SetName( q8, "q8" );;
gap> q8R := FreeRelatorGroup( q8 );; 
gap> genq8R := GeneratorsOfGroup( q8R );;
gap> homq8R := FreeRelatorHomomorphism( q8 );;
gap> mq8 := MonoidPresentationFpGroup( q8 );;
gap> fmq8 := FreeGroupOfPresentation( mq8 );; 
gap> id := One( fmq8 );; 
gap> genfmq8 := GeneratorsOfGroup( fmq8 );;
gap> gprels := GroupRelatorsOfPresentation( mq8 );; 
gap> invrels := InverseRelatorsOfPresentation( mq8 );; 
gap> hompres := HomomorphismOfPresentation( mq8 );; 
gap> q8labs := [ "a", "b", "A", "B" ];; 
gap> SetMonoidPresentationLabels( q8, q8labs );; 
gap> rws := RewritingSystemFpGroup( q8 );;
gap> T := F/[Comm(f,g)];;              
gap> SetName( T, "T" );; 
gap> SetArrangementOfMonoidGenerators( T, [1,-1,2,-2] );;
gap> Tlabs := [ "x", "X", "y", "Y" ];; 
gap> mT := MonoidPresentationFpGroup( T );;              
gap> fgmT := FreeGroupOfPresentation( mT );; 
gap> genfgmT := GeneratorsOfGroup( fgmT );;
gap> SetMonoidPresentationLabels( T, Tlabs );; 
gap> rwsT := RewritingSystemFpGroup( T );;
gap> r0 := InitialLoggedRulesOfPresentation( mq8 );; 
gap> a := genfmq8[1];;  b := genfmq8[2];; 
gap> A := genfmq8[3];;  B := genfmq8[4];; 
gap> w0 := b^9 * a^-9;; 


## Example 3.1.1
gap> r0 := InitialLoggedRulesOfPresentation( mq8 );; 
gap> r1 := LoggedOnePassKB( mq8, r0 );;
gap> Length( r1 );
25
gap> PrintLnUsingLabels( r1[20], genfmq8, q8labs );
[ b*a*B, [ [ -9, id ], [ 11, A^3 ] ], a^3 ]

## Example 3.1.2
gap> r11 := LoggedRewriteReduce( mq8, r1 );;
gap> Length( r11 );
13
gap> PrintLnUsingLabels( r11, genfmq8, q8labs );      
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], 
[ B*b, [ ], id ], [ b^2, [ [ -12, id ], [ 10, A^2 ] ], a^2 ], 
[ a^3, [ [ 9, id ] ], A ], [ a^2*b, [ [ 12, id ] ], B ], [ a*b*a, 
[ [ 11, id ] ], b ], [ b*a*B, [ [ 11, a ] ], A ] ]
gap> r2 := LoggedKnuthBendix( mq8, r0 );;
gap> Length( r2 );
20
gap> PrintLnUsingLabels( r2, genfmq8, q8labs );
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], 
[ B*b, [ ], id ], [ b*a, [ [ -11, id ], [ 12, B*A ] ], a*B ], 
[ b^2, [ [ -12, id ], [ 10, A^2 ] ], a^2 ], [ b*A, [ [ -11, id ] ], a*b ], 
[ A*b, [ [ -9, id ], [ 12, A ] ], a*B ], [ A^2, [ [ -9, id ] ], a^2 ], 
[ A*B, [ [ -12, a ] ], a*b ], [ B*a, [ [ -12, id ], [ 11, A ] ], a*b ], 
[ B*A, [ [ -11, a*b ] ], a*B ], [ B^2, [ [ -12, id ] ], a^2 ], 
[ a^3, [ [ 9, id ] ], A ], [ a^2*b, [ [ 12, id ] ], B ], [ a^2*B, 
[ [ -12, A^2 ], [ 9, id ] ], b ] ]

## Example 3.2.1
gap> w0;   
q8_M2^9*q8_M1^-9
gap> lw1 := LoggedOnePassReduceWord( w0, r0 );;
gap> PrintLnUsingLabels( lw1, genfmq8, q8labs );  
[ [ [ 10, id ] ], b^5*A*a^-8 ]
gap> lw2 := LoggedReduceWordKB( w0, r0 );; 
gap> PrintLnUsingLabels( lw2, genfmq8, q8labs );
[ [ [ 10, id ], [ 10, id ] ], b*A^9 ]
gap> lw2 := LoggedReduceWordKB( w0, r2 );;
gap> PrintLnUsingLabels( lw2, genfmq8, q8labs );
[ [ [ -12, id ], [ 10, A^2 ], [ -11, b^-6*a^-2 ], [ 12, id ], [ -11, b^-3 ], 
[ 12, B*A*b^-3 ], [ -12, id ], [ 10, A^2 ], [ -11, B^-1*a^-1*b^-1*a^-2 ], 
[ -12, a^-1*b^-1*a^-2 ], [ 11, A*a^-1*b^-1*a^-2 ], [ 12, id ], 
[ -12, a^-2*B^-1 ], [ 10, A^2*a^-2*B^-1 ], [ -12, id ], [ 11, A ], 
[ 9, b^-1*a^-1 ], [ -11, a^-1 ], [ -9, b^-1*a^-2 ], [ 12, id ], 
[ -11, a*b ], [ -11, a*b*a^-1 ], [ -12, A^2 ], [ 9, id ], [ -11, id ] ], a*b ]

## Example 3.2.2
gap> lrws := LoggedRewritingSystemFpGroup( q8 );;
gap> PrintLnUsingLabels( lrws, genfmq8, q8labs );
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], 
[ B*b, [ ], id ], [ b*a, [ [ -11, id ], [ 12, B*A ] ], a*B ], 
[ b^2, [ [ -12, id ], [ 10, A^2 ] ], a^2 ], [ b*A, [ [ -11, id ] ], a*b ], 
[ A*b, [ [ -9, id ], [ 12, A ] ], a*B ], [ A^2, [ [ -9, id ] ], a^2 ], 
[ A*B, [ [ -12, a ] ], a*b ], [ B*a, [ [ -12, id ], [ 11, A ] ], a*b ], 
[ B*A, [ [ -11, a*b ] ], a*B ], [ B^2, [ [ -12, id ] ], a^2 ], 
[ a^3, [ [ 9, id ] ], A ], [ a^2*b, [ [ 12, id ] ], B ], [ a^2*B, 
[ [ -12, A^2 ], [ 9, id ] ], b ] ]
gap> Length( lrws );
20
gap> lrwsT := LoggedRewritingSystemFpGroup( T );;
gap> PrintLnUsingLabels( lrwsT, genfgmT, Tlabs );
[ [ x^-1, [ ], X ], [ X^-1, [ ], x ], [ y^-1, [ ], Y ], [ Y^-1, 
[ ], y ], [ x*X, [ ], id ], [ X*x, [ ], id ], [ y*Y, [ ], id ], 
[ Y*y, [ ], id ], [ y*x, [ [ -9, X*Y ] ], x*y ], [ y*X, [ [ 9, Y ] ], X*y ], 
[ Y*x, [ [ 9, X ] ], x*Y ], [ Y*X, [ [ -9, id ] ], X*Y ] ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  logrws.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

