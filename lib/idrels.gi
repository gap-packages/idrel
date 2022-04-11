##############################################################################
##
#W  idrels.gi                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Implementation file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2022 Anne Heyworth and Chris Wensley 
##
##  This file contains generic methods for identities among relators 

############################################*##################*##############
##
#M  GroupRelatorSequenceLessThan
##
InstallMethod( GroupRelatorSequenceLessThan, "for two grp rel sequences", 
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
#M  ModuleRelatorSequenceReduce
##
InstallMethod( ModuleRelatorSequenceReduce, "generic method for a Ysequence", 
    true, [ IsList ], 0, 
function( y )

    local  k, leny, w, found;

    leny := Length( y );
    k := 1;
    ## remove consecutive terms when one is the inverse of the other 
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
    ## remove first and last terms when one is the inverse of the other 
    found := true; 
    while found do 
        found := false; 
        if ( ( leny > 1 ) and ( y[1][1] = - y[leny][1] ) 
                          and ( y[1][2] = y[leny][2] ) ) then 
            y := y{[2..leny-1]};
            leny := leny - 2; 
            found := true; 
        fi; 
    od;
    return y;
end );

##############################################################################
##
#M  YSequenceConjugateAndReduce
##
InstallMethod( YSequenceConjugateAndReduce, "generic method for a Ysequence", 
    true, [ IsList, IsHomogeneousList ], 0, 
function( y, rws )

    local  k, leny, w;

    leny := Length( y ); 
    if ( leny > 0 ) then 
        w := y[1][2]^(-1);
        y := List( y, c -> [ c[1], ReduceWordKB( c[2]*w, rws ) ] );
    fi;
    return y;
end );

##############################################################################
##
#M  ConvertToGroupRelatorSequences 
##
##  this operation takes a list of monoid relator sequences mseq for the 
##  group G which involve numbers for the relators and monoid conjugating  
##  words and replaces them with the relators and conjugating words in G 
##  
InstallMethod( ConvertToGroupRelatorSequences, 
    "generic method for an fp-group and a monoid relator sequence", true,  
    [ IsFpGroup, IsHomogeneousList ], 0, 
function( G, mseq )

    local  monG, mu, fmG, gfmG, ngfmG, numgen2, F, genF, idF, freerels, 
           FR, genFR, omega, len, gseq, i, s0, s1, s2, s3, s4, leni, 
           t, t1, rt, wt, z, z1, z2; 

    monG := MonoidPresentationFpGroup( G ); 
    mu := HomomorphismOfPresentation( monG );
    fmG := FreeGroupOfPresentation( monG );
    gfmG := GeneratorsOfGroup( fmG );
    ngfmG := Length( gfmG );
    F := FreeGroupOfFpGroup( G );
    genF := GeneratorsOfGroup( F );
    idF := One( F );
    freerels := RelatorsOfFpGroup( G );
    FR := FreeRelatorGroup( G );
    genFR := GeneratorsOfGroup( FR );
    omega := GroupHomomorphismByImages( FR, F, genFR, freerels );

    len := Length( mseq ); 
    gseq := ListWithIdenticalEntries( len, 0 ); 
    for i in [1..len] do 
        s0 := mseq[i]; 
        s1 := ShallowCopy( s0[2] ); 
        s2 := ShallowCopy( s0[2] );
        leni := Length( s1 ); 
        for t in [1..leni] do 
            t1 := s1[t][1];
            if ( t1 > 0 ) then 
                rt := genFR[ t1 - ngfmG ];
            else 
                rt := genFR[ - t1 - ngfmG ]^-1;
            fi;
            wt := Image( mu, s1[t][2] );
            s2[t] := [ rt, wt ]; 
        od; 
        s3 := ModuleRelatorSequenceReduce( s2 );
        ##  check that this really is an identity 
        leni := Length( s3 );
        if ( leni > 0 ) then 
            s4 := ShallowCopy( s3 );
            for t in [1..Length(s4)] do 
                z := s4[t];
                z1 := Image( omega, z[1] );
                z2 := z[2];
                s4[t] := z1^z2;
            od;
            if not( Product( s4 ) = idF ) then 
                Print( "s0 = ", s0, "\n" ); 
                Print( "s1 = ", s1, "\n" ); 
                Print( "s2 = ", s2, "\n" ); 
                Print( "s3 = ", s3, "\n" ); 
                Print( "s4 = ", s4, "\n" ); 
                Error( "supposed identity fails to reduce to idF" );
            fi;
        fi;
        gseq[i] := [ s0[1], s3 ]; 
    od; 
    return gseq;
end ); 

##############################################################################
##
#M  IdentityRelatorSequences 
##
InstallMethod( IdentityRelatorSequences, "generic method for an fp-group", 
    true, [ IsFpGroup ], 0, 
function( G ) 

    local genG, mG, haslabs, labsG, amg, fmG, gfmG, igfmG, idM, invrels, 
          invrules, ninvrules, grprels, mu, genpos, logrws, rws, F, genF, 
          idF, numgenF, genrangeF, g, k, gfmGpos, freerels, numrel, relrange, 
          FR, genFR, idR, omega, uptolen, words, fam, iwords, numelts, 
          edgesT, mseq, e, elt, rho, numa, ide, r, lenr, edgelist, 
          edge, w, lw, v, posv, inv, lenv, j, numids, rules; 

    genG := GeneratorsOfGroup( G ); 
    mG := MonoidPresentationFpGroup( G ); 
    haslabs := HasMonoidPresentationLabels( mG ); 
    if haslabs then 
        labsG := MonoidPresentationLabels( mG ); 
    fi; 
    amg := ArrangementOfMonoidGenerators( G ); 
    fmG := FreeGroupOfPresentation( mG );
    gfmG := GeneratorsOfGroup( fmG );
    igfmG := InverseGeneratorsOfFpGroup( fmG ); 
    idM := One( fmG );
    invrels := InverseRelatorsOfPresentation( mG );
    invrules := InverseRulesOfPresentation( mG ); 
    ninvrules := Length( invrules ); 
    grprels := GroupRelatorsOfPresentation( mG );
    mu := HomomorphismOfPresentation( mG );
    genpos := MonoidGeneratorsFpGroup( G ); 
    logrws := LoggedRewritingSystemFpGroup( G );
    rws := List( logrws, r -> [ r[1], r[3] ] );
    if ( InfoLevel( InfoIdRel ) >= 2 ) then
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
    gfmGpos := gfmG{ genrangeF };
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

    ##  construct the first few elements in the group 
    uptolen := 2;     ######################  temporary value 
    if ( HasPartialElements( G ) and 
         ( PartialElementsLength( G ) >= uptolen ) ) then 
        words := PartialElements( G ); 
        uptolen := PartialElementsLength( G ); 
    else 
        words := PartialElementsOfMonoidPresentation( G, uptolen ); 
    fi; 
    fam := FamilyObj( words[1] ); 
    iwords := PartialInverseElements( G ); 
    words := List( words, w -> ReduceWordKB( w, invrules ) ); 
    iwords := List( iwords, w -> ReduceWordKB( w, invrules ) ); 
    if ( InfoLevel( InfoIdRel ) > 0 ) then 
        if haslabs then 
            Print( " words = " ); 
            PrintLnUsingLabels( words, gfmG, labsG ); 
            Print( "iwords = " ); 
            PrintLnUsingLabels( iwords, gfmG, labsG ); 
        else 
            Print( "words = ", words, "\niwords = ", iwords, "\n" ); 
        fi; 
    fi; 
    numelts := Length( words ); 
    edgesT := GenerationTree( G ); 
    rules := IdentitySequenceRewriteRules( mG ); 
    mseq := ShallowCopy( PowerIdentities( G ) ); 
    ##  now work through the list of elements, adding each relator in turn 
    e := 1;  ## number of monoid elements processed - no need to process id  
    while ( e < numelts ) do 
        e := e+1; 
        elt := words[e];
        for rho in relrange do 
            numa := (e-1)*numrel + rho;
            ide := [ [ - ( rho + ninvrules ), iwords[e] ] ];
            ### cycle [g,r] (from vertex g and reading r along edges) 
            ### is converted to a list of its component edges:
            ### [source vertex, edge label] (some may be inverse edges) 
            r := grprels[rho];
            lenr := Length( r ); 
            edgelist := ListWithIdenticalEntries( lenr, 0 );
            edgelist[1] := [ elt, Subword(r,1,1) ];
            ### Edges of the cycle which are in the tree are removed, 
            ### and the rest are represented by their position in the 
            ### list of alpha edges.
            for k in [1..lenr] do 
                edge := edgelist[k]; 
                w := Product( edge ); 
                lw := LoggedReduceWordKB( w, logrws ); 
                v := lw[2];  ## the new vertex 
                posv := Position( words, v ); 
                if ( v = w ) then  ## no reduction 
                    if ( posv = fail ) then  ## v=w is not yet in the tree 
                        Add( words, v ); 
                        inv := InverseWordInFreeGroupOfPresentation( fmG, v );
                        Add( iwords, inv ); 
                        Add( edgesT, edge ); 
                        j := Position( gfmG, edge[2] ); 
                        Add( edgesT, [ v, iwords[j] ] );
                    fi; 
                else  ## v<>w, so there is some logging to include in the ide 
                    if ( posv = fail ) then 
                        Add( words, v );
                        inv := InverseWordInFreeGroupOfPresentation( fmG, v );
                        Add( iwords, inv ); 
                        lenv := Length( v );
                        g := Subword( v, lenv, lenv );
                        Add( edgesT, [ Subword( v, 1, lenv-1 ), g ] ); 
                        j := Position( gfmG, g ); 
                        Add( edgesT, [ v, iwords[j] ] );
                    fi;
                    Append( ide, lw[1] );
                fi; 
                if ( k < lenr ) then 
                    edgelist[k+1] := [ v, Subword(r,k+1,k+1) ];
                else 
                    if not ( v = elt ) then 
                        Error( "v <> elt" ); 
                    fi; 
                fi;
            od; 
            #?  why make this change in ide? 
            w := ide[1][2]^(-1); 
            for k in [1..Length(ide)] do 
                ide[k][2] := ReduceWordKB( ide[k][2]*w, invrules ); 
            od; 
            ide := RelatorSequenceReduce( mG, ide ); 
            if ( ide <> [ ] ) then 
                posv := Position( mseq, ide ); 
                if ( posv = fail ) then 
                    Info( InfoIdRel, 2, "[elt,rho] = ", [elt,rho] );
                    Add( mseq, ide ); 
                fi; 
            fi;
        od; 
    od;
    Info( InfoIdRel, 1, "mseq has length: ", Length(mseq) ); 
##    iseq := ReduceGroupRelatorSequences( G, mseq );
##    Info( InfoIdRel, 1, "mseq has length: ", Length(mseq) ); 
##    return iseq; 
    Sort( mseq, GroupRelatorSequenceLessThan );
    return mseq; 
end );


##############################################################################
##
#M  PermuteIdentitySequence 
#M  SwapIdentitySequenceLeft 
#M  SwapIdentitySequenceRight 
#M  SwapIdentitySequence 
##
##  permute the entries in J according to the cycle (p,p+1,...,q) 
##  (conjugating intermediate terms) so as to bring J[q] adjacent to J[p-1] 
##  swap J[p] with J[p+1] 
## 
InstallMethod( SwapIdentitySequenceLeft, 
    "for an fp-group and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt ], 0, 
function( mG, J, p ) 

    local invrules, invnum, gpwords, lenJ, m, x, u, y, i, n, v, w; 

    invrules := InverseRulesOfPresentation( mG ); 
    invnum := Length( invrules ); 
    gpwords := GroupRelatorsOfPresentation( mG ); 
    lenJ := Length( J ); 
    if not (0<p) and (p<lenJ) then 
        Error( "require 0 < p < lenJ" ); 
    fi; 
    n := J[p][1]; 
    v := J[p][2]; 
    if ( n > 0 ) then 
        x := gpwords[n-invnum]^(-1); 
    else 
        x := gpwords[-n-invnum]; 
    fi; 
    u := J[p+1][2]; 
    y := x^v; 
    m := J[p+1][1]; 
    w := ReduceWordKB( u*y, invrules ); 
    return Concatenation( J{[1..p-1]}, [ [m,w], J[p] ], J{[p+2..lenJ]} ); 
end ); 

InstallMethod( SwapIdentitySequenceRight, 
    "for an fp-group and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt ], 0, 
function( mG, J, p ) 

    local invrules, invnum, gpwords, lenJ, m, x, u, y, i, n, v, w; 

    invrules := InverseRulesOfPresentation( mG ); 
    invnum := Length( invrules ); 
    gpwords := GroupRelatorsOfPresentation( mG ); 
    lenJ := Length( J ); 
    if not (0<p) and (p<lenJ) then 
        Error( "require 0 < p < lenJ" ); 
    fi; 
    m := J[p+1][1]; 
    u := J[p+1][2]; 
    if ( m > 0 ) then 
        x := gpwords[m-invnum]; 
    else 
        x := gpwords[-m-invnum]^(-1); 
    fi; 
    y := x^u; 
    n := J[p][1]; 
    v := J[p][2]; 
    w := ReduceWordKB( v*y, invrules ); 
    return Concatenation( J{[1..p-1]}, [ J[p+1], [n,w] ], J{[p+2..lenJ]} ); 
end ); 

InstallMethod( SwapIdentitySequence, 
    "for an fp-group and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt ], 0, 
function( mG, J, p ) 

    local lt, rt, L; 

    lt := SwapIdentitySequenceLeft( mG, J, p ); 
    rt := SwapIdentitySequenceRight( mG, J, p ); 
    L := [ lt, rt ]; 
    Sort( L, GroupRelatorSequenceLessThan ); 
    return L[1]; 
end ); 

InstallMethod( PermuteIdentitySequence, 
    "for an fp-group and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt, IsPosInt ], 0, 
function( mG, J, p, q ) 

    local invrules, invnum, gpwords, lenJ, m, x, u, y, K, i, n, v, w; 

    invrules := InverseRulesOfPresentation( mG ); 
    invnum := Length( invrules ); 
    gpwords := GroupRelatorsOfPresentation( mG ); 
    lenJ := Length( J ); 
    if not (0<p) and (p<q) and (q<=lenJ) then 
        Error( "require 0 < p < q <= lenJ" ); 
    fi; 
    m := J[q][1]; 
    if ( m > 0 ) then 
        x := gpwords[m-invnum]; 
    else 
        x := gpwords[-m-invnum]^(-1); 
    fi; 
    u := J[q][2]; 
    y := x^u; 
    K := J{[p..q-1]}; 
    for i in [1..q-p] do 
        n := K[i][1]; 
        v := K[i][2]; 
        w := ReduceWordKB( v*y, invrules ); 
        K[i] := [ n, w ]; 
    od; 
    return Concatenation( J{[1..p-1]}, [ J[q] ], K, J{[q+1..lenJ]} ); 
end ); 

##############################################################################
##
#M  AreEquivalentIdentities 
## 
InstallMethod( AreEquivalentIdentities, 
    "for an fp-group and a two lists of relator sequences", true, 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList ], 0, 
function( G, L1, L2 ) 

    local mG, fmG, gfmG, Glabs, J1, J2, rules, len, R1, R2, found, 
          i, j, p1, k, p2, K1, K2; 

    mG := MonoidPresentationFpGroup( G );
    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    Glabs := MonoidPresentationLabels( G ); 
    rules := IdentitySequenceRewriteRules( mG ); 
    J1 := ShallowCopy( L1 ); 
    J2 := ShallowCopy( L2 ); 
    if ( J1 = J2 ) then 
        return true; 
    fi; 
    len := Length( J1 ); 
    if not ( Length( J2 ) = len ) then 
        return false; 
    fi; 
    R1 := Set( List( J1, p -> p[1] ) ); 
    R2 := Set( List( J2, p -> p[1] ) ); 
    if not ( R1 = R2 ) then 
        return false; 
    fi; 
    found := false; 
    i := 0; 
    while ( ( J1[i+1] = J2[i+1] ) and ( i < len ) ) do
        i := i+1; 
    od; 
    while ( i<len ) do 
        i := i+1; 
        j := i-1; 
        while ( ( not found ) and ( j < len ) ) do 
             j := j+1; 
             p1 := J1[j]; 
             k := i-1; 
             while ( ( not found ) and ( k < len ) ) do 
                 k := k+1; 
                 p2 := J2[k]; 
                 if ( p1 = p2 ) then 
                     K1 := PermuteIdentitySequence( mG, J1, i, j ); 
                     J1 := OnePassReduceSequence( [K1], rules )[1]; 
                     K2 := PermuteIdentitySequence( mG, J2, i, k ); 
                     J2 := OnePassReduceSequence( [K2], rules )[1]; 
                     if ( InfoLevel( InfoIdRel ) > 1 ) then 
                         Print( "revised J1 and J2:\n" ); 
                         PrintLnUsingLabels( J1, gfmG, Glabs ); 
                         PrintLnUsingLabels( J2, gfmG, Glabs ); 
                     fi; 
                     found := true; 
                     if ( J1 = J2 ) then 
                         return true; 
                     fi; 
                fi; 
            od; 
        od; 
        found := false; 
    od; 
    return ( J1 = J2 ); 
end ); 

