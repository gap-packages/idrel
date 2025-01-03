#############################################################################
##
##  PackageInfo.g  file for the package IdRel 
##  Anne Heyworth and Chris Wensley 
##

SetPackageInfo( rec(

PackageName := "idrel",
Subtitle := "Identities among relations",
Version := "2.48dev",
Date := "03/01/2025", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    LastName      := "Heyworth",
    FirstNames    := "Anne",
    IsAuthor      := true,
    IsMaintainer  := false
  ),
  rec(
    LastName      := "Wensley",
    FirstNames    := "Chris",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "cdwensley.maths@btinternet.com",
    WWWHome       := "https://github.com/cdwensley",
    Place         := "Llanfairfechan"
  )
],

Status := "accepted",
CommunicatedBy := "Leonard Soicher (QMUL)",
AcceptDate := "05/2015",

SourceRepository := rec( 
  Type := "git", 
  URL := "https://github.com/gap-packages/idrel" ),
  IssueTrackerURL  := Concatenation( ~.SourceRepository.URL, "/issues" ),
  PackageWWWHome   := "https://gap-packages.github.io/idrel/",
  README_URL       := Concatenation( ~.PackageWWWHome, "README.md" ),
  PackageInfoURL   := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
  ArchiveURL       := Concatenation( ~.SourceRepository.URL, 
                                   "/releases/download/v", ~.Version, 
                                   "/", ~.PackageName, "-", ~.Version ), 
ArchiveFormats   := ".tar.gz",

AbstractHTML :=
"<span class=\"pkgname\">IdRel</span> is a package for computing the identities among relations of a group presentation using rewriting, logged rewriting, monoid polynomials, module polynomials and Y-sequences.",

PackageDoc := rec(
  BookName  := "IdRel",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Identities among Relations"
),

Dependencies := rec(
  GAP := ">=4.11.1",
  NeededOtherPackages := [ ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ]
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := ["logged rewriting","identities among relations",
             "Y-sequences"], 

BannerString := Concatenation( 
    "Loading IdRel ", String( ~.Version ), " (Identities among Relations)\n", 
    "by Anne Heyworth and ", 
    "Chris Wensley (https://github.com/cdwensley)\n", 
 "-----------------------------------------------------------------------\n" ),

AutoDoc := rec(
    TitlePage := rec(
        Copyright := Concatenation(
            "© 1999-2025 Anne Heyworth and Chris Wensley<P/>\n",
            "The &IdRel; package is free software; you can redistribute it ", 
            "and/or modify it under the terms of the GNU General ", 
            "Public License as published by the Free Software Foundation; ", 
            "either version 2 of the License, or (at your option) ", 
            "any later version.\n"
            ), 
        Abstract := Concatenation( 
            "&IdRel; is a &GAP; package originally implemented in 1999, ", 
            "using the &GAP; 3 language, ", 
            "when the first author was studying for a Ph.D. in Bangor.\n", 
            "<P/>\n", 
            "This package is designed to compute a minimal set of ", 
            "generators for the module of the identities among relators ", 
            "of a group presentation.\n", 
            "It does this using\n", 
            "<List>\n", 
            "<Item>\n", 
            "rewriting and logged rewriting: a self-contained ", 
            "implementation of the Knuth-Bendix process using the ", 
            "monoid presentation associated to the group presentation;\n", 
            "</Item>\n", 
            "<Item>\n", 
            "monoid polynomials: an implementation of the monoid ring;\n", 
            "</Item>\n", 
            "<Item>\n", 
            "module polynomials: an implementation of the right module ", 
            "over this monoid generated by the relators.\n", 
            "</Item>\n", 
            "<Item>\n", 
            "Y-sequences: used as a <E>rewriting</E> way of representing ", 
            "elements of a free crossed module (products of conjugates ", 
            "of group relators and inverse relators).\n", 
            "</Item>\n", 
            "</List>\n", 
            "<P/>\n",  
            "&idrel; became an accepted &GAP; package in May 2015.\n", 
            "<P/>\n",  
            "Bug reports, suggestions and comments are, of course, welcome.\n", 
            "Please contact the last author at ", 
            "<Email>cdwensley.maths@btinternet.com</Email> ", 
            "or submit an issue at the GitHub repository ",
            "<URL>https://github.com/gap-packages/idrel/issues/</URL>.\n" 
            ), 
        Acknowledgements := Concatenation( 
            "This documentation was prepared using the ", 
            "&GAPDoc; <Cite Key='GAPDoc'/> ", 
            "and &AutoDoc; <Cite Key='AutoDoc'/> packages.<P/>\n", 
            "The procedure used to produce new releases uses the package ", 
            "<Package>GitHubPagesForGAP</Package> ", 
            "<Cite Key='GitHubPagesForGAP' /> ", 
            "and the package <Package>ReleaseTools</Package>.<P/>" 
            ),
    )
),

));
