##############################################################################
##
#W  logrws.gi                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Implementation file for functions of the IdRel package
##
#Y  Copyright (C) 1999-2024 Anne Heyworth and Chris Wensley 

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

    local  id, id2, lenw, posw, r, lenr, posr, u, v; 

    id := One( rules[1][1] ); 
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

    local  id, w, rw;

    id := One( rules[1][1] ); 
    if ( Length( word ) = 0 ) then 
        return word; 
    fi; 
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
## OnePassKB( <mG>, <rules> )
##
InstallMethod( OnePassKB, 
    "for a monoid presentation and a list of rules", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, r0 ) 

    local  fmG, gfmG, nargs, rules, rule, crit1, crit2, newrule, id, 
           red1, red2, newrules, i, rule1, l1, r1, len1, pos1, rule2, 
           l2, r2, len2, pos2, u, v, lenu, lenv, ur2v, critnum, critn, 
           numrules, use;

    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    id := One( fmG );
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
                    red1 := ReduceWordKB( crit1, rules );
                    crit2 := r1;
                    red2 := ReduceWordKB( crit2, rules );
                    if ( ( red1 in gfmG ) and ( red2 in gfmG ) ) then 
                        if ( Position( gfmG, red1 ) 
                             > Position( gfmG, red2 ) ) then 
                            newrule := [ red1, red2 ]; 
                        else 
                            newrule := [ red2, red1 ]; 
                        fi; 
                    elif ( red1 < red2 ) then 
                        newrule := [ red2, red1 ]; 
                    elif ( red2 < red1 ) then 
                        newrule := [ red1, red2 ]; 
                    fi;
                    if not( red1 = red2 ) then 
                        Info( InfoIdRel, 2, "type 1: ", newrule ); 
                        Add( newrules, newrule );
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
                        red1 := ReduceWordKB( crit1, rules );
                        crit2 := u*r2;
                        red2 := ReduceWordKB( crit2, rules );
                        if ( ( red1 in gfmG ) and ( red2 in gfmG ) ) then 
                            if ( Position( gfmG, red1 ) 
                                 > Position( gfmG, red2 ) ) then 
                                newrule := [ red1, red2 ]; 
                            else 
                                newrule := [ red2, red1 ]; 
                            fi; 
                        elif ( red1 < red2 ) then 
                            newrule := [ red2, red1 ]; 
                        elif ( red2 < red1 ) then 
                            newrule := [ red1, red2 ]; 
                        fi;
                        if not( red1 = red2 ) then 
                            Info( InfoIdRel, 2, "type 2: ", newrule ); 
                            Add( newrules, newrule );
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
    Sort( rules, BetterRuleByReductionOrLength );
    ## remove duplicates 
    numrules := Length( rules ); 
    use := [1..numrules]; 
    for i in [2..numrules] do 
        if ( rules[i] = rules[i-1] ) then 
            use := Difference( use, [i] ); 
        fi; 
    od; 
    return rules{use};
end );

##############################################################################
##
#M  RewriteReduce( <mG>, <rules> )
##
InstallMethod( RewriteReduce, 
    "for a monoid presentation and a list of rules", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 

function( mG, r0 )

    local  fmG, gfmG, rules, rule, pos, omit, r, r1, r2, len1, len2, 
           newrules, numrules, use, i;

    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    rules := ShallowCopy( r0 ); 
    for rule in rules do 
        pos := Position( rules, rule ); 
        omit := false; 
        newrules := Filtered( rules, r -> not( r[1] = rule[1] ) );
        r1 := ReduceWordKB( rule[1], newrules );
        r2 := ReduceWordKB( rule[2], newrules ); 
        len1 := Length( r1 ); 
        len2 := Length( r2 ); 
        r := [ r1, r2 ]; 
        if ( ( r1 < rule[1] ) or ( r2 < rule[2] ) ) then 
            if ( ( len1 = 1 ) and ( len2 = 1 ) ) then 
                ## treat generators/inverses as a special case 
                if ( ( r1 in gfmG ) and ( r2 in gfmG ) ) then 
                    if Position( gfmG, r1 ) < Position( gfmG, r2 ) then 
                        r[1] := r2; 
                        r[2] := r1; 
                    else 
                        r[1] := r1; 
                        r[2] := r2; 
                    fi; 
                elif ( r1 in gfmG ) then 
                    r[1] := r2; 
                    r[2] := r1; 
                elif ( r2 in gfmG ) then 
                    r[1] := r1; 
                    r[2] := r2; 
                fi; 
                if ( r1 = r2 ) then 
                    omit := true; 
                fi;
            elif ( r1 > r2 ) then 
                r[1] := r1;
                r[2] := r2; 
            elif ( r1 < r2 ) then 
                r[1] := r2;
                r[2] := r1; 
            else 
                ## r1 = r2 
                omit := true; 
            fi; 
            if omit then 
                rules := newrules; 
            else 
                rules := Concatenation( rules{[1..pos-1]}, [ r ], 
                                        rules{[pos+1..Length(rules)]} ); 
            fi; 
        fi;
    od; 
    Sort( rules, BetterRuleByReductionOrLength ); 
    ## remove duplicates 
    numrules := Length( rules ); 
    use := [1..numrules]; 
    for i in [2..numrules] do 
        if ( rules[i] = rules[i-1] ) then 
            use := Difference( use, [i] ); 
        fi; 
    od; 
    return rules{use}; 
end );

