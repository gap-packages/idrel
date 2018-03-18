##############################################################################
##
#W  logrws.gd                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2018 Anne Heyworth and Chris Wensley 
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
##
DeclareGlobalFunction( "LengthLexLess" );
DeclareGlobalFunction( "LengthLexGreater" );

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
#R  IsMonoidPresentationFpGroupRep( <G> )
#P  IsMonoidPresentationFpGroup( <G> )
#O  ArrangeMonoidGenerators( <G>, <L> )
#A  ArrangementOfMonoidGenerators( <G> ) 
#A  MonoidPresentationFpGroup( <G> )
#A  InverseGeneratorsOfFpGroup( <G> ) 
#A  FreeGroupOfPresentation( <mon> )
#A  GroupRelatorsOfPresentation( <mon> )
#A  InverseRelatorsOfPresentation( <mon> )
#A  HomomorphismOfPresentation( <mon> )
#A  MonoidGeneratorsFpGroup( <G> )
#A  ElementsOfMonoidPresentation( <G> )
#O  PartialElementsOfMonoidPresentation( <G,len> )
#A  PartialElements( <G> )
#A  PartialInverseElements( <G> )
#A  PartialElementsLength( <G> )
#O  InverseWordInFreeGroupOfPresentation( <F>, <w> ) 
##
DeclareRepresentation( "IsMonoidPresentationFpGroupRep", 
##  tried removing the IsFpGroup (29/07/17) 
#?    IsFpGroup and IsAttributeStoringRep, 
    IsAttributeStoringRep, 
    [ "ArrangementOfMonoidGenerators", "FreeGroupOfPresentation", 
      "GroupRelatorsOfPresentation", "InverseRelatorsOfPresentation", 
      "HomomorphismOfPresentation" ] );
DeclareProperty( "IsMonoidPresentationFpGroup", IsList );
DeclareAttribute( "MonoidPresentationFpGroup", IsFpGroup ); 
DeclareOperation( "ArrangeMonoidGenerators", [ IsFpGroup, IsHomogeneousList ] ); 
DeclareAttribute( "ArrangementOfMonoidGenerators", IsFpGroup ); 
DeclareAttribute( "FreeGroupOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "InverseGeneratorsOfFpGroup", IsFpGroup );
DeclareAttribute( "GroupRelatorsOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "InverseRelatorsOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "HomomorphismOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "MonoidGeneratorsFpGroup", IsFpGroup ); 
DeclareAttribute( "ElementsOfMonoidPresentation", IsFpGroup );
DeclareOperation( "PartialElementsOfMonoidPresentation", 
    [ IsFpGroup, IsPosInt ] );
DeclareAttribute( "PartialElements", IsFpGroup, "mutable" );
DeclareAttribute( "PartialInverseElements", IsFpGroup, "mutable" );
DeclareAttribute( "PartialElementsLength", IsFpGroup, "mutable" );
DeclareAttribute( "GenerationTree", IsFpGroup, "mutable" ); 
DeclareOperation( "InverseWordInFreeGroupOfPresentation", 
    [ IsFpGroup, IsWord ] ); 

#############################################################################
##
#O  MonoidWordFpWord( <word>, <fam>, <order> )
##
DeclareOperation( "MonoidWordFpWord", [IsWord, IsFamilyDefaultRep, IsList] );

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
DeclareAttribute( "RewritingSystemFpGroup", IsFpGroup );

#############################################################################
##
#O  InitialLoggedRules( <G> )
#O  LoggedOnePassReduceWord( <word>, <rules> )
#O  LoggedReduceWordKB( <word>, <rules> )
#O  LoggedOnePassKB( <G>, <rules> )
#O  LoggedRewriteReduce( <G>, <rules> )
#O  LoggedKnuthBendix( <G>, <rules> )
##
DeclareOperation( "InitialLoggedRules", [ IsFpGroup ] ); 
DeclareOperation( "LoggedOnePassReduceWord", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "LoggedReduceWordKB", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "LoggedOnePassKB", [ IsFpGroup, IsHomogeneousList ] );
DeclareOperation( "LoggedRewriteReduce", [ IsFpGroup, IsHomogeneousList ] );
DeclareOperation( "LoggedKnuthBendix", [ IsFpGroup, IsHomogeneousList ] );

#############################################################################
##
#O  CheckLoggedKnuthBendix( <rules> )
##
DeclareOperation( "CheckLoggedKnuthBendix", [ IsHomogeneousList ] );

#############################################################################
##
#O  BetterLoggedRuleByReductionOrLength( <rulel>, <rule2> )
##
##  cannot require homogeneous lists because of middle terms
##
DeclareOperation( "BetterLoggedRuleByReductionOrLength", [ IsList, IsList ] );

#############################################################################
##
#A  LoggedRewritingSystemFpGroup( <G> )
##
DeclareAttribute( "LoggedRewritingSystemFpGroup", IsGroup );

#############################################################################
##
#O  RelatorSequenceReduce( <G>, <seq> )
##
DeclareOperation( "RelatorSequenceReduce", [ IsFpGroup, IsHomogeneousList ] );

#############################################################################
##
#E logrws.gd. . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
