##############################################################################
##
#W  idrel_manual.g                 Idrel Package                 Chris Wensley
#W                                                             & Anne Heyworth
##
#Y  Copyright (C) 1999-2016 Anne Heyworth and Chris Wensley
##

## ====================== Rewriting Systems ===================== 

## Example 2.1 

F := FreeGroup( 2 );
a := F.1;
b := F.2;
rels3 := [ a^3, b^2, a*b*a*b ]; 
s3 := F/rels3; 
SetName( s3, "s3" ); 
idrels3 := IdentitiesAmongRelators( s3 );
idy3 := IdentityYSequences( s3 ); 
Length( idy3 ); 
Y4 := idy3[4];
Y6 := idy3[6];
Y8 := idy3[8]; 
Print( "YSequences 4, 6 and 8:\n", Y4, "\n", Y6, "\n", Y8, "\n\n" ); 
Print( "identities among relators for group s3:\n" ); 
Display( idrels3[1] );

## The quaternion group example 

rels := [ a^4, b^4, a*b*a*b^-1, a^2*b^2 ];
q8 := F/rels;
Print( "q8 is the quaternion group F/rels where rels = ", rels, "\n" ); 
SetName( q8, "q8" );
frq8 := FreeRelatorGroup( q8 ); 
frhomq8 := FreeRelatorHomomorphism( q8 );
mon := MonoidPresentationFpGroup( q8 ); 
fgmon := FreeGroupOfPresentation( mon ); 
genfgmon := GeneratorsOfGroup( fgmon );
gprels := GroupRelatorsOfPresentation( mon ); 
invrels := InverseRelatorsOfPresentation( mon ); 
hompres := HomomorphismOfPresentation( mon ); 
rws := RewritingSystemFpGroup( q8 );
monrels := Concatenation( gprels, invrels ); 
id := One( monrels[1] );
r0 := List( monrels, r -> [ r, id ] ); 

ap := genfgmon[1];
bp := genfgmon[2];
am := genfgmon[3];
bm := genfgmon[4];
w0 := bp^9 * ap^9; 
w1 := OnePassReduceWord( w0, r0 ); 
w2 := ReduceWordKB( w0, r0 ); 
r1 := OnePassKB( r0 );
r1 := RewriteReduce( r1 ); 
r2 := KnuthBendix( r1 );
Print( "complete rewrite system for q8 :-\n", r2, "\n" ); 
w2 := ReduceWordKB( w0, r2 ); 
Print( "word w0 = ", w0, " rewrites to w2 = ", w2, "\n" ); 
elq8 := Elements( q8 ); 
Print( "normal forms for the 8 elements in q8:\n", elq8, "\n\n" ); 
elmonq8 := ElementsOfMonoidPresentation( q8 );


Print( "\n\n\n============= Logged Rewriting Systems =================\n\n" );

l0 := ListWithIdenticalEntries( 8, 0 );
for j in [1..8] do
   r := r0[j];
   if (j<5) then
      l0[j] := [ r[1], [ [j,id] ], r[2] ];
   else
      l0[j] := [ r[1], [ ], r[2] ];
   fi;
od;
l0; 
l1 := LoggedOnePassKB( l0 );
Length( l1 );
l1 := LoggedRewriteReduce( l1 );
l2 := LoggedKnuthBendix( l1 ); 
Print( "complete logged rewrite system for q8 :-\n", l2, "\n" ); 

w0; 
lw1 := LoggedOnePassReduceWord( w0, l0 );
lw2 := LoggedReduceWordKB( w0, l0 ); 
lw2 := LoggedReduceWordKB( w0, l2 ); 
Print( "word w0 = ", w0, " logged rewrites to lw2 = ", lw2, "\n" ); 


Print( "\n\n\n================ Monoid Polynomials ===================\n\n" );

rels := RelatorsOfFpGroup( q8 ); 
freeq8 := FreeGroupOfFpGroup( q8 ); 
gens := GeneratorsOfGroup( freeq8 );
famfree := ElementsFamily( FamilyObj( freeq8 ) ); 
famfree!.monoidPolyFam := MonoidPolyFam; 
cg := [6,7]; 
pg := MonoidPolyFromCoeffsWords( cg, gens );; 
Print( "monoid polynomial pg = " );
Print( pg, "\n" ); 
cr := [3,4,-5,-2];
pr := MonoidPolyFromCoeffsWords( cr, rels );; 
Print( "monoid polynomial pr = " );
Print( pr, "\n" );
Print( "zero monoid polynomial = " );
Print( ZeroMonoidPoly( freeq8 ), "\n" );
Print( "pr has coefficients ", Coeffs( pr ), "\n" );
Print( "pr has terms ", Terms( pr ), "\n" );
Print( "pr has words ", Words( pr ), "\n" );
Print( "pr has lead term ", LeadTerm( pr ), "\n" );
Print( "pr has lead coefficient ", LeadCoeffMonoidPoly( pr ), "\n" );