##############################################################################
##
#M  KnuthBendix( <mG>, <rules> )
##
InstallMethod( KnuthBendix, 
    "for a monoid presentation and a list of rules", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, r )

    local  fmG, gfmG, rules, newrules, passes; 

    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    rules := ShallowCopy( r );
    passes := 0;
    newrules := RewriteReduce( mG, OnePassKB( mG, rules) );
    while not( rules = newrules ) do 
        rules := newrules;
        newrules := RewriteReduce( mG, OnePassKB( mG, rules) );
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

    local n, n2, ok, i, pos, neg, inv, posi, invi; 

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

    local  F, genF, genG, numgen, numgen2, agm, Grels, numrel, relrange, 
           relsmon, str, FM, genFM, idFM, famFM, invgenFM, i, pos, neg, 
           geninvrels, invrules, mG, genmG, geninv, imgenG, j, 
           isoG, mu, fam, filter, mon;

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
    Grels := RelatorsOfFpGroup( G ); 
    numrel := Length( Grels );
    relrange := [1..numrel];
    relsmon := ListWithIdenticalEntries( numrel, 0 );
    if HasName( G ) then 
        str := Concatenation( Name( G ), "_M" );
    else 
        str := "mon";
    fi;
    FM := FreeGroup( 2*numgen, str );
    genFM := GeneratorsOfGroup( FM ); 
    idFM := One( FM ); 
    famFM := ElementsFamily( FamilyObj( FM ) );
    famFM!.monoidPolyFam := MonoidPolyFam;
    invgenFM := ShallowCopy( genFM ); 
    for i in [1..numgen] do
        pos := Position( agm, i ); 
        neg := Position( agm, -i ); 
        invgenFM[pos] := genFM[neg]; 
        invgenFM[neg] := genFM[pos]; 
    od; 
    geninvrels := [1..numgen2];
    for i in [1..numgen] do 
        j := Position( agm, i ); 
        pos := Position( agm, -i ); 
        geninvrels[i] := genFM[j] * genFM[pos];
        geninvrels[numgen+i] := genFM[pos] * genFM[j];
    od;
    invrules := Concatenation( List( geninvrels, r -> [ r, idFM ] ), 
                List( [1..numgen2], i -> [ genFM[i]^(-1), invgenFM[i] ] ) ); 
    Sort( invrules, BetterRuleByReductionOrLength ); 
    for i in relrange do 
        relsmon[i] := MonoidWordFpWord( Grels[i], famFM, agm );
    od;
    mG := FM / Concatenation( geninvrels, relsmon ); 
    genmG := GeneratorsOfGroup( mG ); 
    Info( InfoIdRel, 2, "invrules = ", invrules ); 
    Info( InfoIdRel, 2, "inverse relators = ", geninvrels ); 
    Info( InfoIdRel, 3, "relsmon = ", relsmon ); 
    geninv := 0 * [1..numgen2]; 
    imgenG := 0 * [1..numgen]; 
    for i in [1..numgen2] do
        j := agm[i]; 
        if (j>0) then 
            geninv[i] := genF[j]; 
            imgenG[j] := genmG [i]; 
        else 
            geninv[i] := genF[-j]^(-1); 
        fi; 
    od; 
    Info( InfoIdRel, 2, "geninv = ", geninv ); 
    Info( InfoIdRel, 2, "imgenG = ", imgenG ); 
    isoG := GroupHomomorphismByImagesNC( G, mG, genG, imgenG ); 
    mu := GroupHomomorphismByImagesNC( FM, F, genFM, geninv );
    fam := FamilyObj( [ geninv, relsmon, geninvrels, mu ] );
    filter := IsMonoidPresentationFpGroupRep;
    mon := rec(); 
    ObjectifyWithAttributes( mon, 
      NewType( fam, filter ), 
      IsMonoidPresentationFpGroup, true, 
      FreeGroupOfPresentation, FM, 
      GroupRelatorsOfPresentation, relsmon, 
      InverseRelatorsOfPresentation, geninvrels, 
      InverseRulesOfPresentation, invrules, 
      HomomorphismOfPresentation, mu ); 
    SetIsomorphicFpGroup( G, mG ); 
    SetIsomorphismByPresentation( G, isoG ); 
    SetInverseGeneratorsOfFpGroup( FM, invgenFM ); 
    SetUnderlyingGroupOfPresentation( mon, G ); 
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
function( rule1, rule2 )
 
    local  l1, l2, len1, len2, r1, r2, d1, d2;

    l1 := rule1[1];
    len1 := Length( l1 ); 
    l2 := rule2[1]; 
    len2 := Length( l2 ); 

    # rewrite rules are best 
    if ( len1 = 1 ) then 
        if ( len2 = 1 ) then 
            return l1 < l2; 
        else 
            return true; 
        fi; 
    fi; 
    # shorter left-hand sides are next best 
    if ( len1 < len2 ) then 
        return true; 
    elif ( len2 < len1 ) then 
        return false; 
    fi; 
    r1 := rule1[2]; 
    r2 := rule2[2]; 
    # rules which reduce length the most are next best 
    d1 := len1 - Length( r1 );
    d2 := len2 - Length( r2 );
    if ( d1 > d2 ) then 
        return true;
    elif ( d1 < d2 ) then 
        return false;
    fi; 
    if ( l1 < l2 ) then 
        return true; 
    elif ( l1 > l2 ) then 
        return false; 
    fi; 
    return ( r1 < r2 ); 
