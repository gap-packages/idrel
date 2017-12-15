##############################################################################
##
#W  modpoly.gi                    IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2017 Anne Heyworth and Chris Wensley 
##
##  This file contains generic methods for module polynomials

#############################################################################
##
#M  String, ViewString, PrintString, ViewObj, PrintObj 
##  . . . . . . . . . . . . . . . . . . . . . . . . .  for monoid polynomials 
##
InstallMethod( String, "for a module poly with generators, monoidpolys", 
    true, [ IsModulePolyGensPolysRep ], 0, 
function( e ) 
    return( STRINGIFY( "module polynomial" ) ); 
end );

InstallMethod( ViewString, "for a module poly with generators, monoidpolys", 
    true, [ IsModulePolyGensPolysRep ], 0, String ); 

InstallMethod( PrintString, "for a module poly with generators, monoidpolys", 
    true, [ IsModulePolyGensPolysRep ], 0, String ); 

InstallMethod( ViewObj, "for a module poly with generators, monoidpolys", 
    true, [ IsModulePolyGensPolysRep ], 0, 
function( p ) 
    Print( p );
end );

InstallMethod( PrintObj, "for a module poly with generators, monoidpolys", 
    true, [ IsModulePolyGensPolysRep ], 0, 
function( poly )

    local  n, g, len, i;

    n := MonoidPolys( poly ); 
    g := GeneratorsOfModulePoly( poly );
    len := Length( poly );
    if ( len = 0 ) then 
        Print( "zero modpoly " );
    else 
        ### 11/10/05 : Display -> Print
        Print( g[1], "*(", n[1], ")" );
        for i in [2..len] do
            Print( " + ", g[i], "*(", n[i], ")" );
        od;
    fi;
end );

##############################################################################
##
#M  ModulePolyFromGensPolysNC . . assumes lists of generators and monoid polys
##
InstallMethod( ModulePolyFromGensPolysNC, 
    "generic method for a module polynomial", true, [ IsList, IsList ], 0, 
function( gens, polys )

    local  fam, filter, poly;

    ### 11/10/05 : problem after moving ModulePolyFam to modpoly.gd
    ### fam := FamilyObj( gens[1] )!.modulePolyFam;
    fam := ModulePolyFam;
    filter := IsModulePoly and IsModulePolyGensPolysRep;
    poly := Objectify( NewType( fam, filter ), rec() );
    SetGeneratorsOfModulePoly( poly, gens );
    SetMonoidPolys( poly, polys );
    if ( ( Length( gens ) = 1 ) and ( gens[1] = One( gens[1] ) ) ) then
        SetLength( poly, 0 );
    fi;
    return poly;
end );

##############################################################################
##
#M  ModulePolyFromGensPolys
##
InstallMethod( ModulePolyFromGensPolys, 
    "generic method for a module polynomial", true, [ IsList, IsList ], 0, 
function( gp, pp )

    local  polys, gens, len, L, i, j, gi;

    polys := ShallowCopy( pp ); 
    gens := ShallowCopy( gp );
    len := Length( gens );
    if not ForAll( gens, w -> ( IsWord( w ) and Length( w ) = 1 ) ) then 
        Error( "first list must contain generators of a free group" );
    fi;
    if not ( ( Length( polys) = len ) and 
             ForAll( polys, n -> IsMonoidPolyTermsRep( n ) ) ) then 
        Error( "second list must be list of ncpolys and have same length" );
    fi;
    SortParallel( gens, polys, function(u,v) return u<v; end );
    L := [1..len];
    i := 1;
    while ( i < len ) do gi := gens[i];
        j := i+1;
        while ( ( j <= len ) and ( gens[j] = gi ) ) do 
            polys[i] := polys[i] + polys[j];
            polys[j] := 0;
            j := j+1;
        od;
        i := j;
    od;
    L := Filtered( L, i -> ( polys[i] <> 0 ) );
    for j in L do 
        if ( Coeffs( polys[j] ) = [ 0 ] ) then 
            polys[j] := 0;
        fi;
    od;
    L := Filtered( L, i -> ( polys[i] <> 0 ) );
    polys := polys{L};
    gens := gens{L};
    if ( polys = [ ] ) then
        gens := [ One( gp[1] ) ];
        polys := [ One( Words( pp[1] )[1] ) ];
    fi;
    return ModulePolyFromGensPolysNC( gens, polys );
end );

############################################################################## 
##
#M  ModulePoly
##
InstallGlobalFunction( ModulePoly, 
function( arg )

    local  nargs, g, n, i;

    nargs := Length( arg );
    if not ForAll( arg, a -> IsList( a ) ) then 
        Error( "arguments must all be lists: terms or (gens + ncpolys)" );
    fi;
    if ( nargs = 2 ) then 
        # expect gens + ncpolys 
        g := arg[1];
        n := arg[2];
        if ( Length( g ) = Length( n ) ) then 
            if ( ForAll( g, x -> ( IsWord( x ) and ( Length( x ) = 1 ) ) ) 
                 and ForAll( n, x -> IsMonoidPolyTermsRep( x ) ) ) then 
                return ModulePolyFromGensPolys( g, n );
            elif ( ForAll( g, x -> ( IsMonoidPolyTermsRep( x ) ) ) and 
                   ForAll( n, x -> ( IsWord( x ) and ( Length( x ) = 1 ) ) ) )
                then return ModulePolyFromGensPolys( n, g );
            fi;
        fi; 
    fi;
    # expect list of terms 
    if not ForAll( arg, a -> 
        ( ( Length( a ) = 2 ) and IsWord( a[1] ) and ( Length( a[1] ) = 1 ) 
          and IsMonoidPolyTermsRep( a[2] ) ) ) then 
        Error( "expecting a list of terms [ gen, ncpoly ]" );
    fi;
    g := [1..nargs];
    n := [1..nargs];
    for i in [1..nargs] do
        g[1] := arg[i][1];
        n[i] := arg[i][2];
    od;
    return ModulePolyFromGensPolys( g, n );
end );

##############################################################################
##
#M  Length for a module polynomial
##
InstallOtherMethod( Length, "generic method for a module polynomial", true, 
    [ IsModulePolyGensPolysRep ], 0, 
function( poly )

    local  g, len;

    g := GeneratorsOfModulePoly( poly );
    len := Length( g );
    if ( ( len = 1 ) and ( g[1] = One( g[1] ) ) ) then
        len := 0;
    fi;
    return len;
end );

###############################################################################
##
#M  \= for a module polynomial
##
InstallOtherMethod( \=, "generic method for module polynomials", true, 
    [ IsModulePolyGensPolysRep, IsModulePolyGensPolysRep ], 0, 
function( s1, s2 )

    local  i, n1, n2;

    if not ( GeneratorsOfModulePoly(s1) = GeneratorsOfModulePoly(s2) ) then 
        return false;
    fi;
    n1 := MonoidPolys( s1 );
    n2 := MonoidPolys( s2 );
    for i in [1..Length(s1)] do 
        if ( n1[i] <> n2[i] ) then 
            return false;
        fi;
    od;
    return true;
end );

##############################################################################
##
#M  One                                                for a module polynomial
##
InstallOtherMethod( One, "generic method for a module polynomial", true, 
    [ IsModulePolyGensPolysRep ], 0, 
poly -> One( FamilyObj( GeneratorsOfModulePoly( poly )[1] ) ) );

