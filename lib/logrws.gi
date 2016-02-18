##############################################################################
##
#W  logrws.gi                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Declaration file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2016 Anne Heyworth and Chris Wensley 
##

##############################################################################
##
#M  LengthLexLess . . . . . . . . . .  ordering for noncommutative polynomials
##
InstallGlobalFunction( LengthLexLess, 
function( x, y )
    local lx, ly;
    lx := Length( x );
    ly := Length( y ); 
        if ( lx < ly ) then 
            return true;
    elif ( lx > ly ) then 
            return false;
    else
            return ( x < y );
    fi;
end );

##############################################################################
##
#M LengthLex . . . . . . . . . Greater ordering for noncommutative polynomials
##
InstallGlobalFunction( LengthLexGreater, 
function( x, y )
    local lx, ly;
    lx := Length( x );
    ly := Length( y ); 
    if ( lx > ly ) then 
        return true;
    elif ( lx < ly ) then 
        return false;
    else
        return ( x > y );
    fi;
end );

##############################################################################
##
#M FreeRelatorGroup( <G> )
##
InstallMethod( FreeRelatorGroup, "generic method for FpGroup", true, 
    [ IsFpGroup ], 0, 
function( G )

    local  F, rels, len, R, str, genR, hom;

    F := FreeGroupOfFpGroup( G );
    rels := RelatorsOfFpGroup( G );
    len := Length( rels );
    if HasName( G ) then 
        str := Concatenation( Name( G ), "_R" );
    else
        str := "FR";
    fi;
    R := FreeGroup( len, str );
    genR := GeneratorsOfGroup( R );
    if HasName( G ) then 
        SetName( R, str );
    fi;
    hom := GroupHomomorphismByImagesNC( R, F, genR, rels );
    SetFreeRelatorHomomorphism( G, hom );
    ### 11/10/05 : moved ModulePolyFam to modpoly.gd
    ### famR := ElementsFamily( FamilyObj( R ) );
    ### famR!.modulePolyFam := ModulePolyFam;
    return R;
end );

##############################################################################
##
#M FreeRelatorHomomorphism( <G> )
##
InstallMethod( FreeRelatorHomomorphism, "generic method for FpGroup", true, 
    [ IsFpGroup ], 0, 
function( G )

    local  F, R, rels, genR;

    F:= FreeGroupOfFpGroup( G ); 
    R:= FreeRelatorGroup( G );
    rels := RelatorsOfFpGroup( G );
    genR := GeneratorsOfGroup( R );
    if not ( Length( rels ) = Length( genR ) ) then 
        Error( "<rels> and <genR> have different lengths" );
    fi;
    return GroupHomomorphismByImagesNC( R, F, genR, rels );
end );

##############################################################################
## 
#M OnePassReduceWord( <word>, <rules> )
##
InstallMethod( OnePassReduceWord, "generic method for word and list of rules", 
    true, [ IsWord, IsHomogeneousList ], 0, 
function( word, rules )

    local  id, lenw, posw, r, lenr, posr, u, v; 

    # id := One( FamilyObj( word) );
    id := One( word );
    for r in rules do 
        posr := PositionWord( word, r[1], 1 );
        if IsInt( posr ) then 
            lenw := Length( word );
            lenr := Length( r[1] );
            posw := posr + lenr;
            if ( posr = 1 ) then
                u := id;
            else 
                u := Subword( word, 1, posr-1 );
            fi;
            if ( posw-1 = lenw ) then
                v := id;
            else 
                v := Subword( word, posw, lenw );
            fi;
            word := u*r[2]*v;
        fi;
    od;
    return word;
end );

##############################################################################
##
#M ReduceWordKB( <word>, <rules> )
##
InstallMethod( ReduceWordKB, "generic method for word and list of rules", 
    true, [ IsWord, IsHomogeneousList ], 0, 
function( word, rules )

    local  w, rw;

    w := word;
    rw := OnePassReduceWord( w, rules );
    while not( w = rw ) do
        w := rw;
        rw := OnePassReduceWord( w, rules );
    od;
    return w;
end );

##############################################################################
##
## OnePassKB( < rules> )
##
InstallMethod( OnePassKB, "generic method for a list of rules", true, 
    [ IsHomogeneousList ], 0, 
function( r0 )

    local  nargs, rules, rule, crit1, crit2, red1, red2, newrules, i, 
           rule1, l1, r1, len1, pos1, rule2, l2, r2, len2, pos2, 
           u, v, lenu, lenv, ur2v, critnum, critn, id;

    id := One( r0[1][1] );
    rules := ShallowCopy( r0 );
    newrules := [ ];
    critnum := 0;
    critn := 0;
    # Find all the critical pairs:
    for rule1 in rules do 
        l1 := rule1[1];
        r1 := rule1[2];
        len1 := Length( l1 ); 
        for rule2 in rules do 
            l2 := rule2[1];
            r2 := rule2[2];
            len2 := Length( l2 );
            # Search for type 1 pairs (when l2 is contained in l1 ) 
            pos1 := PositionWord( l1, l2, 1 );
            if IsInt( pos1 ) then 
                pos2 := pos1 + len2; 
                if ( pos1 = 1 ) then 
                    u := id;
                else 
                    u := Subword( l1, 1, pos1-1 );
                fi;
                if ( pos2-1 = len1 ) then
                    v := id;
                else 
                    v := Subword( l1, pos2, len1 );
                fi;
                ur2v := u * r2 * v;
                if not( ur2v = r1 ) then 
                    critnum := critnum + 1;
                    critn := critn + 1;
                    crit1 := ur2v;
                    red1 := OnePassReduceWord( crit1, rules );
                    while not( crit1 = red1 ) do 
                        crit1 := red1;
                        red1 := OnePassReduceWord( crit1, rules );
                    od;
                    crit2 := r1;
                    red2 := OnePassReduceWord( crit2, rules );
                    while not( crit2 = red2 ) do 
                        crit2 := red2;
                        red2 := OnePassReduceWord( crit2, rules );
                    od;
                    if ( crit1 < crit2 ) then 
                        crit2 := crit1;
                        crit1 := red2;
                    fi;
                    if not( crit1 = crit2 ) then 
                        Info( InfoIdRel, 3, "type 1: ", [ crit1, crit2 ] ); 
                        Add( newrules, [ crit1, crit2 ] );
                    fi;
                fi; 
            fi;
            # Search for type 2 pairs:
            # (These occur when the right of l1 overlaps the left of l2) 
            # (the length of the possible overlap (i) varies) 
            i := 1;
            while not( ( i > len1 ) or ( i > len2 ) ) do 
                if ( Subword( l1, len1-i+1, len1 ) = Subword( l2, 1, i) ) then 
                    if ( i = len1 ) then 
                        u := id;
                    else 
                        u := Subword( l1, 1, len1-i );
                    fi;
                    if ( i = len2 ) then
                        v := id;
                    else 
                        v := Subword( l2, i+1, len2 );
                    fi;
                    if not( r1*v = u*r2 ) then 
                        critnum := critnum + 1;
                        critn := critn + 1;
                        crit1 := r1*v;
                        red1 := OnePassReduceWord( crit1, rules );
                        while not( crit1 = red1 ) do 
                            crit1 := red1;
                            red1 := OnePassReduceWord( crit1, rules );
                        od;
                        crit2 := u*r2;
                        red2 := OnePassReduceWord( crit2, rules );
                        while not( crit2 = red2 ) do 
                            crit2 := red2;
                            red2 := OnePassReduceWord( crit2, rules );
                        od;
                        if ( crit1 < crit2 ) then 
                            crit2 := crit1;
                            crit1 := red2;
                        fi;
                        if not( crit1 = crit2 ) then 
                            Info( InfoIdRel, 3, "type2 : ", [ crit1, crit2 ] );
                            Add( newrules, [ crit1, crit2 ] );
                        fi;
                    fi;
                fi;
                i := i+1;
                if ( critn > 1000 ) then 
                    Print( critnum, " found\n" );
                    critn := critn - 1000;
                fi;
            od; 
        od; 
    od;
    if ( InfoLevel( InfoIdRel ) > 2 ) then 
        Print( "number of Critical Pairs found is ", critnum, "\n" );
    fi;
    # Add them in as new rules:
    Append( rules, newrules );
    return rules;
end );

