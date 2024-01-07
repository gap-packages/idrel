##############################################################################
##
#W  idrels.gi                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Implementation file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2024 Anne Heyworth and Chris Wensley 
##
##  This file contains generic methods for identities among relators 

############################################*##################*##############
##
#M  LogSequenceLessThan
##
InstallMethod( LogSequenceLessThan, "for two grp rel sequences", 
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

    local genG, mG, haslabs, Glabs, amg, fmG, gfmG, id, igfmG, invrels, 
          invrules, ninvrules, grprels, mu, genpos, logrws, rws, F, genF, 
          idF, numgenF, genrangeF, g, k, gfmGpos, freerels, numrel, relrange, 
          FR, genFR, idR, omega, uptolen, words, fam, iwords, numelts, 
          edgesT, mseq, e, elt, rho, numa, ide, r, lenr, edgelist, 
          edge, w, lw, v, posv, inv, lenv, j, numids, rules; 

    genG := GeneratorsOfGroup( G ); 
    mG := MonoidPresentationFpGroup( G ); 
    haslabs := HasMonoidPresentationLabels( mG ); 
    if haslabs then 
        Glabs := MonoidPresentationLabels( mG ); 
    else 
        Glabs := [ ];
    fi; 
    amg := ArrangementOfMonoidGenerators( G ); 
    fmG := FreeGroupOfPresentation( mG );
    gfmG := GeneratorsOfGroup( fmG );
    igfmG := InverseGeneratorsOfFpGroup( fmG ); 
    id := One( fmG );
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
            PrintLnUsingLabels( words, gfmG, Glabs ); 
            Print( "iwords = " ); 
            PrintLnUsingLabels( iwords, gfmG, Glabs ); 
        else 
            Print( "words = ", words, "\niwords = ", iwords, "\n" ); 
        fi; 
    fi; 
    numelts := Length( words ); 
    edgesT := GenerationTree( G ); 
    rules := LogSequenceRewriteRules( mG ); 
    mseq := ShallowCopy( RootIdentities( G ) ); 
    ##  now work through the list of elements, adding each relator in turn 
    e := 1;  ## number of monoid elements processed - no need to process id  
    while ( e < numelts ) do 
        e := e+1; 
        elt := words[e];
        for rho in relrange do 
            numa := (e-1)*numrel + rho;
            ide := [ ]; 
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
            Add( ide, [ - rho, iwords[e] ] ); 
            for k in [1..Length(ide)] do 
                ide[k][2] := ReduceWordKB( ide[k][2], invrules ); 
            od; 
            ide := LogSequenceReduce( mG, ide ); 
            Assert( 0, ExpandLogSequence( mG, ide ) = id );
            if ( ide <> [ ] ) then 
                posv := Position( mseq, ide ); 
                if ( posv = fail ) then 
                    Info( InfoIdRel, 2, "[elt,rho,ide] = ", [elt,rho,ide] );
                    Add( mseq, ide ); 
                fi; 
            fi;
        od; 
    od;
    Info( InfoIdRel, 1, "mseq has length: ", Length(mseq) ); 
    Sort( mseq, LogSequenceLessThan );
    return mseq; 
end );

##############################################################################
##
#M  ExpandLogSequence 
#M  MoveLeftLogSequence 
#M  MoveRightLogSequence 
#M  SwapLogSequence 
##
##  permute the entries in J according to the cycle (p,p+1,...,q) 
##  (conjugating intermediate terms) so as to bring J[q] adjacent to J[p-1] 
##  swap J[p] with J[p+1] 
## 
InstallMethod( ExpandLogSequence, 
    "for an fp-group presentation and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, J ) 

    local fmG, gfmG, invrels, ninvrels, invrules, ninvrules, gprels, 
          len, id, w, i, m, u, r; 

    fmG := FreeGroupOfPresentation( mG );
    gfmG := GeneratorsOfGroup( fmG );
    invrels := InverseRelatorsOfPresentation( mG ); 
    ninvrels := Length( invrels ); 
    invrules := InverseRulesOfPresentation( mG ); 
    ninvrules := Length( invrules ); 
    gprels := GroupRelatorsOfPresentation( mG ); 
    len := Length( J ); 
    id := One( fmG ); 
    w := id; 
    for i in [1..len] do 
        m := J[i][1]; 
        u := J[i][2]; 
        if ( m > 0 ) then 
            r := gprels[m];
        else 
            r := gprels[-m]^-1; 
        fi; 
        w := w * u^-1 * r * u; 
        w := ReduceWordKB( w, invrules ); 
    od;
    return w; 
end ); 