end );

##############################################################################
##
#M  RewritingSystemFpGroup
##
InstallMethod( RewritingSystemFpGroup, "generic method for an fp-group", 
    true, [ IsFpGroup ], 0, 
function( G )

    local  mG, fmG, id, rules;

    mG := MonoidPresentationFpGroup( G );
    fmG := FreeGroupOfPresentation( mG ); 
    id := One( fmG );
    rules := List( GroupRelatorsOfPresentation( mG ), r -> [ r, id ] );
    rules := Concatenation( rules, InverseRulesOfPresentation( mG ) ); 
    rules := KnuthBendix( mG, rules );
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

    local  mG, genG, fmG, amg, genmon, genpos;

    mG := MonoidPresentationFpGroup( G );
    genG := GeneratorsOfGroup( G );
    fmG := FreeGroupOfPresentation( mG );
    amg := ArrangementOfMonoidGenerators( G );
    genmon := GeneratorsOfGroup( fmG ); 
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

    local  mG, genG, elG, fmG, genpos, rws, elmG;

    mG := MonoidPresentationFpGroup( G );
    genG := GeneratorsOfGroup( G );
    elG := Elements( G );
    fmG := FreeGroupOfPresentation( mG );
    genpos := GeneratorsOfGroup( fmG ){[1..Length(genG)]};
    elmG := List( elG, g -> MappedWord( g, genG, genpos ) );
    rws := RewritingSystemFpGroup( G );
    elmG := List( elmG, g -> ReduceWordKB( g, rws ) );
#   ?? should elmG be sorted ??
    Sort( elmG );
    return elmG;
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
    id := One( rules[1][1] ); 
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
            c := List( r[2], ci -> [ ci[1], ci[2]*u^(-1) ] ); 
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
#M  LoggedOnePassKB( <mG>, <rules> )
##
InstallMethod( LoggedOnePassKB, 
    "for a monoid presentation and a list of logged rules", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, r0 ) 

    local  fmG, gfmG, id, rules, invrules, newrules, newrule, critnum, critn, 
           rule1, l1, c1, r1, len1, rule2, l2, c2, r2, len2, 
           pos1, pos2, u, v, iu, ur2v, red1, log1, ilog1, red2, log2, ilog2, 
           crit1, crit2, redrule, n, lenu, lenv, i, c2u, ic2u, ic1, c, j, 
           lenc, L, iL, numrules, use; 

    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG );
    id := One( fmG );
    rules := ShallowCopy( r0 ); 
    invrules := InverseRulesOfPresentation( mG ); 
    Info( InfoIdRel, 2, "in LoggedOnePassKB with ", Length(rules), " rules" ); 
    Info( InfoIdRel, 3, "rules = ", rules );
    newrules := [ ]; 
    critnum := 0; 
    critn := 0; 
    # Find all the critical pairs: 
    for rule1 in rules do 
        l1 := rule1[1]; 
        c1 := rule1[2]; 
        r1 := rule1[3];  
        len1 := Length( l1 );
        for rule2 in rules do 
            l2 := rule2[1]; 
            c2 := rule2[2]; 
            r2 := rule2[3]; 
            len2 := Length( l2 );
            # Search for type 1 pairs (when l2 is contained in l1): 
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
                iu := InverseWordInFreeGroupOfPresentation( fmG, u ); 
                ur2v := u * r2 * v; 
                if not ( ur2v = r1 ) then 
                    critnum := critnum + 1; 
                    Info( InfoIdRel, 2, "type 1 pair: ", [ u*r2*v, r1 ] );
                    critn := critn + 1; 
                    crit1 := ur2v; 
                    c2u := List( c2, 
                         c -> [ c[1], ReduceWordKB( c[2]*iu, invrules ) ] );
                    red1 := LoggedReduceWordKB( crit1, rules ); 
                    log1 := List( red1[1], 
                         c -> [ c[1], ReduceWordKB( c[2], invrules ) ] ); 
                    red1 := red1[2]; 
                    crit2 := r1; 
                    red2 := LoggedReduceWordKB( crit2, rules ); 
                    log2 := List( red2[1], 
                         c -> [ c[1], ReduceWordKB( c[2], invrules ) ] ); 
                    red2 := red2[2]; 
                    # Orientate them:
                    ilog2 := Reversed( List( log2, c -> [ -c[1], c[2] ] ) );
                    ilog1 := Reversed( List( log1, c -> [ -c[1], c[2] ] ) );
                    ic2u := Reversed( List( c2u, c -> [ -c[1], c[2] ] ) ); 
                    ic1 := Reversed( List( c1, c -> [ -c[1], c[2] ] ) ); 
                    L := Concatenation( ilog2, ic2u, c1, log1 ); 
                    iL := Concatenation( ilog1, ic1, c2u, log2 ); 
                    if ( ( red1 in gfmG ) and ( red2 in gfmG ) ) then 
                        if ( Position( gfmG, red1 ) 
                             > Position( gfmG, red2 ) ) then 
                            newrule := [ red1, iL, red2 ]; 
                        else 
                            newrule := [ red2, L, red1 ]; 
                        fi; 
                    elif ( red1 < red2 ) then
                        newrule := [ red2, L, red1 ]; 
                    elif ( red2 < red1 ) then  
                        newrule := [ red1, iL, red2 ];
                    fi;
                    # Add them in as new rules:
                    if ( red1 = red2 ) then 
                        redrule :=LogSequenceReduce( mG, L ); 
                        if ( redrule <> [ ] ) then
                            Info( InfoIdRel, 2, " !! red1 = red2 at:\n", L ); 
                        fi;
                    else 
                        c := newrule[2];
                        lenc := Length( c );
                        j := 1;
                        while( j < lenc ) do
                            if ( ( c[j][1] = - c[j+1][1] ) and 
                                 ( c[j][2] =   c[j+1][2] ) ) then 
                                c := Concatenation( c{[1..j-1]}, 
                                                    c{[j+2..lenc]} );
                                j := j - 2;
                                Info( InfoIdRel, 2, "reduced to: ", c );
                                lenc := lenc - 2;
                            fi;
                            j := j + 1;
                        od;
                        newrule[2] := c;
                        Add( newrules, newrule );
                        Info( InfoIdRel, 2, "(1) newrule = ", newrule ); 
                    fi;
                fi; 
            fi; 
            # Now we have to search for type 2 pairs:
            # These occur when the right of l1 overlaps the left of l2 
            i := 1;
            while not( ( i > len2 ) or ( i > len1 ) ) do 
                if ( Subword( l1, len1-i+1, len1 ) 
                     = Subword( l2, 1, i ) ) then 
                    if ( len1 = i ) then 
                        u := id;
                    else 
                        u := Subword( l1, 1, len1-i );
                    fi;
                    if ( len2 = i ) then
                        v := id;
                    else
                        v := Subword( l2, i+1, len2 );
                    fi;
                    Info( InfoIdRel, 2, "type 2 overlap word: ", 
                                        rule1[1]*v ); 
                    c1 := rule1[2];
                    iu := InverseWordInFreeGroupOfPresentation( fmG, u ); 
                    c2u := List( rule2[2], 
                           c -> [ c[1], ReduceWordKB( c[2]*iu, invrules ) ] ); 
                    if not ( r1*v = u*r2 ) then 
                        critnum := critnum + 1; 
                        critn := critn + 1; 
                        crit1 := r1*v;
                        red1 := LoggedReduceWordKB( crit1, rules ); 
                        log1 := List( red1[1], 
                          c -> [ c[1], ReduceWordKB( c[2], invrules ) ] ); 
                        red1 := red1[2]; 
                        crit2 := u*r2; 
                        red2 := LoggedReduceWordKB( crit2, rules );
                        log2 := List( red2[1], 
                          c -> [ c[1], ReduceWordKB( c[2], invrules ) ] ); 
                        red2 := red2[2]; 
                        # Orientate them:
                        ilog2 := Reversed( List( log2, c -> [ -c[1], c[2] ] ) );
                        ilog1 := Reversed( List( log1, c -> [ -c[1], c[2] ] ) );
                        ic2u := Reversed( List( c2u, c -> [ -c[1], c[2] ] ) ); 
                        ic1 := Reversed( List( c1, c -> [ -c[1], c[2] ] ) ); 
                        L := Concatenation( ilog2, ic2u, c1, log1 ); 
                        iL := Concatenation( ilog1, ic1, c2u, log2 ); 
                        if ( ( red1 in gfmG ) and ( red2 in gfmG ) ) then 
                            if ( Position( gfmG, red1 ) 
                                 > Position( gfmG, red2 ) ) then 
                                newrule := [ red1, iL, red2 ]; 
                            else 
                                newrule := [ red2, L, red1 ]; 
                            fi; 
                        elif ( red1 < red2 ) then
                            newrule := [ red2, L, red1 ]; 
                        elif ( red2 < red1 ) then  
                            newrule := [ red1, iL, red2 ];
                        fi;
                        # Add them in as new rules:
                        if ( red1 = red2 ) then 
                            Info( InfoIdRel, 2, "LHS = RHS" ); 
                            redrule :=LogSequenceReduce( mG, L ); 
                            if ( redrule <> [ ] ) then
                                Info( InfoIdRel, 2, 
                                  " !! type2, red1=red2= ", red1, " at:", L ); 
                            fi;
                        else 
                            c := newrule[2]; 
                            lenc := Length( c );
                            j := 1;
                            while ( j < lenc ) do 
                                if ( ( c[j][1] = - c[j+1][1] ) and 
                                     ( c[j][2] =   c[j+1][2] ) ) then 
                                    c := Concatenation( c{[1..j-1]}, 
                                                        c{[j+2..lenc]});
                                    j := j - 2;
                                    Info( InfoIdRel, 2, "reduced to : ", c); 
                                    lenc := lenc - 2;
                                    if ( ( j = -1 ) and ( lenc > 0 ) ) then
                                        j := 0;
                                    fi;
                                fi;
                                j := j + 1;
                            od;
                            newrule[2] := c;
                            Add( newrules, newrule ); 
                            Info( InfoIdRel, 2, "(2) newrule = ", newrule ); 
                        fi;
                    fi; 
                fi; 
                i := i + 1; 
            od; 
        od; 
    od;
    Append( rules, newrules );
    Sort( rules, BetterLoggedRuleByReductionOrLength );
    ## remove duplicates 
    numrules := Length( rules ); 
    use := [1..numrules]; 
    for i in [2..numrules] do 
        if ( rules[i] = rules[i-1] ) then 
            use := Difference( use, [i] ); 
        fi; 
    od; 
    return rules{use}; 
