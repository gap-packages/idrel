##############################################################################
##
#W  logrws.tst                   Idrel Package                   Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2021 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

## Example 3.1.1
gap> l0 := ListWithIdenticalEntries( 8, 0 );;
gap> for j in [1..8] do
>        r := r0[j];;
>        if (j<5) then
>           l0[j] := [ r[1], [ [j,id] ], r[2] ];;
>        else
>           l0[j] := [ r[1], [ ], r[2] ];;
>        fi;
>    od;
gap> PrintUsingLabels( l0, genfgmon, labs ); 
[ [ a^4, [ [ 1, id ] ], id ], [ b^4, [ [ 2, id ] ], id ], [ a*b*a*B, [ [ 3, 
id ] ], id ], [ a^2*b^2, [ [ 
4, id ] ], id ], [ a*A, [ ], id ], [ b*B, [ ], id ], [ 
A*a, [ ], id ], [ B*b, [ ], id ] ]
gap> l1 := LoggedOnePassKB( q8, l0 );;
gap> Length( l1[1] );
21
gap> PrintUsingLabels( l1[1][16], genfgmon, labs );
[ b^2, [ [ -4, id ], [ 2, A^2 ] ], a^2 ]

## Example 3.1.2
gap> l11 := LoggedRewriteReduce( q8, l1[1] );;
gap> PrintUsingLabels( l11, genfgmon, labs );      
[ [ a*A, [ ], id ], [ b^2, [ [ -4, id ], [ 
2, A^2 ] ], a^2 ], [ b*B, [ ], id ], [ 
A*a, [ ], id ], [ B*b, [ ], id ], [ a^3, [ [ 1, id ] ], A ], [ a^2*b, [ [ 
4, id ] ], 
B ], [ a*b*a, [ [ 3, id ] ], b ], [ b*a*B, [ [ 3, a ] ], A ] ]
gap> Length( l11 );
9
gap> l2 := LoggedKnuthBendix( q8, l11 );;
gap> PrintUsingLabels( l2[1], genfgmon, labs );
[ [ a*A, [ ], id ], [ b*a, [ [ 3, a ], [ -1, id ], [ 
4, A ] ], a*B ], [ b^2, [ [ -4, 
id ], [ 2, A^2 ] ], a^2 ], [ b*A, [ [ -3, id ] ], a*b ], [ b*B, [ ], id ], [ 
A*a, [ ], id ], [ A*b, [ [ -1, id ], [ 4, A ] ], a*B ], [ A^2, [ [ 
-1, id ] ], 
a^2 ], [ A*B, [ [ -1, id ], [ -2, A^2 ], [ 4, id ], [ 3, a*B ], [ -3, id ] ], 
a*b ], [ B*a, [ [ -4, id ], [ 3, A ] ], a*b ], [ B*b, [ ], id ], [ B*A, [ [ 
-3, 
a*b ] ], a*B ], [ B^2, [ [ -4, id ] ], a^2 ], [ a^3, [ [ 1, id ] ], A ], [ 
a^2*b, [ [ 4, id ] ], B ], [ a^2*B, [ [ -4, A^2 ], [ 1, id ] ], b ] ]
gap> Length( l2[1] );
16
gap> Length( l2[2] );
51

## Example 3.2.1
gap> PrintUsingLabels( w0, genfgmon, labs );   
b^9*a^9
gap> lw1 := LoggedOnePassReduceWord( w0, l0 );;
gap> PrintUsingLabels( lw1, genfgmon, labs );  
[ [ [ 1, b^-9 ], [ 2, id ] ], b^5*a^5 ]
gap> lw2 := LoggedReduceWordKB( w0, l0 );; 
gap> PrintUsingLabels( lw2, genfgmon, labs );
[ [ [ 1, b^-9 ], [ 2, id ], [ 1, b^-5 ], [ 2, id ] ], b*a ]
gap> lw2 := LoggedReduceWordKB( w0, l2[1] );;
gap> PrintUsingLabels( lw2, genfgmon, labs );
[ [ [ 3, a*b^-8 ], [ -1, b^-8 ], [ 4, A*b^-8 ], [ -4, id ], [ 2, A^2 ], [ -4, 
a^-1*b^-6*a^-2 ], [ 3, A*a^-1*b^-6*a^-2 ], [ 1, b^-1*a^-2*b^-6*a^-2 ], [ 4, 
id ], [ 3, a*b^-4*B^-1 ], [ -1, b^-4*B^-1 ], [ 4, A*b^-4*B^-1 ], [ -4, 
B^-1 ], [ 2, A^2*B^-1 ], [ -3, a^-1*B^-1*a^-1*b^-2*a^-2*B^-1 ], [ -4, id ], [ 
3, 
A ], [ 1, b^-1*a^-2*B^-1*a^-1*b^-1*(b^-1*a^-1)^2 ], [ 4, 
B^-1*a^-1*b^-1*(b^-1*a^-1)^2 ], [ 3, id ], [ -1, a^-1 ], [ 4, A*a^-1 ], [ -4, 
B^-1*a^-2 ], [ 2, A^2*B^-1*a^-2 ], [ -4, a^-2 ], [ 3, A*a^-2 ], [ -4, 
a^-2*b^-1*a^-3 ], [ 1, id ], [ 3, a*A^-1 ], [ -1, A^-1 ], [ 4, id ], [ -4, 
id ], [ 3, A ], [ 3, id ], [ -1, a^-1 ], [ 4, A*a^-1 ], [ -4, a^-2 ], [ 3, 
A*a^-2 ], [ 1, id ], [ -1, id ], [ 4, A ] ], a*B ]

## Example 3.2.2
gap> lrws := LoggedRewritingSystemFpGroup( q8 );;
gap> PrintUsingLabels( lrws, genfgmon, labs );
[ [ B*b, [ ], id ], [ A*a, [ ], id ], [ b*B, [ ], id ], [ a*A, [ ], id ], [ a^\
2*B, [ [ -8, 
A^2 ], [ 5, id ] ], b ], [ a^2*b, [ [ 8, id ] ], B ], [ a^3, [ [ 5, id ] ], 
A ], [ B^2, [ [ -8, id ] ], a^2 ], [ B*A, [ [ -7, a*b ] ], a*B ], [ B*a, [ [ 
-8, 
id ], [ 7, A ] ], a*b ], [ A*B, [ [ -5, id ], [ -6, A^2 ], [ 8, id ], [ 7, 
a*B ], [ -7, id ] ], a*b ], [ A^2, [ [ -5, id ] ], a^2 ], [ A*b, [ [ 
-5, id ], [ 8, 
A ] ], a*B ], [ b*A, [ [ -7, id ] ], a*b ], [ b^2, [ [ -8, id ], [ 
6, A^2 ] ], 
a^2 ], [ b*a, [ [ 7, a ], [ -5, id ], [ 8, A ] ], a*B ] ]
gap> Length( lrws );
16

gap> lrwsT := LoggedRewritingSystemFpGroup( T );;
gap> labsT := [ "a", "A", "b", "B" ];; 
gap> SetMonoidGeneratorLabels( T, labsT );; 
gap> PrintUsingLabels( lrwsT, genfgmonT, labsT );
[ [ B*b, [ ], id ], [ b*B, [ ], id ], [ A*a, [ ], id ], [ a*A, [ ], id ], [ B*\
A, [ [ -5, 
id ] ], A*B ], [ B*a, [ [ 5, A ] ], a*B ], [ b*A, [ [ 5, B ] ], A*b ], [ 
b*a, [ [ -5, A*B ] ], a*b ] ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  logrws.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