InstallMethod( MoveLeftLogSequence, 
    "for an fp-group presentation and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsList, IsPosInt ], 0, 
function( mG, S, L, q ) 

    local J, invrules, invnum, gpwords, lenJ, lenL, p, r, 
          Y, m, x, u, y, K, i, n, v, w, H, rules; 

    J := ShallowCopy( S );
    invrules := InverseRulesOfPresentation( mG ); 
    invnum := Length( invrules ); 
    gpwords := GroupRelatorsOfPresentation( mG ); 
    lenJ := Length( J ); 
    if not IsRange( L ) then 
        Error( "L is not a range" ); 
    fi;
    lenL := Length( L ); 
    p := L[1]; 
    r := L[lenL]; 
    if not ( L = [p..r] ) then 
        Error( "incorrect range" ); 
    fi; 
    if not (0<q) and (q<p) and (r<=lenJ) then 
        Error( "require 0 < q < p < r <= lenJ" ); 
    fi; 
    Y := [p..r]; 
    for i in [p..r] do 
        u := ConjugatingWordOfLoggedTerm( mG, J[i] ); 
        Y[i-p+1] := ReduceWordKB( u, invrules ); 
    od; 
    y := Product( Y ); 
    y := ReduceWordKB( y, invrules ); 
    K := J{[q..p-1]}; 
    for i in [1..p-q] do 
        n := K[i][1]; 
        v := K[i][2]; 
        w := ReduceWordKB( v*y, invrules ); 
        K[i] := [ n, w ]; 
    od; 
    H := Concatenation( J{[1..q-1]}, J{[p..r]}, K, J{[r+1..lenJ]} ); 
    rules := LogSequenceRewriteRules( mG ); 
    return OnePassReduceLogSequence( H, rules ); 
end ); 

InstallMethod( MoveRightLogSequence, 
    "for an fp-group presentation and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsList, IsPosInt ], 0, 
function( mG, S, L, q ) 

    local J, invrules, invnum, gpwords, lenJ, lenL, p, r, 
          Y, m, x, u, y, K, i, n, v, w, H, rules; 

    J := ShallowCopy( S ); 
    invrules := InverseRulesOfPresentation( mG ); 
    invnum := Length( invrules ); 
    gpwords := GroupRelatorsOfPresentation( mG ); 
    lenJ := Length( J ); 
    if not IsRange( L ) then 
        Error( "L is not a range" ); 
    fi;
    lenL := Length( L ); 
    p := L[1]; 
    r := L[lenL]; 
    if not ( L = [p..r] ) then 
        Error( "incorrect range" ); 
    fi; 
    if not (0<p) and (p<q) and (q+r-p <= lenJ) then 
        Error( "require 0 < p < q and q+r-p <= lenJ" ); 
    fi; 
    Y := [p..r]; 
    for i in [p..r] do 
        u := ConjugatingWordOfLoggedTerm( mG, J[i] ); 
        Y[i-p+1] := ReduceWordKB( u^-1, invrules ); 
    od; 
    y := Product( Y ); 
    y := ReduceWordKB( y, invrules ); 
    K := J{[r+1..q]}; 
    for i in [1..q-r] do 
        n := K[i][1]; 
        v := K[i][2]; 
        w := ReduceWordKB( v*y, invrules ); 
        K[i] := [ n, w ]; 
    od; 
    H := Concatenation( J{[1..p-1]}, K, J{[p..r]}, J{[q+1..lenJ]} ); 
    rules := LogSequenceRewriteRules( mG ); 
    return OnePassReduceLogSequence( H, rules ); 
end ); 

