##############################################################################
##
#W  monpoly.gd                    IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2016 Anne Heyworth and Chris Wensley 
##
##  The category of monoid polynomials is declared.

#############################################################################
##
#R  IsMonoidPolyTermsRep( <poly> )
##
##  A monoid polynomial is a list of terms and term = coeff*word
##
DeclareRepresentation( "IsMonoidPolyTermsRep", 
    IsMonoidPoly and IsAttributeStoringRep, [ "coeffs", "words" ] );

#############################################################################
##
#O  MonoidPolyFromCoeffsWordsNC( <coeffs>, <words> )
#O  MonoidPolyFromCoeffsWords( <coeffs>, <words)
##
DeclareOperation( "MonoidPolyFromCoeffsWordsNC", [ IsList, IsList ] );
DeclareOperation( "MonoidPolyFromCoeffsWords", [ IsList, IsList ] );

#############################################################################
##
#O  MonoidPoly( <args> )
##
DeclareGlobalFunction( "MonoidPoly" );

#############################################################################
##
#A  Coeffs( <poly> )
#A  Words( <poly> )
#A  Terms( <poly> )
#A  LeadTerm( <poly> )
#A  LeadCoeffMonoidPoly( <poly> )
#A  LeadWordMonoidPoly( <poly> )
##
DeclareAttribute( "Coeffs", IsMonoidPolyTermsRep );
DeclareAttribute( "Words", IsMonoidPolyTermsRep );
DeclareAttribute( "Terms", IsMonoidPolyTermsRep );
DeclareAttribute( "LeadTerm", IsMonoidPolyTermsRep );
DeclareAttribute( "LeadCoeffMonoidPoly", IsMonoidPolyTermsRep );
DeclareAttribute( "LeadWordMonoidPoly", IsMonoidPolyTermsRep );

#############################################################################
##
#O  AddTermMonoidPoly( <poly>, <coeff>, <word> )
##
DeclareOperation( "AddTermMonoidPoly", 
    [ IsMonoidPolyTermsRep, IsRat, IsWord ] );

#############################################################################
##
#O  ZeroMonoidPoly( <F> )
##
DeclareOperation( "ZeroMonoidPoly", [ IsFreeGroup ] );

#############################################################################
##
#O  Monic( <poly> )
##
DeclareOperation( "Monic", [ IsMonoidPolyTermsRep ] );

#############################################################################
##
#O  ReduceMonoidPoly( <poly, rules> )
##
DeclareOperation( "ReduceMonoidPoly", [ IsMonoidPolyTermsRep, IsList ] );

#############################################################################
##
#O  LoggedReduceMonoidPoly( <poly>, <rules>, <sats> )
##
DeclareOperation( "LoggedReduceMonoidPoly", 
    [ IsMonoidPolyTermsRep, IsHomogeneousList, IsHomogeneousList ] );

######################################*#######################################
##
#E monpoly.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
