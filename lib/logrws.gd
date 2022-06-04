##############################################################################
##
#W  logrws.gd                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2022 Anne Heyworth and Chris Wensley 
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
#R  IsMonoidPresentationFpGroupRep( <G> )
#P  IsMonoidPresentationFpGroup( <G> )
#O  ArrangeMonoidGenerators( <G>, <L> )
#A  ArrangementOfMonoidGenerators( <G> ) 
#A  InversesOfMonoidGenerators( <G> ) 
#A  MonoidPresentationFpGroup( <G> ) 
#A  UnderlyingGroupOfPresentation( <mon> ) 
#A  FreeGroupOfPresentation( <mon> )
#A  GroupRelatorsOfPresentation( <mon> )
#A  InverseRelatorsOfPresentation( <mon> )
#A  InverseRulesOfPresentation( <mon> )
#A  HomomorphismOfPresentation( <mon> ) 
#A  IsomorphicFpGroup( <G> ) 
#A  IsomorphismByPresentation( <G> ); 
#A  MonoidGeneratorsFpGroup( <G> )
#A  MonoidPresentationLabels( <G> )
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
DeclareAttribute( "UnderlyingGroupOfPresentation", 
    IsMonoidPresentationFpGroup ); 
DeclareOperation( "ArrangeMonoidGenerators", [ IsFpGroup, IsHomogeneousList ] ); 
DeclareAttribute( "ArrangementOfMonoidGenerators", IsFpGroup ); 
DeclareAttribute( "InverseGeneratorsOfFpGroup", IsFpGroup ); 
DeclareAttribute( "FreeGroupOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "GroupRelatorsOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "InverseRelatorsOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "InverseRulesOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "HomomorphismOfPresentation", 
    IsMonoidPresentationFpGroupRep );
DeclareAttribute( "IsomorphicFpGroup", IsFpGroup ); 
DeclareAttribute( "IsomorphismByPresentation", IsFpGroup ); 
DeclareAttribute( "MonoidGeneratorsFpGroup", IsFpGroup ); 
DeclareAttribute( "MonoidPresentationLabels", IsFpGroup ); 
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
#O  OnePassReduceWord( <word>, <rules> )
#O  ReduceWordKB( <word>, <rules> )
#O  OnePassKB( <monG>, <rules> )
#O  RewriteReduce( <monG>, <rules> )
#O  KnuthBendix( <monG>, <rules> )
##
DeclareOperation( "OnePassReduceWord", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "ReduceWordKB", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "OnePassKB", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] );
DeclareOperation( "RewriteReduce", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] );
DeclareOperation( "KnuthBendix", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] );

#############################################################################
##
#C  IsMonoidPoly
DeclareCategory( "IsMonoidPoly", IsMultiplicativeElement );
MonoidPolyFam := NewFamily( "MonoidPolyFam", IsMonoidPoly );

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
#A  InitialLoggedRulesOfPresentation( <mG> )
#A  InitialRulesOfPresentation( <mG> )
DeclareAttribute( "InitialLoggedRulesOfPresentation", 
    IsMonoidPresentationFpGroup ); 
DeclareAttribute( "InitialRulesOfPresentation", 
    IsMonoidPresentationFpGroup ); 

#############################################################################
##
#O  LoggedOnePassReduceWord( <word>, <rules> )
#O  LoggedReduceWordKB( <word>, <rules> )
#O  LoggedOnePassKB( <mG>, <rules> )
#O  LoggedRewriteReduce( <mG>, <rules> )
#O  LoggedKnuthBendix( <mG>, <rules> )
##
DeclareOperation( "LoggedOnePassReduceWord", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "LoggedReduceWordKB", [ IsWord, IsHomogeneousList ] );
DeclareOperation( "LoggedOnePassKB", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] );
DeclareOperation( "LoggedRewriteReduce", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] );
DeclareOperation( "LoggedKnuthBendix", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] );

#############################################################################
##
#O  CheckLoggedKnuthBendix( <rules> )
##
DeclareOperation( "CheckLoggedKnuthBendix", [ IsHomogeneousList ] );

#############################################################################
##
#O  BetterLoggedRuleByReductionOrLength( <rulel>, <rule2> ) 
#O  BetterLoggedList( <L1>, <L2> ) 
##
##  cannot require homogeneous lists because of middle terms
##
DeclareOperation( "BetterLoggedRuleByReductionOrLength", [ IsList, IsList ] );
DeclareOperation( "BetterLoggedList", [ IsList, IsList ] ); 

#############################################################################
## 
#A  LoggedRewritingSystemFpGroup( <G> ) 
#A  IdentitiesFromLoggedRewriting( <G> ) 
## 
DeclareAttribute( "LoggedRewritingSystemFpGroup", IsFpGroup ); 
DeclareAttribute( "IdentitiesFromLoggedRewriting", IsFpGroup ); 

#############################################################################
##
#O  LogSequenceReduce( <mG>, <seq> )
##
DeclareOperation( "LogSequenceReduce", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] );

#############################################################################
##
#O  PrintUsingLabels( <obj>, <gens>, <labs> )
#O  PrintLnUsingLabels( <obj>, <gens>, <labs> )
##
DeclareOperation( "PrintUsingLabels", [ IsObject, IsList, IsList ] );
DeclareOperation( "PrintLnUsingLabels", [ IsObject, IsList, IsList ] );

#############################################################################
##
#E logrws.gd. . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