##############################################################################
##
#M  IdentitySequenceRewriteRules
##
InstallMethod( IdentitySequenceRewriteRules, 
    "for an fp-group and a list of Ysequences", true, 
    [ IsMonoidPresentationFpGroup ], 0, 
function( mG ) 

    local G, fmG, gfmG, id, invrules, len, gprels, numrels, rewrites, powers, 
          i, rel, erel, g, k, m, idi, w, v, rule, p; 

    G := UnderlyingGroupOfPresentation( mG ); 
    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    id := One( fmG );  
    invrules := InverseRulesOfPresentation( mG ); 
    len := Length( InverseRulesOfPresentation( mG ) ); 
    gprels := GroupRelatorsOfPresentation( mG ); 
    numrels := Length( gprels ); 
    rewrites := [ ]; 
    powers := [ ]; 
    for i in [1..numrels] do 
        rel := gprels[i]; 
        erel := ExtRepOfObj( rel ); 
        if ( Length( erel ) = 2 ) then 
            ##  the relation is a power g^k 
            #?  need to deal with relators such as (ab)^2 later!! 
            g := gfmG[ erel[1] ]; 
            k := erel[2]; 
            m := i + len; 
            idi := [ [ -m, id], [ m, g ] ]; 
            Add( powers, idi ); 
Info( InfoIdRel, 1, "idi ", i, " = ", idi ); 
            w := g; 
            v := ReduceWordKB( w^-1, invrules ); 
            rule := [ [ m, w ], [ m, id ] ]; 
            p := Position( rewrites, rule ); 
            if ( p = fail ) then 
                Add( rewrites, rule ); 
            fi; 
            rule := [ [ -m, w ], [ -m, id ] ]; 
            p := Position( rewrites, rule ); 
            if ( p = fail ) then 
                Add( rewrites, rule ); 
            fi; 
            rule := [ [ m, v ], [ m, id ] ]; 
            p := Position( rewrites, rule ); 
            if ( p = fail ) then 
                Add( rewrites, rule ); 
            fi; 
            rule := [ [ -m, v ], [ -m, id ] ]; 
            p := Position( rewrites, rule ); 
            if ( p = fail ) then 
                Add( rewrites, rule ); 
            fi; 
        fi; 
    od; 
Info( InfoIdRel, 1, "number of rewrites found = ", Length( rewrites ) ); 
    SetPowerIdentities( G, powers ); 
    return rewrites; 
end ); 