end );

##############################################################################
##
#M  LoggedRewriteReduce( <mG>, <rules> )
##
InstallMethod( LoggedRewriteReduce, 
    "for a monoid presentation and list of logged rules", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, r0 )

    local  fmG, id, gfmG, rules, numrules, rule, rule1, rule2, rule3, irule2, 
           pos, use, r, red1, red3, len1, len3, omit, 
           r1, r3, log1, ilog1, log3, ilog3, c13, c31, newrules, i;

    fmG := FreeGroupOfPresentation( mG ); 
    id := One( fmG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    rules := ShallowCopy( r0 ); 
    numrules := Length( rules ); 
    for rule in rules do 
        pos := Position( rules, rule ); 
        omit := false; 
        newrules := Filtered( rules, r -> not( r[1] = rule[1] ) );
        rule1 := rule[1]; 
        rule2 := rule[2]; 
        irule2 := Reversed( List( rule2, c -> [ - c[1], c[2] ] ) ); 
        rule3 := rule[3]; 
        red1 := LoggedReduceWordKB( rule1, newrules ); 
        log1 := red1[1]; 
        ilog1 := Reversed( List( log1, c -> [ - c[1], c[2] ] ) ); 
        r1 := red1[2]; 
        len1 := Length( r1 ); 
        red3 := LoggedReduceWordKB( rule3, newrules ); 
        log3 := red3[1]; 
        ilog3 := Reversed( List( log3, c -> [ - c[1], c[2] ] ) ); 
        r3 := red3[2]; 
        len3 := Length( r3 ); 
        c13 := Concatenation( ilog1, rule2, log3 ); 
        c31 := Concatenation( ilog3, irule2, log1 ); 
        if ( ( r1 < rule[1] ) or ( r3 < rule[3] ) ) then 
            if ( ( len1 = 1 ) and ( len3 = 1 ) ) then 
                ## treat generators/inverses as a special case 
                if ( ( r1 in gfmG ) and ( r3 in gfmG ) ) then 
                    if Position( gfmG, r1 ) < Position( gfmG, r3 ) then 
                        r := [ r3, c31, r1 ]; 
                    else 
                        r := [ r1, c13, r3 ]; 
                    fi; 
                elif ( r1 in gfmG ) then 
                    r := [ r3, c31, r1 ]; 
                elif ( r3 in gfmG ) then 
                    r := [ r1, c13, r3 ]; 
                fi; 
                if ( r1 = r3 ) then 
                    omit := true; 
                fi;
            elif ( r1 > r3 ) then 
                r := [ r1, c13, r3 ]; 
            elif ( r1 < r3 ) then 
                r := [ r3, c31, r1 ]; 
            else 
                ## r1 = r3 
                omit := true; 
            fi; 
            if omit then 
                rules := newrules; 
            else 
                rules := Concatenation( rules{[1..pos-1]}, [r], 
                                        rules{[pos+1..Length(rules)]} ); 
            fi; 
        fi; 
    od;
    Sort( rules, BetterLoggedRuleByReductionOrLength ); 
    ## remove duplicates 
    ## this is where we could catch some identities if we so wished 
    numrules := Length( rules ); 
    use := [1..numrules]; 
    for i in [2..numrules] do 
        if ( ( rules[i][1] = rules[i-1][1] ) and 
             ( rules[i][3] = rules[i-1][3] ) ) then 
            use := Difference( use, [i] ); 
        fi; 
    od; 
    return rules{use}; 
end );