##############################################################################
##
#M  RewriteReduce( <rules> )
##
InstallMethod( RewriteReduce, "generic method for a list of rules", true, 
    [ IsHomogeneousList ], 0, function( r0 )

    local  nargs, rules, rule, r, r1, r2, newrules, i, j;

    rules := List( Set ( ShallowCopy( r0 ) ) );
    for rule in rules do 
        newrules := Filtered( rules, r -> not( r = rule) );
        r1 := ReduceWordKB( rule[1], newrules );
        r2 := ReduceWordKB( rule[2], newrules );
        if ( ( r1 < rule[1] ) or ( r2 < rule[2] ) ) then 
            if ( r1 > r2 ) then 
                rule[1] := r1;
                rule[2] := r2;
            elif ( r1 < r2 ) then 
                rule[1] := r2;
                rule[2] := r1;
            else 
                rules := newrules;
            fi;
        fi;
    od;
    return List( Set( rules ) );
end );

##############################################################################
##
#M KnuthBendix( <rules> )
##
InstallMethod( KnuthBendix, "generic method for a list of rules", true, 
    [ IsHomogeneousList ], 0, 
function( r )

    local  rules, newrules, passes;
    rules := ShallowCopy( r );
    passes := 0;
    newrules := RewriteReduce( OnePassKB( rules) );
    while not( rules = newrules ) do 
        rules := newrules;
        newrules := RewriteReduce( OnePassKB( rules) );
        passes := passes + 1;
        if ( InfoLevel( InfoIdRel ) > 2 ) then 
            Print( "number of rules generated = ", Length(rules), "\n" );
            Print( "rules = ", rules, "\n" );
            Print( "passes = ", passes, "\n" );
        fi;
    od;
    return rules;
end );

###############################################################################
##
#M  MonoidWordFpWord( <word>, <fam>, <shift> )
##
InstallMethod( MonoidWordFpWord, 
    "generic method for a word, a family of monoid elements, and a Posint", 
    true, [ IsWord, IsFamilyDefaultRep, IsPosInt ], 0, 
function( w, fam, shift)

    local  rep, j;

    ### added ShallowCopy(  07/10/05 ???
    rep := ShallowCopy( ExtRepOfObj( w ) );
    j := 2;
    while( j <= Length( rep ) ) do 
        if ( rep[j] < 0 ) then 
            rep[j] := -rep[j];
            rep[j-1] := rep[j-1] + shift;
        fi;
        j := j+2;
    od;
    return ObjByExtRep( fam, rep );
end );

##############################################################################
##
#M  MonoidPresentationFpGroup
##
InstallOtherMethod( PrintObj, "generic method for MonoidPresentation FpGroup", 
    true, [ IsMonoidPresentationFpGroup ], 0, 
function( mon ) 
    Print( "monoid presentation for an fp-group with homomorphism\n", 
        MappingGeneratorsImages( HomomorphismOfPresentation( mon ) ) ); 
end ); 