##############################################################################
##
#M  OnePassReduceSequence
##
InstallMethod( OnePassReduceSequence, 
    "for an ixdentity and a list of sequence rewrite rules", true, 
    [ IsHomogeneousList, IsHomogeneousList ], 0, 
function( J, rules ) 

    local idi, leni, j, u, m, w, lenw, found, rule, x, lenx; 

    ## apply rewrite rules to the sequence J 
    idi := ShallowCopy( J ); 
    leni := Length( idi ); 
    for j in [1..leni] do 
        u := idi[j]; 
        m := u[1]; 
        w := u[2]; 
        lenw := Length( w ); 
        found := true; 
        while found do 
            found := false; 
            for rule in rules do 
                if ( rule[1][1] = m ) then 
                    x := rule[1][2]; 
                    lenx := Length( x ); 
                    if ( ( lenx <= lenw ) and 
                         ( Subword( w, 1, lenx ) = x ) ) then 
                        w := Subword( w, lenx+1, lenw ); 
                        lenw := Length( w ); 
                        idi[j] := [ m, w ]; 
                        Info( InfoIdRel, 2, "u -> v where u = ", 
                              u, " and v = ", [m,w] ); 
                        found := true; 
                    fi; 
                fi; 
            od; 
        od; 
    od;
    return idi; 
end ); 

