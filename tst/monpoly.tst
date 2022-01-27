##############################################################################
##
#W  monpoly.tst                  Idrel Package                   Chris Wensley
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
gap> r1 := OnePassKB( r0 );;
gap> r1 := RewriteReduce( r1 );; 
gap> r2 := KnuthBendix( r1 );;

## Example 4.1.1
gap> rels8 := RelatorsOfFpGroup( q8 ); 
[ f1^4, f2^4, f1*f2*f1*f2^-1, f1^2*f2^2 ]
gap> freeq8 := FreeGroupOfFpGroup( q8 );; 
gap> gens := GeneratorsOfGroup( freeq8 );;
gap> famfree := ElementsFamily( FamilyObj( freeq8 ) );; 
gap> famfree!.monoidPolyFam := MonoidPolyFam;; 
gap> cg := [6,7];; 
gap> pg := MonoidPolyFromCoeffsWords( cg, gens );; 
gap> Print( pg, "\n" ); 
7*f2 + 6*f1
gap> cr := [3,4,-5,-2];;
gap> pr := MonoidPolyFromCoeffsWords( cr, rels8 );; 
gap> Print( pr, "\n" );
4*f2^4 - 5*f1*f2*f1*f2^-1 - 2*f1^2*f2^2 + 3*f1^4
gap> Print( ZeroMonoidPoly( freeq8 ), "\n" );
zero monpoly 

## Example 4.2.1
gap> Coeffs( pr );
[ 4, -5, -2, 3 ]
gap> Terms( pr );
[ [ 4, f2^4 ], [ -5, f1*f2*f1*f2^-1 ], [ -2, f1^2*f2^2 ], [ 3, f1^4 ] ]
gap> Words( pr );
[ f2^4, f1*f2*f1*f2^-1, f1^2*f2^2, f1^4 ]
gap> LeadTerm( pr );
[ 4, f2^4 ]
gap> LeadCoeffMonoidPoly( pr );
4

## Example 4.2.2
gap> mpr := Monic( pr );; 
gap> Print( mpr, "\n" ); 
 f2^4 - 5/4*f1*f2*f1*f2^-1 - 1/2*f1^2*f2^2 + 3/4*f1^4

## Example 4.2.3
gap> w := gens[1]^gens[2]; 
f2^-1*f1*f2
gap> cw := 3/4;;  
gap> wpg := AddTermMonoidPoly( pg, cw, w );;
gap> Print( wpg, "\n" );
3/4*f2^-1*f1*f2 + 7*f2 + 6*f1

## Example 4.3
gap> [ pg = pg, pg = pr ]; 
[ true, false ]
gap> prcw := pr * cw;;
gap> Print( prcw, "\n" ); 
3*f2^4 - 15/4*f1*f2*f1*f2^-1 - 3/2*f1^2*f2^2 + 9/4*f1^4
gap> cwpr := cw * pr;;
gap> Print( cwpr, "\n" ); 
3*f2^4 - 15/4*f1*f2*f1*f2^-1 - 3/2*f1^2*f2^2 + 9/4*f1^4
gap> [ pr = prcw, prcw = cwpr ];
[ false, true ]
gap> Print( pg + pr, "\n" );
4*f2^4 - 5*f1*f2*f1*f2^-1 - 2*f1^2*f2^2 + 3*f1^4 + 7*f2 + 6*f1
gap> Print( pg - pr, "\n" );
 - 4*f2^4 + 5*f1*f2*f1*f2^-1 + 2*f1^2*f2^2 - 3*f1^4 + 7*f2 + 6*f1
gap> Print( pg * w, "\n" );
6*f1*f2^-1*f1*f2 + 7*f1*f2
gap> Print( pg * pr, "\n" );
28*f2^5 - 35*(f2*f1)^2*f2^-1 - 14*f2*f1^2*f2^2 + 21*f2*f1^4 + 24*f1*f2^4 - 
30*f1^2*f2*f1*f2^-1 - 12*f1^3*f2^2 + 18*f1^5

## Example 4.3.1
gap> Length( pr );
4

gap> [ pr > 3*pr, pr > pg ];
[ false, true ]

## Example 4.4.1
gap> M := genfgmon;; 
gap> mp1 := MonoidPolyFromCoeffsWords( [9,-7,5], 
>               [ M[1]*M[3], M[2]^3, M[4]*M[3]*M[2] ] );; 
gap> PrintUsingLabels( mp1, genfgmon, q8labs ); 
5*B*A*b + -7*b^3 + 9*a*A
gap> rmp1 := ReduceMonoidPoly( mp1, r2 );;
gap> PrintUsingLabels( rmp1, genfgmon, q8labs );         
-7*B + 5*a + 9*id

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  monpoly.tst . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