InstallMethod( MonoidPresentationFpGroup, "generic method for an fp-group", 
    true, [ IsFpGroup ], 0, 
function( G )

    local  F, freerels, genF, genG, geninv, numgen, numrel, relrange, str, 
           FM, genFM, relsmon, i, list, j, elt, pos, geninvrels, 
           famFM, r, rep, fam, filter, mon, mu;

    F := FreeGroupOfFpGroup( G );
    genF:= GeneratorsOfGroup( F );
    genG:= GeneratorsOfGroup( G );
    geninv := Concatenation( genF, List( genF, g -> g^-1 ) );
    numgen := Length( genF );
    freerels := RelatorsOfFpGroup( G );
    numrel := Length( freerels );
    relrange := [1..numrel];
    relsmon := ListWithIdenticalEntries( numrel, 0 );
    if HasName( G ) then 
        str := Concatenation( Name( G ), "_M" );
    else 
        str := "mon";
    fi;
    # should be FM := FreeMonoid ... ???
    FM := FreeGroup( 2*numgen, str );
    genFM := GeneratorsOfGroup( FM );
    mu := GroupHomomorphismByImages( FM, F, genFM, geninv );
    famFM := ElementsFamily( FamilyObj( FM ) );
    famFM!.monoidPolyFam := MonoidPolyFam;
    for i in relrange do 
#       r := freerels[i];
#       rep := ExtRepOfDbj( r );
#       j := 2;
#       while ( j <= Length( rep) ) do
#           if ( rep[j] < 0 ) then -
#               rep[j] := - rep[j];
#               rep[j-l] := rep[j-l] + numgen;
#           fi;
#           j := j+2;
#       od;
#       relsmon[i] := ObjByExtRep( famFM, rep );
        relsmon[i] := MonoidWordFpWord( freerels[i], famFM, numgen );
    od;
    Info( InfoIdRel, 3, "relsmon = ", relsmon ); 
    geninvrels := [1..2*numgen];
    for i in [1..numgen] do 
        geninvrels[i] := genFM[i] * genFM[i+numgen];
        geninvrels[numgen+i] := genFM[i+numgen] * genFM[i];
    od;
    if ( InfoLevel( InfoIdRel ) > 2 ) then 
        Print( "inverse relators are: \n", geninvrels, "\n" );
        Print( "new group relators are: \n", relsmon, "\n" );
    fi;
    fam := FamilyObj( [ geninv, relsmon, geninvrels, mu ] );
    filter := IsMonoidPresentationFpGroup;
    mon := Objectify( NewType( fam, filter ), rec() );
    SetFreeGroupOfPresentation( mon, FM );
    SetGroupRelatorsOfPresentation( mon, relsmon );
    SetInverseRelatorsOfPresentation( mon, geninvrels );
    SetHomomorphismOfPresentation( mon, mu );
    return mon;
end );

##############################################################################
##
#M ViewObj
##
InstallMethod( ViewObj, "method for monoid presentations", true, 
    [ IsMonoidPresentationFpGroup ], 0, 
function( mon ) 
    ## Print( "<monoid presentation>" );
    Print( mon );
end );

##############################################################################
## 
#M  BetterRuleByReductionOrLength
##
InstallMethod( BetterRuleByReductionOrLength, "generic method for 2 rules", 
    true, [ IsHomogeneousList, IsHomogeneousList ], 0, 
function( r1, r2 )
 
    local  l1, l2, len1, len2, d1, d2, id, i1, i2;

    # words that equate generators are best (includes inverse relators)
    id := One( r1[1] );
    l1 := r1[1];
    l2 := r2[1];
    i1 := ( ( r1[2] = id ) and ( Length( l1 ) = 2 ) and
            ( Subword( l1, 1, 1 ) <> Subword( l1, 2, 2 ) ) );
    i2 := ( ( r2[2] = id ) and ( Length( l2 ) = 2 ) and
            ( Subword( l2, 1, 1 ) <> Subword( l2, 2, 2 ) ) );
    if ( i1 and i2 ) then 
        if ( l1 < l2 ) then 
            return true;
        elif ( l1 > l2 ) then 
            return false;
        fi;
    elif i1 then
        return true;
    elif i2 then 
        return false;
    fi;
    # rules which reduce length the most are next best 
    len1 := Length( l1); 
    len2 := Length( l2 );
    d1 := len1 - Length( r1[2] );
    d2 := len2 - Length( r2[2] );
    if ( d1 > d2 ) then 
        return true;
    elif ( d1 < d2 ) then 
        return false;
    elif ( len1 > len2 ) then 
        return true;
    elif ( len1 < len2 ) then 
        return false;
    else 
        return ( l1 > l2 );
fi;
end );

##############################################################################
##
#M  RewritingSystemFpGroup
##
InstallMethod( RewritingSystemFpGroup, "generic method for an fp-group", 
    true, [ IsFpGroup ], 0, 
function( G )

    local  id, monG, monrels, rules;

    monG := MonoidPresentationFpGroup( G );
    monrels := Concatenation( InverseRelatorsOfPresentation( monG ), 
                              GroupRelatorsOfPresentation( monG ) );
    id := One( monrels[1] );
    rules := List( monrels, r -> [ r, id ] );
    rules := KnuthBendix( rules );
    Sort( rules, BetterRuleByReductionOrLength );
    return rules;
end );

##############################################################################
##
#M  ElementsOfMonoidPresentation
##
InstallMethod( ElementsOfMonoidPresentation, "generic method for an FpGroup", 
    true, [ IsFpGroup ], 0, 
function( G )

    local  monG, genG, elG, fgmon, genpos, rws, elmon;

    monG := MonoidPresentationFpGroup( G );
    genG := GeneratorsOfGroup( G );
    elG := Elements( G );
    fgmon := FreeGroupOfPresentation( monG );
    genpos := GeneratorsOfGroup( fgmon ){[1..Length(genG)]};
    elmon := List( elG, g -> MappedWord( g, genG, genpos ) );
    rws := RewritingSystemFpGroup( G );
    elmon := List( elmon, g -> ReduceWordKB( g, rws ) );
#   ?? should elmon be sorted ??
    Sort( elmon );
    return elmon;
end );

#############################################################################
##
#M  LoggedOnePassReduceWord( <word>, <rules> )
##
InstallMethod( LoggedOnePassReduceWord, 
    "generic method for a word and list of logged rules", true, 
    [ IsWord, IsHomogeneousList ], 0, 
function( word, rules )

    local  id, pair, r, posr, lenr, lenu, lenv, u, v, c;

    pair := [ [ ], word ];
    id := One( FamilyObj( word ) );
    for r in rules do 
        posr := PositionWord( pair[2], r[1], 1 );
        if IsInt( posr ) then 
            lenr := Length( r[1] );
            lenu := posr - 1;
            lenv := Length( pair[2] ) - lenu - lenr;
            if ( lenu = 0 ) then
                u := id;
            else 
                u := Subword( pair[2], 1, lenu);
            fi;
            if ( lenv = 0 ) then
                v := id;
            else 
                v := Subword( pair[2], lenu+lenr+1, lenu+lenr+lenv );
            fi;
            c := List( r[2], ci -> [ ci[1], ci[2]*u^-1 ] );
            pair := [ Concatenation( pair[1], c ), u*r[3]*v ];
        fi;
    od;
    return pair;
end );

###############################################################################
##
#M  LoggedReduceWordKB( <word>, <rules> )
##
InstallMethod( LoggedReduceWordKB, 
    "generic method for a word and list of logged rules", true, 
    [ IsWord, IsHomogeneousList ], 0, 
function ( word, rules )

    local  w, rw, ans;

    w := word;
    ans := LoggedOnePassReduceWord( w, rules );
    while not( ans[2] = w ) do
        w := ans[2];
        rw := LoggedOnePassReduceWord( w, rules );
        ans[2] := rw[2];
        ans[1] := Concatenation( ans[1], rw[1] );
    od;
    return ans;
end );

