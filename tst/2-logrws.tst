##############################################################################
##
#W  2-logrws.tst                   Idrel Package                 Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2017 Anne Heyworth and Chris Wensley
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
gap> l0; 
[ [ q8_M1^4, [ [ 1, <identity ...> ] ], <identity ...> ], 
  [ q8_M2^4, [ [ 2, <identity ...> ] ], <identity ...> ], 
  [ q8_M1*q8_M2*q8_M1*q8_M4, [ [ 3, <identity ...> ] ], <identity ...> ], 
  [ q8_M1^2*q8_M2^2, [ [ 4, <identity ...> ] ], <identity ...> ], 
  [ q8_M1*q8_M3, [  ], <identity ...> ], [ q8_M2*q8_M4, [  ], <identity ...> ]
    , [ q8_M3*q8_M1, [  ], <identity ...> ], 
  [ q8_M4*q8_M2, [  ], <identity ...> ] ]
gap> l1 := LoggedOnePassKB( l0 );;
gap> Length( l1[1] );
21

## Example 3.1.2
gap> l11 := LoggedRewriteReduce( l1[1] );
[ [ q8_M1*q8_M3, [  ], <identity ...> ], 
  [ q8_M2^2, [ [ -4, <identity ...> ], [ 2, q8_M1^-2 ] ], q8_M1^2 ], 
  [ q8_M2*q8_M4, [  ], <identity ...> ], [ q8_M3*q8_M1, [  ], <identity ...> ]
    , [ q8_M4*q8_M2, [  ], <identity ...> ], 
  [ q8_M1^3, [ [ 1, <identity ...> ] ], q8_M3 ], 
  [ q8_M1^2*q8_M2, [ [ 4, <identity ...> ] ], q8_M4 ], 
  [ q8_M1*q8_M2*q8_M1, [ [ 3, <identity ...> ] ], q8_M2 ], 
  [ q8_M2*q8_M1*q8_M4, [ [ 3, q8_M3^-1 ] ], q8_M3 ] ]
gap> Length( l11 );
9
gap> l2 := LoggedKnuthBendix( l11 );;
gap> l2[1]; 
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
gap> Length( l2[1] );
16
gap> Length( l2[2] );
49

## Example 3.2.1
gap> w0; 
q8_M2^9*q8_M1^9
gap> lw1 := LoggedOnePassReduceWord( w0, l0 );
[ [ [ 1, q8_M2^-9 ], [ 2, <identity ...> ] ], q8_M2^5*q8_M1^5 ]
gap> lw2 := LoggedReduceWordKB( w0, l0 ); 
[ [ [ 1, q8_M2^-9 ], [ 2, <identity ...> ], [ 1, q8_M2^-5 ], 
      [ 2, <identity ...> ] ], q8_M2*q8_M1 ]
gap> lw2 := LoggedReduceWordKB( w0, l2[1] ); 
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

## Example 3.2.2
gap> lrws := LoggedRewritingSystemFpGroup( q8 );
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
gap> Length( lrws );
16

gap> lrwsT := LoggedRewritingSystemFpGroup( T );
[ [ T_M4*T_M3, [  ], <identity ...> ], [ T_M3*T_M4, [  ], <identity ...> ], 
  [ T_M2*T_M1, [  ], <identity ...> ], [ T_M1*T_M2, [  ], <identity ...> ], 
  [ T_M4*T_M2, [ [ -5, <identity ...> ] ], T_M2*T_M4 ], 
  [ T_M4*T_M1, [ [ 5, T_M1^-1 ] ], T_M1*T_M4 ], 
  [ T_M3*T_M2, [ [ 5, T_M3^-1 ] ], T_M2*T_M3 ], 
  [ T_M3*T_M1, [ [ -5, T_M1^-1*T_M3^-1 ] ], T_M1*T_M3 ] ]

#############################################################################
##
#E  2-logrws.tst . . . . . . . . . . . . . . . . . . . . . . . . . ends here

