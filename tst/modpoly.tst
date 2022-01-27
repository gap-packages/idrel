##############################################################################
##
#W  modpoly.tst                  Idrel Package                   Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2022 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

## items defined in rws.tst and monpoly.tst 
gap> F := FreeGroup( 2 );;
gap> f := F.1;;  g := F.2;;
gap> rels8 := [ f^4, g^4, f*g*f*g^-1, f^2*g^2 ];;
gap> q8 := F/rels8;;
gap> SetName( q8, "q8" );;
gap> mon := MonoidPresentationFpGroup( q8 );;
gap> fgmon := FreeGroupOfPresentation( mon );; 
gap> genfgmon := GeneratorsOfGroup( fgmon );;
gap> gprels := GroupRelatorsOfPresentation( mon );; 
gap> invrels := InverseRelatorsOfPresentation( mon );; 
gap> monrels := Concatenation( gprels, invrels );; 
gap> id := One( monrels[1] );;
gap> r0 := List( monrels, r -> [ r, id ] );; 
gap> r1 := OnePassKB( r0 );;
gap> r1 := RewriteReduce( r1 );; 
gap> r2 := KnuthBendix( r1 );;
gap> q8labs := [ "a", "b", "A", "B" ];; 
gap> freeq8 := FreeGroupOfFpGroup( q8 );; 
gap> M := GeneratorsOfGroup( fgmon );;
gap> mp1 := MonoidPolyFromCoeffsWords( [9,-7,5], 
>               [ M[1]*M[3], M[2]^3, M[4]*M[3]*M[2] ] );; 
gap> rmp1 := ReduceMonoidPoly( mp1, r2 );;


## Example 5.1.1
gap> q8R := FreeRelatorGroup( q8 );; 
gap> genq8R := GeneratorsOfGroup( q8R ); 
[ q8_R1, q8_R2, q8_R3, q8_R4 ]
gap> Print( rmp1, "\n" ); 
 - 7*q8_M4 + 5*q8_M1 + 9*<identity ...>
gap> M := GeneratorsOfGroup( fgmon ); 
[ q8_M1, q8_M2, q8_M3, q8_M4 ]
gap> mp2 := MonoidPolyFromCoeffsWords( [4,-5], [ M[4], M[1] ] );;
gap> Print( mp2, "\n" ); 
4*q8_M4 - 5*q8_M1
gap> zeromp := ZeroModulePoly( q8R, freeq8 );
zero modpoly 

## Example 5.1.2
gap> q8R := FreeRelatorGroup( q8 );; 
gap> q8Rlabs := [ "q", "r", "s", "t" ];; 
gap> s1 := ModulePoly( [ genq8R[4], genq8R[1] ], [ rmp1, mp2 ] );;
gap> PrintLnModulePoly( s1, genfgmon, q8labs, genq8R, q8Rlabs );
q*(4*B + -5*a) + t*(-7*B + 5*a + 9*id)
gap> s2 := ModulePoly( [ genq8R[3], genq8R[2], genq8R[1] ], 
>       [ -1*rmp1, 3*mp2, (rmp1+mp2) ] );;
gap> PrintLnModulePoly( s2, genfgmon, q8labs, genq8R, q8Rlabs );
q*(-3*B + 9*id) + r*(12*B + -15*a) + s*(7*B + -5*a + -9*id)

## Example 5.2.1
gap> [ Length(s1), Length(s2) ];
[ 2, 3 ]
gap> One( s1 );
<identity ...>
gap> Terms( s1 );
[ [ q8_R1, 4*q8_M4 - 5*q8_M1 ], 
  [ q8_R4,  - 7*q8_M4 + 5*q8_M1 + 9*<identity ...> ] ]
gap> Print( LeadTerm( s1 ), "\n" );
[ q8_R4,  - 7*q8_M4 + 5*q8_M1 + 9*<identity ...> ]
gap> Print( LeadTerm( s2 ), "\n" );
[ q8_R3, 7*q8_M4 - 5*q8_M1 - 9*<identity ...> ]
gap> Print( LeadMonoidPoly( s1 ), "\n" );
 - 7*q8_M4 + 5*q8_M1 + 9*<identity ...>
gap> Print( LeadMonoidPoly( s2 ), "\n" );
7*q8_M4 - 5*q8_M1 - 9*<identity ...>

## Example 5.3.1
gap> mp0 := MonoidPolyFromCoeffsWords( [6], [ M[2] ] );;
gap> s0 := AddTermModulePoly( s1, genq8R[3], mp0 ); 
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

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

##############################################################################
##
#E  modpoly.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

