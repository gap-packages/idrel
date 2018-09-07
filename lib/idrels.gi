##############################################################################
##
#W  idrels.gi                     IdRel Package                  Chris Wensley
#W                                                             & Anne Heyworth
##  Implementation file for functions of the IdRel package.
##
#Y  Copyright (C) 1999-2018 Anne Heyworth and Chris Wensley 
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

    local  k, leny, w;

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
    if ( ( leny > 1 ) and ( y[1][1] = y[leny][1]^(-1) ) 
                      and ( y[1][2] = y[leny][2] ) ) then 
        y := y{[2..leny-1]};
        leny := leny - 2;
    fi; 
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

    local  monG, mu, FM, genFM, numgenM, F, genF, idF, freerels, FR, genFR, 
           omega, len, gseq, i, s0, s1, s2, s3, s4, leni, t, t1, rt, wt, 
           z, z1, z2; 
    monG := MonoidPresentationFpGroup( G ); 
    mu := HomomorphismOfPresentation( monG );
    FM := FreeGroupOfPresentation( monG );
    genFM := GeneratorsOfGroup( FM );
    numgenM := Length( genFM );
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
                rt := genFR[ t1 - numgenM ];
            else 
                rt := genFR[ - t1 - numgenM ]^-1;
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

    local genG, monG, amg, FM, genFM, invgenFM, idM, numgenM, invrels, 
          invrules1, invrules2, grprels, mu, genpos, logrws, rws, F, genF, 
          idF, numgenF, genrangeF, g, k, genFMpos, freerels, numrel, relrange, 
          FR, genFR, idR, omega, uptolen, words, fam, iwords, numelts, 
          edgesT, mseq, e, elt, rho, numa, ide, r, lenr, edgelist, 
          edge, w, lw, v, posv, inv, lenv, j, numids, gseq, lenseq; 

    genG := GeneratorsOfGroup( G ); 
    monG := MonoidPresentationFpGroup( G ); 
    amg := ArrangementOfMonoidGenerators( G ); 
    FM := FreeGroupOfPresentation( monG );
    genFM := GeneratorsOfGroup( FM );
    invgenFM := InverseGeneratorsOfFpGroup( FM ); 
    idM := One( FM );
    numgenM := Length( genFM );
    invrels := InverseRelatorsOfPresentation( monG );
    invrules1 := ListWithIdenticalEntries( Length( genFM ), 0 );
    invrules2 := Concatenation( List( invrels, r -> [ r, idM ] ),
                                List( invrels, r -> [r^-1, idM ] ) );
    grprels := GroupRelatorsOfPresentation( monG );
    mu := HomomorphismOfPresentation( monG );
    genpos := MonoidGeneratorsFpGroup( G ); 
    logrws := LoggedRewritingSystemFpGroup( G );
    #?  WHY??   rws := Filtered( logrws, r -> not( r[1] in invrels ) );
    rws := List( logrws, r -> [ r[1], r[3] ] );
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
    numelts := Length( words ); 
    edgesT := GenerationTree( G ); 
    mseq := [ ];
    ##  now work through the list of elements, adding each relator in turn 
    e := 0;  ## this is the number of monoid elements processed so far 
    while ( e < numelts ) do 
        e := e+1; 
        elt := words[e];
        for rho in relrange do 
            Info( InfoIdRel, 2, "[e,rho] = ", [e,rho] );
            numa := (e-1)*numrel + rho;
            ide := [ [ -(rho+numgenM), iwords[e] ] ];
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
                        inv := InverseWordInFreeGroupOfPresentation( FM, v );
                        Add( iwords, inv ); 
                        Add( edgesT, edge ); 
                        j := Position( genFM, edge[2] ); 
                        Add( edgesT, [ v, iwords[j] ] );
                    fi; 
                else  ## v<>w, so there is some logging to include in the ide 
                    if ( posv = fail ) then 
                        Add( words, v );
                        inv := InverseWordInFreeGroupOfPresentation( FM, v );
                        Add( iwords, inv ); 
                        lenv := Length( v );
                        g := Subword( v, lenv, lenv );
                        Add( edgesT, [ Subword( v, 1, lenv-1 ), g ] ); 
                        j := Position( genFM, g ); 
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
            w := ide[1][2]^(-1); 
            for k in [1..Length(ide)] do 
                ide[k][2] := ide[k][2]*w; 
            od; 
            ide := RelatorSequenceReduce( G, ide );
            if ( ide <> [ ] ) then 
                posv := Position( mseq, ide ); 
                if ( posv = fail ) then 
                    Add( mseq, ide ); 
                fi;
            fi;
        od; 
    od;
    Info( InfoIdRel, 1, "mseq has length: ", Length(mseq), "\n" ); 
    Info( InfoIdRel, 3, mseq ); 
    ### convert relator sequences to Y-sequences 
    lenseq := Length( mseq );
    mseq := List( [1..lenseq], i -> [ i, mseq[i] ] );
    gseq := ConvertToGroupRelatorSequences( G, mseq );
    gseq := ReduceGroupRelatorSequences( gseq ); 
    lenseq := Length( gseq );
    gseq := List( [1..lenseq], i -> [ i, gseq[i][1], gseq[i][2] ] ); 
    return gseq;