InstallMethod( SwapLogSequence, 
    "for an fp-group presentation and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt, IsPosInt ], 0, 
function( mG, S, p, q ) 

    local J, lenJ, lt, rt, L; 

    J := ShallowCopy( S ); 
    lenJ := Length( J ); 
    if not (0<p) and (p<q) and (q <= lenJ) then 
        Error( "require 1 <= p < q <= lenJ" ); 
    fi; 
    L := MoveRightLogSequence( mG, J, [p], q ); 
    if ( q-p > 1 ) then 
        L := MoveLeftLogSequence( mG, L, [q-1], p ); 
    fi; 
    return L; 
end ); 

##############################################################################
##
#M  ConjugateByWordLogSequence
##
InstallMethod( ConjugateByWordLogSequence, 
    "for an fp-group presentation, an identity sequence, and a word", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsWord ], 0, 
function( mG, J, w ) 

    local invrules, idrules, K, lenK, c, k, j, v; 
    
    invrules := InverseRulesOfPresentation( mG ); 
    idrules := LogSequenceRewriteRules( mG );
    K := ShallowCopy( J );
    lenK := Length( K ); 
    for j in [1..lenK] do 
        c := ShallowCopy( K[j] ); 
        v := ReduceWordKB( c[2]*w, invrules );
        K[j] := [ c[1], v ]; 
    od; 
    return OnePassReduceLogSequence( K, idrules ); 
end ); 

InstallMethod( FixFirstTermLogSequence, 
    "for an fp-group presentation and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, J ) 

    ## make sure each identity starts with [\rho,id] 

    local  fmG, id, invrules, idrules, G, roots, lenJ, w, H, j, v, c; 

    fmG := FreeGroupOfPresentation( mG ); 
    id := One( fmG ); 
    invrules := InverseRulesOfPresentation( mG ); 
    idrules := LogSequenceRewriteRules( mG );
    G := UnderlyingGroupOfPresentation( mG ); 
    roots := RootIdentities( G ); 
    lenJ := Length( J ); 
    w := J[1][2]; 
    H := ListWithIdenticalEntries( lenJ, 0 ); 
    if ( w <> id ) then 
        w := ReduceWordKB( w^-1, invrules ); 
        for j in [1..lenJ] do 
            v := ReduceWordKB( J[j][2]*w, invrules );
            H[j] := [ J[j][1], v ]; 
        od; 
    fi; 
    return OnePassReduceLogSequence( H, idrules ); 
end ); 

InstallMethod( ChangeStartLogSequence, 
    "for an fp-group presentation and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList, IsPosInt ], 0, 
function( mG, J, p ) 

    ## make the p-th entry the first entry

    local  K, lenK, L, R, H; 

    K := ShallowCopy( J ); 
    lenK := Length( K ); 
    if ( p < 2 ) or ( p > lenK ) then 
        Error( "choose p in [2..lenK]" ); 
    fi; 
    L := K{[p..lenK]}; 
    R := K{[1..p-1]}; 
    H := Concatenation( L, R ); 
    return H; 
end ); 

InstallMethod( InverseLogSequence, 
    "for an identity sequence", true, [ IsHomogeneousList ], 0, 
function( S ) 

    local  J, lenJ, H, j, k; 

    J := ShallowCopy( S ); 
    lenJ := Length( J ); 
    H := ListWithIdenticalEntries( lenJ, 0 ); 
    for j in [1..lenJ] do 
        k := lenJ - j + 1;
        H[j] := [ - J[k][1], J[k][2] ]; 
    od; 
    return H; 
end ); 

