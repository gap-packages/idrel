#############################################################################
##
##  PackageInfo.g   file for the package IdRel version 2.21  (10/12/14)
##  Anne Heyworth and Chris Wensley 
##

SetPackageInfo( rec(
PackageName := "idrel",
Subtitle := "Identities among relations",

Version := "2.21",
Date := "10/12/2014",

##  duplicate these values for inclusion in the manual: 
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "2.21">
##  <!ENTITY TARFILENAME "idrel-2.21.tar.gz">
##  <!ENTITY HTMLFILENAME "idrel221.html">
##  <!ENTITY RELEASEDATE "10/12/2014">
##  <!ENTITY LONGRELEASEDATE "10th December 2014">
##  <#/GAPDoc>

PackageWWWHome := 
  "http://pages.bangor.ac.uk/~mas023/chda/idrel/",

ArchiveURL := "http://pages.bangor.ac.uk/~mas023/chda/idrel/idrel-2.21", 
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Heyworth",
    FirstNames    := "Anne",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "anne.heyworth@googlemail.com",
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

Status := "deposited",
## CommunicatedBy := "",
## AcceptDate := "",

README_URL := 
  Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := 
  Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

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
  NeededOtherPackages := [ [ "xmod", ">= 2.26" ], [ "GAPDoc", ">= 1.5.1" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ]
),

AvailabilityTest := ReturnTrue,

BannerString := Concatenation( 
    "Loading IdRel ", String( ~.Version ), " for GAP 4.7", 
    " - Anne Heyworth and Chris Wensley ...\n" ),

Autoload := false,

TestFile := "tst/idrel_manual.tst",

Keywords := ["logged rewriting","identities among relations",
             "Y-sequences"]

));