##############################################################################
##
#M  ReduceGroupRelatorSequences 
##
InstallMethod( ReduceGroupRelatorSequences, 
    "for an fp-group and a list of Ysequences", true, 
    [ IsFpGroup, IsHomogeneousList ], 0, 
function( G, L ) 

    local startwithid, cancelinverses, findconjugates, removeempties, info, 
          mG, fmG, gfmG, id, arr, invrules, invnum, gpwords, Glabs, powers, 
          idrules, L1, L2, L3, L4, lenL, rules, numrules, 
          i, j, k, idj, idk; 

    startwithid := function( K ) 
    ## make sure each identity starts with [\rho,id] 
        local J, lenJ, k, idk, lenk, w, cidk, j, v; 
        J := ShallowCopy( K );
        lenJ := Length( J ); 
        for k in [1..lenJ] do 
            idk := ShallowCopy( J[k] ); 
            lenk := Length( idk ); 
            w := idk[1][2]; 
            if ( w <> id ) then 
                w := ReduceWordKB( w^-1, invrules ); 
                cidk := ListWithIdenticalEntries( lenk, 0 ); 
                for j in [1..lenk] do 
                    v := ReduceWordKB( idk[j][2]*w, invrules );
                    cidk[j] := [ idk[j][1], v ]; 
                od; 
                J[k] := cidk; 
            fi; 
        od; 
        if ( Length( J ) <> Length( idrules ) ) then 
            Error( "unequal lengths for Sort" ); 
        fi; 
        SortParallel( J, idrules, GroupRelatorSequenceLessThan );
        return J; 
    end; 

    cancelinverses := function( K ) 
        local lenK, H, changed, i, idi, leni, ichanged, j, t, k, u, cidi; 

        lenK := Length( K ); 
        changed := false; 
        H := ListWithIdenticalEntries( lenK, 0 ); 
        for i in [1..lenK] do 
            idi := K[i]; 
            leni := Length( idi ); 
            ## now check for occurrences of: [-p,w] ... [p,w] 
            ichanged := true; 
            while ichanged and ( idi <> [ ] ) do 
                ichanged := false; 
                j := 0;
                while ( j < leni-1 ) do 
                    j := j+1; 
                    t := idi[j]; 
                    k := 0; 
                    while ( k < leni ) do 
                        k := k+1; 
                        u := idi[k]; 
                        if ( ( t[1] = -u[1] ) and ( t[2] = u[2] ) ) then 
                            cidi := PermuteIdentitySequence( mG, idi, j+1, k ); 
                            idi := Concatenation( cidi{[1..j-1]}, 
                                                  cidi{[j+2..leni]} ); 
                            leni := leni - 2; 
                            changed := true; 
                            ichanged := true; 
                        fi; 
                    od; 
                od; 
            H[i] := idi; 
            od; 
        od; 
        if changed then 
            Info( InfoIdRel, 2, "changes made by cancelinverses" ); 
        fi; 
        return H; 
    end; 

    findconjugates := function( J ) 
    ## search for conjugate of one identity lying within another 
    local K, lenK, i, idi, leni, rho, j, idj, lenj, k, w, c, ok; 
        K := ShallowCopy( J ); 
        lenK := Length( K );
        for i in [1..lenK] do 
            idi := K[i]; 
            leni := Length( idi );
            if ( leni > 0 ) then
                rho := idi[1][1];
                for j in [i+1..lenK] do 
                    idj := K[j];
                    lenj := Length( idj );
                    k := 1;
                    while ( k <= (lenj-leni+1) ) do 
                        if ( idj[k][1] = rho ) then 
                            w := idj[k][2]; 
                            c := 1;
                            ok := true;
                            while ( ok and ( c < leni ) ) do
                                c := c+1;
                                if ([idi[c][1],idi[c][2]*w]<>idj[k+c-1]) then 
                                     ok := false;
                                fi; 
                            od;
                            if ok then 
                                idj := Concatenation( idj{[1..k-1]}, 
                                                      idj{[(k+leni)..lenj]} );
                                K[j] := idj; 
                                Info( InfoIdRel, 2, "reduction (1) at [i,j] = ", 
                                      [i,j], ", L4[j] = ", idj );
                                lenj := lenj - leni;
                                k := k-1;
                            fi;
                        fi;
                        k := k+1;
                    od;
                od; 
                idi := Reversed( List( idi, c -> [ - c[1], c[2] ] ) ); 
                w := ReduceWordKB( idi[1][2]^(-1), invrules ); 
                for j in [1..Length(idi)] do 
                    idi[j][2] := ReduceWordKB( idi[j][2]*w, invrules ); 
                od; 
                rho := idi[1][1];
                for j in [i+1..lenK] do 
                    idj := K[j];
                    lenj := Length( idj );
                    k := 1;
                    while ( k <= (lenj-leni+1) ) do 
                        if ( idj[k][1] = rho ) then 
                            w := idj[k][2];
                            c := 1;
                            ok := true;
                            while ( ok and ( c < leni ) ) do
                                c := c+1;
                                if ([idi[c][1],idi[c][2]*w]<>idj[k+c-1]) then 
                                     ok := false;
                                fi; 
                            od;
                            if ok then 
                                idj := Concatenation( idj{[1..k-1]}, 
                                                      idj{[(k+leni)..lenj]} );
                                K[j] := idj;
                                Info( InfoIdRel, 2, "reduction (2) at [i,j] = ", 
                                      [i,j], ", L4[j] = ", idj );
                                lenj := lenj - leni;
                                k := k-1;
                            fi;
                        fi;
                        k := k+1;
                    od;
                od; 
            fi; 
        od; 
        return K; 
    end; 

    removeempties := function( J ) 
    ## remove all [ ]'s from J and adjust idrules at the same time 
        local lenJ, M, N, K, i, lenK; 
        lenJ := Length( J ); 
        M := List( J, L -> L = [ ] ); 
        N := [ ]; 
        for i in [1..lenJ] do 
            if not M[i] then 
                Add( N, i ); 
            fi; 
        od; 
        idrules := idrules{ N }; 
        K := Filtered( J, L -> L <> [ ] ); 
        lenK := Length( K ); 
        if ( lenJ <> lenK ) then 
            Info( InfoIdRel, 2, "in removeempties length reduced from ", 
                  lenJ, " to ", lenK ); 
        fi; 
        return K; 
    end; 

    ##################################################################### 
    ## function proper starts here 
    info := InfoLevel( InfoIdRel ); 
    mG := MonoidPresentationFpGroup( G ); 
    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    ## id := One( fmG ); 
    id := One( FamilyObj( L[1][1][2] ) ); 
    arr := ArrangementOfMonoidGenerators( G ); 
    invrules := InverseRulesOfPresentation( mG ); 
    invnum := Length( invrules ); 
    gpwords := GroupRelatorsOfPresentation( mG ); 
    if not HasMonoidPresentationLabels( mG ) then 
        Glabs := [ ];  
    else 
        Glabs := MonoidPresentationLabels( mG ); 
    fi; 
    idrules := ListWithIdenticalEntries( Length(L), 0 ); 
    L4 := startwithid( L ); 
    lenL := Length( L4 ); 
    if ( info > 1 ) then 
        Print( "in ReduceGroupRelatorSequences\n" ); 
        Print( "\n***** Glabs = ", Glabs, "  *****\n\n" ); 
        Print( "after sorting L4 has length ", lenL, "\n" );
        Print( List( L4, L -> Length(L) ), "\n" ); 
        PrintLnUsingLabels( L4, gfmG, Glabs ); 
        Print( "\ndetermining the rewrite rules\n" ); 
    fi; 
    rules := IdentitySequenceRewriteRules ( mG ); 
    powers := PowerIdentities( G ); 
if Length(rules)=0 then Error("here"); fi; 
    numrules := Length( rules ); 
    if ( info > 1 ) then 
        Print( "there are ", Length(rules), " rewrite rules:\n" ); 
        PrintLnUsingLabels( rules, gfmG, Glabs ); 
    fi;
    L1 := [ ]; 
    while ( L1 <> L4 ) do 
        L1 := ShallowCopy ( L4 ); 
        Info( InfoIdRel, 2, "running cancelinverses:"); 
        L3 := cancelinverses( L4 ); 
        if ( info > 1 ) then 
            Print( "L3 has length ", Length(L3), " :-\n" ); 
            Print( List( L3, L -> Length(L) ), "\n" ); 
            PrintLnUsingLabels( L3, gfmG, Glabs ); 
            Print( "running removeempties:\n" ); 
        fi; 
        L2 := removeempties( L3 ); 
        if ( info > 1 ) then 
            Print( "L2 has length ", Length(L2), " :-\n" ); 
            Print( List( L2, L -> Length(L) ), "\n" ); 
            PrintLnUsingLabels( L2, gfmG, Glabs ); 
            ## Print( "idrules = ", idrules, "\n" ); 
            Print( "running findconjugates:\n" ); 
        fi; 
        L3 := findconjugates( L2 ); 
        if ( info > 1 ) then 
            Print( "L3 has length ", Length(L3), " :-\n" ); 
            Print( List( L3, L -> Length(L) ), "\n" ); 
            PrintLnUsingLabels( L3, gfmG, Glabs ); 
            Print( "running removeempties:\n" ); 
        fi; 
        L2 := removeempties( L3 ); 
        if ( info > 1 ) then 
            Print( "L2 has length ", Length(L2), " :-\n" ); 
            Print( List( L2, L -> Length(L) ), "\n" ); 
            PrintLnUsingLabels( L2, gfmG, Glabs ); 
            Print( "running startwithid:\n" ); 
        fi; 
        L3 := startwithid( L2 ); 
        if ( info > 1 ) then 
            Print( "L3 has length ", Length(L3), " :-\n" );
            PrintLnUsingLabels( L3, gfmG, Glabs ); 
            Print( "running OnePassreduceSequence:\n" ); 
        fi; 
        lenL := Length( L3 ); 
        for j in [1..lenL] do 
            idj := L3[j]; 
            if not ( idj in powers ) then 
                L3[j] := OnePassReduceSequence( idj, rules ); 
            fi; 
        od; 
        L4 := ShallowCopy( L3 ); 
        if ( info > 1 ) then 
            Print( "L4 has length ", Length(L4), " :-\n" ); 
            Print( List( L4, L -> Length(L) ), "\n" ); 
            PrintLnUsingLabels( L4, gfmG, Glabs ); 
        fi; 
    od; 
    Sort( L4, GroupRelatorSequenceLessThan ); 
    ## now test for equivalence  
    lenL := Length( L4 ); 
    i := 1; 
    while ( ( Length( L4[i] ) = 2 ) and ( i <= lenL ) ) do 
        i := i+1; 
    od; 
    for j in [i..lenL] do 
        idj := L4[j]; 
        if ( idj <> [ ] ) then 
            for k in [j+1..lenL] do 
                idk := L4[k]; 
                if ( idk <> [ ] ) then 
                    if AreEquivalentIdentities( G, idj, idk ) then 
                        L4[k] := [ ]; 
                    fi; 
                fi; 
            od; 
        fi; 
    od;
Print( "adjusted L4 = \n" ); 
Print( List( L4, L -> Length(L) ), "\n" ); 
PrintLnUsingLabels( L4, gfmG, Glabs );
    return removeempties( L4 ); 
end );

