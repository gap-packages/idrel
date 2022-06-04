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

#############################################################################
##
#A  IdentitiesAmongRelators( <G> ) 
#A  RootIdentities( <G> )
#A  RootPositions( <G> )
##
DeclareAttribute( "IdentitiesAmongRelators", IsFpGroup ); 
DeclareAttribute( "RootIdentities", IsFpGroup );
DeclareAttribute( "RootPositions", IsFpGroup );

##############################################################################
##
#O  LogSequenceLessThan( <J>, <K> )
#O  ReduceLogSequences( <G>, <seq> )
#O  ExpandLogSequence( <mG>, <L> ) 
#O  MoveLeftLogSequence( <mG>, <K>, <L>, <q> ) 
#O  MoveRightLogSequence( <mG>, <L>, <p>, <q> ) 
#O  SwapLogSequence( <mG>, <L>, <p>, <q> ) 
#O  CancelInversesLogSequence( <mG>, <K> ) 
#O  CancelImmediateInversesLogSequence( <K> ) 
#O  ConjugateByWordLogSequence( <mG>, <J>, <w> ) 
#O  FixFirstTermLogSequence( <mG>, <J> ) 
#O  ChangeStartLogSequence( <mG>, <J>, <p> ) 
#O  InverseLogSequence( <J> ) 
#O  ConjugatingWordOfLoggedTerm( <mG>, <t> ) 
##
DeclareOperation( "LogSequenceLessThan", [ IsList, IsList ] );
DeclareOperation( "ReduceLogSequences", [ IsFpGroup, IsHomogeneousList ] );
DeclareOperation( "ExpandLogSequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] ); 
DeclareOperation( "MoveLeftLogSequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsList, IsPosInt ] ); 
DeclareOperation( "MoveRightLogSequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsList, IsPosInt ] ); 
DeclareOperation( "SwapLogSequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt, IsPosInt ] ); 
DeclareOperation( "CancelInversesLogSequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] ); 
DeclareOperation( "CancelImmediateInversesLogSequence", 
    [ IsHomogeneousList ] ); 
DeclareOperation( "ConjugateByWordLogSequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsWord ] ); 
DeclareOperation( "FixFirstTermLogSequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ] ); 
DeclareOperation( "ChangeStartLogSequence", 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt ] ); 
DeclareOperation( "InverseLogSequence", 
    [ IsHomogeneousList ] ); 
DeclareOperation( "ConjugatingWordOfLoggedTerm", 
    [ IsMonoidPresentationFpGroup, IsList ] );

#############################################################################
##  
#A  LogSequenceRewriteRules( <mon> ) 
#O  OnePassReduceLogSequence( <seq> <rules> ) 
#O  SubstituteLogSubsequence( <seq> <sub1> <sub2 > ) 
#O  IdentityRelatorSequences( <G> )
#O  AreEquivalentIdentitiies( <G> <L1> <L2> ) 
##
DeclareAttribute( "LogSequenceRewriteRules", 
    IsMonoidPresentationFpGroup, "mutable" ); 
DeclareOperation( "OnePassReduceLogSequence", 
    [ IsHomogeneousList, IsHomogeneousList ] ); 
DeclareOperation( "SubstituteLogSubsequence", [ IsMonoidPresentationFpGroup, 
    IsHomogeneousList, IsHomogeneousList, IsHomogeneousList ] ); 
DeclareOperation( "IdentityRelatorSequences", [ IsFpGroup ] );
DeclareOperation( "AreEquivalentIdentities", 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList ] ); 

##############################################################################
##
#O  ConvertToGroupRelatorSequences( <G>, <S> )
#O  ModuleRelatorSequenceReduce( <Y> )
##
DeclareOperation( "ConvertToGroupRelatorSequences", 
    [ IsFpGroup, IsHomogeneousList ] ); 
DeclareOperation( "ModuleRelatorSequenceReduce", [ IsList ] );

#############################################################################
##
#O  ReduceModulePolyList( <L> )
##
DeclareOperation( "ReduceModulePolyList", 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList, IsHomogeneousList ] );

##############################################################################
##
#A  IdentityYSequences( <G> )
#O  ConvertToYSequences( <G>, <F>, <S> )
#O  YSequenceConjugateAndReduce( <Y>, <rws> ) 
## 
DeclareAttribute( "IdentityYSequences", IsFpGroup );
DeclareOperation( "ConvertToYSequences", 
    [ IsFpGroup, IsFreeGroup, IsHomogeneousList ] ); 
DeclareOperation( "YSequenceConjugateAndReduce", [IsList,IsHomogeneousList] ); 

#############################################################################
##
#O  PrintYSequence( <obj>, <gens1>, <labs1>, <gens2>, <labs2> )
#O  PrintLnYSequence( <obj>, <gens1>, <labs1>, <gens2>, <labs2> )
##
DeclareOperation( "PrintYSequence", 
    [ IsObject, IsList, IsList, IsList, IsList ] );
DeclareOperation( "PrintLnYSequence", 
    [ IsObject, IsList, IsList, IsList, IsList ] );

#############################################################################
##
#E idrels.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