##############################################################################
##
#M  LoggedOnePassKB( <rules> )
##
InstallMethod( LoggedOnePassKB, "generic method for a list of logged rules", 
    true, [ IsHomogeneousList ], 0, 
function( r0 ) 

    local  id, rules, rule, crit, p, c2, q, d1, np, nq, d2, yseq, 
           newrule, newrules, len1, r, n, lenr, lenu, lenv, u, v, 
           i, c1, c2u, c, j, lenc, filt;

    id := One( r0[1][1] );
    rules := ShallowCopy( r0 );
    Info( InfoIdRel, 2, "in LoggedOnePassKB with rules =" ); 
    Info( InfoIdRel, 2, rules );
    newrules := [ ];
    yseq := [ ];
    # Find all the critical pairs:
    for rule in rules do 
        len1 := Length( rule[1] );
        filt := Filtered( rules, r -> not( r = rule) );
        for r in filt do 
            lenr := Length( r[1] );
            # Search for type 1 pairs:
            # (These occur when r[1] is contained in rule[1] ) 
            if IsInt( PositionWord( rule[1], r[1], 1 ) ) then 
                lenu := PositionWord( rule[1], r[1], 1 ) - 1;
                lenv := len1 - lenu - lenr;
                if ( lenu = 0 ) then
                    u := id;
                else 
                    u := Subword( rule[1], 1, lenu );
                fi;
                if ( lenv = 0 ) then
                    v := id;
                else 
                    v := Subword( rule[1], lenu+lenr+1, lenu+lenr+lenv );
                fi;
                c1 := rule[2];
                c2u := List( r[2], c -> [ c[1], c[2]*(u^-1) ] );
                Info( InfoIdRel, 3, "type 1 pair ", [ u*r[3]*v, rule[3] ] );
                p := rule[3];
                q := u*r[3]*v;
                d1 := LoggedReduceWordKB( p, rules );
                np := d1[2];
                d1 := d1[1];
                d2 := LoggedReduceWordKB( q, rules );
                nq := d2[2];
                d2 := d2[1];
                # Orientate them:
                if ( np < nq ) then
                    d2 := Reversed( List( d2, c -> [ -c[1], c[2] ] ) );
                    c2u := Reversed( List( c2u, c -> [ -c[1], c[2] ] ) );
                    newrule := [ nq, Concatenation( d2, c2u, c1, d1 ), np ]; 
                else 
                    d1 := Reversed( List( d1, c -> [ -c[1], c[2] ] ) );
                    c1 := Reversed( List( c1, c -> [ -c[1], c[2] ] ) );
                    newrule := [ np, Concatenation( d1, c1, c2u, d2 ), nq ];
                fi;
                # Add them in as new rules:
                if ( np = nq ) then
                    if ( newrule[2] <> [ ] ) then
                        Info( InfoIdRel, 2, " !! np = nq at:\n", newrule[2] );
                        Add( yseq, ReducedYSequence( newrule[2] ) );
                    fi;
                else 
                    Info( InfoIdRel, 3, "newrule1 = ", newrule ); 
                    c := newrule[2];
                    lenc := Length( c );
                    j := 1;
                    while( j < lenc ) do
                        if ( ( c[j][1] = - c[j+1][1] ) and 
                             ( c[j][2] =   c[j+1][2] ) ) then 
                            c := Concatenation( c{[1..j-1]}, c{[j+2..lenc]} );
                            j := j - 2;
                            Info( InfoIdRel, 3, "reduced to: ", c );
                            lenc := lenc - 2;
                        fi;
                        j := j + 1;
                    od;
                    newrule[2] := c;
                    Add( newrules, newrule );
                fi;
            fi;
            # Now we have to search for type 2 pairs:
            # (These occur when the right of rule[1] 
            # coincides with the left of r[1]) 
            i := 1;
            while not( ( i > lenr ) or ( i > len1 ) ) do 
                if ( Subword( rule[1], len1-i+1, len1 ) 
                     = Subword( r[1], 1, i ) ) then 
                    if ( len1 = i ) then 
                        u := id;
                    else 
                        u := Subword( rule[1], 1, len1-i );
                    fi;
                    if ( lenr = i ) then
                        v := id;
                    else
                        v := Subword( r[1], i+1, lenr );
                    fi;
                    Info( InfoIdRel, 3, "type 2 overlap word = ", rule[1]*v ); 
                    c1 := rule[2];
                    c2u := List( r[2], c -> [ c[1], c[2]*u^-1 ] );
                    p := rule[3]*v;
                    q := u*r[3];
                    d1 := LoggedReduceWordKB( p, rules );
                    np := d1[2];
                    d1 := d1[1];
                    d2 := LoggedReduceWordKB( q, rules );
                    nq := d2[2];
                    d2 := d2[1];
                    # Orientate them:
                    if ( np < nq ) then
                        d2 := Reversed( List( d2, c -> [ -c[1], c[2] ] ) );
                        c2u := Reversed( List( c2u, c -> [ -c[1], c[2] ] ) );
                        newrule := [ nq, Concatenation(d2, c2u, c1, d1), np ];
                    else
                        d1 := Reversed( List( d1, c -> [ -c[1], c[2] ] ) );
                        c1 := Reversed( List( c1, c -> [ -c[1], c[2] ] ) );
                        newrule := [ np, Concatenation(d1, c1, c2u, d2), nq ];
                    fi;
                    # Add them in as new rules:
                    if ( np = nq ) then
                        if ( newrule[2] <> [ ] ) then
                            Info( InfoIdRel, 2, " !! type2, np = nq at:" );
                            Info( InfoIdRel, 2, newrule[2] );
                            Add( yseq, ReducedYSequence( newrule[2] ) );
                        fi;
                    else 
                        Info( InfoIdRel, 3, "newrule2 = ", newrule );
                        c := newrule[2]; 
                        lenc := Length( c );
                        j := 1;
                        while ( j < lenc ) do 
                            if ( ( c[j][1] = - c[j+1][1] ) and 
                                 ( c[j][2] =   c[j+1][2] ) ) then 
                                c := Concatenation(c{[1..j-1]},c{[j+2..lenc]});
                                j := j - 2;
                                Info( InfoIdRel, 3, "reduced to : ", c );
                                lenc := lenc - 2;
                                if ( ( j = -1 ) and ( lenc > 0 ) ) then
                                    j := 0;
                                fi;
                            fi;
                           j := j + 1;
                        od;
                        newrule[2] := c;
                        Add( newrules, newrule ); 
                    fi;
                fi;
                i := i + 1;
            od;
        od; 
    od;
    Append( rules, newrules );
    if ( Length( yseq ) > 0 ) then 
        if ( InfoLevel( InfoIdRel ) > 1 ) then
            Print( "\nYsequences found during LoggedOnePassKB:\n", 
                    yseq, "\n\n" );
        fi;
    fi;
    return rules;
end );

