#############################################################################
##
##  PackageInfo.g   file for the package IdRel version 2.33 
##  Anne Heyworth and Chris Wensley 
##

SetPackageInfo( rec(
PackageName := "idrel",
Subtitle := "Identities among relations",

Version := "2.33",
Date := "18/02/2016",

##  duplicate these values for inclusion in the manual: 
##  <#GAPDoc Label="PKGVERSIONDATA"> 
##  <!ENTITY IDRELVERSION "2.33">
##  <!ENTITY IDRELTARFILENAME "idrel-2.33.tar.gz">
##  <!ENTITY IDRELHTMLFILENAME "idrel233.html">
##  <!ENTITY IDRELRELEASEDATE "18/02/2016">
##  <!ENTITY IDRELLONGRELEASEDATE "18th February 2016">
##  <!ENTITY IDRELCOPYRIGHTYEARS "1999-2016">
##  <#/GAPDoc>

PackageWWWHome := 
  "http://pages.bangor.ac.uk/~mas023/chda/idrel/",

ArchiveURL := "http://pages.bangor.ac.uk/~mas023/chda/idrel/idrel-2.33", 
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Heyworth",
    FirstNames    := "Anne",
    IsAuthor      := true,
    IsMaintainer  := false,
    ## Email         := "anne.heyworth@gmail.com",
    ## WWWHome       := "",
    ## PostalAddress := Concatenation( ["\n", "UK"] ),
    ## Place         := "",
    ## Institution   := ""
  ),
  rec(
    LastName      := "Wensley",
    FirstNames    := "Christopher D.",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "c.d.wensley@bangor.ac.uk",
    WWWHome       := "http://pages.bangor.ac.uk/~mas023/",
    PostalAddress := Concatenation( [
                       "Dr. C.D. Wensley\n",
                       "School of Computer Science\n",
                       "Bangor University\n",
                       "Dean Street\n",
                       "Bangor\n",
                       "Gwynedd LL57 1UT\n",
                       "UK"] ),
    Place         := "Bangor",
    Institution   := "Bangor University"
  )
],

Status := "accepted",
CommunicatedBy := "Leonard Soicher (QMUL)",
AcceptDate := "05/2015",

README_URL := 
  Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := 
  Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

SourceRepository := rec( 
  Type := "git", 
  URL := "https://github.com/gap-packages/idrel" ),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),

AbstractHTML :=
 "IdRel is a package for computing the identities among relations of a group presentation using rewriting, logged rewriting, monoid polynomials, module polynomials and Y-sequences.",

PackageDoc := rec(
  BookName  := "IdRel",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Identities among Relations",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.7",
  NeededOtherPackages := [ [ "xmod", ">= 2.51" ], [ "GAPDoc", ">= 1.5.1" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ]
),

AvailabilityTest := ReturnTrue,

BannerString := Concatenation( 
    "Loading IdRel ", String( ~.Version ), " for GAP 4.7", 
    " - Anne Heyworth and Chris Wensley ...\n" ),

TestFile := "tst/idrel_manual.tst",

Keywords := ["logged rewriting","identities among relations",
             "Y-sequences"]

));