##############################################################################
##
#M  LoggedKnuthBendix( <mG>, <rules> )
##
InstallMethod( LoggedKnuthBendix, 
    "for a monoid presentation and a list of rules", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, r0 )

    local  fmG, rules, newrules, passes, k, K2, K2a, mseq;

    fmG := FreeGroupOfPresentation( mG ); 
    rules := ShallowCopy( r0 );
    newrules := LoggedOnePassKB( mG, rules ); 
    Info( InfoIdRel, 1, "number of rules generated: ", Length( newrules ) ); 
    newrules := LoggedRewriteReduce( mG, newrules );
    passes := 1;
    if ( InfoLevel( InfoIdRel ) > 1 ) then 
        Print( "     which are reduced to : ", Length( newrules ), "\n" ); 
        Print( "        number of passes : ", passes, "\n" );
    fi; 
    while not( rules = newrules ) do 
        rules := newrules; 
        newrules := LoggedOnePassKB( mG, rules ); 
        Info( InfoIdRel, 2, "number of rules generated: ", Length(newrules) );
        newrules := LoggedRewriteReduce( mG, newrules );
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
#M  BetterLoggedList 
#M  BetterLoggedRuleByReductionOrLength
##
InstallMethod( BetterLoggedList, 
    "generic method for 2 logged lists", true, [ IsList, IsList ], 0, 
function( c1, c2 )

    local  len1, len2, i, t1, t2; 

    if ( c1 = c2 ) then 
        return false; 
    fi; 
    len1 := Length( c1 ); 
    len2 := Length( c2 ); 
    if ( len1 < len2 ) then 
        return true; 
    elif ( len1 > len2 ) then 
        return false; 
    fi; 
    i := 1;
    while ( c1[i] = c2[i] ) do 
        i := i+1; 
    od; 
    t1 := c1[i]; 
    t2 := c2[i]; 
    if ( t1[1] < t2[1] ) then 
        return true; 
    elif ( t1[1] > t2[1] ) then 
        return false; 
    fi; 
    if ( t1[2] < t2[2] ) then 
        return true; 
    elif ( t1[2] > t2[2] ) then 
        return false; 
    fi; 
    ## should never get here 
    Error( "here" ); 
end ); 

