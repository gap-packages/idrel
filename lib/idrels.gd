##############################################################################
##
#W  idrels.gd                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2022 Anne Heyworth and Chris Wensley 
##
##  This file contains the declarations of operations for 
##  identities among relators.

##############################################################################
##
#O  GroupRelatorSequenceLessThan( <YI>, <Y2> )
#O  ConvertToGroupRelatorSequences( <G>, <S> )
#O  ConvertToYSequences( <G>, <F>, <S> )
#O  ModuleRelatorSequenceReduce( <Y> )
#O  YSequenceConjugateAndReduce( <Y>, <rws> ) 
#O  RewriteRulesFromIdentities( <G>, <seq> ) 
#O  ReduceGroupRelatorSequences( <G>, <seq> )
##
DeclareOperation( "GroupRelatorSequenceLessThan", [ IsList, IsList ] );
DeclareOperation( "ConvertToGroupRelatorSequences", 
    [ IsFpGroup, IsHomogeneousList ] ); 
DeclareOperation( "ConvertToYSequences", 
    [ IsFpGroup, IsFreeGroup, IsHomogeneousList ] ); 
DeclareOperation( "ModuleRelatorSequenceReduce", [ IsList ] );
DeclareOperation( "YSequenceConjugateAndReduce", [IsList,IsHomogeneousList] ); 
DeclareOperation( "ReduceGroupRelatorSequences", 
    [ IsFpGroup, IsHomogeneousList ] );

##############################################################################
##
#O  SwapIdentitySequence( <mG>, <L>, <p> ) 
#O  SwapIdentitySequenceLeft( <mG>, <L>, <p> ) 
#O  SwapIdentitySequenceRight( <mG>, <L>, <p> ) 
#O  PermuteIdentitySequence( <mG>, <L>, <p>, <q> ) 
##
DeclareOperation( "SwapIdentitySequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt ] ); 
DeclareOperation( "SwapIdentitySequenceLeft", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt ] ); 
DeclareOperation( "SwapIdentitySequenceRight", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt ] ); 
DeclareOperation( "PermuteIdentitySequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt, IsPosInt ] ); 


#############################################################################
##  
#A  IdentitySequenceRewriteRules( <mon> ) 
#O  MakeIdentitySequenceRewriteRules( <mon> ) 
#O  OnePassReduceSequence( <seq> <rules> ) 
#O  IdentityRelatorSequences( <G> )
#O  AreEquivalentIdentitiies( <G> <L1> <L2> ) 
##
DeclareAttribute( "IdentitySequenceRewriteRules", 
    IsMonoidPresentationFpGroup, "mutable" ); 
DeclareOperation( "MakeIdentitySequenceRewriteRules", 
    [ IsMonoidPresentationFpGroup ] ); 
DeclareOperation( "OnePassReduceSequence", 
    [ IsHomogeneousList, IsHomogeneousList ] ); 
DeclareOperation( "IdentityRelatorSequences", [ IsFpGroup ] );
DeclareOperation( "AreEquivalentIdentities", 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList ] ); 

#############################################################################
##
#O  ReduceModulePolyList( <L> )
##
DeclareOperation( "ReduceModulePolyList", 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList, IsHomogeneousList ] );

#############################################################################
##
#A  IdentitiesAmongRelators( <G> ) 
#A  PowerIdentities( <G> ) 
#A  IdentityYSequences( <G> )
#A  IdentityYSequencesKB( <G> )
#A  RootIdentities( <G> )
##
DeclareAttribute( "IdentitiesAmongRelators", IsFpGroup ); 
DeclareAttribute( "PowerIdentities", IsFpGroup ); 
DeclareAttribute( "IdentityYSequences", IsFpGroup );
DeclareAttribute( "IdentityYSequencesKB", IsFpGroup );
DeclareAttribute( "RootIdentities", IsFpGroup );

#############################################################################
##
#E idrels.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
