##############################################################################
##
#W  logrws.gd                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2016 Anne Heyworth and Chris Wensley 
##
##  This file contains declarations of operations for logged rewrite systems.

DeclareInfoClass( "InfoIdRel" );

#############################################################################
##
#V  InfoIdRel
##
DeclareInfoClass( "InfoIdRel" );

#############################################################################
##
#O  LengthLexLess( <args> )
#O  LengthLexGreater( <args> )
#O  SyllableLess( <args> )
#O  SyllableGreater( <args> )
##
DeclareGlobalFunction( "LengthLexLess" );
DeclareGlobalFunction( "LengthLexGreater" );
DeclareGlobalFunction( "SyllableLess" );
DeclareGlobalFunction( "SyllableGreater" );

#############################################################################
##
#A  FreeRelatorGroup( <G> ) 
#A  FreeRelatorHomomorphism( <G> )
## 
DeclareAttribute( "FreeRelatorGroup", IsFpGroup );
DeclareAttribute( "FreeRelatorHomomorphism", IsFpGroup );

#############################################################################
##
#O  OnePassReduceWord( <word>, <rules> )
#O  ReduceWordKB( <word>, <rules> )
#O  OnePassKB( <rules> )
#O  RewriteReduce( <rules> )
#O  KnuthBendix( <rules> )
##
DeclareOperation( "OnePassReduceWord", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "ReduceWordKB", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "OnePassKB", [ IsHomogeneousList ] );
DeclareOperation( "RewriteReduce", [ IsHomogeneousList ] );
DeclareOperation( "KnuthBendix", [ IsHomogeneousList ] );

#############################################################################
##
#C  IsMonoidPoly
DeclareCategory( "IsMonoidPoly", IsMultiplicativeElement );
MonoidPolyFam := NewFamily( "MonoidPolyFam", IsMonoidPoly );

#############################################################################
##
#R  IsMonoidPresentationFpGroup( <G> )
#A  MonoidPresentationFpGroup( <G> )
#A  FreeGroupOfPresentation( <mon> )
#A  GroupRelatorsOfPresentation( <mon> )
#A  InverseRelatorsOfPresentation( <mon> )
#A  HomomorphismOfPresentation( <mon> )
#A  ElementsOfMonoidPresentation( <G> )
##
DeclareRepresentation( "IsMonoidPresentationFpGroup", 
    IsFpGroup and IsAttributeStoringRep, 
    [ "FreeGroupOfPresentation", "GroupRelatorsOfPresentation", 
      "InverseRelatorsOfPresentation", "HomomorphismOfPresentation" ] );
DeclareAttribute( "MonoidPresentationFpGroup" , IsFpGroup );
DeclareAttribute( "FreeGroupOfPresentation", IsMonoidPresentationFpGroup );
DeclareAttribute( "GroupRelatorsOfPresentation", IsMonoidPresentationFpGroup );
DeclareAttribute( "InverseRelatorsOfPresentation", IsMonoidPresentationFpGroup );
DeclareAttribute( "HomomorphismOfPresentation", IsMonoidPresentationFpGroup );
DeclareAttribute( "ElementsOfMonoidPresentation", IsFpGroup );

#############################################################################
##
#O  MonoidWordFpWord( <word>, <fam>, <shift> )
##
DeclareOperation( "MonoidWordFpWord", [IsWord, IsFamilyDefaultRep, IsPosInt] );

#############################################################################
##
#O  BetterRuleByReductionOrLength( <rule1>, <rule2> )
##
DeclareOperation( "BetterRuleByReductionOrLength", 
    [ IsHomogeneousList, IsHomogeneousList ] );

#############################################################################
##
#A  RewritingSystemFpGroup( <G> )
##
DeclareAttribute( "RewritingSystemFpGroup", IsGroup );

#############################################################################
##
#O  LoggedOnePassReduceWord( <word>, <rules> )
#O  LoggedReduceWordKB( <word>, <rules> )
#O  LoggedOnePassKB( <rules> )
#O  LoggedRewriteReduce( <rules> )
#O  LoggedKnuthBendix( <rules> )
##
DeclareOperation( "LoggedOnePassReduceWord", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "LoggedReduceWordKB", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "LoggedOnePassKB", [ IsHomogeneousList ] );
DeclareOperation( "LoggedRewriteReduce", [ IsHomogeneousList ] );
DeclareOperation( "LoggedKnuthBendix", [ IsHomogeneousList ] );

#############################################################################
##
#O  CheckLoggedKnuthBendix( <rules> )
##
DeclareOperation( "CheckLoggedKnuthBendix", [ IsHomogeneousList ] );

#############################################################################
##
#O  BetterLoggedRuleByReductionOrLength( <rulel>, <rule2> )
##
## cannot require homogeneous lists because of middle terms
##
DeclareOperation( "BetterLoggedRuleByReductionOrLength", [ IsList, IsList ] );

#############################################################################
##
#A  LoggedRewritingSystemFpGroup( <G> )
##
DeclareAttribute( "LoggedRewritingSystemFpGroup", IsGroup );

##############################################################################
##
#O  OrderingYSequences( <YI>, <Y2> )
#O  ReducedYSequence( <Y> )
#A  IdentityYSequences( <G> )
##
DeclareOperation( "OrderingYSequences", [ IsList, IsList ] );
DeclareOperation( "ReducedYSequence", [ IsList ] );
DeclareAttribute( "IdentityYSequences", IsGroup );

#############################################################################
##
#E logrws.gd. . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