##############################################################################
##
#M LoggedRewriteReduce( <rules> )
##
InstallMethod( LoggedRewriteReduce, "generic method for list of logged rules", 
    true, [ IsHomogeneousList ], 0, 
function( r0 )

    local  rules, rule, r, newrules, nolog, p, q, np, nq, c0, c1, c2, d, 
           rng, keep, rpos, lpos, l1, l2, w1, w2, s1, s2, i, j;

    rules := List( Set( ShallowCopy( r0 ) ) ); 
    keep := ListWithIdenticalEntries( Length( rules ), -1 );
    rng := [1..Length(rules)];
    for r in rng do 
        rule := rules[r];
        if ( keep[r] < 0 ) then 
            rpos := Filtered( rng, 
                i -> ( ( rules[i][1]=rule[1] ) and ( rules[i][3]=rule[3] ) ) );
            lpos := Length( rpos );
            if ( lpos > 1 ) then 
                # choose which logged rule to keep 
                c1 := rules[rpos[1]][2];
                j := 1;
                for i in [2..lpos] do 
                    c2 := rules[rpos[i]][2];
                    if ( c2 < c1 ) then
                         j := i;
                         c1 := c2;
                    fi;
                od;
                for i in [1..lpos] do 
                    if ( i = j ) then 
                        keep[rpos[i]] := 1;
                    else
                        keep[rpos[i]] := 0;
                    fi;
                od; 
            fi; 
        fi; 
    od;
    rpos := Filtered( rng, j -> ( keep[j] <> 0 ) );
    rules := rules{rpos};
    for rule in rules do 
#       change next line?
        newrules := Filtered( rules, r -> not( r = rule) );
        # removes rule and any equivalent rules
        p := rule[1];
        c0 := rule[2]; 
        q := rule[3]; 
        np := LoggedReduceWordKB( p, newrules )[2];
        nq := LoggedReduceWordKB( q, newrules )[2];
        if ( np = nq ) then 
            rules := newrules;
        fi;
        if ( not( np=nq ) and ( not( ( np=p ) and ( nq=q ) ) ) ) then
            c1 := LoggedReduceWordKB( p, newrules )[1];
            c2 := LoggedReduceWordKB( q, newrules )[1];
            if ( np > nq ) then 
                rule[1] := np;
                rule[3] := nq;
                c1 := Reversed( List( c1, c -> [ -c[1], c[2] ] ) );
                rule[2] := Concatenation( c1, c0, c2 );
            else 
                rule[1] := nq;
                rule[3] := np;
                c2 := Reversed( List( c2, c -> [ -c[1], c[2] ] ) );
                c0 := Reversed( List( c0, c -> [ -c[1], c[2] ] ) );
                rule[2] := Concatenation( c2, c0, c1 );
            fi;
        fi; 
    od;
    nolog := List( rules, r -> [ r[1], r[3] ] );
    rules := Filtered( rules,
        r -> not( [r[1],r[3]] in nolog{[1..Position(rules,r)-1]} ) );
    return List( Set( rules) );
end );

##############################################################################
##
#M  LoggedKnuthBendix( <rules> )
##
InstallMethod( LoggedKnuthBendix, "generic method for a list of rules", 
    true, [ IsHomogeneousList ], 0, 
function( r0 )

    local  rules, newrules, passes, k, K2, K2a;

    rules := ShallowCopy( r0 );
    newrules := LoggedOnePassKB( rules );
    Info( InfoIdRel, 2, "number of rules generated: ", Length( newrules ) ); 
    newrules := LoggedRewriteReduce( newrules );
    passes := 1;
    if ( InfoLevel( InfoIdRel ) > 1 ) then 
        Print( "     which are reduced to : ", Length( newrules ), "\n" ); 
        Print( "        number of passes : ", passes, "\n" );
    fi;
    while not( rules = newrules ) do 
        rules := newrules; 
        newrules := LoggedOnePassKB( rules );
        Info( InfoIdRel, 2, "number of rules generated: ", Length(newrules) );
        newrules := LoggedRewriteReduce( newrules );
        passes := passes + 1; 
        if ( InfoLevel( InfoIdRel ) > 1 ) then 
            Print(" which are reduced to : ", Length( newrules ), "\n" );
            Print( " number of passes: ", passes, "\n" );
        fi;
    od;
    return rules;
end );

#################################*############################################
##
#M  CheckLoggedKnuthBendix( <rules> )
##
InstallMethod( CheckLoggedKnuthBendix, "generic method for a list of rules", 
    true, [ IsHomogeneousList ], 0, 
function( rules )

    local  i, r, k, l;

    k := ShallowCopy( rules );
    for i in [1..Length(rules)] do 
        r := rules[i];
        l := List( r[2], c -> c[1]^c[2] );
        k[i][2] := Product(l)*r[3];
        k[i][3] := ( k[i][1] = k[i][2] );
    od;
    return k;
end );

############################################################*#################
##
#M  BetterLoggedRuleByReductionOrLength
##
InstallMethod( BetterLoggedRuleByReductionOrLength, "generic method for 2 rules",
    true, [ IsList, IsList ], 0, 
function( r1, r2 )

    local  l1, l2, d1, d2, id, i1, i2;

    # words that map to the identity are best 
    # id:= One( FamilyObj( r1[1] ) );
    id := One( r1[1] );
    i1 := ( r1[3] = id );
    i2 := ( r2[3] = id );
    if i1 then 
        if i2 then 
            return ( r1[1] > r2[1] );
        else 
            return true;
        fi;
    elif i2 then 
        return false;
    fi;
    # rules which reduce length the most are next best 
    l1 := Length( r1[1] );
    l2 := Length( r2[1] );
    d1 := l1 - Length( r1[3] );
    d2 := l2 - Length( r2[3] );
    if ( d1 > d2 ) then 
        return true;
    elif ( d1 < d2 ) then 
        return false;
    elif ( l1 > l2 ) then 
        return true;
    elif ( l1 < l2 ) then 
        return false;
    else
        return ( r1[1] > r2[1] );
    fi;
end );

