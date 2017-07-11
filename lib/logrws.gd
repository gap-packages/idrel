##############################################################################
##
#W  logrws.gd                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2017 Anne Heyworth and Chris Wensley 
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
#R  IsMonoidPresentationFpGroupRep( <G> )
#P  IsMonoidPresentationFpGroup( <G> )
#A  ArrangementOfMonoidGenerators( <G> ) 
#A  MonoidPresentationFpGroup( <G> )
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
DeclareAttribute( "ArrangementOfMonoidGenerators", IsFpGroup ); 
DeclareAttribute( "FreeGroupOfPresentation", 
    IsMonoidPresentationFpGroupRep );
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
DeclareAttribute( "GenerationTree", IsFpGroup ); 
DeclareAttribute( "PartialElements", IsFpGroup );
DeclareAttribute( "PartialInverseElements", IsFpGroup );
DeclareAttribute( "PartialElementsLength", IsFpGroup );

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
#A  RelatorSequenceReduce( <L> )
##
DeclareAttribute( "RelatorSequenceReduce", IsHomogeneousList );

##############################################################################
##
#O  YSequenceLessThan( <YI>, <Y2> )
#O  YSequencesFromRelatorSequences( <S>, <G> )
#O  YSequenceReduce( <Y> )
#O  YSequenceConjugateAndReduce( <Y>, <rws> )
#A  IdentityYSequencesOld( <G> )
#A  IdentityYSequences( <G> )
#A  IdentityYSequencesKB( <G> )
##
DeclareOperation( "YSequenceLessThan", [ IsList, IsList ] );
DeclareOperation( "YSequencesFromRelatorSequences", [ IsList, IsGroup ] ); 
DeclareOperation( "YSequenceReduce", [ IsList ] );
DeclareOperation( "YSequenceConjugateAndReduce", [IsList,IsHomogeneousList] );
DeclareAttribute( "IdentityYSequencesOld", IsGroup );
DeclareAttribute( "IdentityYSequences", IsGroup );
DeclareAttribute( "IdentityYSequencesKB", IsGroup );

#############################################################################
##
#E logrws.gd. . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