##############################################################################
##
#M  Terms
##
InstallOtherMethod( Terms, "generic method for a module polynomial", true, 
    [ IsModulePolyGensPolysRep ], 0, 
function( poly )

    local  g, n, t, i;

    g := GeneratorsOfModulePoly( poly ); 
    n := MonoidPolys( poly );
    t := [ 1..Length( poly ) ];
    for i in [ 1..Length( poly ) ] do
        t[i] := [ g[i], n[i] ];
    od;
    return t;
end );

##############################################################################
##
#M  LeadGenerator
##
InstallMethod( LeadGenerator, "generic method for a module polynomial", 
    true, [ IsModulePolyGensPolysRep ], 0, 
function( poly )

    if ( Length( poly ) = 0 ) then 
        return fail;
    else 
        return GeneratorsOfModulePoly( poly )[ Length( poly ) ];
    fi;
end );

##############################################################################
##
#M  LeadMonoidPoly
##
InstallMethod( LeadMonoidPoly, "generic method for a module polynomial", 
    true, [ IsModulePolyGensPolysRep ], 0, 
function( poly )

    if ( Length( poly ) = 0 ) then 
        return fail;
    else
        return MonoidPolys( poly )[ Length( poly ) ];
    fi;
end );

##############################################################################
##
#M  LeadTerm
##
InstallOtherMethod( LeadTerm, "generic method for a module polynomial", true, 
    [ IsModulePolyGensPolysRep ], 0, 
function( poly )

    if ( Length( poly ) = 0 ) then 
        return fail;
    else 
        return [ LeadGenerator( poly ), LeadMonoidPoly( poly ) ];
    fi;
end );

##############################################################################
##
#M  ZeroModulePoly
##
InstallMethod( ZeroModulePoly, "generic method for two free groups", 
    true, [ IsFreeGroup, IsFreeGroup ], 0, 
function( R, F ) 
    return ModulePolyFromGensPolysNC( [ One( R ) ], [ One( F )] );
end );

##############################################################################
##
#M  AddTermModulePoly
##
InstallMethod( AddTermModulePoly, 
    "generic method for a module polynomial and a term", true, 
    [ IsModulePolyGensPolysRep, IsWord, IsMonoidPolyTermsRep ], 0, 
function( poly, gen, ncpoly )

    local  pp, gp, len, i, j, terms, gi, pi, b, d, u, v, pa, ga, ans;

    gp := GeneratorsOfModulePoly( poly );
    if not ( FamilyObj( gen ) = FamilyObj( gp[1] ) ) then 
        Error( "poly and generator us1ng different free groups" );
     fi;
    if not ( Length( gen ) = 1 ) then 
        Error( "the second parameter must be a generator" );
    fi;
    pp := MonoidPolys( poly );
    len := Length( poly );
    i := 1;
    while ( ( gp[i] > gen ) and ( i < len ) ) do
        i := i + 1;
    od;
    if ( gp[len] > gen ) then
        i := len + 1;
        pa := Concatenation( pp, [ncpoly] );
        ga := Concatenation( gp, [gen] );
        return ModulePolyFromGensPolys( ga, pa );
    fi;
    gi := gp[i];
    pi := pp[i];
    if (gi = gen) then 
        pi := pi + ncpoly; 
        b := pp{[1..i-1]};
        d := pp{[i+1..len]};
        u := gp{[1..i-1]};
        v := gp{[i+1..len]};
        if ( pi <> 0 ) then 
            ans := ModulePolyFromGensPolys( Concatenation( b, [pi], d ), 
                                            Concatenation( u, [gi], v ) );
        elif ( len = 1 ) then 
            ans := ModulePolyFromGensPolys( [0], [One(FamilyObj( gen ))] );
        else 
            ans := ModulePolyFromGensPolys( Concatenation( b, d ), 
                                            Concatenation( u, v ) );
        fi;
    else
        if ( i = 1 ) then
            b := [ ];
            u := [ ];
        else
            b := pp{[1..i-1]};
            u := gp{[1..i-1]};
        fi;
        if ( i = len+1 ) then
            d := [ ];
            v := [ ];
        else
            d := pp{[i..len]};
            v := gp{[i..len]};
        fi;
        ans := ModulePolyFromGensPolys( Concatenation( u, [gen], v ), 
                                        Concatenation( b, [ncpoly], d ) );
    fi;
    return ans;
end );

##############################################################################
##
#M  \+ for two module polynomials
##
InstallOtherMethod( \+, "generic method for module polynomials", true, 
    [ IsModulePolyGensPolysRep, IsModulePolyGensPolysRep ], 0, 
function( p1, p2 )

    local  p, w;

    if ( Length( p1 ) = 0 ) then 
        return p2;
    elif ( Length( p2 ) = 0 ) then 
        return p1;
    fi;
    p := Concatenation( MonoidPolys( p1 ), MonoidPolys( p2 ) );
    w := Concatenation( GeneratorsOfModulePoly( p1 ), 
                        GeneratorsOfModulePoly( p2 ) );
    return ModulePolyFromGensPolys( w, p );
end );

##############################################################################
##
#M  \* for a module poly and a rational
##
InstallOtherMethod( \*, "generic method for module polynomial and rational", 
    true, [ IsModulePolyGensPolysRep, IsRat ], 0, 
function( poly, rat )

    local  p, len, one;

    if ( rat = 0 ) then 
        one := One( FamilyObj( GeneratorsOfModulePoly( poly )[1] ) ); 
        return ModulePolyFromGensPolys( [ 0 ], [ one ] );
    fi;
    len := Length( poly );
    if ( len = 0 ) then 
        return poly;
    fi;
    p := List( MonoidPolys( poly ), n -> n * rat );
    return ModulePolyFromGensPolys( GeneratorsOfModulePoly( poly ), p );
end );

##############################################################################
##
#M  \* for a rational and a module poly
##
InstallOtherMethod( \*, "generic method for rational and module polynomial", 
    true, [ IsRat, IsModulePolyGensPolysRep ], 0, 
function( rat, poly ) 
    return poly * rat;
end );

##############################################################################
##
#M  \- for a module polynomials
##
InstallOtherMethod( \-, "generic method for module polynomials", true, 
    [ IsModulePolyGensPolysRep, IsModulePolyGensPolysRep ], 0, 
function( s1, s2 ) 
    return s1 + ( s2 * (-1) );
end );

#############################################################################
##
#M  \* for a module poly and a word
##
InstallOtherMethod( \*, "generic method for module polynomial and word", 
    true, [ IsModulePolyGensPolysRep, IsWord ], 0, 
function( poly, word)

    local  n1, n2, lenp, lenn, i, mp;

    if ( poly = ( poly - poly ) ) then  
        #? surely there should be something better than this ?? 
        return poly;
    fi;
    n1 := MonoidPolys( poly );
    if not ( FamilyObj( word) = FamilyObj( Words( n1[1] )[1] ) ) then 
        Error( "poly and word us1ng different free groups" );
    fi;
    lenp := Length( poly );
    if ( lenp = 0 ) then 
        return poly;
    fi;
    lenn := Length( n1 );
    n2 := ListWithIdenticalEntries( lenn, 0 );
    for i in [1..lenn] do 
        n2[i] := n1[i] * word;
    od;
##Print( "poly = ", poly, "\n" );
##Print( "word = ", word, "\n" );
##Print( "n2 = ", n2, "\n" );
    mp := ModulePolyFromGensPolys( GeneratorsOfModulePoly( poly ), n2 ); 
##Print( "mp = ", mp, "\n" );
    return mp; 
end );

