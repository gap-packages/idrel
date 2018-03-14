##############################################################################
##
#W  idrels.gd                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2018 Anne Heyworth and Chris Wensley 
##
##  This file contains the declarations of operations for 
##  identities among relators.

##############################################################################
##
#O  YSequenceLessThan( <YI>, <Y2> )
#O  ConvertToGroupRelatorSequences( <G>, <S> )
#O  ConvertToYSequences( <G>, <F>, <S> )
#O  YSequenceReduce( <Y> )
#O  YSequenceConjugateAndReduce( <Y>, <rws> )
#O  ReduceGroupRelatorSequences( <seq> )
##
DeclareOperation( "YSequenceLessThan", [ IsList, IsList ] );
DeclareOperation( "ConvertToGroupRelatorSequences", 
    [ IsFpGroup, IsHomogeneousList ] ); 
DeclareOperation( "ConvertToYSequences", 
    [ IsFpGroup, IsFreeGroup, IsHomogeneousList ] ); 
DeclareOperation( "YSequenceReduce", [ IsList ] );
DeclareOperation( "YSequenceConjugateAndReduce", [IsList,IsHomogeneousList] );
DeclareOperation( "ReduceGroupRelatorSequences", [ IsHomogeneousList ] );

#############################################################################
##
#A  IdentityYSequences( <G> )
#A  IdentityYSequencesKB( <G> )
#A  IdentityGroupRelatorSequences( <G> )
#A  IdentityGroupRelatorSequencesKB( <G> )
#A  IdentityMonoidRelatorSequences( <G> )
#A  IdentityMonoidRelatorSequencesKB( <G> )
##
DeclareAttribute( "IdentityYSequences", IsFpGroup );
DeclareAttribute( "IdentityYSequencesKB", IsFpGroup );
DeclareAttribute( "IdentityGroupRelatorSequences", IsFpGroup );
DeclareAttribute( "IdentityGroupRelatorSequencesKB", IsFpGroup );
DeclareAttribute( "IdentityMonoidRelatorSequences", IsFpGroup );
DeclareAttribute( "IdentityMonoidRelatorSequencesKB", IsFpGroup );

#############################################################################
##
#O  ReduceModulePolyList( <L> )
##
DeclareOperation( "ReduceModulePolyList", 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList, IsHomogeneousList ] );

#############################################################################
##
#A  IdentitiesAmongRelators( <G> )
#A  IdentitiesAmongRelatorsKB( <G> )
#A  RootIdentities( <G> )
##
DeclareAttribute( "IdentitiesAmongRelators", IsGroup );
DeclareAttribute( "IdentitiesAmongRelatorsKB", IsGroup );
DeclareAttribute( "RootIdentities", IsGroup );

#############################################################################
##
#E idrels.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