end );

##############################################################################
##
#M  ReduceGroupRelatorSequences
##
InstallMethod( ReduceGroupRelatorSequences, "for a list of Ysequences", true, 
    [ IsHomogeneousList ], 0, 
function( L ) 

    local changed, L2, lenL, i, idi, leni, rho, j, idj, lenj, k, w, c, ok;

    ### search for conjugate of one identity lying within another 
    changed := true; 
    L2 := ShallowCopy( L ); 
    while changed do 
        Info( InfoIdRel, 1, "## new iteration in ReduceGroupRelatorSequences" );
        L2 := Filtered( L2, y -> not ( y[2] = [ ] ) ); 
        lenL := Length( L2 );
        Sort( L2, function( K, L ) 
                  return GroupRelatorSequenceLessThan( K[2], L[2] ); 
                  end );
        Info( InfoIdRel, 1, "after sorting:" ); 
        Info( InfoIdRel, 1, "number of identities = ", lenL );
        if ( InfoLevel( InfoIdRel ) > 1 ) then 
            Perform( L2, Display ); 
        fi;
        changed := false;
        for i in [1..lenL] do 
            idi := L2[i][2];
            leni := Length( idi );
            if ( leni > 0 ) then
                rho := idi[1][1];
                for j in [i+1..lenL] do 
                    idj := L2[j][2];
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
                                L2[j][2] := idj;
                                lenj := lenj - leni;
                                if ( InfoLevel( InfoIdRel ) > 0 ) then
                                    if ( lenj = 0 ) then 
                                    Print( "** id ", L2[j][1], 
                                           " reduced by id ", L2[i][1], 
                                           " to ", idj, " at [i,j] = ", 
                                           [i,j], " **\n"); 
                                    fi; 
                                fi;
                                changed := true;
                                k := k-1;
                            fi;
                        fi;
                        k := k+1;
                    od;
                od; 
                idi := Reversed( List( idi, c -> [ c[1]^-1, c[2] ] ) ); 
                w := idi[1][2]^(-1); 
                for j in [1..Length(idi)] do 
                    idi[j][2] := idi[j][2]*w; 
                od; 
                rho := idi[1][1];
                for j in [i+1..lenL] do 
                    idj := L2[j][2];
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
                                L2[j][2] := idj;
                                lenj := lenj - leni;
                                if ( InfoLevel( InfoIdRel ) > 0 ) then
                                    if ( lenj = 0 ) then 
                                    Print( "** id ", L2[j][1], 
                                           " reduced by reversed id ", L2[i][1], 
                                           " to ", idj, " at [i,j] = ", 
                                           [i,j], " **\n"); 
                                    fi; 
                                fi;
                                changed := true;
                                k := k-1;
                            fi;
                        fi;
                        k := k+1;
                    od;
                od; 
            fi; 
        od; 
    od;
    return L2;
end );

