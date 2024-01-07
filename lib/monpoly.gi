##############################################################################
##
#W  monpoly.gi                    IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Implementation file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2024 Anne Heyworth and Chris Wensley 
##

#############################################################################
##
#M  String, ViewString, PrintString, ViewObj, PrintObj 
##  . . . . . . . . . . . . . . . . . . . . . . . . .  for monoid polynomials 
##
InstallMethod( String, "for a monoid poly with terms", true, 
    [ IsMonoidPolyTermsRep ], 0, 
function( e ) 
    return( STRINGIFY( "monoid polynomial" ) ); 
end );

InstallMethod( ViewString, "for a monoid poly with terms", true, 
    [ IsMonoidPolyTermsRep ], 0, String ); 

InstallMethod( PrintString, "for a monoid poly with terms", true, 
    [ IsMonoidPolyTermsRep ], 0, String ); 

InstallMethod( ViewObj, "for a monoid poly with terms", true, 
    [ IsMonoidPolyTermsRep ], 0, 
function( p ) 
    Print( p );
end );

InstallMethod( PrintObj, "for a monoid poly with terms", true, 
    [ IsMonoidPolyTermsRep ], 0, 
function( poly )

    local  c, w, len, i, coeff;

    c := Coeffs( poly ); 
    w := Words( poly );
    len := Length( poly );
    if ( len = 0 ) then 
        Print( "zero monpoly " );
    else 
        coeff := c[1];
        if ( coeff = 1 ) then
            Print ( " " );
        elif ( coeff = -1 ) then
            Print ( " -" );
        elif ( coeff < 0 ) then
            Print( " - ", -coeff, "*" );
        else 
            Print( coeff, "*" );
        fi;
        Print( w[1] );
        for i in [2..len] do 
            coeff := c[i];
            if ( coeff = 1 ) then
                Print( " + " );
            elif ( coeff = -1 ) then
                Print ( " - " );
            elif ( coeff > 0 ) then
                Print( " + ", coeff, "*" );
            else
                Print( " - ", -coeff, "*" );
            fi;
            Print( w[i] );
        od;
    fi;
end );

##############################################################################
##
#M  MonoidPolyFromCoeffsWordsNC . . . . . assumes sorted, duplicate-free words
##
InstallMethod( MonoidPolyFromCoeffsWordsNC, 
    "generic method for a monoid polynomial", true, [ IsList, IsList ], 0, 
function( coeffs, words)

    local  obj, fam, filter, poly;

    obj := FamilyObj( words[1] );
    fam := obj!.monoidPolyFam;
    filter := IsMonoidPoly and IsMonoidPolyTermsRep;
    poly := Objectify( NewType( fam, filter ), rec() );
    SetCoeffs( poly, coeffs );
    SetWords( poly, words );
    if ( ( Length( coeffs ) = 1 ) and ( coeffs[1] = 0 ) and 
         ( words[1] = One( obj ) ) ) then 
        SetLength( poly, 0 );
    fi;
    return poly;
end );

##############################################################################
##
#M  MonoidPolyFromCoeffsWords
##
InstallMethod( MonoidPolyFromCoeffsWords, 
    "generic method for a monoid polynomial", true, [ IsList, IsList ], 0, 
function( cp, wp )

    local  coeffs, words, poly, len, L, i, j, wi;

    coeffs := ShallowCopy( cp ); 
    words := ShallowCopy( wp );
    len := Length( coeffs );
    if not ForAll( coeffs, IsRat ) then 
        Error( "first list must be list of rationals" );
    fi;
    if not ( ( Length( words) = len ) and ForAll( words, IsWord ) ) 
        then Error( "second list must contain words and have equal length" );
    fi;
    SortParallel( words, coeffs, function(u,v) return u>v; end );
    L := [1..len];
    i := 1;
    while ( i < len ) do 
        wi := words[i];
        j := i+1;
        while ( ( j <= len ) and ( words[j] = wi ) ) do
            coeffs[i] := coeffs[i] + coeffs[j];
            coeffs[j] := 0;
            j := j+1;
        od;
        i := j;
    od;
    L := Filtered( L, i -> ( coeffs[i] <> 0 ) );
    coeffs := coeffs{L};
    words := words{L};
    if ( coeffs = [ ] ) then
        coeffs := [ 0 ];
        words := [ One( wp[1] ) ];
    fi;
    poly := MonoidPolyFromCoeffsWordsNC( coeffs, words );
    return poly;
end );