#############################################################################
##
#M  ConvertToYSequences( <G> )
##
InstallMethod( ConvertToYSequences, "for an fp-group and group relator seq", 
    true, [ IsFpGroup, IsFreeGroup, IsHomogeneousList ], 0, 
function( G, FY, iseq ) 

    local mG, elmon, oneM, gprels, invrules, numinv, frgp, frgens, fmG, FMfam, 
          hom, L, FYgens, lrws, rws, numids, gseq, polys, k, j, pos, ident, 
          leni, irange, gp, npols, i, i0, i1, w, hw, len, rp, nyp, yp, lp, 
          lbest; 

    mG := MonoidPresentationFpGroup( G );
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
    gprels := GroupRelatorsOfPresentation( mG ); 
    invrules := InverseRulesOfPresentation( mG ); 
    numinv := Length( invrules ); 
    frgp := FreeRelatorGroup( G );
    frgens := GeneratorsOfGroup( frgp );
    fmG := FreeGroupOfPresentation( mG );
    FMfam := ElementsFamily( FamilyObj( fmG ) );
    lrws := LoggedRewritingSystemFpGroup( G );
    rws := List( lrws, r -> [ r[1], r[3] ] ); 
    hom := HomomorphismOfPresentation( mG ); 
    L := ArrangementOfMonoidGenerators( G );
    FYgens := GeneratorsOfGroup( FY );
    numids := Length( iseq ); 
    gseq := List( [1..numids], i -> [ i, iseq[i] ] ); 
    polys := [ ];
    k := 0;
    for j in [1..numids] do 
        Info( InfoIdRel, 2, "===============  j = ", j, "  ===============" ); 
        pos := gseq[j][1]; 
        ident := gseq[j][2];
        Info( InfoIdRel, 2, "gseq[j] = ", gseq[j] );
        leni := Length( ident );
        if ( leni > 0 ) then
            k := k+1;
            Info( InfoIdRel, 2, "k = ", k );
            irange := [1..leni];
            gp := ListWithIdenticalEntries( leni, 0 );
            npols := ListWithIdenticalEntries( leni, 0 );
            for i in irange do 
                i1 := ident[i][1];
                if ( i1 < 0 ) then 
                    i0 := i1 + numinv; 
                else 
                    i0 := i1 - numinv; 
                fi; 
                w := ImageElm( hom, ident[i][2] ); 
                w := MonoidWordFpWord( w, FMfam, L );
                w := ReduceWordKB( w, rws );
                if ( i0 > 0 ) then
                    gp[i] := frgens[i0];
                    npols[i] := MonoidPolyFromCoeffsWords( [+1], [w] );
                else
                    gp[i] := frgens[-i0]^(-1);
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
#M  ReduceModulePolyList( <L> )
##
InstallMethod( ReduceModulePolyList, "for a list of identities", true, 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList, IsHomogeneousList ], 0, 
function( G, elmon, rws, modpols )

    local  irrepols, irrerems, sats, irrenum, m1, m0, i, lp, rp, leadgp, yp, 
           logrem, remyp, remrp, rem, remsat, m, r;

    irrepols := [ ];
    irrerems:= [ ];
    sats := [ ];
    irrenum := 0;
    m1 := RelatorModulePoly( modpols[1] );
    m0 := m1 - m1;
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
            rem := LoggedReduceModulePoly( rp, rws, sats, m0 );
            remyp := yp + YSequenceModulePoly( rem );
            remrp := RelatorModulePoly( rem );
            logrem := LoggedModulePoly( remyp, remrp );
        fi;
        if ( remrp = m0 ) then 
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
    return [ irrepols, irrerems, irrenum, sats ];
end );