mpr := Monic( pr );; 
Print( "monic form of pr is ", mpr, "\n" );
w := gens[1]^gens[2]; 
cw := 3/4;  
wpg := AddTermMonoidPoly( pg, cw, w );; 
Print( "adding cw = ", cw, " of w = ", w, " to pg gives", wpg, "\n" );
Print( "pg=pg ?,  pg=pr ?  " );
[ pg = pg, pg = pr ]; 
prcw := pr * cw;;
Print( "pr*cw = ", prcw, "\n" ); 
cwpr := cw * pr;;
Print( "cw*pr = ", cwpr, "\n" ); 
[ pr = prcw, prcw = cwpr ];
Print( "pg + pr = ", pg + pr, "\n" );
Print( "pg - pr = ", pg - pr, "\n" );
Print( "pg * w = ", pg * w, "\n" );
Print( "pg * pr = ", pg * pr, "\n" );
Print( "pr has length ", Length( pr ), "\n" );
Print( "pr > 3*pr ? ", pr > 3*pr, "\n" ); 
Print( "pr > pg ? ", pr > pg, "\n" );

M := genfgmon; 
Print( "mp1 is the monoid polynomial with coefficients [9,-7,5]\n" ); 
Print( "and words [M[1]*M[3], M[2]^3, M[4]*M[3]*M[2]]\n" );
mp1 := MonoidPolyFromCoeffsWords( [9,-7,5], [M[1]*M[3], M[2]^3, M[4]*M[3]*M[2]] );; 
Print( mp1, "\n" ); 
rmp1 := ReduceMonoidPoly( mp1, r2 );;
Print( "the reduced form of mp1 is rmp1 = " );
Print( rmp1, "\n" ); 


Print( "\n\n\n================== Module Polynomials ==================\n\n" );

frq8 := FreeRelatorGroup( q8 ); 
genfrq8 := GeneratorsOfGroup( frq8 ); 
Print( "mp2 has coefficients [4,-5] and words [ M[4], M[1] ] :-\n" );
mp2 := MonoidPolyFromCoeffsWords( [4,-5], [ M[4], M[1] ] );;
Print( mp2, "\n" ); 
Print( "module polynomial s1 = \n" );
s1 := ModulePoly( [ genfrq8[4], genfrq8[1] ], [ rmp1, mp2 ] );
Print( "module polynomial s2 = \n" );
s2 := ModulePoly( [ genfrq8[3], genfrq8[2], genfrq8[1] ], 
   [ -1*rmp1, 3*mp2, (rmp1+mp2) ] );
zeromp := ZeroModulePoly( frq8, freeq8 );
Print( "s1,s2 have lengths ", [ Length(s1), Length(s2) ], "\n" );
Print( " One(s1) = ", One( s1 ), "\n" );
Print( "s1 has terms ", Terms( s1 ), "\n" );
Print( "s1 has lead term", LeadTerm( s1 ), "\n" );
Print( "s2 has lead term", LeadTerm( s2 ), "\n" );
Print( "s1 has lead monoid poly", LeadMonoidPoly( s1 ), "\n" );
Print( "s2 has lead monoid poly", LeadMonoidPoly( s2 ), "\n" );

mp0 := MonoidPolyFromCoeffsWords( [6], [ M[2] ] );
s0 := AddTermModulePoly( s1, genfrq8[3], mp0 ); 
Print( "module polynomial s0 = ", s0, "\n" );
Print( "s1 + s2 = ", s1 + s2, "\n" );
Print( "s1 - s0 = ", s1 - s0, "\n" );
Print( "s1 * 1/2 = ", s1 * 1/2, "\n" );
Print( "s1 * M[1] = ", s1 * M[1], "\n" );


Print( "\n\n\n============== Identities among relators ==============\n\n" );

yseqs := IdentityYSequences( q8 );;
Print( "q8 has ", Length( yseqs ), " Ysequences\n" );
polys := IdentityModulePolys( q8 );;
Print( "q8 has ", Length( polys ), " module polynomials\n" );
idsq8 := IdentitiesAmongRelators( q8 );;
Print( "q8 has ", Length( idsq8 ), "identities among relators\n" );
Length( idsq8[1] );
Print( "the 7 identities for q8:\n" );
Display( idsq8[1] );
Print( "q8 has root identities:\n", RootIdentities( q8 ), "\n" );
Print( "s3 has root identities:\n", RootIdentities( s3 ), "\n" );

Print( "\n=========== end of output from: idrel_manual.g ==============\n\n" );