##############################################################################
##
#M  Monic
##
# InstallMethod( Monic, "generic method for a module polynomial", true, 
#   [ IsModulePolyGensPolysRep ], 0, 
# function( poly )
#
#     local  c, c1;
#
#     if ( Length( poly ) = 0 ) then 
#         return fail;
#     fi;
#     c:= Coeffs( poly );
#     c1 := c[1];
#     c := List( c, x -> x/c1 );
#     return ModulePolyFromGensPolysNC( c, GeneratorsOfModulePoly( poly ) );
# end );

##############################################################################
##
#M  \< for module polynomials
##
InstallOtherMethod( \<, "generic method for module polynomials", true, 
    [ IsModulePolyGensPolysRep, IsModulePolyGensPolysRep ], 0, 
function( p1, p2 )

    local  i, l1, l2, g1, g2, m1, m2; 

    g1 := GeneratorsOfModulePoly( p1 ); 
    g2 := GeneratorsOfModulePoly( p2 );
    l1 := Length( g1 );
    l2 := Length( g2 ); 
    if ( l1 < l2 ) then 
        return true;
    elif ( l1 > l2 ) then 
        return false;
    fi;
    m1 := MonoidPolys( p1 );
    m2 := MonoidPolys( p2 );
    # for i in [1..l1] do 
    for i in Reversed( [1..l1] ) do 
        if ( g1[i] < g2[i] ) then 
            return true;
        elif ( g1[i] > g2[i] ) then 
            return false;
        elif ( m1[i] < m2[i] ) then 
            return true;
        elif ( m1[i] > m2[i] ) then 
            return false;
        fi;
    od;
    # if here then polys are equal 
    return false;
end );

##############################################################################
##
#M  LoggedModulePolyNC                        assumes data in the correct form
##
InstallMethod( LoggedModulePolyNC, 
    "generic method for a logged module polynomial", true, 
    [ IsModulePolyGensPolysRep, IsModulePolyGensPolysRep ], 0, 
function( ypoly, rpoly )

    local  fam, filter, logpoly;

    fam := FamilyObj( [ ypoly, rpoly ] );
    filter := IsLoggedModulePolyYSeqRelsRep;
    logpoly := Objectify( NewType( fam, filter ), rec() );
    SetYSequenceModulePoly( logpoly, ypoly );
    SetRelatorModulePoly( logpoly, rpoly );
    return logpoly;
end );

##############################################################################
##
#M  LoggedModulePoly
##
InstallMethod( LoggedModulePoly, "generic method for logged module polynomial",
    true, [ IsModulePolyGensPolysRep, IsModulePolyGensPolysRep ], 0, 
function( ypoly, rpoly )

    # need to put some checks in here?
    return LoggedModulePolyNC( ypoly, rpoly );
end );

#############################################################################
##
#M  PrintObj( <logpoly> )
##
InstallMethod( PrintObj, "for a logged module poly", true, 
    [ IsLoggedModulePolyYSeqRelsRep ], 0, 
function( logpoly )

    Print( "( ", YSequenceModulePoly( logpoly ), ", ", 
                 RelatorModulePoly( logpoly ), " )" );
end );

#############################################################################
##
#M  Display( <logpoly> )
##
InstallMethod( Display, "for a logged module poly", true,
    [IsLoggedModulePolyYSeqRelsRep ], 0, 
function( logpoly ) 

    Print( "( " );
    Display( YSequenceModulePoly( logpoly ) );
    Print ( ", " ) ;
    Display( RelatorModulePoly( logpoly ) );
    Print( " )" );
end );

##############################################################################
##
#M  Length                                      for a logged module polynomial
##
InstallOtherMethod( Length, "generic method for a logged module polynomial", 
    true, [ IsLoggedModulePolyYSeqRelsRep ], 0, 
function( lp ) 
    return Length( RelatorModulePoly( lp ) );
end );

##############################################################################
##
#M  \=                                       for two logged module polynomials
##
InstallOtherMethod( \=, "generic method for logged module polynomials", true, 
    [ IsLoggedModulePolyYSeqRelsRep, IsLoggedModulePolyYSeqRelsRep ], 0, 
function( lp1, lp2 )
    if not ( YSequenceModulePoly( lp1 ) = YSequenceModulePoly( lp2 ) ) then 
        return false;
    elif not ( RelatorModulePoly( lp1 ) = RelatorModulePoly( lp2 ) ) then 
        return false;
    fi;
    return true;
end );

##############################################################################
##
#M  \+                                       for two logged module polynomials
##
InstallOtherMethod( \+, "generic method for logged module polynomials", 
    true, [ IsLoggedModulePolyYSeqRelsRep, IsLoggedModulePolyYSeqRelsRep ], 0,
function( lp1, lp2 )

    local  rp, yp;

    rp := RelatorModulePoly( lp1 ) + RelatorModulePoly( lp2 );
    yp := YSequenceModulePoly( lp1 ) + YSequenceModulePoly( lp2 );
    return LoggedModulePolyNC( yp, rp );
end );

##############################################################################
##
#M  \*                                 for a logged module poly and a rational
##
InstallOtherMethod( \*, 
    "generic method for a logged module polynomial and a rational", true, 
    [ IsLoggedModulePolyYSeqRelsRep, IsRat ], 0, 
function( lp, rat)

    local  yp, rp;

    yp := YSequenceModulePoly( lp );
    rp := RelatorModulePoly( lp );
    if ( rat = 0 ) then 
        return LoggedModulePolyNC( yp-yp, rp-rp );
    fi;
    return LoggedModulePoly( yp * rat, rp * rat );
end );

##############################################################################
##
#M  \-                                           for logged module polynomials
##
InstallOtherMethod( \-, "generic method for logged module polynomials", true, 
    [ IsLoggedModulePolyYSeqRelsRep, IsLoggedModulePolyYSeqRelsRep ], 0,
function( lp1, lp2 ) 
    return ( lp1 + ( lp2 * (-1) ) );
end );

##############################################################################
##
#M  \<                                          for a logged module polynomial
##
InstallOtherMethod( \<, "generic method for logged module polynomials", true, 
    [ IsLoggedModulePolyYSeqRelsRep, IsLoggedModulePolyYSeqRelsRep ], 0, 
function( lp1, lp2 ) 

    local  yp1, yp2, rp1, rp2;

    rp1 := RelatorModulePoly( lp1 );
    rp2 := RelatorModulePoly( lp2 );
    if ( rp1 < rp2 ) then 
        return true;
    elif ( rp1 > rp2 ) then 
        return false;
    fi;
    yp1 := YSequenceModulePoly( lp1 );
    yp2 := YSequenceModulePoly( lp2 );
    if ( yp1 < yp2 ) then 
        return true;
    elif ( yp1 > yp2 ) then 
        return false;
    fi;
    return false;
end );

#############################################################################
##
#M  FreeYSequenceGroup( <G> )
##
InstallMethod( FreeYSequenceGroup, "generic method for FpGroup", true, 
    [ IsFpGroup ], 0, 
function( G )

    local  idY, len, str, Flen, L, genFY, FY, famY;

    if HasName( G ) then 
        str := Concatenation( Name( G ), "_Y" );
    else
        str := "FY";
    fi;
    idY := IdentityYSequences( G );
    len := Length( idY );
    Flen := FreeGroup( len, str );
    L := Filtered( [1..len], i -> not( idY[i] = [ ] ) );
    genFY := GeneratorsOfGroup( Flen ){L};
    FY := Subgroup( Flen, genFY );
    SetName( FY, str );
    famY := ElementsFamily( FamilyObj( FY ) );
    famY!.modulePolyFam := ModulePolyFam;
##Print( "\n%%%  genFY has length ", Length(genFY), "\n\n" );
    return FY;
end );