#############################################################################
##
#M  IdentitiesAmongRelators( <G> )
##
InstallMethod( IdentitiesAmongRelators, "for an fp-group", true, 
    [ IsFpGroup ], 0, 
function( G )

    local L, mG, elmon, rws, F, FR, genFR, fmG, FMgens, FY, FYgens, 
          gseq, modpols, redpols, irrepols, irrerems, irrenum, sats, 
          r, ids, pol, ymp, gymp, pos, seq, iseq;

    if HasArrangementOfMonoidGenerators( G ) then 
        L := ArrangementOfMonoidGenerators( G ); 
    else 
        L := ArrangeMonoidGenerators( G ); 
    fi;
    mG := MonoidPresentationFpGroup( G );
    if HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    else  
        elmon := ElementsOfMonoidPresentation( G ); 
    fi; 
    rws := List( LoggedRewritingSystemFpGroup( G ), r -> [ r[1], r[3] ] );
    F := FreeGroupOfFpGroup( G );
    FR := FreeGroupOfPresentation( mG );
    genFR := GeneratorsOfGroup( FR );
    fmG := FreeGroupOfPresentation( mG );
    FMgens := GeneratorsOfGroup( fmG );
    gseq := IdentityRelatorSequences( G ); 
    iseq := ReduceGroupRelatorSequences( G, gseq );
    Info( InfoIdRel, 1, "iseq has length: ", Length(iseq) ); 

    FY := FreeYSequenceGroup( G );
    FYgens := GeneratorsOfGroup( FY ); 
    modpols := ConvertToYSequences( G, FY, iseq );
    redpols := ReduceModulePolyList( G, elmon, rws, modpols );
    irrepols := redpols[1]; 
    irrerems := redpols[2]; 
    irrenum := redpols[3]; 
    sats := redpols[4]; 
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
    SetIdentityYSequences( G, irrepols ); 
    ## now pick out the relator sequences corresponding to these polys 
    ids := ListWithIdenticalEntries( irrenum, 0 ); 
    for r in [1..irrenum] do 
        pol := irrepols[r]; 
        ymp := YSequenceModulePoly( pol ); 
        gymp := GeneratorsOfModulePoly( ymp )[1]; 
        pos := Position( FYgens, gymp );
        seq := iseq[pos]; 
        ids[r] := seq[3]; 
    od; 
    #? return [ irrepols, irrerems ]; 
    return ids; 
end );

#############################################################################
##
#M  RootIdentities( <G> )
##
InstallMethod( RootIdentities, "for an FpGroup", true, [ IsFpGroup ], 0, 
function( G )

    local  ids, len, roots, i, idi, leni;

    ids := IdentityRelatorSequences( G ); 
    len := Length( ids ); 
    roots := [ ]; 
    for i in [1..len] do 
        idi := ids[i]; 
        leni := Length( idi ); 
        if ( ( leni = 2 ) and ( idi[1][1] = - idi[2][1] ) ) then 
            Add( roots, idi ); 
        fi; 
    od;
    return roots;
end );

###############*#############################################################
##
#E idrels.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