InstallMethod( BetterLoggedRuleByReductionOrLength, 
    "generic method for 2 logged rules", true, [ IsList, IsList ], 0, 
function( rule1, rule2 )

    local  l1, l2, len1, len2, r1, r2, d1, d2;

    # must give same results as BetterRuleByReductionOrLength 
    # so use the logged components as part of the test only at the very end 
    l1 := rule1[1];
    len1 := Length( l1 ); 
    l2 := rule2[1]; 
    len2 := Length( l2 ); 

    # rewrite rules are best 
    if ( len1 = 1 ) then 
        if ( len2 = 1 ) then 
            return l1 < l2; 
        else 
            return true; 
        fi; 
    fi; 
    # shorter left-hand sides are next best 
    if ( len1 < len2 ) then 
        return true; 
    elif ( len2 < len1 ) then 
        return false; 
    fi; 
    r1 := rule1[3]; 
    r2 := rule2[3]; 
    # rules which reduce length the most are next best 
    d1 := len1 - Length( r1 );
    d2 := len2 - Length( r2 );
    if ( d1 > d2 ) then 
        return true;
    elif ( d1 < d2 ) then 
        return false;
    else 
    fi; 
    if ( l1 < l2 ) then 
        return true; 
    elif ( l1 > l2 ) then 
        return false; 
    fi; 
    if ( r1 < r2 ) then 
        return true; 
    elif ( r1 > r2 ) then 
        return false; 
    fi; 
    return BetterLoggedList( rule1[2], rule2[2] ); 
end );

##############################################################################
##
#M  InitialLoggedRulesOfPresentation
##
InstallMethod( InitialLoggedRulesOfPresentation, 
    "generic method for an  presentation", true, 
    [ IsMonoidPresentationFpGroup ], 0, 
function( mG ) 

    local fmG, invrules, leni, r0, r1, grel, igrel, ngrel, id, rules; 

    fmG := FreeGroupOfPresentation( mG ); 
    id := One( fmG ); 
    invrules := InverseRulesOfPresentation( mG ); 
    leni := Length( invrules ); 
    r0 := List( invrules, r -> [ r[1], [ ], r[2] ] ); 
    grel := GroupRelatorsOfPresentation( mG );
    ngrel := Length( grel ); 
    igrel := List( [1..ngrel], i -> ReduceWordKB( grel[i]^-1, invrules ) ); 
##  r1 := List( [1..ngrel], i -> [ grel[i], [ [ i+leni, id ] ], id ] ); 
    r1 := List( [1..ngrel], i -> [ grel[i], [ [ i, id ] ], id ] ); 
    rules := Concatenation( r0, r1 ); 
    Sort( rules, BetterLoggedRuleByReductionOrLength ); 
    return rules; 
end );

##############################################################################
##
#M  InitialRulesOfPresentation
##
InstallMethod( InitialRulesOfPresentation, 
    "generic method for an fp-group presentation", true, 
    [ IsMonoidPresentationFpGroup ], 0, 
function( mG ) 

    local rules; 

    rules := InitialLoggedRulesOfPresentation( mG ); 
    return List( rules, L -> [ L[1], L[3] ] ); 
end );