##############################################################################
##
#M  MonoidPoly
##
InstallGlobalFunction( MonoidPoly, 
function( arg )

    local  nargs, w, c, i;

    nargs := Length( arg );
    if not ForAll( arg, IsList ) then 
        Error( "arguments must all be lists: terms or (coeffs + words)" );
    fi;
    if ( nargs = 2 ) then 
        # expect coeffs + words 
        c := arg[1];
        w := arg[2];
        if ( Length( c ) = Length( w ) ) then 
            if ( ForAll( c, IsRat ) and 
                 ForAll( w, IsWord ) ) then 
                return MonoidPolyFromCoeffsWords( c, w );
            elif ( ForAll( w, IsRat ) and 
                   ForAll( c, IsWord ) ) then 
                return MonoidPolyFromCoeffsWords( w, c );
            fi;
        fi;
    fi;
    # expect list of terms 
    if not ForAll( arg, a -> 
          ( ( Length( a ) = 2 ) and IsRat( a[1] ) and IsWord( a[2] ) ) ) then 
        Error( "expecting a list of terms [ coeff, word ]" );
    fi;
    c := [1..nargs];
    w := [1..nargs];
    for i in [1..nargs] do
        c[i] := arg[i][1];
        w[i] := arg[i][2];
    od;
    return MonoidPolyFromCoeffsWords( c, w );
end );

##############################################################################
##
#M  Length . . . . . . . . . . . . . . . . . . . . . . for a monoid polynomial
##
InstallOtherMethod( Length, "generic method for a monoid polynomial", true, 
    [ IsMonoidPolyTermsRep ], 0, 
function( poly )

    local  len;

    len := Length( Words( poly ) );
    if ( ( len = 1 ) and ( Coeffs( poly )[1] = 0 ) ) then
        len := 0;
    fi;
    return len;
end );

##############################################################################
##
#M  \= for a monoid polynomial
##
InstallOtherMethod( \=, "generic method for monoid polynomials", true, 
    [ IsMonoidPolyTermsRep, IsMonoidPolyTermsRep ], 0, 
function( p1, p2 ) 
    return( ( Coeffs(p1) = Coeffs(p2) ) and ( Words(p1) = Words(p2) ) ); 
end );

##############################################################################
##
#M  One for a monoid polynomial
##
## ????????????????????????????? delete this ?????????????????????????????????
##
InstallOtherMethod( One, "generic method for a monoid polynomial", true, 
    [ IsMonoidPolyTermsRep ], 0, 
poly -> One( FamilyObj( Words( poly )[1] ) ) );

##############################################################################
##
#M  Terms
##
InstallMethod( Terms, "generic method for a monoid polynomial", true, 
    [ IsMonoidPolyTermsRep ], 0, 
function( poly )

    local  c, w, t, i;

    c := Coeffs( poly ); 
    w := Words( poly );
    t := [ 1..Length( poly ) ];
    for i in [ 1..Length( poly ) ] do
        t[i] := [ c[i], w[i] ];
    od;
    return t;
end );

##############################################################################
##
#M  LeadTerm
##
InstallMethod( LeadTerm, "generic method for a monoid polynomial", true, 
    [ IsMonoidPolyTermsRep ], 0, 
function( poly )

    if ( Length( poly ) = 0 ) then 
        return fail;
    else 
        return [ Coeffs( poly )[1], Words( poly )[1] ];
    fi;
end );

##############################################################################
##
#M  LeadCoeffMonoidPoly
##
InstallMethod( LeadCoeffMonoidPoly, "generic method for a monoid polynomial", 
    true, [ IsMonoidPolyTermsRep ], 0, 
function( poly )

    if ( Length( poly ) = 0 ) then 
        return fail;
    else 
        return Coeffs( poly )[1];
    fi;
end );

##############################################################################
##
#M  ZeroMonoidPoly
##
InstallMethod( ZeroMonoidPoly, "generic method for a free group", true, 
    [ IsFreeGroup ], 0, 
function( F ) 
    return MonoidPolyFromCoeffsWordsNC( [ 0 ], [ One( F ) ] );
end );

