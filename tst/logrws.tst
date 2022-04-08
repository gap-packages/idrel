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
gap> r0 := InitialLoggedRulesOfPresentation( q8 );; 
gap> a := genfmq8[1];;  b := genfmq8[2];; 
gap> A := genfmq8[3];;  B := genfmq8[4];; 
gap> w0 := b^9 * a^-9;; 


## Example 3.1.1
gap> r0 := InitialLoggedRulesOfPresentation( q8 );; 
gap> r1 := LoggedOnePassKB( mq8, r0 );;
gap> Length( r1[1] );
25
gap> PrintLnUsingLabels( r1[1][22], genfmq8, q8labs );
[ a*b*a, [ [ 11, id ] ], b ]

## Example 3.1.2
gap> r11 := LoggedRewriteReduce( mq8, r1[1] );;
gap> Length( r11 );
13
gap> PrintLnUsingLabels( r11, genfmq8, q8labs );      
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b^2, [ [ -12, id ], [ 10, A^2 ] ], a^2 ], 
[ b*B, [ ], id ], [ A*a, [ ], id ], [ B*b, [ ], id ], [ a^3, 
[ [ 9, id ] ], A ], [ a^2*b, [ [ 12, id ] ], B ], [ a*b*a, [ 
[ 11, id ] ], b ], [ b*a*B, [ [ 11, a ] ], A ] ]
gap> r2 := LoggedKnuthBendix( mq8, r0 );;
gap> Length( r2[1] );
20
gap> PrintLnUsingLabels( r2[1], genfmq8, q8labs );
[ [ a^-1, [ ], A ], [ b^-1, [ ], B ], [ A^-1, [ ], a ], [ B^-1, 
[ ], b ], [ a*A, [ ], id ], [ b*a, [ [ 11, a ], [ -9, id ], [ 12, A ] ], 
a*B ], [ b^2, [ [ -12, id ], [ 10, A^2 ] ], a^2 ], [ b*A, [ [ -11, id ] ], 
a*b ], [ b*B, [ ], id ], [ A*a, [ ], id ], [ A*b, [ [ -9, id ], 
[ 12, A ] ], a*B ], [ A^2, [ [ -9, id ] ], a^2 ], [ A*B, [ [ -9, id ], 
[ -10, A^2 ], [ 12, id ], [ 11, a*B ], [ -11, id ] ], a*b ], [ B*a, 
[ [ -12, id ], [ 11, A ] ], a*b ], [ B*b, [ ], id ], [ B*A, [ 
[ -11, a*b ] ], a*B ], [ B^2, [ [ -12, id ] ], a^2 ], [ a^3, [ 
[ 9, id ] ], A ], [ a^2*b, [ [ 12, id ] ], B ], [ a^2*B, [ [ -12, A^2 ], 
[ 9, id ] ], b ] ]
gap> Length( r2[2] );
53

## Example 3.2.1
gap> w0;   
b^9*a^-9
gap> lw1 := LoggedOnePassReduceWord( w0, r0 );;
gap> PrintLnUsingLabels( lw1, genfmq8, q8labs );  
[ [ [ 10, id ] ], b^5*A*a^-8 ]
gap> lw2 := LoggedReduceWordKB( w0, r0 );; 
gap> PrintLnUsingLabels( lw2, genfmq8, q8labs );
[ [ [ 1, b^-9 ], [ 2, id ], [ 1, b^-5 ], [ 2, id ] ], b*a ]
gap> lw2 := LoggedReduceWordKB( w0, r2[1] );;
gap> PrintLnUsingLabels( lw2, genfmq8, q8labs );
[ [ [ 3, a*b^-8 ], [ -1, b^-8 ], [ 4, A*b^-8 ], [ -4, id ], 
[ 2, A^2 ], [ -4, a^-1*b^-6*a^-2 ], [ 3, A*a^-1*b^-6*a^-2 ], 
[ 1, b^-1*a^-2*b^-6*a^-2 ], [ 4, id ], [ 3, a*b^-4*B^-1 ], 
[ -1, b^-4*B^-1 ], [ 4, A*b^-4*B^-1 ], [ -4, B^-1 ], [ 2, A^2*B^-1 ], 
[ -3, a^-1*B^-1*a^-1*b^-2*a^-2*B^-1 ], [ -4, id ], [ 3, A ], 
[ 1, b^-1*a^-2*B^-1*a^-1*b^-1*(b^-1*a^-1)^2 ], [ 4, 
B^-1*a^-1*b^-1*(b^-1*a^-1)^2 ], [ 3, id ], [ -1, a^-1 ], [ 4, A*a^-1 ], 
[ -4, B^-1*a^-2 ], [ 2, A^2*B^-1*a^-2 ], [ -4, a^-2 ], [ 3, A*a^-2 ], 
[ -4, a^-2*b^-1*a^-3 ], [ 1, id ], [ 3, a*A^-1 ], [ -1, A^-1 ], 
[ 4, id ], [ -4, id ], [ 3, A ], [ 3, id ], [ -1, a^-1 ], 
[ 4, A*a^-1 ], [ -4, a^-2 ], [ 3, A*a^-2 ], [ 1, id ], [ -1, id ], 
[ 4, A ] ], a*B ]

## Example 3.2.2
gap> lrws := LoggedRewritingSystemFpGroup( q8 );;
gap> PrintLnUsingLabels( lrws, genfmq8, q8labs );
[ [ B*b, [ ], id ], [ A*a, [ ], id ], [ b*B, [ ], id ], [ a*A, 
[ ], id ], [ a^2*B, [ [ -8, A^2 ], [ 5, id ] ], b ], [ a^2*b, 
[ [ 8, id ] ], B ], [ a^3, [ [ 5, id ] ], A ], [ B^2, [ [ -8, id ] ], a^2 ], 
[ B*A, [ [ -7, a*b ] ], a*B ], [ B*a, [ [ -8, id ], [ 7, A ] ], a*b ], 
[ A*B, [ [ -5, id ], [ -6, A^2 ], [ 8, id ], [ 7, a*B ], [ -7, id ] ], 
a*b ], [ A^2, [ [ -5, id ] ], a^2 ], [ A*b, [ [ -5, id ], [ 8, A ] ], a*B ], 
[ b*A, [ [ -7, id ] ], a*b ], [ b^2, [ [ -8, id ], [ 6, A^2 ] ], a^2 ], 
[ b*a, [ [ 7, a ], [ -5, id ], [ 8, A ] ], a*B ] ]
gap> Length( lrws );
16

gap> lrwsT := LoggedRewritingSystemFpGroup( T );;
gap> PrintLnUsingLabels( lrwsT, genfgmT, Tlabs );
[ [ Y*y, [ ], id ], [ y*Y, [ ], id ], [ X*x, [ ], id ], [ x*X, 
[ ], id ], [ Y*X, [ [ -5, id ] ], X*Y ], [ Y*x, [ [ 5, X ] ], x*Y ], 
[ y*X, [ [ 5, Y ] ], X*y ], [ y*x, [ [ -5, X*Y ] ], x*y ] ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  logrws.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