##############################################################################
##
#M  LoggedRewritingSystemFpGroup
##
InstallMethod( LoggedRewritingSystemFpGroup, "generic method for an fp-group",
    true, [ IsFpGroup ], 0, 
function( G )

    local  fmG, mu, idmu, id, mG, grprels, ngrels, monrels, len, 
           invrels, invrules, leni, i, r, r0, r1, c, p, p2, lenc, j;

    mG := MonoidPresentationFpGroup( G ); 
    fmG := FreeGroupOfPresentation( mG ); 
    id := One( fmG ); 
    invrels := InverseRelatorsOfPresentation( mG );
    mu := HomomorphismOfPresentation( mG );
    idmu := One( Source( mu ) ); 
    grprels := GroupRelatorsOfPresentation( mG );
    monrels := Concatenation( invrels, grprels ); 
    invrules := List( invrels, r -> [ r, id ] );
    r0 := InitialLoggedRulesOfPresentation( mG );
    Info( InfoIdRel, 3, "initial rules = ", r0 ); 
    r1 := LoggedKnuthBendix( mG, r0 ); 
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
        r := [ r[1], c, r[3] ];
    od; 
    Info( InfoIdRel, 2, "rules before reduction : ", r1 );
    for j in [1..Length(r1)] do
        r := r1[j];
        c := r[2];
        for p in c do 
            ###### should not need this condition!!! ###### 
            if ( FamilyObj( p[2]) = FamilyObj( idmu ) ) then 
                p2 := ReduceWordKB( p[2], invrules ); 
                p := [ p[1], p2 ]; 
            else 
                Print( "Warning: ", p[2], " not in M at j = ", j, "\n" );
            fi;
        od;
        r1[j] := [ r[1], c, r[3] ];
    od; 
    Sort( r1, BetterLoggedRuleByReductionOrLength );
    SetLoggedRewritingSystemFpGroup( G, r1 ); 
    return r1; 
end );