###############################################################################
##
#M  AddTermMonoidPoly
##
InstallMethod( AddTermMonoidPoly, 
    "generic method for a monoid polynomial and a term", true, 
    [ IsMonoidPolyTermsRep, IsRat, IsWord ], 0, 
function( poly, coeff, word )

    local  cp, wp, len, i, j, terms, wi, ci, b, d, u, v, ca, wa, ans;

    wp := Words( poly );
    if not ( FamilyObj( word ) = FamilyObj( wp[1] ) ) then 
        Error( "poly and word using different free groups" );
    fi;
    if ( coeff = 0 ) then 
        return poly;
    fi;
    cp := Coeffs( poly );
    len := Length( poly );
    if ( len = 0 ) then 
        return MonoidPolyFromCoeffsWordsNC( [ coeff ], [ word ] );
    fi;
    i := 1;
    while ( ( wp[i] > word ) and ( i < len ) ) do
        i := i+1;
    od;
    if ( wp[len] > word ) then
        i := len + 1;
        ca := Concatenation( cp, [coeff] );
        wa := Concatenation( wp, [word] );
        return MonoidPolyFromCoeffsWordsNC( ca, wa );
    fi;
    wi := wp[i];
    ci:= cp[i];
    if (wi = word) then 
        ci := ci + coeff;
        b := cp{[1..i-1]};
        d := cp{[i+1..len]};
        u := wp{[1..i-1]};
        v := wp{[i+1..len]};
        if ( ci <> 0 ) then 
            ans := MonoidPolyFromCoeffsWordsNC( Concatenation( b, [ci], d ), 
                                                Concatenation( u, [wi], v ) );
        elif ( len = 1 ) then 
            ans := MonoidPolyFromCoeffsWordsNC( [0], 
                                                [ One( FamilyObj( word) ) ] );
        else 
            ans := MonoidPolyFromCoeffsWordsNC( Concatenation( b, d ), 
                                                Concatenation( u, v ) );
        fi;
    else
        if ( i = 1 ) then
            b := [ ];
            u := [ ];
        else
            b := cp{[1..i-1]};
            u := wp{[1..i-1]};
        fi;
        if ( i = len+1 ) then
            d := [ ];
            v := [ ];
        else
            d := cp{[i..len]};
            v := wp{[i..len]};
        fi;
        ans := MonoidPolyFromCoeffsWordsNC( Concatenation( b, [coeff], d ), 
                                            Concatenation( u, [word], v ) );
    fi;
    return ans;
end );

##############################################################################
##
#M  \+                                              for two monoid polynomials
##
InstallOtherMethod( \+, "generic method for monoid polynomials", true, 
    [ IsMonoidPolyTermsRep, IsMonoidPolyTermsRep ], 0, 
function( p1, p2 )

    local  c, w;

    c := Concatenation( Coeffs( p1 ), Coeffs( p2 ) );
    w := Concatenation( Words( p1 ), Words( p2 ) );
    return MonoidPolyFromCoeffsWords( c, w );
end );

##############################################################################
##
#M  \*                                            for monoid poly and rational
##
InstallOtherMethod( \*, "generic method for monoid polynomial and rational", 
    true, [ IsMonoidPolyTermsRep, IsRat ], 0, 
function( poly, rat )

    local  c, len, one;

    if ( rat = 0 ) then 
        one := One( FamilyObj( Words( poly )[1] ) );
        return MonoidPolyFromCoeffsWords( [ 0 ], [ one] );

    fi;
    len := Length( poly );
    if ( len = 0 ) then 
        return poly;
    fi;
    c := List( Coeffs( poly ), n -> rat*n );
    return MonoidPolyFromCoeffsWordsNC( c, Words( poly ) );
end );

##############################################################################
##
#M  \*                                            for rational and monoid poly
##
InstallOtherMethod( \*, "generic method for rational and monoid polynomial", 
    true, [ IsRat, IsMonoidPolyTermsRep ], 0, 
function( rat, poly ) 
    return  poly * rat;
end );

##############################################################################
##
#M  \-                                                 for a monoid polynomlal
##
InstallOtherMethod( \-, "generic method for monoid polynomials", true, 
    [ IsMonoidPolyTermsRep, IsMonoidPolyTermsRep ], 0, 
function( p1, p2 ) 
    return p1 + ( p2 * (-1) );
end );

##############################################################################
##
#M  \*                                            for a monoid poly and a word
##
InstallOtherMethod( \*, "generic method for a monoid polynomial and a word", 
    true, [ IsMonoidPolyTermsRep, IsWord ], 0, 
function( poly, word )

    local  w, len;

    w := Words( poly ); 
    if not ( FamilyObj( word ) = FamilyObj( w[1] ) ) then 
        Error( "poly and word using different free groups" );
    fi;
    len := Length( poly );
    if ( len = 0 ) then 
        return poly;
    fi;
    w := List( w, v -> v*word );
    return MonoidPolyFromCoeffsWords( Coeffs( poly ), w );
end );