##############################################################################
##
#M  LoggedRewritingSystemFpGroup
##
InstallMethod( LoggedRewritingSystemFpGroup, "generic method for an fp-group",
    true, [ IsFpGroup ], 0, 
function( G )

    local  idmu, id, monG, mu, grprels, ngrels, monrels, len, inv, invrules, 
           leni, i, r, r0, r1, len1, c, p, lenc, j;

    monG := MonoidPresentationFpGroup( G );
    inv := InverseRelatorsOfPresentation( monG );
    mu := HomomorphismOfPresentation( monG );
    idmu := One( Source( mu ) ); 
    leni := Length( inv );
    grprels := GroupRelatorsOfPresentation( monG );
    ngrels := Length( grprels );
    monrels := Concatenation( inv, grprels ); 
    id := One( monrels[1] );
    invrules := List( inv, r -> [ r, id ] );
    Info( InfoIdRel, 3, "invrules = ", invrules, "\n" ); 
    len := Length( monrels );
    r0 := [1..len];
    for i in [1..len] do 
        r := monrels[i];
        if ( i > leni ) then
            r0[i] := [ r, [ [ i, id ] ], id ];
        else
            r0[i] := [ r, [ ], id ];
        fi;
    od;
    Info( InfoIdRel, 3, "initial rules = ", r0 ); 
    r1 := LoggedKnuthBendix( r0 );
    Info( InfoIdRel, 2, "rules after KB2 = ", r1 ); 
    # put the inverse relators at the front ..
    # expect them to be the only ones which map to the identity 
    Sort( r1, BetterLoggedRuleByReductionOrLength );
    # cancel terms of the form [-j, w ][ +j, w ] 
    for r in r1 do 
        c := r[2];
        lenc := Length( c );
        j := 1;
        while ( j < lenc ) do 
            if ( ( c[j][1] = - c[j+1][1] ) and ( c[j][2] = c[j+1][2] ) ) then 
                c := Concatenation( c{[1..j-1]}, c{[j+2..lenc]} );
                j := j - 1;
                lenc := lenc - 2;
            fi;
            j := j + 1;
        od;
        r[2] := c;
    od; 
    Info( InfoIdRel, 3, "rules before reduction : ", r1 );
    for j in [1..Length(r1)] do
        r := r1[j];
        c := r[2];
        for p in c do 
            ###### should not need this condition!!! ###### 
            if ( FamilyObj( p[2]) = FamilyObj( idmu ) ) then 
                p[2] := ReduceWordKB( p[2], invrules );
            else 
                Print( "Warning: ", p[2], " not in M at j = ", j, "\n" );
            fi;
        od;
        r[2] := c;
    od;
    len1:= Length( r1 );
    if ( InfoLevel( InfoIdRel ) > 2 ) then
        Print( "---------------------------------------------------------\n" );
    fi;
    return r1;
end );

############################################*##################*##############
##
#M  OrderingYSequences
##
InstallMethod( OrderingYSequences, "generic method for two YSequences", 
    true, [ IsList, IsList ], 0, 
function( y, z ) 
    if ( Length( y ) < Length( z ) ) then 
        return true;
    elif ( Length( y ) > Length( z ) ) then 
        return false;
    else
        return ( y < z );
    fi;
end );

##############################################################################
##
#M  ReducedYSequence
##
InstallMethod( ReducedYSequence, "generic method for a Ysequence", 
    true, [ IsList ], 0, 
function( y )

    local  k, leny, w;

    leny := Length( y );
    k := 1;
    while ( k < leny ) do 
        if ( ( y[k][1] = y[k+1][1]^(-1) ) and ( y[k][2] = y[k+1][2] ) ) then 
            y := Concatenation( y{[1..k-1]}, y{[k+2..leny]} );
            k := k - 2;
            leny := leny - 2;
            if ( ( k = -1 ) and ( leny > 0 ) ) then
                k := 0;
            fi;
        fi;
        k := k + 1;
    od;
#    ##  the following is not an appropriate operation
#    ##  could define something like ProductYSequence ????
#    ##  make the first conjugating word the identity word 
#    if ( leny > 0 ) then 
#        w := y[1][2]^(-1);
#        y := List( y, c -> [ c[1], c[2]*w ] );
#    fi;
    return y;
end );