#############################################################################
##
#M  FreeYSequenceGroupKB( <G> )
##
InstallMethod( FreeYSequenceGroupKB, "generic method for FpGroup", true, 
    [ IsFpGroup ], 0, 
function( G )

    local  idY, len, str, Flen, L, genFY, FY, famY;

    if HasName( G ) then 
        str := Concatenation( Name( G ), "_Y" );
    else
        str := "FY";
    fi;
    idY := IdentityYSequencesKB( G );
    len := Length( idY );
    Flen := FreeGroup( len, str );
    L := Filtered( [1..len], i -> not( idY[i] = [ ] ) );
    genFY := GeneratorsOfGroup( Flen ){L};
    FY := Subgroup( Flen, genFY );
    SetName( FY, str );
    famY := ElementsFamily( FamilyObj( FY ) );
    famY!.modulePolyFam := ModulePolyFam;
Print( "\n%%%  genFY (KB) has length ", Length(genFY), "\n\n" );
    return FY;
end );

#############################################################################
##
#M  MinimiseLeadTerm( <smp>, <group>, <rules> )
##
##  (22/02/17) up until now this function used all elements in the group 
##  to multiply with: now changed to allow a partial list of elements 
##
InstallMethod( MinimiseLeadTerm, "for a module poly, group and rules", 
    true, [ IsLoggedModulePolyYSeqRelsRep, IsGroup, IsList ], 0, 
function( lp, G, rules)

    local  len, rp, mp, mbest, xbest, lbest, x, mx, rbest, ybest, 
           oneM, FMgens, elmon, elrng, e;

    if HasElementsOfMonoidPresentation( G ) then 
        elmon := ElementsOfMonoidPresentation( G ); 
    elif HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    else
        Error( "no list of elements available" ); 
    fi;
    oneM := elmon[1];
    elrng := [2..Length(elmon)];  
    rp := RelatorModulePoly( lp );
    len := Length( rp );
    mp := MonoidPolys( rp )[len];
    mbest := mp;
    xbest := oneM;
    lbest := lp;
    for e in elrng do  
        x := elmon[e]; 
        mx := ReduceMonoidPoly( mp*x, rules );
        if ( InfoLevel( InfoIdRel ) > 4 ) then
            Print( x, " : " ); 
            Display(mx); 
        fi;
        if ( mx < mbest ) then 
            mbest := mx;
            xbest := x;
        fi;
    od; 
    if ( xbest <> oneM ) then 
        rbest := ReduceModulePoly( rp * xbest, rules );
        ybest := YSequenceModulePoly( lp ) * xbest;
        lbest := LoggedModulePolyNC( ybest, rbest );
    fi;
    return lbest;
end );

#############################################################################
##
#M  ReduceModulePoly( <smp>, <rules> )
##
InstallMethod( ReduceModulePoly, "for a module poly and a reduction system", 
    true, [ IsModulePolyGensPolysRep, IsHomogeneousList ], 0, 
function( mp, rules )

    local  i, p, rp, rw;

    rp := ListWithIdenticalEntries( Length( mp ), 0 );
    for i in [1..Length(mp)] do 
        p := MonoidPolys( mp )[i];
        rw := List( Words( p ), w -> ReduceWordKB( w, rules) );
        rp[i] := MonoidPolyFromCoeffsWords( Coeffs( p ), rw );
    od;
    return ModulePolyFromGensPolysNC( GeneratorsOfModulePoly( mp ), rp );
end );

#############################################################################
##
#M  IdentityModulePolysOld( <G> )
##
InstallMethod( IdentityModulePolysOld, "for an fp-group", true, [ IsFpGroup ], 0, 
function( G ) 

    local  idents, numids, frgp, frgens, famfrgp, relG, genG, fgp, fgens, 
           L, rel, posgens, e, i, j, k, monG, elmon, oneM, FM, FMgens, FMfam, 
           FY, FYgens, arws, rws, ident, w, yp, nyp, rp, lp, gp, mp, polys, 
           leni, irange, i1, npols, len, mbest, lbest, x, xbest, mx, rx, yx; 

    genG := GeneratorsOfGroup( G );
    monG := MonoidPresentationFpGroup( G );
    if HasElementsOfMonoidPresentation( G ) then 
        elmon := ElementsOfMonoidPresentation( G ); 
    elif HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    else
        Error( "no list of elements available" ); 
    fi;
    oneM := elmon[1]; 
    frgp := FreeRelatorGroup( G );
    frgens := GeneratorsOfGroup( frgp );
    ### 11/10/05 : moved this from logrws.gi
    famfrgp := ElementsFamily( FamilyObj( frgp ) );
    famfrgp!.modulePolyFam := ModulePolyFam;
    relG := RelatorsOfFpGroup( G );
    FM := FreeGroupOfPresentation( monG );
    FMgens := GeneratorsOfGroup( FM );
    FMfam := ElementsFamily( FamilyObj( FM ) );
    L := ArrangementOfMonoidGenerators( G );
    FY := FreeYSequenceGroup( G );
    FYgens := GeneratorsOfGroup( FY );
    posgens := frgens{ [1..Length( relG )] };
    arws := LoggedRewritingSystemFpGroup( G );
    rws := List( arws, r -> [ r[1], r[3] ] );
    idents := IdentityYSequencesOld( G );
    numids := Length( idents );
    polys := [ ];
    k := 0;
    for j in [1..numids] do 
        ident := idents[j];
        leni := Length( ident );
        if ( leni > 0 ) then
            k := k+1;
            irange := [1..leni];
            gp := ListWithIdenticalEntries( leni, 0 );
            npols := ListWithIdenticalEntries( leni, 0 );
            for i in irange do 
                i1 := ident[i][1];
                w := MonoidWordFpWord( ident[i][2], FMfam, L );
                w := ReduceWordKB( w, rws );
                if i1 in frgens then
                    gp[i] := i1;
                    npols[i] := MonoidPolyFromCoeffsWords( [+1], [w] );
                else
                    gp[i] := i1^(-1);
                    npols[i] := MonoidPolyFromCoeffsWords( [-1], [w] );
                fi;
            od;
            rp := ModulePolyFromGensPolys( gp, npols );
            len := Length( rp );
            if not ( len = 0 ) then 
                nyp := MonoidPolyFromCoeffsWords( [ 1 ], [ oneM ] );
                yp := ModulePolyFromGensPolys( [ FYgens[k] ], [ nyp ] );
                lp := LoggedModulePolyNC( yp, rp );
                lbest := MinimiseLeadTerm( lp, G, rws );
                lp := lbest*(-1);
                if ( lbest < lp ) then 
                    Add( polys, lbest );
                else 
                    Add( polys, lp );
                fi;
            fi; 
        fi; 
    od;
    Sort( polys );
    return polys;
end );