InstallMethod( ConjugatingWordOfLoggedTerm, 
    "for an fp-group presentation and a term in a sequence", true, 
    [ IsMonoidPresentationFpGroup, IsList ], 0, 
function( mG, t ) 

    local invrules, invnum, gpwords, lenJ, lenL, p, r, 
          Y, m, x, u, y, K, i, n, v, w; 

    invrules := InverseRulesOfPresentation( mG ); 
    invnum := Length( invrules ); 
    gpwords := GroupRelatorsOfPresentation( mG ); 
    m := t[1]; 
    if ( m > 0 ) then 
        x := gpwords[m]; 
    else 
        x := gpwords[-m]^(-1); 
    fi; 
    u := t[2]; 
    return ReduceWordKB( x^u, invrules ); 
end ); 

##############################################################################
##
#M  CancelInversesLogSequence
#M  CancelImmediateInversesLogSequence
##
InstallMethod( CancelImmediateInversesLogSequence, 
    "for an fp-group presentation and an identity sequence", true, 
    [ IsHomogeneousList ], 0, 
function( J ) 

    local K, lenK, H, changed, j, t, k, u, c; 

    K := ShallowCopy( J ); 
    lenK := Length( K ); 
    changed := false; 
    j := 0; 
    while ( j < lenK-1 ) do 
        j := j+1; 
        t := K[j]; 
        u := K[j+1]; 
        if ( ( t[1] = -u[1] ) and ( t[2] = u[2] ) ) then 
            K := Concatenation( K{[1..j-1]}, K{[j+2..lenK]} ); 
            lenK := lenK - 2; 
            if ( j > 1 ) then 
                j := j-2; 
            fi;
            changed := true; 
        fi; 
    od; 
    if changed then 
        Info( InfoIdRel, 2, "changes made by cancelinverses" ); 
    fi; 
    return K; 
end ); 

InstallMethod( CancelInversesLogSequence, 
    "for an fp-group presentation and an identity sequence", true, 
    [ IsMonoidPresentationFpGroup, IsHomogeneousList ], 0, 
function( mG, J ) 

    local K, lenK, changed, j, t, k, u, H; 

    K := ShallowCopy( J ); 
    ## now check for occurrences of: [-p,w] ... [p,w] 
    changed := true; 
    while changed and ( K <> [ ] ) do 
        changed := false; 
        lenK := Length( K ); 
        j := 0; 
        while ( j < lenK - 1 ) and ( not changed ) do 
            j := j+1; 
            k := 0; 
            while ( k < lenK - j ) and ( not changed ) do 
                k := k+1; 
                t := K[k]; 
                u := K[k+j]; 
                if ( ( t[1] = -u[1] ) and ( t[2] = u[2] ) ) then 
                    H := MoveLeftLogSequence( mG, K, [k+j], k+1 ); 
                    K := Concatenation( H{[1..k-1]}, H{[k+2..lenK]} ); 
                    changed := true; 
                fi; 
            od; 
        od; 
    od; 
    if changed then 
        Info( InfoIdRel, 2, "changes made by cancelinverses" ); 
    fi; 
    return K; 
end ); 