#############################################################################
##
#M  ConvertToYSequences( <G> )
##
InstallMethod( ConvertToYSequences, "for an fp-group and group relator seq", 
    true, [ IsFpGroup, IsFreeGroup, IsHomogeneousList ], 0, 
function( G, FY, gseq ) 

    local monG, elmon, oneM, frgp, frgens, FM, FMfam, L, FYgens, lrws, rws, 
          numids, polys, k, j, pos, ident, leni, irange, gp, npols, i, i1, 
          w, len, rp, nyp, yp, lp, lbest; 

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
    FM := FreeGroupOfPresentation( monG );
    FMfam := ElementsFamily( FamilyObj( FM ) );
    lrws := LoggedRewritingSystemFpGroup( G );
    rws := List( lrws, r -> [ r[1], r[3] ] );
    L := ArrangementOfMonoidGenerators( G );
    FYgens := GeneratorsOfGroup( FY );
    numids := Length( gseq );
    polys := [ ];
    k := 0;
    for j in [1..numids] do 
        Info( InfoIdRel, 2, "===============  j = ", j, "  ===============" ); 
        pos := gseq[j][1]; 
        ident := gseq[j][3];
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

    local L, monG, elmon, rws, F, FR, genFR, FM, FMgens, FY, FYgens, 
          gseq, modpols, redpols, irrepols, irrerems, irrenum, sats, 
          r, ids, pol, ymp, gymp, pos, seq;

    if HasArrangementOfMonoidGenerators( G ) then 
        L := ArrangementOfMonoidGenerators( G ); 
    else 
        L := ArrangeMonoidGenerators( G ); 
    fi;
    monG := MonoidPresentationFpGroup( G );
    if HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    else  
        elmon := ElementsOfMonoidPresentation( G ); 
    fi;
    rws := List( LoggedRewritingSystemFpGroup( G ), r -> [ r[1], r[3] ] );
    F := FreeGroupOfFpGroup( G );
    FR := FreeGroupOfPresentation( monG );
    genFR := GeneratorsOfGroup( FR );
    FM := FreeGroupOfPresentation( monG );
    FMgens := GeneratorsOfGroup( FM );
    gseq := IdentityRelatorSequences( G );
    FY := FreeYSequenceGroup( G );
    FYgens := GeneratorsOfGroup( FY ); 
    modpols := ConvertToYSequences( G, FY, gseq );
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
        seq := gseq[pos]; 
        ids[r] := seq[3]; 
    od; 
    #? return [ irrepols, irrerems ]; 
    return ids; 
end );

#############################################################################
##
#M  IdentitiesAmongRelatorsKB( <G> )
##
InstallMethod( IdentitiesAmongRelatorsKB, "for an FpGroup", true, 
    [ IsFpGroup ], 0, 
function( G )

    local L, monG, elmon, rws, F, FR, genFR, FM, FMgens, FY, FYgens, mseq, 
          lenseq, gseq, modpols, redpols, irrepols, irrerems, irrenum, sats, 
          r, ids, pol, ymp, gymp, pos, seq;

    L := ArrangementOfMonoidGenerators( G ); 
    monG := MonoidPresentationFpGroup( G );
    if HasElementsOfMonoidPresentation( G ) then 
        elmon := ElementsOfMonoidPresentation( G ); 
    elif HasPartialElements( G ) then 
        elmon := PartialElements( G ); 
    else
        Error( "no list of elements available" ); 
    fi;
    rws := List( LoggedRewritingSystemFpGroup( G ), r -> [ r[1], r[3] ] );
    F := FreeGroupOfFpGroup( G );
    FR := FreeGroupOfPresentation( monG );
    genFR := GeneratorsOfGroup( FR );
    FM := FreeGroupOfPresentation( monG );
    FMgens := GeneratorsOfGroup( FM );
    if not HasIdentityRelatorSequencesKB( G ) then 
        Error( "G does not yet have IdentityRelatorSequencesKB" ); 
    fi; 
    gseq := IdentityRelatorSequencesKB( G ); 
    lenseq := Length( gseq );
    FY := FreeYSequenceGroupKB( G );
    FYgens := GeneratorsOfGroup( FY ); 
    modpols := ConvertToYSequences( G, FY, gseq );
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
    SetIdentityYSequencesKB( G, irrepols ); 
    ## now pick out the relator sequences corresponding to these polys 
    ids := ListWithIdenticalEntries( irrenum, 0 ); 
    for r in [1..irrenum] do 
        pol := irrepols[r]; 
        ymp := YSequenceModulePoly( pol ); 
        gymp := GeneratorsOfModulePoly( ymp )[1]; 
        pos := Position( FYgens, gymp );
        seq := gseq[pos]; 
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

    local  idsR, idsY, len, rng;

    if ( HasIdentitiesAmongRelators( G ) and HasIdentityYSequences( G ) ) then
        idsR := IdentitiesAmongRelators( G );
        idsY := IdentityYSequences( G ); 
        len := List( idsY, i -> Length( RelatorModulePoly(i) ) );
        rng := Filtered( [1..Length(len)], i -> len[i]=1 );
        return idsR{rng};
    else
        Print( "direct method not yet implemented\n" );
        return fail;
    fi;
end );

###############*#############################################################
##
#E idrels.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