##############################################################################
##
#M  \*                                              for two monoid polynomials
##
InstallOtherMethod( \*, "generic method for two monoid polynomials", true, 
    [ IsMonoidPolyTermsRep, IsMonoidPolyTermsRep ], 0, 
function( p1, p2 )

    local  c1, w1, c2, w2, len2, i, poly;

    c1 := Coeffs( p1 ); 
    w1 := Words( p1 ); 
    c2 := Coeffs( p2 ); 
    w2 := Words( p2 );
    if not ( FamilyObj( w1[1] ) = FamilyObj( w2[1] ) ) then 
        Error( "words using different free groups" );
    fi;
    len2 := Length( p2 );
    if ( len2 = 0 ) then 
        return p2;
    fi;
    poly := p1 * w2[1] * c2[1];
    for i in [2..len2] do
        poly := poly + ( p1 * w2[i] * c2[i] );
    od;
    return poly;
end );

##############################################################################
##
#M  Monic
##
InstallMethod( Monic, "generic method for a monoid polynomial", true, 
    [ IsMonoidPolyTermsRep ], 0, 
function( poly )

    local  c, c1;

    if ( Length( poly ) = 0 ) then 
        return fail;
    fi;
    c := Coeffs( poly );
    c1 := c[1];
    c := List( c, x -> x/c1 );
    return MonoidPolyFromCoeffsWordsNC( c, Words( poly ) );
end );

##############################################################################
##
#M  \<                                                 for a monoid polynomial
##
InstallOtherMethod( \<, "generic method for monoid polynomials", true, 
    [ IsMonoidPolyTermsRep, IsMonoidPolyTermsRep ], 0, 
function( p1, p2 )

    local  i, len1, len2, w1, w2, c1, c2, a1, a2;

    len1 := Length( p1 ); 
    len2 := Length( p2 );
    if ( len1 < len2 ) then 
        return true;
    elif ( len1 > len2 ) then 
        return false;
    fi;
    w1 := Words( p1 );
    w2 := Words( p2 );
    for i in [1..len1] do 
        if ( w1[i] < w2[i] ) then 
            return true;
        elif ( w1[i] > w2[i] ) then 
            return false;
        fi;
    od;
    c1 := Coeffs( p1 );
    c2 := Coeffs( p2 );
    for i in [1..len1] do 
        a1 := AbsInt( c1[i] ); 
        a2 := AbsInt( c2[i] );
        if ( a1 < a2 ) then 
            return true;
        elif ( a1 > a2 ) then 
            return false;
        # else absolute values equal, so choose -(term) > +(term) 
        elif ( c1[i] > c2[i] ) then 
            return true;
        elif ( c1[i] < c2[i] ) then 
            return false;
        fi;
    od;
    return false;
end );

#############################################################################
##
#M  ReduceMonoidPoly( <poly>, <rules> )
##
InstallMethod( ReduceMonoidPoly, "for a monoid poly", true,
    [ IsMonoidPolyTermsRep, IsList ], 0, 
function( poly, rules)

    local  rw, rmp;
    rw := List( Words( poly ), w -> ReduceWordKB( w, rules) );
    rmp := MonoidPolyFromCoeffsWords( Coeffs( poly ), rw );
    return rmp;  
end );

#############################################################################
##
#M  LoggedReduceMonoidPoly( <poly>, <rules>, <sats> )
##
InstallMethod( LoggedReduceMonoidPoly, 
    "for a monoid poly, a reduction system and a list of saturated sets", 
    true, [ IsMonoidPolyTermsRep, IsHomogeneousList, IsHomogeneousList ], 0, 
function( logpoly, rules, sats )

    local  tm, poly, logrw, rw, ncp, logs;

    poly := logpoly[2];
    logrw := List( Words( poly ), w -> LoggedReduceWordKB( w, rules) );
    rw := List( logrw, L -> L[2] );
    logs:= List( logrw, L -> L[1] );
    ncp:= MonoidPolyFromCoeffsWordsNC( Coeffs( poly ), rw );
    return [ logs, ncp ];
end );

#############################################################################
##
#E monpoly.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
