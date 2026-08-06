##############################################################################
##
#W  robynn.tst                   Idrel Package                   Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2026 Anne Heyworth and Chris Wensley
##
##  this example appears in issue #28, from Robynn Corveleyn

gap> p := 5;;
gap> F := FreeGroup( "a", "b", "c" );;
gap> a := F.1;; b:=F.2;; c:=F.3;;
gap> comms := [ Comm(a,Comm(a,b)), Comm(b,Comm(a,b)), Comm(b,Comm(b,c)),
> Comm(a,c), Comm(c,Comm(c,Comm(b,c))), Comm(b,Comm(c,Comm(b,c))) ];;
gap> powers := [ a^p, b^p, c^p ];;
gap> rels := Concatenation( powers, comms );;
gap> G := F/rels;;
gap> Size(G);
1953125
gap> monG := MonoidPresentationFpGroup( G );;
gap> SetName( monG, "M" );

gap> initG := InitialRulesOfPresentation( monG );
[ [ mon1^-1, mon4 ], [ mon2^-1, mon5 ], [ mon3^-1, mon6 ], 
  [ mon4^-1, mon1 ], [ mon5^-1, mon2 ], [ mon6^-1, mon3 ], 
  [ mon1*mon4, <identity ...> ], [ mon2*mon5, <identity ...> ], 
  [ mon3*mon6, <identity ...> ], [ mon4*mon1, <identity ...> ], 
  [ mon5*mon2, <identity ...> ], [ mon6*mon3, <identity ...> ], 
  [ mon4*mon6*mon1*mon3, <identity ...> ], [ mon1^5, <identity ...> ], 
  [ mon2^5, <identity ...> ], [ mon3^5, <identity ...> ], 
  [ mon4*mon5*mon4*mon2*mon1*mon5*mon1*mon2, <identity ...> ], 
  [ mon5*mon6*mon5*mon3*mon2*mon6*mon2*mon3, <identity ...> ], 
  [ mon5^2*mon4*mon2*mon1*mon2*mon4*mon5*mon1*mon2, <identity ...> ], 
  [ mon6^2*mon5*mon3*mon2*mon6*mon5*mon6*mon2*mon3*mon5*mon3*mon2*mon3*mon5*mon\
6*mon2*mon3, <identity ...> ], 
  [ mon5*mon6*mon5*mon3*mon2*mon6*mon5*mon6*mon2*mon3^2*mon2*mon6^2*mon5*mon3*m\
on2*mon3*mon5*mon6*mon2*mon3, <identity ...> ] ]
gap> rulesG1 := OnePassKB( monG, initG );;
gap> redG1 := RewriteReduce( monG, rulesG1 );;
gap> Print( "[|rulesG1|,|redG1|] = ", [Length(rulesG1),Length(redG1)], "\n" );
[|rulesG1|,|redG1|] = [ 42, 27 ]
gap> rulesG2 := OnePassKB( monG, redG1 );;
gap> redG2 := RewriteReduce( monG, rulesG2 );;
gap> Print( "[|rulesG2|,|redG2|] = ", [Length(rulesG2),Length(redG2)], "\n" );
[|rulesG2|,|redG2|] = [ 60, 33 ]
gap> rulesG3 := OnePassKB( monG, redG2 );;
gap> redG3 := RewriteReduce( monG, rulesG3 );;
gap> Print( "[|rulesG3|,|redG3|] = ", [Length(rulesG3),Length(redG3)], "\n" );
[|rulesG3|,|redG3|] = [ 111, 50 ]
gap> rulesG4 := OnePassKB( monG, redG3 );;
gap> redG4 := RewriteReduce( monG, rulesG4 );;
gap> Print( "[|rulesG4|,|redG4|] = ", [Length(rulesG4),Length(redG4)], "\n" );
[|rulesG4|,|redG4|] = [ 320, 107 ]
gap> rulesG5 := OnePassKB( monG, redG4 );;
1000 found
2000 found
gap> redG5 := RewriteReduce( monG, rulesG5 );;
gap> Print( "[|rulesG5|,|redG5|] = ", [Length(rulesG5),Length(redG5)], "\n" );
[|rulesG5|,|redG5|] = [ 1634, 617 ]

gap> LinitG := InitialLoggedRulesOfPresentation( monG );;
gap> rulesL1 := LoggedOnePassKB( monG, LinitG );;
gap> redL1 := LoggedRewriteReduce( monG, rulesL1 );;
gap> Print( "[|rulesL1|,|redL1|] = ", [Length(rulesL1),Length(redL1)], "\n" );
[|rulesL1|,|redL1|] = [ 45, 27 ]
gap> rulesL2 := LoggedOnePassKB( monG, redL1 );;
gap> redL2 := LoggedRewriteReduce( monG, rulesL2 );;
gap> Print( "[|rulesL2|,|redL2|] = ", [Length(rulesL2),Length(redL2)], "\n" );
[|rulesL2|,|redL2|] = [ 63, 33 ]
gap> rulesL3 := LoggedOnePassKB( monG, redL2 );;
gap> redL3 := LoggedRewriteReduce( monG, rulesL3 );;
gap> Print( "[|rulesL3|,|redL3|] = ", [Length(rulesL3),Length(redL3)], "\n" );
[|rulesL3|,|redL3|] = [ 119, 50 ]
gap> rulesL4 := LoggedOnePassKB( monG, redL3 );;
gap> redL4 := LoggedRewriteReduce( monG, rulesL4 );;
gap> Print( "[|rulesL4|,|redL4|] = ", [Length(rulesL4),Length(redL4)], "\n" );
[|rulesL4|,|redL4|] = [ 342, 106 ]
gap> rulesL5 := LoggedOnePassKB( monG, redL4 );;
gap> redL5 := LoggedRewriteReduce( monG, rulesL5 );;
gap> Print( "[|rulesL5|,|redL5|] = ", [Length(rulesL5),Length(redL5)], "\n" );
[|rulesL5|,|redL5|] = [ 1753, 616 ]
