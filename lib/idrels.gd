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
#O  GroupRelatorSequenceLessThan( <YI>, <Y2> )
#O  ConvertToGroupRelatorSequences( <G>, <S> )
#O  ConvertToYSequences( <G>, <F>, <S> )
#O  ModuleRelatorSequenceReduce( <Y> )
#O  YSequenceConjugateAndReduce( <Y>, <rws> )
#O  ReduceGroupRelatorSequences( <seq> )
##
DeclareOperation( "GroupRelatorSequenceLessThan", [ IsList, IsList ] );
DeclareOperation( "ConvertToGroupRelatorSequences", 
    [ IsFpGroup, IsHomogeneousList ] ); 
DeclareOperation( "ConvertToYSequences", 
    [ IsFpGroup, IsFreeGroup, IsHomogeneousList ] ); 
DeclareOperation( "ModuleRelatorSequenceReduce", [ IsList ] );
DeclareOperation( "YSequenceConjugateAndReduce", [IsList,IsHomogeneousList] );
DeclareOperation( "ReduceGroupRelatorSequences", [ IsHomogeneousList ] );

#############################################################################
##  
#A  IdentityRelatorSequences( <G> )
#A  IdentityRelatorSequencesKB( <G> )
##
DeclareAttribute( "IdentityRelatorSequences", IsFpGroup );
DeclareAttribute( "IdentityRelatorSequencesKB", IsFpGroup );

#############################################################################
##
#O  ReduceModulePolyList( <L> )
##
DeclareOperation( "ReduceModulePolyList", 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList, IsHomogeneousList ] );

#############################################################################
##
#A  IdentitiesAmongRelators( <G> )
#A  IdentityYSequences( <G> )
#A  IdentitiesAmongRelatorsKB( <G> )
#A  IdentityYSequencesKB( <G> )
#A  RootIdentities( <G> )
##
DeclareAttribute( "IdentitiesAmongRelators", IsGroup );
DeclareAttribute( "IdentityYSequences", IsGroup );
DeclareAttribute( "IdentitiesAmongRelatorsKB", IsGroup );
DeclareAttribute( "IdentityYSequencesKB", IsGroup );
DeclareAttribute( "RootIdentities", IsGroup );

#############################################################################
##
#E idrels.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