#############################################################################
##
#M  IdentityModulePolys( <G> )
##
InstallMethod( IdentityModulePolys, "for an Fp Group", true, [ IsFpGroup ], 0, 
function( G ) 

    local  idents, numids, frgp, frgens, famfrgp, relG, genG, fgp, fgens, 
           L, rel, posgens, e, i, j, k, monG, elmon, oneM, 
           FM, FMgens, FMfam, FY, FYgens, arws, rws, ident, pos, w, 
           yp, nyp, rp, lp, gp, mp, polys, leni, irange, i1, npols, 
           len, mbest, lbest, x, xbest, mx, rx, yx; 

    genG := GeneratorsOfGroup( G );
    monG := MonoidPresentationFpGroup( G );
    if HasElementsOfMonoidPresentation( G ) then 
        elmon := ElementsOfMonoidPresentation( G ); 
    elif HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    elif ( HasIsFinite( G ) and IsFinite( G ) ) then 
        elmon := ElementsOfMonoidPresentation( G ); 
    else 
        ##  using 3 as a suitable word length 
        elmon := PartialElementsOfMonoidPresentation( G, 3 );  
    fi;
    oneM := elmon[1]; 
    frgp := FreeRelatorGroup( G );
    frgens := GeneratorsOfGroup( frgp );
    famfrgp := ElementsFamily( FamilyObj( frgp ) );
    famfrgp!.modulePolyFam := ModulePolyFam;
    relG := RelatorsOfFpGroup( G );
    FM := FreeGroupOfPresentation( monG );
    FMgens := GeneratorsOfGroup( FM );
    FMfam := ElementsFamily( FamilyObj( FM ) );
    L := ArrangementOfMonoidGenerators( G );
    FY := FreeYSequenceGroup( G );
    FYgens := GeneratorsOfGroup( FY );
    Info( InfoIdRel, 2, "FYgens has ", Length(FYgens), " entries" );
    posgens := frgens{ [1..Length( relG )] };
    arws := LoggedRewritingSystemFpGroup( G );
    rws := List( arws, r -> [ r[1], r[3] ] );
    idents := IdentityYSequences( G );
    numids := Length( idents );
    polys := [ ];
    k := 0;
    for j in [1..numids] do 
        Info( InfoIdRel, 2, "===============  j = ", j, "  ===============" ); 
        pos := idents[j][1]; 
        ident := idents[j][3];
        Info( InfoIdRel, 2, "idents[j] = ", idents[j] );
        leni := Length( ident );
        if ( leni > 0 ) then
            k := k+1;
            Info( InfoIdRel, 2, "k = ", k );
            irange := [1..leni];
            gp := ListWithIdenticalEntries( leni, 0 );
            npols := ListWithIdenticalEntries( leni, 0 );
            for i in irange do 
                i1 := ident[i][1];
                w := MonoidWordFpWord( ident[i][2], FMfam, L );
                w := ReduceWordKB( w, rws );
                if i1 in frgens then
                    gp[i] := i1;
                    npols[i] := MonoidPolyFromCoeffsWords( [+1], [w] );
                else
                    gp[i] := i1^(-1);
                    npols[i] := MonoidPolyFromCoeffsWords( [-1], [w] );
                fi;
            od;
            Info( InfoIdRel, 2, "npols = ", npols ); 
            rp := ModulePolyFromGensPolys( gp, npols );
            Info( InfoIdRel, 2, "rp = ", rp ); 
            len := Length( rp );
            if not ( len = 0 ) then 
                nyp := MonoidPolyFromCoeffsWords( [ 1 ], [ oneM ] );
                Info( InfoIdRel, 2, "nyp = ", nyp ); 
                yp := ModulePolyFromGensPolys( [ FYgens[pos] ], [ nyp ] );
                Info( InfoIdRel, 2, "yp = ", yp ); 
                lp := LoggedModulePolyNC( yp, rp );
                Info( InfoIdRel, 2, "lp = ", lp );
                lbest := MinimiseLeadTerm( lp, G, rws );
                lp := lbest*(-1);
                Info( InfoIdRel, 2, "lp = ", lp );
                if ( lbest < lp ) then 
                    Add( polys, lbest );
                else 
                    Add( polys, lp );
                fi;
            fi; 
        fi; 
    od;
    Sort( polys );
    return polys;
end );

#############################################################################
##
#M  IdentityModulePolysKB( <G> )
##
InstallMethod( IdentityModulePolysKB, "for an Fp Group", true, [ IsFpGroup ], 0, 
function( G ) 

    local  idents, numids, frgp, frgens, famfrgp, relG, genG, fgp, fgens, 
           L, rel, posgens, e, i, j, k, monG, elmon, oneM, 
           FM, FMgens, FMfam, FY, FYgens, arws, rws, ident, w, 
           yp, nyp, rp, lp, gp, mp, polys, leni, irange, i1, npols, 
           len, mbest, lbest, x, xbest, mx, rx, yx; 

    genG := GeneratorsOfGroup( G );
    monG := MonoidPresentationFpGroup( G );
    if HasElementsOfMonoidPresentation( G ) then 
        elmon := ElementsOfMonoidPresentation( G ); 
    elif HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    else
        Error( "no list of elements available" ); 
    fi;
    oneM := elmon[1]; 
    frgp := FreeRelatorGroup( G );
    frgens := GeneratorsOfGroup( frgp );
    ### 11/10/05 : moved this from logrws.gi
    famfrgp := ElementsFamily( FamilyObj( frgp ) );
    famfrgp!.modulePolyFam := ModulePolyFam;
    relG := RelatorsOfFpGroup( G );
    arws := LoggedRewritingSystemFpGroup( G );
    rws := List( arws, r -> [ r[1], r[3] ] );
    FM := FreeGroupOfPresentation( monG );
    FMgens := GeneratorsOfGroup( FM );
    FMfam := ElementsFamily( FamilyObj( FM ) );
    L := ArrangementOfMonoidGenerators( G );
    FY := FreeYSequenceGroupKB( G );
    FYgens := GeneratorsOfGroup( FY );
    posgens := frgens{ [1..Length( relG )] };
    idents := IdentityYSequencesKB( G );
    idents := YSequencesFromRelatorSequences( idents, G ); 
    numids := Length( idents );
    polys := [ ];
    k := 0;
    for j in [1..numids] do 
Print( "=================  j = ", j, "  ==================\n" ); 
        ident := idents[j][2];
Print( "ident = ", ident, "\n" );
        leni := Length( ident );
        if ( leni > 0 ) then
            k := k+1;
Print( "k = ", k, "\n" );
            irange := [1..leni];
            gp := ListWithIdenticalEntries( leni, 0 );
            npols := ListWithIdenticalEntries( leni, 0 );
            for i in irange do 
                i1 := ident[i][1];
                w := MonoidWordFpWord( ident[i][2], FMfam, L );
                w := ReduceWordKB( w, rws );
                if i1 in frgens then
                    gp[i] := i1;
                    npols[i] := MonoidPolyFromCoeffsWords( [+1], [w] );
                else
                    gp[i] := i1^(-1);
                    npols[i] := MonoidPolyFromCoeffsWords( [-1], [w] );
                fi;
            od;
Print( "npols = ", npols, "\n" ); 
            rp := ModulePolyFromGensPolys( gp, npols );
Print( "rp = ", rp, "\n" ); 
            len := Length( rp );
            if not ( len = 0 ) then 
                nyp := MonoidPolyFromCoeffsWords( [ 1 ], [ oneM ] );
Print( "nyp = ", nyp, "\n" ); 
                yp := ModulePolyFromGensPolys( [ FYgens[k] ], [ nyp ] );
Print( "yp = ", yp, "\n" ); 
                lp := LoggedModulePolyNC( yp, rp );
Print( "lp = ", lp, "\n" );
                lbest := MinimiseLeadTerm( lp, G, rws );
                lp := lbest*(-1);
Print( "lp = ", lp, "\n" );
                if ( lbest < lp ) then 
                    Add( polys, lbest );
                else 
                    Add( polys, lp );
                fi;
            fi; 
        fi; 
###### if j=3 then j[1]:=j[2]; fi;
    od;
    Sort( polys );
    return polys;
end );