##############################################################################
##
#M  AreEquivalentIdentities 
## 
InstallMethod( AreEquivalentIdentities, 
    "for an fp-group and two relator sequences", true, 
    [ IsFpGroup, IsHomogeneousList, IsHomogeneousList ], 0, 
function( G, L1, L2 ) 

    local mG, fmG, gfmG, Glabs, J1, J2, rules, len, R1, R2, found, 
          i, j, p1, k, p2, K1, K2; 

    mG := MonoidPresentationFpGroup( G );
    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    if not HasMonoidPresentationLabels( mG ) then 
        Glabs := [ ];  
    else 
        Glabs := MonoidPresentationLabels( mG ); 
    fi; 
    rules := LogSequenceRewriteRules( mG ); 
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
                     K1 := MoveLeftLogSequence( mG, J1, [j], i ); 
                     J1 := OnePassReduceLogSequence( [K1], rules )[1]; 
                     K2 := MoveLeftLogSequence( mG, J2, [k], i ); 
                     J2 := OnePassReduceLogSequence( [K2], rules )[1]; 
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
#M  LogSequenceRewriteRules
##
InstallMethod( LogSequenceRewriteRules, 
    "for an fp-group presentation", true, [ IsMonoidPresentationFpGroup ], 0, 
function( mG ) 

    local G, fmG, gfmG, igfmG, id, invrules, len, roots, numroots, rewrites,  
          i, root, n, w, v, rule, p, x, y, rels, nrels, irels, rpos, r, ir; 

    G := UnderlyingGroupOfPresentation( mG ); 
    fmG := FreeGroupOfPresentation( mG ); 
    gfmG := GeneratorsOfGroup( fmG ); 
    igfmG := InverseGeneratorsOfFpGroup( fmG ); 
    id := One( fmG );  
    invrules := InverseRulesOfPresentation( mG ); 
    len := Length( InverseRulesOfPresentation( mG ) ); 
    roots := RootIdentities( G ); 
    numroots := Length( roots ); 
    rewrites := [ ]; 
    for i in [1..numroots] do 
        root := roots[i]; 
        n := root[2][1]; 
        w := root[2][2]; 
        if not ( ( root[1][1] = -n ) and ( root[1][2] = id ) ) then 
            Error( "unexpected root" ); 
        fi; 
        rule := [ [ n, w ], [ n, id ] ]; 
        p := Position( rewrites, rule ); 
        if ( p = fail ) then 
            Add( rewrites, rule ); 
        fi; 
        rule := [ [ -n, w ], [ -n, id ] ]; 
        p := Position( rewrites, rule ); 
        if ( p = fail ) then 
            Add( rewrites, rule ); 
        fi; 
        v := ReduceWordKB( w^-1, invrules ); 
        rule := [ [ n, v ], [ n, id ] ]; 
        p := Position( rewrites, rule ); 
        if ( p = fail ) then 
            Add( rewrites, rule ); 
        fi; 
        rule := [ [ -n, v ], [ -n, id ] ]; 
        p := Position( rewrites, rule ); 
        if ( p = fail ) then 
            Add( rewrites, rule ); 
        fi; 
        if ( Length( w ) = 2 ) then 
            x := Subword( w, 1, 1 ); 
            y := Subword( w, 2, 2 ); 
            p := Position( gfmG, y ); 
            y := igfmG[ p ]; 
            if ( x > y ) then 
                rule := [ [ n, x ], [ n, y ] ]; 
            else 
                rule := [ [ n, y ], [ n, x ] ]; 
            fi; 
            p := Position( rewrites, rule ); 
            if ( p = fail ) then 
                Add( rewrites, rule ); 
            fi; 
            if ( x > y ) then 
                rule := [ [ -n, x ], [ -n, y ] ]; 
            else 
                rule := [ [ -n, y ], [ -n, x ] ]; 
            fi; 
            p := Position( rewrites, rule ); 
            if ( p = fail ) then 
                Add( rewrites, rule ); 
            fi; 
        fi; 
    od; 
    ## now add rules from relators which are not roots 
    rels := GroupRelatorsOfPresentation( mG ); 
    nrels := Length( rels ); 
    irels := List( rels, r -> ReduceWordKB( r^-1, invrules ) ); 
    rpos := RootPositions( G ); 
    for n in [1..nrels] do 
        if not rpos[n] then 
            r := rels[n]; 
            ir := irels[n]; 
            Add( rewrites, [ [ n, r ], [ n, id ] ] ); 
            Add( rewrites, [ [ n, ir ], [ n, id ] ] ); 
            Add( rewrites, [ [ -n, r ], [ -n, id ] ] ); 
            Add( rewrites, [ [ -n, ir ], [ -n, id ] ] ); 
        fi; 
    od;
    return rewrites; 
end ); 

##############################################################################
##
#M  OnePassReduceLogSequence
##
InstallMethod( OnePassReduceLogSequence, 
    "for an identity and a list of sequence rewrite rules", true, 
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
                        w := rule[2][2] * Subword( w, lenx+1, lenw ); 
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
#M  SubstituteLogSubsequence
##
InstallMethod( SubstituteLogSubsequence, 
    "for three log sequences", true, [ IsMonoidPresentationFpGroup, 
        IsHomogeneousList, IsHomogeneousList, IsHomogeneousList ], 0, 
function( mG, K, J1, J2 ) 

    local lenK, len1, pos, H, rules; 

    lenK := Length( K ); 
    len1 := Length( J1 ); 
    pos := PositionSublist( K, J1 ); 
    if ( pos = fail ) then 
        return fail; 
    fi; 
    H := Concatenation( K{[1..pos-1]}, J2, K{[pos+len1..lenK]} ); 
    rules := LogSequenceRewriteRules( mG );
    return OnePassReduceLogSequence( H, rules ); 
end ); 

##############################################################################
##
#M  ReduceLogSequences 
##
InstallMethod( ReduceLogSequences, 
    "for an fp-group and a list of Ysequences", true, 
    [ IsFpGroup, IsHomogeneousList ], 0, 
function( G, L ) 

    local startwithid, findconjugates, removeempties, info, 
          mG, fmG, gfmG, id, arr, invrules, invnum, gpwords, Glabs, roots, 
          L1, L2, L3, L4, lenL, idrules, idnum, 
          i, j, k, idj, idk, m, w; 

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
        Sort( J, LogSequenceLessThan );
        return J; 
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
                                Info( InfoIdRel, 1, "reduction (1) at [i,j] = ", 
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
                                Info( InfoIdRel, 1, "reduction (2) at [i,j] = ", 
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
    ## remove all [ ]'s from J 
        local lenJ, M, N, K, i, lenK; 
        lenJ := Length( J ); 
        M := List( J, L -> L = [ ] ); 
        N := [ ]; 
        for i in [1..lenJ] do 
            if not M[i] then 
                Add( N, i ); 
            fi; 
        od; 
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
    L4 := startwithid( L ); 
    for j in [1..Length(L4)] do 
        idj := CancelInversesLogSequence( mG, L4[j] );
        w := ExpandLogSequence( mG, idj ); 
        Assert( 0, w = id ); 
        L4[j] := idj; 
    od; 
    lenL := Length( L4 ); 
    if ( info > 1 ) then 
        Print( "in ReduceLogSequences\n" ); 
        Print( "\n***** Glabs = ", Glabs, "  *****\n\n" ); 
        Print( "after sorting L4 has length ", lenL, "\n" );
        Print( List( L4, Length ), "\n" ); 
        PrintLnUsingLabels( L4, gfmG, Glabs ); 
        Print( "\ndetermining the rewrite rules\n" ); 
    fi; 
    idrules := LogSequenceRewriteRules ( mG ); 
    roots := RootIdentities( G ); 
    idnum := Length( idrules ); 
    if ( info > 1 ) then 
        Print( "there are ", Length(idrules), " rewrite rules:\n" ); 
        PrintLnUsingLabels( idrules, gfmG, Glabs ); 
    fi;
    L1 := [ ]; 
    while ( L1 <> L4 ) do 
        L1 := ShallowCopy ( L4 ); 
        Info( InfoIdRel, 2, "running CancelInverses:"); 
        L3 := List( L1, L -> CancelInversesLogSequence( mG, L ) ); 
        for m in [1..Length(L3)] do 
            w := ExpandLogSequence( mG, L3[m] ); 
            Assert( 0, w = id ); 
        od; 
        if ( info > 1 ) then 
            Print( "L3 has length ", Length(L3), " :-\n" ); 
            Print( List( L3, Length ), "\n" ); 
            PrintLnUsingLabels( L3, gfmG, Glabs ); 
            Print( "running removeempties:\n" ); 
        fi; 
        L2 := removeempties( L3 ); 
        for m in [1..Length(L2)] do 
            w := ExpandLogSequence( mG, L2[m] ); 
            Assert( 0, w = id ); 
        od; 
        if ( info > 1 ) then 
            Print( "L2 has length ", Length(L2), " :-\n" ); 
            Print( List( L2, Length ), "\n" ); 
            PrintLnUsingLabels( L2, gfmG, Glabs ); 
            Print( "running findconjugates:\n" ); 
        fi; 
        L3 := findconjugates( L2 ); 
        for m in [1..Length(L3)] do 
            w := ExpandLogSequence( mG, L3[m] ); 
            Assert( 0, w = id ); 
        od; 
        if ( info > 1 ) then 
            Print( "L3 has length ", Length(L3), " :-\n" ); 
            Print( List( L3, Length ), "\n" ); 
            PrintLnUsingLabels( L3, gfmG, Glabs ); 
            Print( "running removeempties:\n" ); 
        fi; 
        L2 := removeempties( L3 ); 
        for m in [1..Length(L2)] do 
            w := ExpandLogSequence( mG, L2[m] ); 
            Assert( 0, w = id ); 
        od; 
        if ( info > 1 ) then 
            Print( "L2 has length ", Length(L2), " :-\n" ); 
            Print( List( L2, Length ), "\n" ); 
            PrintLnUsingLabels( L2, gfmG, Glabs ); 
            Print( "running startwithid:\n" ); 
        fi; 
        L3 := startwithid( L2 ); 
        for m in [1..Length(L3)] do 
            w := ExpandLogSequence( mG, L3[m] ); 
            Assert( 0, w = id ); 
        od; 
        if ( info > 1 ) then 
            Print( "L3 has length ", Length(L3), " :-\n" );
            PrintLnUsingLabels( L3, gfmG, Glabs ); 
            Print( "running OnePassReduceLogSequence:\n" ); 
        fi; 
        lenL := Length( L3 ); 
        for j in [1..lenL] do 
            idj := L3[j]; 
            if not ( idj in roots ) then 
                L3[j] := OnePassReduceLogSequence( idj, idrules ); 
            fi; 
        od; 
        for m in [1..Length(L3)] do 
            w := ExpandLogSequence( mG, L3[m] ); 
            Assert( 0, w = id ); 
        od; 
        L4 := ShallowCopy( L3 ); 
        lenL := Length( L4 ); 
        for j in [1..lenL] do 
            idj := L4[j]; 
            if not ( idj in roots ) then 
                L4[j] := OnePassReduceLogSequence( idj, idrules ); 
            fi; 
        od; 
        if ( info > 1 ) then 
            Print( "L4 has length ", lenL, " :-\n" ); 
            Print( List( L4, Length ), "\n" ); 
            PrintLnUsingLabels( L4, gfmG, Glabs ); 
        fi; 
    od; 
    Sort( L4, LogSequenceLessThan ); 
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
    Info( InfoIdRel, 2, "adjusted L4 = ", List( L4, Length ) ); 
    if ( InfoLevel( InfoIdRel ) > 1 ) then 
        PrintLnUsingLabels( L4, gfmG, Glabs ); 
    fi;
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
          leni, irange, gp, npols, i, i1, w, hw, len, rp, nyp, yp, lp, 
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
                w := ImageElm( hom, ident[i][2] ); 
                w := MonoidWordFpWord( w, FMfam, L );
                w := ReduceWordKB( w, rws );
                if ( i1 > 0 ) then
                    gp[i] := frgens[i1];
                    npols[i] := MonoidPolyFromCoeffsWords( [+1], [w] );
                else
                    gp[i] := frgens[-i1]^(-1);
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
    iseq := ReduceLogSequences( G, gseq );
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
        Print( List( sats, Length ), "\n\n" );
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
        ids[r] := seq; 
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

    local  rels, nrels, rpos, roots, mG, fmG, gens, fam, id, inv, 
           i, r, L, len, w, iw, div, num, d, q, K, ok, k, J;

    rels := RelatorsOfFpGroup( G ); 
    nrels := Length( rels ); 
    rpos := ListWithIdenticalEntries( nrels, false ); 
    roots := [ ]; 
    mG := MonoidPresentationFpGroup( G ); 
    fmG := FreeGroupOfPresentation( mG ); 
    gens := GeneratorsOfGroup( fmG ); 
    fam := FamilyObj( gens[1] ); 
    id := One( fmG ); 
    inv := InverseRulesOfPresentation( mG ); 
    for i in [1..nrels] do 
        r := rels[i]; 
        L := ExtRepOfObj( r ); 
        len := Length( L ); 
        if ( len = 2 ) then 
            w := gens[ L[1] ];
            Add( roots, [ [ -i, id ], [ i, w ] ] ); 
            iw := ReduceWordKB( w^-1, inv ); 
            Add( roots, [ [ -i, id ], [ i, iw ] ] ); 
            rpos[i] := true; 
        else 
            div := DivisorsInt( len ); 
            num := Length( div ); 
            for d in div do 
                if ( ( d > 1 ) and ( d <= len/2 ) ) then 
                    q := len/d; 
                    K := L{[1..q]}; 
                    ok := true; 
                    for k in [2..d] do 
                        J := L{[(k-1)*q+1..k*q]}; 
                        if ( J <> K ) then 
                            ok := false; 
                        fi; 
                    od; 
                    if ok then 
                        w := ObjByExtRep( fam, K ); 
                        Add( roots, [ [ -i, id ], [ i, w ] ] );
                        iw := ReduceWordKB( w^-1, inv ); 
                        Add( roots, [ [ -i, id ], [ i, iw ] ] ); 
                        rpos[i] := true;  
                    fi; 
                fi; 
            od; 
        fi; 
    od; 
    SetRootPositions( G, rpos ); 
    return roots;
end );

##############################################################################
##
#M  PrintLnYSequence
#M  PrintYSequence 
##
InstallMethod( PrintLnYSequence, "for (list of) Ysequences", 
    true, [ IsObject, IsList, IsList, IsList, IsList ], 0, 
function( obj, gens1, labs1, gens2, labs2 ) 
    IdRelOutputPos := 0; 
    IdRelOutputDepth := 0; 
    PrintYSequence( obj, gens1, labs1, gens2, labs2 ); 
    Print( "\n" ); 
    IdRelOutputPos := 0; 
end );

InstallMethod( PrintYSequence, "for (list of) module polynomials", 
    true, [ IsObject, IsList, IsList, IsList, IsList ], 0, 
function( obj, gens1, labs1, gens2, labs2 ) 

    local j, len, ys, gys, mys, rp; 

    IdRelOutputPos := 0; 
    IdRelOutputDepth := 0; 
    if IsList( obj ) then 
        len := Length( obj ); 
        if ( len = 0 ) then 
            Print( "[ ]" ); 
        else 
            Print( "[ " ); 
            IdRelOutputPos := IdRelOutputPos + 2; 
            for j in [1..len] do 
                PrintYSequence( obj[j], gens1, labs1, gens2, labs2 ); 
                if ( j < len ) then 
                    Print( ", " ); 
                    IdRelOutputPos := IdRelOutputPos + 2; 
                fi; 
            od; 
            Print( " ]" ); 
            IdRelOutputPos := IdRelOutputPos + 2; 
        fi; 
    else ## IsYSequence( obj ) we hope 
        ys := YSequenceModulePoly( obj ); 
        gys := GeneratorsOfModulePoly( ys )[1]; 
        mys := MonoidPolys( ys )[1]; 
        Print( gys, "*(" ); 
        PrintUsingLabels( mys, gens1, labs1 ); 
        Print( "), " ); 
        rp := RelatorModulePoly( obj ); 
        PrintModulePoly( rp, gens1, labs1, gens2, labs2 ); 
        Print( ") " ); 
        IdRelOutputPos := IdRelOutputPos + 6; 
    fi; 
end ); 

###############*#############################################################
##
#E idrels.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
