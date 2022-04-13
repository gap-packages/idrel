##############################################################################
##
#W  modpoly.gd                    IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2022 Anne Heyworth and Chris Wensley 
##
##  This file contains the declarations of operations for module polynomials.
##  A ModulePoly is a list of terms [<gen>, <monoid poly> ], 
##  where <gen> is a generator of a free group, 
##  sorted first by the order on the generators 
##  and then by the length-lex order on the monoid polynomials.

#############################################################################
##
#C  IsModulePoly
#C  IsLoggedModulePoly
##
DeclareCategory( "IsModulePoly", IsMultiplicativeElement );
DeclareCategory( "IsLoggedModulePoly", IsObject );

ModulePolyFam := NewFamily( "ModulePolyFam", IsModulePoly );
LoggedModulePolyFam := NewFamily( "LoggedModulePolyFam", IsLoggedModulePoly );

#############################################################################
##
#R  IsModulePolyGensPolysRep( <poly> )
##
## A module polynomial is a list of terms
##
DeclareRepresentation( "IsModulePolyGensPolysRep", 
    IsObject and IsAttributeStoringRep, [ "generators", "monoidPolys" ] );

#############################################################################
##
#O  ModulePolyFromGensPolysNC( <gens>, <ncpolys> )
#O  ModulePolyFromGensPolys( <gens>, <ncpolys> )
##
DeclareOperation( "ModulePolyFromGensPolysNC", [ IsList, IsList ] );
DeclareOperation( "ModulePolyFromGensPolys", [ IsList, IsList ] );

##############################################################################
##
#O  ModulePoly( <args> )
##
DeclareGlobalFunction( "ModulePoly" );

#############################################################################
##
#A  GeneratorsOfModulePoly( <poly> )
#A  MonoidPolys( <poly> )
#A  LeadGenerator( <poly> )
#A  LeadMonoidPoly( <poly> )
##
DeclareAttribute( "GeneratorsOfModulePoly", IsModulePolyGensPolysRep );
DeclareAttribute( "MonoidPolys", IsModulePolyGensPolysRep );
DeclareAttribute( "LeadGenerator", IsModulePolyGensPolysRep );
DeclareAttribute( "LeadMonoidPoly", IsModulePolyGensPolysRep );

#####################################***###*#################################
##
#O  AddTermModulePoly( <poly>, <gen>, <ncpoly> )
##
DeclareOperation( "AddTermModulePoly", 
    [ IsModulePolyGensPolysRep, IsWord, IsMonoidPolyTermsRep ] );

#############################################################################
##
#O  ZeroModulePoly( <R>, <F> )
##
DeclareOperation( "ZeroModulePoly", [ IsFreeGroup, IsFreeGroup ] );

#############################################################################
##
#A  FreeYSequenceGroup( <G> )
##
DeclareAttribute( "FreeYSequenceGroup", IsFpGroup );

#############################################################################
##
#R  IsLoggedModulePolyYSeqRelsRep( <poly> )
##
## A logged module poly is a pair ( YSeqModulePoly, RelsModulePoly )
##
DeclareRepresentation( "IsLoggedModulePolyYSeqRelsRep", 
    IsObject and IsAttributeStoringRep, 
    [ "ySequenceModulePoly", "relatorModulePoly" ] );

#############################################################################
##
#A  RelatorModulePoly( <poly> )
#A  YSequenceModulePoly( <poly> )
##
DeclareAttribute( "RelatorModulePoly", IsLoggedModulePolyYSeqRelsRep );
DeclareAttribute( "YSequenceModulePoly", IsLoggedModulePolyYSeqRelsRep );

#############################################################################
##
#O  LoggedModulePolyNC( <list>, <smp> )
##
DeclareOperation( "LoggedModulePolyNC", 
    [ IsModulePolyGensPolysRep, IsModulePolyGensPolysRep ] );

#############################################################################
##
#O  LoggedModulePoly( <list>, <smp> )
##
DeclareOperation( "LoggedModulePoly", 
    [ IsModulePolyGensPolysRep, IsModulePolyGensPolysRep ] );

#############################################################################
##
#O  SaturatedSetLoggedModulePoly( <logsmp>, <elmon>, <rws>, <sats> )
##
DeclareOperation( "SaturatedSetLoggedModulePoly",
    [ IsLoggedModulePolyYSeqRelsRep, IsList, IsList, IsList ] );

############################################################################
##
#O  MinimiseLeadTerm( <poly, gp, rules> )
##
DeclareOperation( "MinimiseLeadTerm", 
    [ IsLoggedModulePolyYSeqRelsRep, IsGroup, IsList ] );

#############################################################################
##
#O  ReduceModulePoly( <poly, rules> )
##
DeclareOperation( "ReduceModulePoly", [ IsModulePolyGensPolysRep, IsList ] );

#############################################################################
##
#O  LoggedReduceModulePoly( <smp>, <rules>, <sats>, <zero> )
##
DeclareOperation( "LoggedReduceModulePoly", 
    [ IsModulePolyGensPolysRep, IsList, IsList, IsModulePolyGensPolysRep ] );

#############################################################################
##
#O  PrintModulePoly( <obj>, <gens1>, <labs1>, <gens2>, <labs2> )
#O  PrintModulePolyTerm( <obj>, <gens1>, <labs1>, <gens2>, <labs2> )
#O  PrintLnModulePoly( <obj>, <gens1>, <labs1>, <gens2>, <labs2> )
##
DeclareOperation( "PrintModulePoly", 
    [ IsObject, IsList, IsList, IsList, IsList ] );
DeclareOperation( "PrintModulePolyTerm", 
    [ IsObject, IsList, IsList, IsList, IsList ] );
DeclareOperation( "PrintLnModulePoly", 
    [ IsObject, IsList, IsList, IsList, IsList ] );

#############################################################################
##
#E modpoly.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