#############################################################################
##
#M  LoggedReduceModulePoly( <smp>, <rules>, <sats>, <zero) )
##
InstallMethod( LoggedReduceModulePoly, 
    "for a module poly, a reduction system, a list of saturated sets, and 0", 
    true, [IsModulePolyGensPolysRep,IsList,IsList,IsModulePolyGensPolysRep], 0,
function( rp, rws, sats, zero)

    local  rpi, rpj, rpij, yp1, yp, iszero, ans, satset, numsats, 
           i, j, newj, posj;

    if ( sats = [ ] ) then 
        Error( "empty saturated set " );
    fi;
    yp1 := YSequenceModulePoly( sats[1][1] );
    yp := yp1 - yp1;
    if ( Length( rp ) = 0 ) then 
        Error( "empty rp" );
        return LoggedModulePoly( [ ], rp );
    fi;
    numsats := Length( sats );
    rpi := rp;
    iszero := false;
    i := numsats + 1;
    while ( ( i > 1 ) and not iszero ) do 
        i := i-1; 
        satset := sats[i];
        if ( InfoLevel( InfoIdRel ) > 3 ) then 
            Print( "at start of newi loop, i = ", i, "\n" );
            Print(" rpi = " ); Display( rpi ); Print( "\n" );
        fi;
        newj := true;
        while( newj and not iszero ) do 
            if ( InfoLevel( InfoIdRel ) > 3 ) then 
                Print( "newj and not iszero with i = ", i, "\n" );
            fi;
            rpj := rpi;
            newj := false;
            j := 0;
            posj := 0;
            while( ( j < Length( satset ) ) and not iszero ) do
                j := j + 1;
                rpij := rpi + RelatorModulePoly( satset[j] );
                if ( InfoLevel( InfoIdRel ) > 3 ) then 
                    Print ( "** ", j, " rpij = " ); 
                    Display( rpij ); Print( "\n" );
                fi;
                if ( rpj > rpij ) then 
                    newj := true;
                    posj := j;
                    rpj := rpij;
                    if ( rpj = zero) then 
                        iszero := true;
                    fi;
                    if ( InfoLevel( InfoIdRel ) > 3 ) then
                        Print ( "rpj > rpij at j = ", j, "\n" );
                        Print( "new rpj: " ); Display( rpj ); Print( "\n" );
                        if iszero then 
                            Print( "reduced to zero!" );
                        fi;
                    fi; 
                fi; 
            od;
            if newj then
                rpi := rpj;
                yp := yp + YSequenceModulePoly( satset[posj] );
            fi;
        od; 
    od;
    return LoggedModulePoly( yp, rpi );
end );

#############################################################################
##
#M  SaturatedSetLoggedModulePoly( <logsmp>, <elmon>, <rws>, <sats> )
##
InstallMethod( SaturatedSetLoggedModulePoly, 
    "for a logged module poly and rewriting system", true, 
    [ IsLoggedModulePolyYSeqRelsRep, IsList, IsList, IsList ], 0, 
function( l, elmon, rws, sats )

    local  lsats, rsats, numsat, numelt,
           i, j, r, y, x, lx, rx, yx, r0, li, ri, yi, rj, lj, lij, rij, yij;

    r := RelatorModulePoly( l );
    r0 := r - r;
    y := YSequenceModulePoly( l );
    lsats := [ l, l*(-1) ];
    rsats := [ r, r*(-1) ];
    numelt := Length( elmon );
    for x in elmon{[2..numelt]} do 
        rx := ReduceModulePoly( r*x, rws );
        if not ( rx in rsats ) then 
            Add( rsats, rx );
            yx := y * x;
            lx := LoggedModulePolyNC( yx, rx );
            Add( lsats, lx );
            lx := lx * (-1);
            Add( lsats, lx );
            Add( rsats, RelatorModulePoly( lx ) );
        fi;
    od;
    numsat := Length( rsats );
    i := 1;
    while ( i < numsat ) do 
        ri := rsats[i];
        li := lsats[i];
        yi := YSequenceModulePoly( li );
        for j in [(i+2)..numsat] do 
            rj := rsats[j];
            if ( sats = [ ] ) then
                rij := ReduceModulePoly( ri + rj, rws );
            else 
                rij := LoggedReduceModulePoly( ri + rj, rws, sats, r0 );
                rij := RelatorModulePoly( rij );
            fi;
            if ( ( rij <> r0 ) and ( rij < ri ) and ( rij < rj ) 
                               and not ( rij in rsats ) ) then 
                yij := yi + YSequenceModulePoly( lsats[j] );
                lij := LoggedModulePolyNC( yij, rij );
                Add( rsats, rij );
                Add( lsats, lij );
                lij := lij * (-1);
                Add( lsats, lij ); 
                Add( rsats, RelatorModulePoly( lij ) );
            fi;
        od;
        i := i+2;
    od;
    return lsats;
end );

#############################################################################
##
#M  IdentitiesAmongRelatorsOld( <G> )
##
InstallMethod( IdentitiesAmongRelatorsOld, "for an FpGroup", true, 
    [ IsFpGroup ], 0, 
function( G )

    local  monG, F, FR, genFR, FM, FMgens, i, j, k, m, idmon, elrng, L, 
           lp, yp, rp, mp, gp, len, x, mbest, xbest, mx, rx, yx, lx, pols, 
           modpols, labels, sats, elmon, rem, logrem, remrp, polypos, idG, 
           rws, r, irrepols, irrerems, irrenum, ok, irrem, remm, satm, m1, mO,
           remsat, irrek, rpk, ypk, remk, irrng, irrelist, remyp, leadgp;

    L := ArrangementOfMonoidGenerators( G ); 
    monG := MonoidPresentationFpGroup( G );
    modpols := IdentityModulePolysOld( G );
    elmon := ElementsOfMonoidPresentation( G );
    rws := List( LoggedRewritingSystemFpGroup( G ), r -> [ r[1], r[3] ] );
    irrepols := [ ];
    irrerems:= [ ];
    sats := [ ];
    irrenum := 0;
    F := FreeGroupOfFpGroup( G );
    FR := FreeGroupOfPresentation( monG );
    genFR := GeneratorsOfGroup( FR );
    FM := FreeGroupOfPresentation( monG );
    FMgens := GeneratorsOfGroup( FM );
    m1 := RelatorModulePoly( modpols[1] );
    mO := m1 - m1;
    for i in [1..Length(modpols)] do 
        lp := modpols[i];
        if ( InfoLevel( InfoIdRel ) > 2 ) then
            Print( "\n\n", i, " : "); Display( lp ); Print( "\n" );
        fi;
        rp := RelatorModulePoly( lp );
        leadgp := LeadGenerator( rp );
        yp := YSequenceModulePoly( lp );
        if ( InfoLevel( InfoIdRel ) > 2 ) then 
            Print( "\nlooking at polynomial number ", i, ": \n" );
            Display( lp );
            Print( "\n" );
        fi;
        ##################### saturation used here: ####################### 
        if ( sats = [ ] ) then 
            logrem := lp;
            remyp := yp; 
            remrp := rp;
        else 
            rem := LoggedReduceModulePoly( rp, rws, sats, mO );
            remyp := yp + YSequenceModulePoly( rem );
            remrp := RelatorModulePoly( rem );
            logrem := LoggedModulePoly( remyp, remrp );
        fi;
        if ( remrp = mO ) then 
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "reduced to zero by:\n" );
                Display( remyp );
                Print( "\n" );
            fi;
        else 
            if ( LeadGenerator( remrp ) <> leadgp ) then 
                if ( InfoLevel( InfoIdRel ) > 2 ) then
                    Print( "\n! minimising leading term: !\n\n" );
                    logrem := MinimiseLeadTerm( logrem, G, rws );
                fi;
            fi;
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "logrem = " ); Display(logrem); Print("\n");
            fi;
            irrenum := irrenum + 1;
            remsat := SaturatedSetLoggedModulePoly( logrem, elmon, rws, sats );
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "\nsaturated set:\n" );
                for m in [1..Length(remsat)] do 
                    Print( m, ": "); Display(remsat[m]); Print("\n");
                od;
                Print( "irreducible number ", irrenum, " :-\n" );
                Display( lp );
                Print( "\n" );
            fi;
            Add( irrepols, lp );
            Add( irrerems, logrem );
            Add( sats, remsat );
            SortParallel( irrerems, sats );
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "\ncurrent state of reduced list, irrerems:\n" );
                for r in irrerems do 
                    Display( r );
                    Print( "\n" );
                od;
            fi;