##############################################################################
##
#M LogSequenceReduce
##
InstallMethod(LogSequenceReduce, 
    "for a monoid presentation and a relator sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, seq )

    local fmG, idfmG, gfmG, numgfmG, invgfmG, invrels, invrules, 
          invrules2, invinvrules, len, w, ew, k, s1, s2, x1, x2, i, j;

# seq := ShallowCopy( L ); 
    fmG := FreeGroupOfPresentation( mG );
    idfmG := One( fmG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    numgfmG := Length( gfmG ); 
    invgfmG := InverseGeneratorsOfFpGroup( fmG ); 
    invrels := InverseRelatorsOfPresentation( mG ); 
    invrules := List( invrels, r -> [ r, idfmG ] ); 
    invinvrules := InverseRulesOfPresentation( mG ); 
    len := Length( seq );
    for k in [1..len] do 
        w := ReduceWordKB( seq[k][2], invinvrules ); 
        if ( w = idfmG ) then 
            seq[k] := [ seq[k][1], idfmG ]; 
        else 
            ## replace each negative power with its positive equivalent 
            ew := ShallowCopy( ExtRepOfObj( w ) );
            for i in [1..Length(ew)/2] do 
                j := 2*i; 
                if ( ew[j] < 0 ) then 
                    ew[j-1] := Position( gfmG, invgfmG[ ew[j-1] ] ); 
                    ew[j] := - ew[j]; 
                fi; 
            od;
        fi;
    od; 
    k := 1;
    while ( k < len ) do 
        s1 := seq[k]; 
        s2 := seq[k+1]; 
        if ( s1[1] = - s2[1] ) then 
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

    local  mG, amg, fam, fmG, gfmG, invgfmG, idM, numgenM, logrws, rws, 
           edgesT, words, iwords, pos1, pos2, l, k, u, g, gen, v, pos, 
           ev, lev, i, j, m, P, IP, lenP, T, lenT, lenET;

    mG := MonoidPresentationFpGroup( G ); 
    amg := ArrangementOfMonoidGenerators( G ); 
    fmG := FreeGroupOfPresentation( mG );
    gfmG := GeneratorsOfGroup( fmG );
    invgfmG := InverseGeneratorsOfFpGroup( fmG ); 
    idM := One( fmG );
    numgenM := Length( gfmG );
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
                gen := gfmG[g];  
                v := ReduceWordKB( u*gen, rws ); 
                pos := Position( words, v );
                if ( pos = fail ) then 
                    Add( words, v ); 
                    Add( iwords, InverseWordInFreeGroupOfPresentation(fmG,v) ); 
                    Add( edgesT, [ u, gen ] ); 
                    Add( edgesT, [ v, invgfmG[g] ] ); 
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

##############################################################################
##
#M  PrintLnUsingLabels
#M  PrintUsingLabels
##
InstallMethod( PrintLnUsingLabels, "for words in a monoid presentation", 
    true, [ IsObject, IsList, IsList ], 0, 
function( obj, gens, labs ) 
    IdRelOutputPos := 0; 
    IdRelOutputDepth := 0; 
    PrintUsingLabels( obj, gens, labs ); 
    Print( "\n" ); 
    IdRelOutputPos := 0; 
end );

InstallMethod( PrintUsingLabels, "for words in a monoid presentation", 
    true, [ IsObject, IsList, IsList ], 0, 
function( obj, gens, labs )

    local j, len, wgens, z, num, zlen, coeffs, words; 

    if ( labs = [ ] ) then 
        Print( obj ); 
    else 
        IdRelOutputDepth := IdRelOutputDepth + 1; 
        if IsList( obj ) then 
            if ( IdRelOutputPos > 60 ) then 
                Print( "\n" ); 
                IdRelOutputPos := 0; 
            fi; 
            len := Length( obj ); 
            if ( len = 0 ) then 
                Print( "[ ]" ); 
                IdRelOutputPos := IdRelOutputPos + 3; 
            else 
                Print( "[ " ); 
                IdRelOutputPos := IdRelOutputPos + 2; 
                for j in [1..len] do 
                    PrintUsingLabels( obj[j], gens, labs ); 
                    if ( j < len ) then 
                        Print( ", " ); 
                        IdRelOutputPos := IdRelOutputPos + 2; 
                    fi; 
                od; 
                Print( " ]" ); 
                IdRelOutputPos := IdRelOutputPos + 2; 
            fi; 
        elif IsInt( obj ) then 
            Print( obj ); 
            IdRelOutputPos := IdRelOutputPos + 2; 
        elif IsMonoidPoly( obj ) then 
            len := Length( obj ); 
            coeffs := Coeffs( obj ); 
            words := Words( obj ); 
            for j in [1..len] do 
                Print( coeffs[j], "*" ); 
                PrintUsingLabels( words[j], gens, labs ); 
                if ( j < len ) then Print( " + " ); fi; 
            od; 
        else 
            z := NiceStringAssocWord( obj ); 
            if ( z = "<identity ...>" ) then 
                Print( "id" ); 
                IdRelOutputPos := IdRelOutputPos + 2; 
            else 
                len := Length( gens ); 
                wgens := List( [1..len], j -> NiceStringAssocWord( gens[j]) ); 
                for j in [1..len] do 
                    z := SubstitutionSublist( z, wgens[j], labs[j] ); 
                od; 
                zlen := Length( z ); 
                if ( IdRelOutputPos + zlen > 75 ) then 
                    Print( "\n" ); 
                    IdRelOutputPos := 0; 
                fi; 
                Print( z ); 
                IdRelOutputPos := IdRelOutputPos + Length(z); 
            fi; 
        fi; 
        IdRelOutputDepth := IdRelOutputDepth - 1; 
    fi; 
end ); 

InstallOtherMethod( PrintLnUsingLabels, "for words and relators", 
    true, [ IsObject, IsList, IsList, IsList, IsList ], 0, 
function( obj, gens, labs, Rgens, Rlabs ) 
    PrintUsingLabels( obj, gens, labs, Rgens, Rlabs ); 
    Print( "\n" ); 
end ); 

InstallOtherMethod( PrintUsingLabels, "for words and relators", 
    true, [ IsObject, IsList, IsList, IsList, IsList ], 0, 
function( obj, gens, labs, Rgens, Rlabs )

    local j, len, wgens, z, num, zlen, coeffs, words; 

    IdRelOutputDepth := IdRelOutputDepth + 1; 
    if IsList( obj ) then 
        len := Length( obj ); 
        if ( len = 0 ) then 
            Print( "[ ]" ); 
        else 
            Print( "[ " ); 
            IdRelOutputPos := IdRelOutputPos + 2; 
            for j in [1..len] do 
                PrintUsingLabels( obj[j], gens, labs, Rgens, Rlabs ); 
                if ( j < len ) then 
                    Print( ", " ); 
                    IdRelOutputPos := IdRelOutputPos + 2; 
                fi; 
            od; 
            Print( " ]" ); 
            IdRelOutputPos := IdRelOutputPos + 2; 
        fi; 
    elif IsInt( obj ) then 
        Print( obj ); 
        IdRelOutputPos := IdRelOutputPos + 2; 
    elif IsMonoidPoly( obj ) then 
        len := Length( obj ); 
        coeffs := Coeffs( obj ); 
        words := Words( obj ); 
        for j in [1..len] do 
            Print( coeffs[j], "*" ); 
            PrintUsingLabels( words[j], gens, labs, Rgens, Rlabs ); 
            if ( j < len ) then Print( " + " ); fi; 
        od; 
    else 
        z := NiceStringAssocWord( obj ); 
        if ( z = "<identity ...>" ) then 
            if ( IdRelOutputPos > 60 ) then 
                Print( "\n" ); 
                IdRelOutputPos := 0; 
            fi; 
            Print( "id" ); 
            IdRelOutputPos := IdRelOutputPos + 2; 
        else 
            len := Length( gens ); 
            wgens := List( [1..len], j -> NiceStringAssocWord( gens[j]) ); 
            for j in [1..len] do 
                z := SubstitutionSublist( z, wgens[j], labs[j] ); 
            od; 
            len := Length( Rgens ); 
            wgens := List( [1..len], j -> NiceStringAssocWord( Rgens[j]) );
            for j in [1..len] do 
                z := SubstitutionSublist( z, wgens[j], Rlabs[j] ); 
            od; 
            zlen := Length( z ); 
            if ( IdRelOutputPos + zlen > 75 ) then 
                Print( "\n" ); 
                IdRelOutputPos := 0; 
            fi; 
            Print( z ); 
            IdRelOutputPos := IdRelOutputPos + Length(z); 
        fi; 
    fi; 
    IdRelOutputDepth := IdRelOutputDepth - 1; 
    if ( IdRelOutputDepth = 0 ) then 
        IdRelOutputPos := 0; 
    fi; 
end ); 

#############################################################################
##
#E logrws.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