##############################################################################
##
#M  IdentityYSequences
##
InstallMethod( IdentityYSequences, "generic method for an FpGroup", true, 
    [ IsFpGroup ], 0, 
function( G )

    local  monG, mu, elG, sigma, isigma, logrws, rws, F, genF, idF, freerels, 
           FR, genFR, idR, FM, genFM, idM, numgenM, numgenF, grprels, invrels, 
           invrules1, invrules2, numrel, relrange, numelts, eltrange, numids, 
           elt, im2, mue, numlwe, erange, cayley, edgelist, poslist, edgesF, 
           edgesM, lwe, inv, edge, e12, con, ans, i, j, k, pos, cyc1es, cyc1e,
           ide, ide2, ri, wi, idents, iidents, idG, genFMpos, g, gen, uelt, 
           melt, omega, z, z1, z2, numalf, e, rwe, c, leni, w1, genrangeF, 
           x, alfF, invF, k1gx, rev, i1, r, rho, lenr, changed, idi, idj, 
           lenj, ok, idsorder, numa;

    monG := MonoidPresentationFpGroup( G ); 
    FM := FreeGroupOfPresentation( monG );
    genFM := GeneratorsOfGroup( FM );
    idM := One( FM );
    numgenM := Length( genFM );
    invrels := InverseRelatorsOfPresentation( monG );
    invrules2 := Concatenation( List( invrels, r -> [ r, idM ] ),
                                List( invrels, r -> [r^-1, idM ] ) );
    grprels := GroupRelatorsOfPresentation( monG );
    mu := HomomorphismOfPresentation( monG );
    logrws := LoggedRewritingSystemFpGroup( G );
    rws := Filtered( logrws, r -> not( r[1] in invrels ) );
    rws := List( rws, r -> [ r[1], r[3] ] );
    if ( InfoLevel( InfoIdRel ) > 2 ) then
        Print( "logrws = \n" );
        Display( logrws );
        Print( "\nrws = \n" );
        Display( rws );
        Print( "\n" );
    fi;
    F := FreeGroupOfFpGroup( G );
    genF := GeneratorsOfGroup( F );
    idF := One( F );
    numgenF := Length( genF );
    genrangeF := [1..numgenF];
    invrules1 := ListWithIdenticalEntries( Length( genFM ), 0 );
    for g in genrangeF do 
        k := g + numgenF;
        invrules1[g] := [ genFM[g]^-1, genFM[k] ];
        invrules1[k] := [ genFM[k]^-1, genFM[g] ];
    od;
    genFMpos := genFM{ genrangeF };
    freerels := RelatorsOfFpGroup( G );
    numrel := Length( freerels );
    relrange := [1..numrel];
    FR := FreeRelatorGroup( G );
    idR := One( FR );
    genFR := GeneratorsOfGroup( FR );
    omega := GroupHomomorphismByImages( FR, F, genFR, freerels );
    if ( InfoLevel( InfoIdRel ) > 1 ) then 
        Print( "\nhom from FR to F is: \n", omega, "\n\n" );
    fi;
    elG := Elements( G );
    numelts := Size( G );
    eltrange := [1..numelts];
    sigma := ElementsOfMonoidPresentation( G );
#   ?? should sigma be sorted ??
    isigma := List( sigma, e -> ReduceWordKB( e^-1, invrules1 ) );
    if ( InfoLevel( InfoIdRel ) > 1 ) then 
        Print( Name( G ), " has elements \n", elG );
        Print( "\nand monoid elements (in different order): \n", sigma, "\n" );
        Print( "with inverses: \n", isigma, "\n\n" );
    fi;
    edgesM := [ ];
    k1gx := [ ];
    edgesF := [ ];
    for e in eltrange do 
        elt := sigma[e];
        for g in genrangeF do 
            gen := genFMpos[g];
            edge := [ elt, gen ];
            rwe := OnePassReduceWord( elt*gen, invrules2 );
            if not ( rwe in sigma ) then 
                rwe := LoggedReduceWordKB( elt*gen, logrws ); 
                lwe := rwe[1];
                rev := Reversed( List( lwe, c -> [ -c[1], c[2] ] ) );
                inv := [ rwe[2], genFM[g+numgenF] ];
                inv[2] := ReduceWordKB( inv[2], invrules1 );
                Add( edgesM, edge );
                Add( k1gx, lwe );
                Add( edgesM, inv );
                Add( k1gx, rev);
                alfF := [ ReduceWordKB( edge[1], rws ), 
                          ReduceWordKB( edge[2], rws ) ];
                Add( edgesF, alfF );
                invF := [ ReduceWordKB( inv[1], rws ), 
                          ReduceWordKB( inv[2], rws ) ];
                Add( edgesF, invF );
                ## test h1 on this alfa edge 
                e12 := alfF[1]*alfF[2];
                con := e12 * ( ReduceWordKB( e12, rws ) )^-1;
                mue := List( lwe, c -> [ c[1], Image( mu, c[2] ) ] );
                numlwe := Length( lwe );
                erange := [1..numlwe];
                ans := ListWithIdenticalEntries( numlwe, 0 );
                for j in erange do 
                    pos := mue[j][1]; 
                    im2 := mue[j][2];
                    if ( pos < 0 ) then 
                        ans[j] := ( freerels[-pos-numgenM]^-1 )^im2;
                    else 
                        ans[j] := freerels[pos-numgenM]^im2;
                    fi;
                od;
                ans := Product( ans );
                if not ( ans = Image( mu, con) ) then 
                    Print( "test [ans = Image( mu, con)] fails at:\n" );
                    Print( "[e,g] = ", [e,g], "\n" );
                    Print( " edge = ", edge, "\n" );
                    Print( " mue = ", mue, "\n" );
                    Print( " con = ", con, "\n" );
                    Print( " ans = ", ans, "\n" );
                    Error( "error with mu" ); 
                fi;
                Info( InfoIdRel, 3, alfF, " --> ", lwe );
            fi; 
        od; 
    od;
    ################ edgesM & k1gx ########################
    if ( InfoLevel( InfoIdRel ) > 0 ) then
        Print( "edgesM contains ", Length( edgesM ), " edges:\n" ); 
        for e in edgesM do 
            Print( e, "\n" ); 
        od;
        Print( "and there are ", Length(k1gx) ); 
        Print( " reduced lists k1gx[g,x] :-\n" ); 
    fi;
    if ( InfoLevel( InfoIdRel ) > 1 ) then 
        for e in k1gx do 
            Print( e, "\n" );
        od;
        Print( "\n" );
        Print( "There are ", Length( edgesF ) );
        Print( " edges + inverse edges not in the tree:\n" );
        for e in edgesF do
            Print( e, "\n" );
        od;
        Print( "\n" );
    fi;

    ### reduce these terms ???

    # create a list in which to store the identities and their inverses 
    numids := numrel * numelts;
    idents := ListWithIdenticalEntries( numids, 0 );
    iidents := ListWithIdenticalEntries( numids, 0 );
    idsorder := [1..numids];
    numalf := Length( edgesM );
    Info( InfoIdRel, 3, "numids, numalf = ", [ numids, numalf ] );
    for e in eltrange do 
        elt := sigma[e];
        if ( InfoLevel( InfoIdRel ) > 2 ) then
            Print( "==================================================\n" );
            Print( "Element = ", elt, "\n" );
        fi;
        for rho in relrange do 
            numa := (e-1)*numrel + rho;
            ### create the cyc1e [g,r] ? 
            ### and the 2nd part: (rho->^(sigma(g)^(-1) 
            ide := [ [ -(rho+numgenM), isigma[e] ] ];
            ### Cayley cyc1e = relator cyc1e in the Cayley graph 
            cyc1e := [ elt, grprels[rho] ];
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( "numa = ", numa, "\n" );
                Print( "rho = ", rho );
                Print( "cyc1e = 1", cyc1e, "\n" );
            fi;
            ### Cyc1e [g,r] (from vertex g and reading r along edges) 
            ### is converted to a list of its c()mponent edges:
            ### [source vertex, edge label] (some may be inverse edges) 
            r := cyc1e[2];
            lenr := Length( r );
            edgelist := ListWithIdenticalEntries( lenr, 0 );
            edgelist[1] := [ cyc1e[1], Subword( r, 1, 1 ) ];
            for i in [2..lenr] do 
                edgelist[i] := 
                    [ LoggedReduceWordKB( edgelist[i-1][1]*edgelist[i-1][2], 
                                             logrws )[2], Subword( r, i, i ) ];
            od;
            Info( InfoIdRel, 3, "edgelist = ", edgelist );
            ### Edges of the cyc1e which are in the tree are removed, 
            ### and the rest are represented by their position in the 
            ### list of alpha edges.
            poslist := [ ];
            for k in [1..Length(edgelist)] do
                pos:= Position( edgesM, edgelist[k] );
                if not( pos = fail) then 
                    Add( poslist, pos );
                    ide := Concatenation( ide, k1gx[pos] );
                fi;
            od;
            ### map poslist to F(R) 
            leni := Length( ide ); 
            for k in [1..leni] do 
                i1 := ide[k][1];
                if ( i1 > 0 ) then 
                    ri := genFR[ i1 - numgenM ];
                else 
                    ri := genFR[ - i1 - numgenM ]^-1;
                fi;
                wi := Image( mu, ide[k][2] );
                ide[k] := [ ri, wi ];
            od;
            ide := ReducedYSequence( ide );
            ### added this 07/10/05
            leni := Length( ide ); 
            if ( InfoLevel( InfoIdRel ) > 2 ) then
                Print( ", poslist = ", poslist, "\n" );
                Print( "1>   ide = ", ide, "\n" );
                Print( "2> ide = ", ide, "\n" );
                Print( "3> ide = ", ide, "\n" );
            fi;
            ### check that this really is an identity 
            if ( leni > 0 ) then 
                ide2 := ShallowCopy( ide );
                for k in [1..Length(ide2)] do 
                    z := ide2[k];
                    z1 := Image( omega, z[1] );
                    z2 := z[2];
                    ide2[k] := z1^z2;
                od;
                if not( Product( ide2 ) = idF ) then 
                    Print( "ERROR at [e,r]= ", [e,rho] );
                    Print( " ide = ", ide, "\n" );
                    Print( "while ide2 = ", ide2, "\n" );
                fi;
            fi;
            ### see if the identity or its inverse is already in the list 
            if ( leni > 0 ) then 
                pos := Position( idents, ide );
                if ( pos <> fail) then 
                    idents[numa] := [ ];
                    iidents[numa] := [ ];
                    Info( InfoIdRel, 3, "same as identity", pos ); 
                else
                    ide2 := Reversed( List( ide, c -> [ c[1]^(-1), c[2] ] ) );
                    w1 := ide2[1][2]^(-1);
                    ide2 := List( ide2, c -> [ c[1], c[2]*w1 ] );
                    pos := Position( idents, ide2 );
                    if not ( pos = fail) then 
                        idents[numa] := [ ];
                        iidents[numa] := [ ]; 
                        Info( InfoIdRel, 3, 
                              "inverse of previous identity ", pos);
                    else 
                        idents[numa] := ide;
                        iidents[numa] := ide2;
                        Info( InfoIdRel, 3,  
                              "*** new id from [g,rho] = ", [elt,rho] ); 
                    fi;
                fi; 
            else 
                idents[numa] := [ ];
                iidents[numa] := [ ];
            fi;
        od;
    od;
    if ( InfoLevel( InfoIdRel ) > 0 ) then
        for k in [1..numids] do
            Print( "\n", k, " : ", idents[k], "\n" );
        od;
    fi;
    ### search for conjugate of one identity lying within another 
    changed := true;
    while changed do 
#       Print(idsordar,"\n");
#       Print( "\n######### starting new test\n" );
        SortParallel( idents, idsorder, OrderingYSequences );
#       idents := Filtered( idents, L -> not( L = [ ] ) );
#       numids := Length( idents );
#       Print( "\nnumber of identities = ", numids, "\n" );
#       for i in [1..numids] do
#           Print( i, " : ", idents[i], "\n" );
#       od;
#       Print( "\n" );
        changed := false;
        for i in [1..numids] do 
            idi := idents[i];
            leni := Length( idi );
            if ( leni > 0 ) then
                rho := idi[1][1];
                for j in [i+1..numids] do 
                    idj := idents[j];
                    lenj := Length( idj );
                    k := 1;
                    while ( k <= (lenj-leni+1) ) do 
                        if ( idj[k][1] = rho ) then 
                            w1 := idj[k][2];
                            c := 1;
                            ok := true;
                            while ( ok and ( c < leni ) ) do
                                c := c+1;
                                if ([idi[c][1],idi[c][2]*w1]<>idj[k+c-1]) then 
                                     ok := false;
                                fi; 
                            od;
                            if ok then 
                                idj := Concatenation( idj{[1..k-1]}, 
                                                      idj{[(k+leni)..lenj]} );
                                idents[j] := idj;
                                lenj := lenj - leni;
                                if ( InfoLevel( InfoIdRel ) > 2 ) then
                                    if ( lenj = 0 ) then 
                                        Print( "** identity reduced! **\n" ); 
                                    fi; 
                                fi;
                                changed := true;
                                if ( InfoLevel( InfoIdRel ) > 2 ) then
                                    Print( "found ident ", i, " in ", j ); 
                                    Print( " at position ", k, "\n--> " );
                                    Print( idents[j], "\n" );
                                fi;
                                k := k-1;
                            fi;
                        fi;
                        k := k+1;
                    od;
                od; 
            fi; 
        od; 
    od;
    if ( InfoLevel( InfoIdRel ) > 2 ) then
        Print( "Converting identities back to original order: idsorder = " );
        Print( idsorder, "\n" );
    fi;
    SortParallel( idsorder, idents );
    if ( InfoLevel( InfoIdRel ) > 0 ) then
        Print( "Reordering the identites - old order was:\n", idsorder, "\n" );
    fi;
    return idents;
end );

#############################################################################
##
#E logrws.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
