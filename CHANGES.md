# CHANGES to the IdRel package

## 2.47 -> 2.48 for GAP 4.13.1 (27/08/24) 
 * (27/08/24) small fix in MonoidPresentationFpGroup method

## 2.46 -> 2.47 for GAP 4.13.1 (02/06/24) 
 * (02/06/24) small fix in rws.tst - order of elq8 changed in gapdev

## 2.45 -> 2.46 for GAP 4.12.2 (23/01/24) 
 * (23/01/24) minor changes; correct email address

## 2.44 -> 2.45 for GAP 4.12.2 (09/02/23) 
 * (23/12/22) changed email address and other personal details

## 2.43 -> 2.44 for GAP 4.11.1 (04/06/22) 
 * (04/06/22) extensive revision of idrels.* adding a large number 
              of operations for log sequences and identities
 * (23/11/21) renamed the test files; revised Chapter 2 
 * (02/11/21) introduced PrintUsingLabels and other Print commands 

## 2.42 -> 2.43 for GAP 4.10.1 (08/04/21) 
 * (08/04/21) Switch CI to use GitHub Actions 
 * (16/02/19) added License field in PackageInfo.g 

## 2.41 -> 2.42  (13/09/2018)
 * (13/09/18) Replaced PrintOneItemPerLine(L) with Perform(L,Display)
	
## 2.38 -> 2.41  (19/03/2018)
 * (18/03/18) large number of functions edited and renamed and tests altered: 
              IdentitiesAmongRelators now returns group relator sequences 
              and the module polynomials are available as IdentityYSequences 
 * (21/02/18) required package Utils - not XMod 
              separated out new operation InitialLoggedRules 
 * (20/02/18) removed IdentitiesAmongRelatorsOld 
 * (13/02/18) added scripts/* for Travis tests 
 * (12/01/18) now using AutoDoc to build the manual 

## 2.34 -> 2.38  (15/12/2017)
 * (15/12/17) removed examples/*.g from git but saved some in new /expt 
 * (08/08/17) testall.g copied to testing.g; testall now calls TestDirectory
 * (11/07/17) split off method for PartialElementsOfMonoidPresentation 
 * (03/07/17) README and CHANGES now in MarkDown format, so .md files
 * (14/06/17) added methods for String, ViewString, PrintString 
 * (22/02/17) added PartialElementsOfMonoidPresentation 
              added YSequencesFromRelatorSequences 
 * (17/02/17) renamed OrderingYSequences -> YSequenceLessThan 
              renamed ReducedYSequence -> YSequenceReduce 
              new operation YSequenceConjugateAndReduce 
              new operation RelatorSequenceReduce
 * (10/02/17) moved manual section 2.1 to 1.1 in the introduction 
 * (09/02/17) extensive additions to chapters 2 and 3 of the manual 
 * (21/12/16) added MonoidGeneratorsFpGroup
 * (15/11/16) added ArrangementOfMonoidGenerators to allow various orders  

## 2.32 -> 2.34  (20/10/2016)
 * (18/10/16) now using bibliography file `bib.xml` of type `bibxmlext.dtd`
 * (10/10/16) changed package releases to <https://gap-packages.github.io/idrel>
 * (18/02/16) removed date/version info from file headers 
 * (12/01/16) changes to the ENTITYs in `PackageInfo.g` 
 * (28/10/15) added MathJax to `makedocrel.g` 
 * (02/09/15) major edits to `README`, including GitHub issues link 

## 2.31 -> 2.32  (24/08/2015)
 * (24/08/15) packed up version 2.32 prior to move from Bitbucket to GitHub 
 * (24/08/15) added PrintObj method for monoid presentations 

## 2.21 -> 2.31  (01/06/2015)
 * (01/06/15) `PackageInfo.g` : IdRel is now an accepted package 
 * (01/06/15) converted the bibliography to BibXMLext format 
              and added an URL to Anne's thesis (`heyworth.ps.gz`)  

## 2.14 -> 2.21  (10/12/2014)
 * (10/12/14) changed package home to <pages.bangor.ac.uk/~mas023/chda/idrel/>
 * (10/12/14) started a bitbucket repository for idrel 

## 2.12 -> 2.14  (11/01/2013)
 * (11/01/13) changed output in tests due to changes for GAP 4.6 

## 2.11 -> 2.12  (25/04/2012)
 * (23/04/12) replaced ReadTest by Test in `tst/testall.g` 
 * (28/01/12) corrected typo in manual reported by David Callan 
              now using package directory in the format `../idrel-2.12/` 
              and archive files in the format `idrel-2.12.tar` 

## 2.08 -> 2.11  (21/09/2011)
 * (20/09/11) new version of `makedocrel.g` for building the manual 
 * (17/09/11) Shortened the banner. 
 * (16/08/11) Renamed subdirectory `idrel/gap` as `idrel/lib` 

## 2.07 -> 2.08  (06/09/2011)
 * (16/08/11) Changed directory for archive to `.../chda/gap4r5/idrel/` 

## 2.06 -> 2.07  (04/06/2011)
 * (04/06/11) Changed Generators to GeneratorsOfModulePoly 

## 2.05 -> 2.06  (08/05/2011)
 * (08/05/11) Preparing version to be released with GAP4.5. 
 * (18/04/10) Moved IdRel development to IMac at home, and started v.2.06.

## 2.04 -> 2.05  (21/11/2008)
 * (19/11/08) GapDoc relegated to "suggested other packages".

## 2.03 -> 2.04  (14/11/2008)
 * added GNU General Public License declaration 
 * added a test file, `tst/idrel_manual.tst`, 
 * fixed a bug in RootIdentities, 
 * several changes to the manual, which now agrees with the test file.

## 2.02 -> 2.03  (09/10/2007)
 * started this CHANGES file 
 * new email address for Anne 

# History up to version 2.02
 * (07/05/97)?  package started: ?
 * (12/12/00)?  version 1.001 published in Anne Heyworth's thesis
 * (06/10/05)   version 2.01 prepared for GAP 4.4
 * (29/03/06)   version 2.02 uses GAPDoc format for documentation
 * (02/06/06)   fixed minor typo in `PackageInfo.g` but still version 2.02