#           ### if new irre less than existing ones, reorder and reduce ### 
#           if ( ( irrenum > 1 ) and 
#                ( RelatorModulePoly( irres[irrenum-1] ) > rp ) ) then 
#               if ( InfoLevel( InfoIdRel ) > 2 ) then
#                   Print( "new irreducible not greater than the last!\n" );
#                   Print( "current state of irre list:\n" );
#                   for r in irres do 
#                       Display( r );
#                       Print( "\n" );
#                   od;
#               fi;
#               ok := false;
#               while not ok do
#                   ok := true;
#                   m := 0;
#                   # j:= 1;
#                   # while ( ( j < irrenum ) and 
#                   #         ( RelatorModulePoly( irres[j] ) = mO ) ) do
#                   #     j := j+l;
#                   # od;
#                   for k in [1..irrenum-1] do 
#                       if ( ( m = 0 ) and ( irres[k+1] < irres[k] ) ) then 
#                           if ( InfoLevel( InfoIdRel ) > 2 ) then
#                               Print( "\nUnordered at k = ", k, " !!\n" ); 
#                           fi;
#                           m := k+l;
#                       fi;
#                   od;
#                   if ( m > 0 ) then ### needs to be reordered 
#                       ok := false;
#                       irrem := irres[m];
#                       satm := sats[m];
#                       j := m;
#                       while ( ( j>1 ) and ( irrem < irres[j-1] ) ) do
#                           irres[j] := irres[j-1];
#                           sats[j] := sats[j-1];
#                           j := j-1;
#                       od;
#                       irres[j] := irrem;
#                       sats[j] := satm;
#                       if ( j = 1 ) then
#                           j := 2;
#                       fi;
#                       for k in [j..irrenum] do 
#                           rpk := RelatorModulePoly( irres[k] ); 
#                           ypk := YSequenceModulePoly( irres[k] ); 
#                           remk := LoggedReduceModulePoly  
#                                       ( rpk, rws, sats{ [1..k-1] ), mO );
# Print("\nirres[k] = "); Display( irres[k] ); Print("\n");
# Print("    remk = "); Display( remk ); Print("\n");
#                           ## check if reduced to zero 
#                           if not ( rpk = RelatorModulePoly( remk ) ) then # 
#                               rpk := RelatorModulePoly( remk );
#                               ypk := ypk + YSequenceModulePoly( remk ); 
#                               irres[k] := LoggedModulePoly( ypk, rpk ); 
#                               sats[k] := SaturatedSetLoggedModulePoly(  
#                                                irres[k], elmon, rws, [ ] );
#                               #sats[k] := SaturatedSetLoggedModulePoly( 
#                               #                irres[k], genFR, rws );
#                               if ( rpk = m0 ) then ## reduced to zero!
#                                   sats[k] := [ irres[k] ];
#                               else 
#                                   sats[k] := SaturatedSetLoggedModulePoly( 
#                                                 irres[k], elmon, rws, [ ]);
#                                   #sats[k] := SaturatedSetLoggedModulePoly( 
#                                   #                 irres[k], genFR, rws ); 
#                               fi;
#                           fi; 
#                       od; 
#                   fi; 
#               od;
#               ### finally, see if any zero polynomials have been created
#               j := 1;
#               while ( ( j <= irrenum ) and 
#                       ( RelatorModulePoly( irres[j] ) = m0 ) ) do
#                   j := j + 1,
#               od;
#               if ( j > 1 ) then
#                   irrng := [j..irrenum];
#                   irres := irres{ irrng };
#                   sats := sats{ irrng }; 
#                   irrenum := irrenum - j + 1;
#               fi;
#           fi;
#           if ( InfoLevel( InfoIdRel ) > 2 ) then
#               Print( "\nnew state of irre list:\n" );
#               for r in irres do 
#                   Display( r );
#                   Print( "\n" );
#               od;
#            fi;
        fi;
    od;
    if ( InfoLevel( InfoIdRel ) > 0 ) then
        Print( "\nThere were ", irrenum, " irreducibles found.\n" );
        Print( "The corresponding saturated sets have size:\n" );
        Print( List( sats, L -> Length(L) ), "\n\n" );
        Print( "The irreducibles and the (reordered) remainders are:\n\n" );
        for r in [1..irrenum] do 
            Print( r, " : ", irrepols[r], "\n" ); 
        od;
        Print( "-------------------------------------------------------\n\n" );
        for r in [1..irrenum] do 
            Print( r, " : ", irrerems[r], "\n" );
        od; 
    fi;
    return [ irrepols, irrerems ];
end );

