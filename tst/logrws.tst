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
gap> mon := MonoidPresentationFpGroup( q8 );;
gap> fgmon := FreeGroupOfPresentation( mon );; 
gap> genfgmon := GeneratorsOfGroup( fgmon );;
gap> gprels := GroupRelatorsOfPresentation( mon );; 
gap> invrels := InverseRelatorsOfPresentation( mon );; 
gap> hompres := HomomorphismOfPresentation( mon );; 
gap> q8labs := [ "a", "b", "A", "B" ];; 
gap> SetMonoidGeneratorLabels( q8, q8labs );; 
gap> rws := RewritingSystemFpGroup( q8 );;
gap> monrels := Concatenation( gprels, invrels );; 
gap> id := One( monrels[1] );;
gap> r0 := List( monrels, r -> [ r, id ] );; 
gap> w0 := genfgmon[2]^9 * genfgmon[1]^9;; 
gap> T := F/[Comm(f,g)];;              
gap> SetName( T, "T" );; 
gap> SetArrangementOfMonoidGenerators( T, [1,-1,2,-2] );;
gap> Tlabs := [ "x", "X", "y", "Y" ];; 
gap> monT := MonoidPresentationFpGroup( T );;              
gap> fgmonT := FreeGroupOfPresentation( monT );; 
gap> genfgmonT := GeneratorsOfGroup( fgmonT );;
gap> SetMonoidGeneratorLabels( T, Tlabs );; 
gap> rwsT := RewritingSystemFpGroup( T );;


## Example 3.1.1
gap> l0 := ListWithIdenticalEntries( 8, 0 );;
gap> for j in [1..8] do
>        r := r0[j];;
>        if (j<5) then
>           l0[j] := [ r[1], [ [ j, id ] ], r[2] ];;
>        else
>           l0[j] := [ r[1], [ ], r[2] ];;
>        fi;
>    od;
gap> PrintLnUsingLabels( l0, genfgmon, q8labs ); 
[ [ a^4, [ [ 1, id ] ], id ], [ b^4, [ [ 2, id ] ], id ], [ a*b*a*B, 
[ [ 3, id ] ], id ], [ a^2*b^2, [ [ 4, id ] ], id ], [ a*A, 
[ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], [ B*b, [ ], id ] ]
gap> l1 := LoggedOnePassKB( q8, l0 );;
gap> Length( l1[1] );
21
gap> PrintLnUsingLabels( l1[1][16], genfgmon, q8labs );
[ b^2, [ [ -4, id ], [ 2, A^2 ] ], a^2 ]

## Example 3.1.2
gap> l11 := LoggedRewriteReduce( q8, l1[1] );;
gap> PrintLnUsingLabels( l11, genfgmon, q8labs );      
[ [ a*A, [ ], id ], [ b^2, [ [ -4, id ], [ 2, A^2 ] ], a^2 ], 
[ b*B, [ ], id ], [ A*a, [ ], id ], [ B*b, [ ], id ], [ a^3, 
[ [ 1, id ] ], A ], [ a^2*b, [ [ 4, id ] ], B ], [ a*b*a, [ 
[ 3, id ] ], b ], [ b*a*B, [ [ 3, a ] ], A ] ]
gap> Length( l11 );
9
gap> l2 := LoggedKnuthBendix( q8, l11 );;
gap> PrintLnUsingLabels( l2[1], genfgmon, q8labs );
[ [ a*A, [ ], id ], [ b*a, [ [ 3, a ], [ -1, id ], [ 4, A ] ], a*B ], 
[ b^2, [ [ -4, id ], [ 2, A^2 ] ], a^2 ], [ b*A, [ [ -3, id ] ], a*b ], 
[ b*B, [ ], id ], [ A*a, [ ], id ], [ A*b, [ [ -1, id ], [ 4, A ] ], a*B ], 
[ A^2, [ [ -1, id ] ], a^2 ], [ A*B, [ [ -1, id ], [ -2, A^2 ], 
[ 4, id ], [ 3, a*B ], [ -3, id ] ], a*b ], [ B*a, [ [ -4, id ], 
[ 3, A ] ], a*b ], [ B*b, [ ], id ], [ B*A, [ [ -3, a*b ] ], a*B ], 
[ B^2, [ [ -4, id ] ], a^2 ], [ a^3, [ [ 1, id ] ], A ], [ a^2*b, 
[ [ 4, id ] ], B ], [ a^2*B, [ [ -4, A^2 ], [ 1, id ] ], b ] ]
gap> Length( l2[1] );
16
gap> Length( l2[2] );
51

## Example 3.2.1
gap> PrintUsingLabels( w0, genfgmon, q8labs );   
b^9*a^9
gap> lw1 := LoggedOnePassReduceWord( w0, l0 );;
gap> PrintLnUsingLabels( lw1, genfgmon, q8labs );  
[ [ [ 1, b^-9 ], [ 2, id ] ], b^5*a^5 ]
gap> lw2 := LoggedReduceWordKB( w0, l0 );; 
gap> PrintLnUsingLabels( lw2, genfgmon, q8labs );
[ [ [ 1, b^-9 ], [ 2, id ], [ 1, b^-5 ], [ 2, id ] ], b*a ]
gap> lw2 := LoggedReduceWordKB( w0, l2[1] );;
gap> PrintLnUsingLabels( lw2, genfgmon, q8labs );
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
gap> PrintLnUsingLabels( lrws, genfgmon, q8labs );
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
gap> PrintLnUsingLabels( lrwsT, genfgmonT, Tlabs );
[ [ Y*y, [ ], id ], [ y*Y, [ ], id ], [ X*x, [ ], id ], [ x*X, 
[ ], id ], [ Y*X, [ [ -5, id ] ], X*Y ], [ Y*x, [ [ 5, X ] ], x*Y ], 
[ y*X, [ [ 5, Y ] ], X*y ], [ y*x, [ [ -5, X*Y ] ], x*y ] ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  logrws.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

