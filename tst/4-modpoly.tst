##############################################################################
##
#W  4-modpoly.tst                  Idrel Package                 Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2018 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

## Example 5.1.1
gap> frq8 := FreeRelatorGroup( q8 );; 
gap> genfrq8 := GeneratorsOfGroup( frq8 ); 
[ q8_R1, q8_R2, q8_R3, q8_R4 ]
gap> Print( rmp1, "\n" ); 
 - 7*q8_M4 + 5*q8_M1 + 9*<identity ...>
gap> mp2 := MonoidPolyFromCoeffsWords( [4,-5], [ M[4], M[1] ] );;
gap> Print( mp2, "\n" ); 
4*q8_M4 - 5*q8_M1
gap> s1 := ModulePoly( [ genfrq8[4], genfrq8[1] ], [ rmp1, mp2 ] );
q8_R1*(4*q8_M4 - 5*q8_M1) + q8_R4*( - 7*q8_M4 + 5*q8_M1 + 9*<identity ...>)
gap> s2 := ModulePoly( [ genfrq8[3], genfrq8[2], genfrq8[1] ], 
>       [ -1*rmp1, 3*mp2, (rmp1+mp2) ] );
q8_R1*( - 3*q8_M4 + 9*<identity ...>) + q8_R2*(12*q8_M4 - 15*q8_M1) + q8_R3*(
7*q8_M4 - 5*q8_M1 - 9*<identity ...>)
gap> zeromp := ZeroModulePoly( frq8, freeq8 );
zero modpoly 

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
gap> s0 := AddTermModulePoly( s1, genfrq8[3], mp0 ); 
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

#############################################################################
##
#E  4-modpoly.tst . . . . . . . . . . . . . . . . . . . . . . . . . ends here

