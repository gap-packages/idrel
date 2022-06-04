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
gap> relq8 := [ f^4, g^4, f*g*f*g^-1, f^2*g^2 ];;
gap> q8 := F/relq8;;
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
gap> PrintLnUsingLabels( r0, genfmq8, q8labs );
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], 
[ B*b, [ ], id ], [ a^4, [ [ 1, id ] ], id ], [ a^2*b^2, [ [ 4, id ] ], id ], 
[ a*b*a*B, [ [ 3, id ] ], id ], [ b^4, [ [ 2, id ] ], id ] ]

## Example 3.1.2
gap> r1 := LoggedOnePassKB( mq8, r0 );;
gap> Length( r1 );
25
gap> PrintLnUsingLabels( r1, genfmq8, q8labs );
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], 
[ B*b, [ ], id ], [ b^2, [ [ -4, id ], [ 2, A^2 ] ], a^2 ], 
[ b^2, [ [ -1, id ], [ 4, A^2 ] ], a^2 ], [ a^3, [ [ 1, id ] ], A ], 
[ a^3, [ [ 1, a ] ], A ], [ a^2*b, [ [ 4, id ] ], B ], [ a*b*a, 
[ [ 3, id ] ], b ], [ a*b^2, [ [ 4, a ] ], A ], [ b*a*B, [ 
[ 3, a ] ], A ], [ b^3, [ [ 2, id ] ], B ], [ b^3, [ [ 2, b ] ], B ], 
[ a*b^2, [ [ -1, id ], [ 4, A^3 ] ], a^3 ], [ b*a*B, [ [ -1, id ], 
[ 3, A^3 ] ], a^3 ], [ b^3, [ [ -4, id ], [ 2, B*A^2 ] ], a^2*b ], 
[ a^4, [ [ 1, id ] ], id ], [ a^2*b^2, [ [ 4, id ] ], id ], 
[ a*b*a*B, [ [ 3, id ] ], id ], [ b^4, [ [ 2, id ] ], id ] ]

## Example 3.1.2
gap> r2 := LoggedRewriteReduce( mq8, r1 );;
gap> Length( r2 );
13
gap> PrintLnUsingLabels( r2, genfmq8, q8labs );      
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], 
[ B*b, [ ], id ], [ b^2, [ [ -4, id ], [ 2, A^2 ] ], a^2 ], 
[ a^3, [ [ 1, id ] ], A ], [ a^2*b, [ [ 4, id ] ], B ], [ a*b*a, 
[ [ 3, id ] ], b ], [ b*a*B, [ [ 3, a ] ], A ] ]
gap> r3 := LoggedKnuthBendix( mq8, r0 );;
gap> Length( r3 );
20
gap> PrintLnUsingLabels( r3, genfmq8, q8labs );
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], 
[ B*b, [ ], id ], [ b*a, [ [ -3, id ], [ 4, B*A ] ], a*B ], 
[ b^2, [ [ -4, id ], [ 2, A^2 ] ], a^2 ], [ b*A, [ [ -3, id ] ], a*b ], 
[ A*b, [ [ -1, id ], [ 4, A ] ], a*B ], [ A^2, [ [ -1, id ] ], a^2 ], 
[ A*B, [ [ -4, a ] ], a*b ], [ B*a, [ [ -4, id ], [ 3, A ] ], a*b ], 
[ B*A, [ [ -3, a*b ] ], a*B ], [ B^2, [ [ -4, id ] ], a^2 ], 
[ a^3, [ [ 1, id ] ], A ], [ a^2*b, [ [ 4, id ] ], B ], [ a^2*B, 
[ [ -4, A^2 ], [ 1, id ] ], b ] ]

## Example 3.1.5
gap> lrws := LoggedRewritingSystemFpGroup( q8 );;
gap> PrintLnUsingLabels( lrws, genfmq8, q8labs );
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], 
[ B*b, [ ], id ], [ b*a, [ [ -3, id ], [ 4, B*A ] ], a*B ], 
[ b^2, [ [ -4, id ], [ 2, A^2 ] ], a^2 ], [ b*A, [ [ -3, id ] ], a*b ], 
[ A*b, [ [ -1, id ], [ 4, A ] ], a*B ], [ A^2, [ [ -1, id ] ], a^2 ], 
[ A*B, [ [ -4, a ] ], a*b ], [ B*a, [ [ -4, id ], [ 3, A ] ], a*b ], 
[ B*A, [ [ -3, a*b ] ], a*B ], [ B^2, [ [ -4, id ] ], a^2 ], 
[ a^3, [ [ 1, id ] ], A ], [ a^2*b, [ [ 4, id ] ], B ], [ a^2*B, 
[ [ -4, A^2 ], [ 1, id ] ], b ] ]
gap> Length( lrws );
20

gap> lrwsT := LoggedRewritingSystemFpGroup( T );;
gap> PrintLnUsingLabels( lrwsT, genfgmT, Tlabs );
[ [ x^-1, [ ], X ], [ X^-1, [ ], x ], [ y^-1, [ ], Y ], [ Y^-1, 
[ ], y ], [ x*X, [ ], id ], [ X*x, [ ], id ], [ y*Y, [ ], id ], 
[ Y*y, [ ], id ], [ y*x, [ [ -1, X*Y ] ], x*y ], [ y*X, [ [ 1, Y ] ], X*y ], 
[ Y*x, [ [ 1, X ] ], x*Y ], [ Y*X, [ [ -1, id ] ], X*Y ] ]

## Example 3.2.1
gap> PrintLnUsingLabels( w0, genfmq8, q8labs ); 
b^9*a^-9
gap> lw1 := LoggedOnePassReduceWord( w0, lrws );;
gap> PrintLnUsingLabels( lw1, genfmq8, q8labs );  
[ [ [ -4, id ], [ 2, A^2 ], [ -3, b^-6*a^-2 ], [ 4, id ] ], 
B*b^5*a*b*a^-8 ]
gap> lw2 := LoggedReduceWordKB( w0, lrws );; 
gap> PrintLnUsingLabels( lw2, genfmq8, q8labs );
[ [ [ -4, id ], [ 2, A^2 ], [ -3, b^-6*a^-2 ], [ 4, id ], [ -3, b^-3 ], 
[ 4, B*A*b^-3 ], [ -4, id ], [ 2, A^2 ], [ -3, B^-1*a^-1*b^-1*a^-2 ], 
[ -4, a^-1*b^-1*a^-2 ], [ 3, A*a^-1*b^-1*a^-2 ], [ 4, id ], 
[ -4, a^-2*B^-1 ], [ 2, A^2*a^-2*B^-1 ], [ -4, id ], [ 3, A ], 
[ 1, b^-1*a^-1 ], [ -3, a^-1 ], [ -1, b^-1*a^-2 ], [ 4, id ], 
[ -3, a*b ], [ -3, a*b*a^-1 ], [ -4, A^2 ], [ 1, id ], [ -3, id ] ], a*b ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  logrws.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

