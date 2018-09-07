##############################################################################
##
#W  logrws.gi                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Implementation file for functions of the IdRel package
##
#Y  Copyright (C) 1999-2018 Anne Heyworth and Chris Wensley 

##############################################################################
##
#M  LengthLexLess . . . . . . . . . .  ordering for noncommutative polynomials
#M  LengthLexGreater  . . . . . . . .  ordering for noncommutative polynomials
##
InstallGlobalFunction( LengthLexLess, 
function( x, y )
    local lx, ly; 
    if not ( HasLength(x) and HasLength(y) ) then 
        return fail; 
    fi; 
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

InstallGlobalFunction( LengthLexGreater, 
function( x, y )
    local lx, ly;
    if not ( HasLength(x) and HasLength(y) ) then 
        return fail; 
    fi; 
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
InstallMethod( FreeRelatorGroup, "generic method for fp-group", true, 
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
InstallMethod( FreeRelatorHomomorphism, "generic method for fp-group", true, 
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
#M InverseWordInFreeGroupOfPresentation( <F>, <w> )
##
InstallMethod( InverseWordInFreeGroupOfPresentation, 
    "method for a word in the free group of a presentation", true, 
    [ IsFpGroup, IsWord ], 0, 
function( F, v )

    local genF, invgenF, ev, p, q, m; 

    genF := GeneratorsOfGroup( F );
    invgenF := InverseGeneratorsOfFpGroup( F ); 
    ev := Reversed( ShallowCopy( ExtRepOfObj( v ) ) ); 
    for p in [1..Length(ev)/2] do 
        q := p+p;
        m := ev[q-1]; 
        ev[q-1] := Position( genF, invgenF[ ev[q] ] );
        ev[q] := m;
    od; 
    return ObjByExtRep( FamilyObj( v ), ev ); 
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
#M  ArrangeMonoidGenerators( <G>, <L> )
##
InstallMethod( ArrangeMonoidGenerators, "generic method for an fp-group", 
    true, [ IsFpGroup, IsHomogeneousList ], 0, 
function( G, agm ) 

    local n, n2, ok, i, pos, neg; 

    n := Length( GeneratorsOfGroup( G ) ); 
    n2 := n+n;
    ## test that agm has the correct form 
    ok := Length( agm ) = n2; 
    for i in [1..n] do
        pos := Position( agm, i ); 
        if ( pos = fail ) then ok := false; fi; 
        neg := Position( agm, -i ); 
        if ( neg = fail ) then ok := false; fi; 
    od; 
    if not ok then 
        Error( "arrangement agm is not a perm of [1,2,...n,-1,-2,...-n]" ); 
    else
        SetArrangementOfMonoidGenerators( G, agm );
        return agm; 
    fi; 
end ); 

InstallOtherMethod( ArrangeMonoidGenerators, "default method for an fp-group", 
    true, [ IsFpGroup ], 0, 
function( G ) 
    local n, agm; 
    n := Length( GeneratorsOfGroup( G ) ); 
    ## default order is [1,2,...,n,-1,-2,...,-n] 
    agm := Concatenation( [1..n], List( [1..n], i -> -i ) ); 
    SetArrangementOfMonoidGenerators( G, agm ); 
    return agm; 
end ); 

###############################################################################
##
#M  MonoidWordFpWord( <word>, <fam>, <order> )
##
InstallMethod( MonoidWordFpWord, 
    "generic method for a word, a family of monoid elements, and a list", 
    true, [ IsWord, IsFamilyDefaultRep, IsList ], 0, 
function( w, fam, L )

    local  rep, i, j, p, k;

    ### added ShallowCopy(  07/10/05 ???
    rep := ShallowCopy( ExtRepOfObj( w ) );
    j := 2;
    while( j <= Length( rep ) ) do 
        p := rep[j]; 
        i := rep[j-1]; 
        if ( p < 0 ) then 
            k := Position( L, -i );
            rep[j] := -rep[j];
        else 
            k := Position( L, i );
        fi; 
        rep[j-1] := k; 
        j := j+2;
    od;
    return ObjByExtRep( fam, rep );
end );

##############################################################################
##
#M  MonoidPresentationFpGroup
##
InstallMethod( MonoidPresentationFpGroup, "generic method for an fp-group", 
    true, [ IsFpGroup ], 0, 
function( G )

    local  F, freerels, genF, genG, geninv, numgen, numrel, relrange, str, 
           FM, genFM, invgenFM, relsmon, i, list, j, elt, pos, neg, geninvrels, 
           famFM, r, rep, fam, filter, mon, mu, ok, numgen2, agm;

    F := FreeGroupOfFpGroup( G );
    genF:= GeneratorsOfGroup( F );
    genG:= GeneratorsOfGroup( G );
    numgen := Length( genF );
    numgen2 := 2*numgen; 
    if not HasArrangementOfMonoidGenerators( G ) then 
        ## use the default [1,2,...,n,-1,-2,...,-n] 
        agm := ArrangeMonoidGenerators( G ); 
    else 
        agm := ArrangementOfMonoidGenerators( G ); 
    fi;
    ## previously:  geninv := Concatenation( genF, List(genF,g->g^-1) ); 
    geninv := 0 * [1..numgen2]; 
    for i in [1..numgen2] do
        j := agm[i]; 
        if (j>0) then 
            geninv[i] := genF[j]; 
        else 
            geninv[i] := genF[-j]^-1; 
        fi; 
    od; 
    Info( InfoIdRel, 2, "geninv = ", geninv ); 

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
    invgenFM := ShallowCopy( genFM ); 
    for i in [1..numgen] do
        pos := Position( agm, i ); 
        neg := Position( agm, -i ); 
        invgenFM[pos] := genFM[neg]; 
        invgenFM[neg] := genFM[pos]; 
    od; 
    mu := GroupHomomorphismByImages( FM, F, genFM, geninv );
    famFM := ElementsFamily( FamilyObj( FM ) );
    famFM!.monoidPolyFam := MonoidPolyFam;
    for i in relrange do 
        relsmon[i] := MonoidWordFpWord( freerels[i], famFM, agm );
    od;
    Info( InfoIdRel, 3, "relsmon = ", relsmon ); 
    geninvrels := [1..numgen2];
    for i in [1..numgen] do 
        j := Position( agm, i ); 
        pos := Position( agm, -i ); 
        geninvrels[i] := genFM[j] * genFM[pos];
        geninvrels[numgen+i] := genFM[pos] * genFM[j];
    od;
    if ( InfoLevel( InfoIdRel ) > 2 ) then 
        Print( "inverse relators are: \n", geninvrels, "\n" );
        Print( "new group relators are: \n", relsmon, "\n" );
    fi;
    fam := FamilyObj( [ geninv, relsmon, geninvrels, mu ] );
    filter := IsMonoidPresentationFpGroupRep;
    mon := rec(); 
    ObjectifyWithAttributes( mon, 
      NewType( fam, filter ), 
      IsMonoidPresentationFpGroup, true, 
      FreeGroupOfPresentation, FM, 
      GroupRelatorsOfPresentation, relsmon, 
      InverseRelatorsOfPresentation, geninvrels, 
      HomomorphismOfPresentation, mu );
    SetInverseGeneratorsOfFpGroup( FM, invgenFM ); 
    return mon;
end );

##############################################################################
##
#M  String, ViewObj, PrintObj 
##
InstallMethod( ViewObj, "method for monoid presentations", true, 
    [ IsMonoidPresentationFpGroup ], 0, 
function( mon ) 
    Print( "monoid presentation with group relators ",
           GroupRelatorsOfPresentation( mon ) );
    ## Print( mon );
end );

InstallOtherMethod( PrintObj, "method for monoid presentations", true, 
    [ IsMonoidPresentationFpGroup ], 0, 
function( mon ) 
    Print( "monoid presentation for an fp-group with homomorphism\n", 
        MappingGeneratorsImages( HomomorphismOfPresentation( mon ) ) ); 
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
#M  MonoidGeneratorsFpGroup
##
InstallMethod( MonoidGeneratorsFpGroup, "generic method for an fp-group", 
    true, [ IsFpGroup ], 0, 
function( G )

    local  monG, genG, fgmon, amg, genmon, genpos;

    monG := MonoidPresentationFpGroup( G );
    genG := GeneratorsOfGroup( G );
    fgmon := FreeGroupOfPresentation( monG );
    amg := ArrangementOfMonoidGenerators( G );
    genmon := GeneratorsOfGroup( fgmon ); 
    genpos := List( [1..Length(genG)], i -> Position( amg, i ) ); 
    return List( genpos, i -> genmon[i] ); 
end );

##############################################################################
##
#M  ElementsOfMonoidPresentation
##
InstallMethod( ElementsOfMonoidPresentation, "generic method for an fp-group", 
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
#M  LoggedOnePassKB( <G>, <rules> )
##
InstallMethod( LoggedOnePassKB, "for an fp-group and a list of logged rules", 
    true, [ IsFpGroup, IsHomogeneousList ], 0, 
function( G, r0 ) 

    local  monG, FM, id, rules, rule, crit, p, c2, q, d1, np, nq, d2, rseq, 
           numrseq, newrule, redrule, newrules, len1, r, n, lenr, u, lenu, 
           v, lenv, i, c1, c2u, iu, c, j, lenc, filt;

    monG := MonoidPresentationFpGroup( G ); 
    FM := FreeGroupOfPresentation( monG );
    id := One( r0[1][1] );
    rules := ShallowCopy( r0 );
    Info( InfoIdRel, 2, "in LoggedOnePassKB with ", Length(rules) ); 
    Info( InfoIdRel, 3, "rules = ", rules );
    newrules := [ ];
    rseq := [ ];
    numrseq := 0;
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
                iu := InverseWordInFreeGroupOfPresentation( FM, u ); 
                #? c2u := List( r[2], c -> [ c[1], c[2]*u^(-1) ] );
                c2u := List( r[2], c -> [ c[1], c[2]*iu ] );
                Info( InfoIdRel, 2, "type 1 pair ", [ u*r[3]*v, rule[3] ] );
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
                    redrule := RelatorSequenceReduce( G, newrule[2] ); 
                    if ( redrule <> [ ] ) then
                        Info( InfoIdRel, 2, " !! np = nq at:\n", newrule[2] );
                        numrseq := numrseq + 1; 
                        Add( rseq, [ numrseq, redrule ] );
                    fi;
                else 
                    Info( InfoIdRel, 2, "newrule1 = ", newrule ); 
                    c := newrule[2];
                    lenc := Length( c );
                    j := 1;
                    while( j < lenc ) do
                        if ( ( c[j][1] = - c[j+1][1] ) and 
                             ( c[j][2] =   c[j+1][2] ) ) then 
                            c := Concatenation( c{[1..j-1]}, c{[j+2..lenc]} );
                            j := j - 2;
                            Info( InfoIdRel, 2, "reduced to: ", c );
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
                    Info( InfoIdRel, 2, "type 2 overlap word = ", rule[1]*v ); 
                    c1 := rule[2];
                    iu := InverseWordInFreeGroupOfPresentation( FM, u ); 
                    #? c2u := List( r[2], c -> [ c[1], c[2]*u^(-1) ] );
                    c2u := List( r[2], c -> [ c[1], c[2]*iu ] );
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
                        redrule := RelatorSequenceReduce( G, newrule[2] ); 
                        if ( redrule <> [ ] ) then
                            Info( InfoIdRel, 2, " !! type2, np = nq at:" );
                            Info( InfoIdRel, 2, newrule[2] ); 
                            numrseq := numrseq + 1; 
                            Add( rseq, [ numrseq, redrule ] );
                        fi;
                    else 
                        Info( InfoIdRel, 2, "newrule2 = ", newrule );
                        c := newrule[2]; 
                        lenc := Length( c );
                        j := 1;
                        while ( j < lenc ) do 
                            if ( ( c[j][1] = - c[j+1][1] ) and 
                                 ( c[j][2] =   c[j+1][2] ) ) then 
                                c := Concatenation(c{[1..j-1]},c{[j+2..lenc]});
                                j := j - 2;
                                Info( InfoIdRel, 2, "reduced to : ", c );
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
    if ( Length( rseq ) > 0 ) then 
        if ( InfoLevel( InfoIdRel ) > 1 ) then
            Print( "\nthere were ", Length(rseq), 
                   " relator sequences found during LoggedOnePassKB:\n" ); 
            Print( "with lengths: ", List( rseq, y -> Length(y[2]) ), "\n\n" ); 
        fi;
        if ( InfoLevel( InfoIdRel ) > 2 ) then 
            Perform( rseq, Display ); 
        fi;
    fi;
    Info( InfoIdRel, 3, "length of rseq in LoggedOnePassKB: ", Length(rseq) ); 
    return [ rules, rseq ];
end );

##############################################################################
##
#M LoggedRewriteReduce( <G>, <rules> )
##
InstallMethod( LoggedRewriteReduce, "for an fp-group and list of logged rules", 
    true, [ IsFpGroup, IsHomogeneousList ], 0, 
function( G, r0 )

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
    return List( Set(rules) );
end );

##############################################################################
##
#M  LoggedKnuthBendix( <G>, <rules> )
##
InstallMethod( LoggedKnuthBendix, "for an fp-group and a list of rules", 
    true, [ IsFpGroup, IsHomogeneousList ], 0, 
function( G, r0 )

    local  result, rules, newrules, passes, k, K2, K2a, mseq;

    rules := ShallowCopy( r0 );
    result := LoggedOnePassKB( G, rules );
    newrules := result[1];
    Info( InfoIdRel, 1, "number of rules generated: ", Length( newrules ) ); 
    newrules := LoggedRewriteReduce( G, newrules );
    passes := 1;
    if ( InfoLevel( InfoIdRel ) > 1 ) then 
        Print( "     which are reduced to : ", Length( newrules ), "\n" ); 
        Print( "        number of passes : ", passes, "\n" );
    fi;
    while not( rules = newrules ) do 
        rules := newrules; 
        result := LoggedOnePassKB( G, rules );
        newrules := result[1]; 
        Info( InfoIdRel, 2, "number of rules generated: ", Length(newrules) );
        newrules := LoggedRewriteReduce( G, newrules );
        passes := passes + 1; 
        if ( InfoLevel( InfoIdRel ) > 1 ) then 
            Print(" which are reduced to : ", Length( newrules ), "\n" );
            Print( " number of passes: ", passes, "\n" );
        fi;
    od;
    ## the second part of the final result is a set of group relator sequences 
    mseq := result[2]; 
    if ( InfoLevel( InfoIdRel ) > 1 ) then 
        Print( "there were ", Length(mseq), 
            " group relator sequences found during logged Knuth Bendix\n" ); 
    fi;
    mseq := List( mseq, L -> L[2] );
    return [ rules, mseq ];
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
#M  InitialLoggedRules
##
InstallMethod( InitialLoggedRules, "generic method for an fp-group",
    true, [ IsFpGroup ], 0, 
function( G ) 

    local monG, invrels, mu, idmu, leni, grprels, ngrels, monrels, id, 
          invrules, len, r0, i, r; 

    monG := MonoidPresentationFpGroup( G );
    invrels := InverseRelatorsOfPresentation( monG );
    mu := HomomorphismOfPresentation( monG );
    idmu := One( Source( mu ) ); 
    leni := Length( invrels );
    grprels := GroupRelatorsOfPresentation( monG );
    ngrels := Length( grprels );
    monrels := Concatenation( invrels, grprels ); 
    id := One( monrels[1] );
    invrules := List( invrels, r -> [ r, id ] );
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
    return r0; 
end );

##############################################################################
##
#M  LoggedRewritingSystemFpGroup
##
InstallMethod( LoggedRewritingSystemFpGroup, "generic method for an fp-group",
    true, [ IsFpGroup ], 0, 
function( G )

    local  idmu, id, monG, mu, grprels, ngrels, monrels, len, invrels, invrules, 
           leni, i, r, r0, r1, c, p, lenc, j, result, mseq, lenseq, gseq;

    monG := MonoidPresentationFpGroup( G );
    invrels := InverseRelatorsOfPresentation( monG );
    mu := HomomorphismOfPresentation( monG );
    idmu := One( Source( mu ) ); 
    grprels := GroupRelatorsOfPresentation( monG );
    monrels := Concatenation( invrels, grprels ); 
    id := One( monrels[1] );
    invrules := List( invrels, r -> [ r, id ] );
    r0 := InitialLoggedRules( G );
    Info( InfoIdRel, 3, "initial rules = ", r0 ); 
    result := LoggedKnuthBendix( G, r0 );
    r1 := result[1]; 
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
    ## now save the relator sequences found during logged Knuth Bendix 
    mseq := result[2];
    lenseq := Length( mseq );
    mseq := List( [1..lenseq], i -> [ i, mseq[i] ] );
    gseq := ConvertToGroupRelatorSequences( G, mseq );
    gseq := ReduceGroupRelatorSequences( gseq ); 
    lenseq := Length( gseq );
    gseq := List( [1..lenseq], i -> [ i, gseq[i][1], gseq[i][2] ] ); 
    SetIdentityRelatorSequencesKB( G, gseq );
    Info( InfoIdRel, 1 , "#IdentityRelatorsequencesKB:\n", lenseq ); 
    return r1;
end );

##############################################################################
##
#M  RelatorSequenceReduce
##
InstallMethod( RelatorSequenceReduce, "for an fp-group and a relator sequence", 
    true, [ IsFpGroup, IsHomogeneousList ], 0, 
function( G, seq )

    local monG, FM, idFM, genFM, invgenFM, invrels, invrules, invinvrules, 
          len, w, ew, k, s1, s2, x1, x2, i, j;

    monG := MonoidPresentationFpGroup( G ); 
    FM := FreeGroupOfPresentation( monG );
    idFM := One( FM ); 
    genFM := GeneratorsOfGroup( FM );
    invgenFM := InverseGeneratorsOfFpGroup( FM ); 
    invrels := InverseRelatorsOfPresentation( monG ); 
    invrules := List( invrels, r -> [ r, idFM ] ); 
    invinvrules := Concatenation( invrules, 
                       List( invrules, r -> [ r[1]^(-1), r[2] ] ) ); 
    len := Length( seq );
    for k in [1..len] do 
        w := ReduceWordKB( seq[k][2], invinvrules ); 
        if ( w = idFM ) then 
            seq[k][2] := idFM; 
        else 
            ## replace each negative power with its positive equivalent 
            ew := ShallowCopy( ExtRepOfObj( w ) );
            for i in [1..Length(ew)/2] do 
                j := 2*i; 
                if ( ew[j] < 0 ) then 
                    ew[j-1] := Position( genFM, invgenFM[ ew[j-1] ] ); 
                    ew[j] := - ew[j]; 
                fi; 
            od;
        fi;
    od; 
    k := 1;
    while ( k < len ) do 
        s1 := seq[k]; 
        s2 := seq[k+1]; 
        if ( s1[1] = -s2[1] ) then 
            if ( s1[2] = s2[2] ) then 
                seq := Concatenation( seq{[1..k-1]}, seq{[k+2..len]} );
                k := k - 2;
                len := len - 2;
                if ( ( k = -1 ) and ( len > 0 ) ) then
                    k := 0;
                fi;
            fi;
        fi; 
        k := k + 1;
    od;
    return seq;
end );

##############################################################################
##
#M  PartialElementsOfMonoidPresentation 
##
InstallMethod( PartialElementsOfMonoidPresentation, 
    "for an fp-group with monoid presentation and a length", true, 
    [ IsFpGroup, IsPosInt ], 0, 
function( G, len ) 

    local  monG, amg, fam, FM, genFM, invgenFM, idM, numgenM, logrws, rws, 
           edgesT, words, iwords, pos1, pos2, l, k, u, g, gen, v, pos, 
           ev, lev, i, j, m, P, IP, lenP, T, lenT, lenET;

    monG := MonoidPresentationFpGroup( G ); 
    amg := ArrangementOfMonoidGenerators( G ); 
    FM := FreeGroupOfPresentation( monG );
    genFM := GeneratorsOfGroup( FM );
    invgenFM := InverseGeneratorsOfFpGroup( FM ); 
    idM := One( FM );
    numgenM := Length( genFM );
    logrws := LoggedRewritingSystemFpGroup( G );
    rws := List( logrws, r -> [ r[1], r[3] ] );
    edgesT := [ ];
    fam := FamilyObj( idM ); 
    words := [ idM ];
    iwords := [ idM ]; 
    pos1 := 0; 
    pos2 := 1; 
    for l in [1..len] do 
    Info( InfoIdRel, 2, "constructing elements of length ", l ); 
        for k in [pos1+1..pos2] do 
            u := words[k]; 
            for g in [1..numgenM] do 
                gen := genFM[g];  
                v := ReduceWordKB( u*gen, rws ); 
                pos := Position( words, v );
                if ( pos = fail ) then 
                    Add( words, v ); 
                    Add( iwords, InverseWordInFreeGroupOfPresentation(FM,v) ); 
                    Add( edgesT, [ u, gen ] ); 
                    Add( edgesT, [ v, invgenFM[g] ] ); 
                fi; 
            od;
        od;
        pos1 := pos2; 
        pos2 := Length( words ); 
    od; 
    if HasPartialElements( G ) then 
        P := PartialElements( G ); 
        IP := PartialInverseElements( G ); 
        lenP := Length( P ); 
        if ( pos2 > lenP ) then 
            ## more elements have been constructed, so add them to the list 
            Append( P, words{[lenP+1..pos2]} ); 
            Append( IP, iwords{[lenP+1..pos2]} ); 
            T := GenerationTree( G ); 
            lenT := Length( T ); 
            lenET := Length( edgesT );
            if ( lenET > lenT ) then 
                Append( T, edgesT{[lenT+1..lenET]} ); 
            fi;
            SetPartialElementsLength( G, len ); 
        fi;
    else 
        SetGenerationTree( G, edgesT );
        SetPartialElements( G, words ); 
        SetPartialElementsLength( G, len );
        SetPartialInverseElements( G, iwords ); 
    fi; 
    return words; 
end );

#############################################################################
##
#E logrws.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