#############################################################################
##
#M  IdentitiesAmongRelators( <G> )
##
InstallMethod( IdentitiesAmongRelators, "for an fp-group", true, 
    [ IsFpGroup ], 0, 
function( G )

    local  monG, F, FR, genFR, FM, FMgens, i, j, k, m, idmon, elrng, L, 
           lp, yp, rp, mp, gp, len, x, mbest, xbest, mx, rx, yx, lx, pols, 
           modpols, labels, sats, elmon, rem, logrem, remrp, polypos, idG, 
           rws, r, irrepols, irrerems, irrenum, ok, irrem, remm, satm, m1, mO,
           remsat, irrek, rpk, ypk, remk, irrng, irrelist, remyp, leadgp;

    L := ArrangementOfMonoidGenerators( G ); 
    monG := MonoidPresentationFpGroup( G );
    modpols := IdentityModulePolys( G );
    if HasElementsOfMonoidPresentation( G ) then 
        elmon := ElementsOfMonoidPresentation( G ); 
    elif HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    else
        Error( "no list of elements available" ); 
    fi;
    rws := List( LoggedRewritingSystemFpGroup( G ), r -> [ r[1], r[3] ] );
    irrepols := [ ];
    irrerems:= [ ];
    sats := [ ];
    irrenum := 0;
    F := FreeGroupOfFpGroup( G );
    FR := FreeGroupOfPresentation( monG );
    genFR := GeneratorsOfGroup( FR );
    FM := FreeGroupOfPresentation( monG );
    FMgens := GeneratorsOfGroup( FM );
    m1 := RelatorModulePoly( modpols[1] );
    mO := m1 - m1;
    for i in [1..Length(modpols)] do 
        lp := modpols[i];
        if ( InfoLevel( InfoIdRel ) > 2 ) then
            Print( "\n\n", i, " : "); Display( lp ); Print( "\n" );
        fi;
        rp := RelatorModulePoly( lp );
        leadgp := LeadGenerator( rp );
        yp := YSequenceModulePoly( lp );
        if ( InfoLevel( InfoIdRel ) > 2 ) then 
            Print( "\nlooking at polynomial number ", i, ": \n" );
            Display( lp );
            Print( "\n" );
        fi;
        ##################### saturation used here: ####################### 
        if ( sats = [ ] ) then 
            logrem := lp;
            remyp := yp; 
            remrp := rp;
        else 
            rem := LoggedReduceModulePoly( rp, rws, sats, mO );
            remyp := yp + YSequenceModulePoly( rem );
            remrp := RelatorModulePoly( rem );
            logrem := LoggedModulePoly( remyp, remrp );
        fi;
        if ( remrp = mO ) then 
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "reduced to zero by:\n" );
                Display( remyp );
                Print( "\n" );
            fi;
        else 
            if ( LeadGenerator( remrp ) <> leadgp ) then 
                if ( InfoLevel( InfoIdRel ) > 2 ) then
                    Print( "\n! minimising leading term: !\n\n" );
                    logrem := MinimiseLeadTerm( logrem, G, rws );
                fi;
            fi;
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "logrem = " ); Display(logrem); Print("\n");
            fi;
            irrenum := irrenum + 1;
            remsat := SaturatedSetLoggedModulePoly( logrem, elmon, rws, sats );
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "\nsaturated set:\n" );
                for m in [1..Length(remsat)] do 
                    Print( m, ": "); Display(remsat[m]); Print("\n");
                od;
                Print( "irreducible number ", irrenum, " :-\n" );
                Display( lp );
                Print( "\n" );
            fi;
            Add( irrepols, lp );
            Add( irrerems, logrem );
            Add( sats, remsat );
            SortParallel( irrerems, sats );
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "\ncurrent state of reduced list, irrerems:\n" );
                for r in irrerems do 
                    Display( r );
                    Print( "\n" );
                od;
            fi;
        fi;
    od;
    if ( InfoLevel( InfoIdRel ) > 0 ) then
        Print( "\nThere were ", irrenum, " irreducibles found.\n" );
        Print( "The corresponding saturated sets have size:\n" );
        Print( List( sats, L -> Length(L) ), "\n\n" );
        Print( "The irreducibles and the (reordered) remainders are:\n\n" );
        for r in [1..irrenum] do 
            Print( r, " : ", irrepols[r], "\n" ); 
        od;
        Print( "-------------------------------------------------------\n\n" );
        for r in [1..irrenum] do 
            Print( r, " : ", irrerems[r], "\n" );
        od; 
    fi;
    return [ irrepols, irrerems ];
end );

#############################################################################
##
#M  IdentitiesAmongRelatorsKB( <G> )
##
InstallMethod( IdentitiesAmongRelatorsKB, "for an FpGroup", true, 
    [ IsFpGroup ], 0, 
function( G )

    local  monG, F, FR, genFR, FM, FMgens, i, j, k, m, idmon, elrng, L, 
           lp, yp, rp, mp, gp, len, x, mbest, xbest, mx, rx, yx, lx, pols, 
           modpols, labels, sats, elmon, rem, logrem, remrp, polypos, idG, 
           rws, r, irrepols, irrerems, irrenum, ok, irrem, remm, satm, m1, mO,
           remsat, irrek, rpk, ypk, remk, irrng, irrelist, remyp, leadgp;

    L := ArrangementOfMonoidGenerators( G ); 
    monG := MonoidPresentationFpGroup( G );
    modpols := IdentityModulePolysKB( G );
    if HasElementsOfMonoidPresentation( G ) then 
        elmon := ElementsOfMonoidPresentation( G ); 
    elif HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    else
        Error( "no list of elements available" ); 
    fi;
    rws := List( LoggedRewritingSystemFpGroup( G ), r -> [ r[1], r[3] ] );
    irrepols := [ ];
    irrerems:= [ ];
    sats := [ ];
    irrenum := 0;
    F := FreeGroupOfFpGroup( G );
    FR := FreeGroupOfPresentation( monG );
    genFR := GeneratorsOfGroup( FR );
    FM := FreeGroupOfPresentation( monG );
    FMgens := GeneratorsOfGroup( FM );
    m1 := RelatorModulePoly( modpols[1] );
    mO := m1 - m1;
    for i in [1..Length(modpols)] do 
        lp := modpols[i];
        if ( InfoLevel( InfoIdRel ) > 2 ) then
            Print( "\n\n", i, " : "); Display( lp ); Print( "\n" );
        fi;
        rp := RelatorModulePoly( lp );
        leadgp := LeadGenerator( rp );
        yp := YSequenceModulePoly( lp );
        if ( InfoLevel( InfoIdRel ) > 2 ) then 
            Print( "\nlooking at polynomial number ", i, ": \n" );
            Display( lp );
            Print( "\n" );
        fi;
        ##################### saturation used here: ####################### 
        if ( sats = [ ] ) then 
            logrem := lp;
            remyp := yp; 
            remrp := rp;
        else 
            rem := LoggedReduceModulePoly( rp, rws, sats, mO );
            remyp := yp + YSequenceModulePoly( rem );
            remrp := RelatorModulePoly( rem );
            logrem := LoggedModulePoly( remyp, remrp );
        fi;
        if ( remrp = mO ) then 
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "reduced to zero by:\n" );
                Display( remyp );
                Print( "\n" );
            fi;
        else 
            if ( LeadGenerator( remrp ) <> leadgp ) then 
                if ( InfoLevel( InfoIdRel ) > 2 ) then
                    Print( "\n! minimising leading term: !\n\n" );
                    logrem := MinimiseLeadTerm( logrem, G, rws );
                fi;
            fi;
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "logrem = " ); Display(logrem); Print("\n");
            fi;
            irrenum := irrenum + 1;
            remsat := SaturatedSetLoggedModulePoly( logrem, elmon, rws, sats );
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "\nsaturated set:\n" );
                for m in [1..Length(remsat)] do 
                    Print( m, ": "); Display(remsat[m]); Print("\n");
                od;
                Print( "irreducible number ", irrenum, " :-\n" );
                Display( lp );
                Print( "\n" );
            fi;
            Add( irrepols, lp );
            Add( irrerems, logrem );
            Add( sats, remsat );
            SortParallel( irrerems, sats );
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "\ncurrent state of reduced list, irrerems:\n" );
                for r in irrerems do 
                    Display( r );
                    Print( "\n" );
                od;
            fi;
        fi;
    od;
    if ( InfoLevel( InfoIdRel ) > 0 ) then
        Print( "\n=============  This the KB version!  ==============\n" );
        Print( "There were ", irrenum, " irreducibles found.\n" );
        Print( "The corresponding saturated sets have size:\n" );
        Print( List( sats, L -> Length(L) ), "\n\n" );
        Print( "The irreducibles and the (reordered) remainders are:\n\n" );
        for r in [1..irrenum] do 
            Print( r, " : ", irrepols[r], "\n" ); 
        od;
        Print( "-------------------------------------------------------\n\n" );
        for r in [1..irrenum] do 
            Print( r, " : ", irrerems[r], "\n" );
        od; 
    fi;
    return [ irrepols, irrerems ];
end );

#############################################################################
##
#M  RootIdentities( <G> )
##
InstallMethod( RootIdentities, "for an FpGroup", true, [ IsFpGroup ], 0, 
function( G )

    local  ids1, len, rng;

    if HasIdentitiesAmongRelators( G ) then
        ids1 := IdentitiesAmongRelators( G )[1];
        len := List( ids1, i -> Length(i) );
        rng := Filtered( [1..Length(len)], i -> len[i]=1 );
        return ids1{rng};
    else
        Print( "direct method not yet implemented\n" );
        return fail;
    fi;
end );

###############*#############################################################
##
#E modpoly.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
