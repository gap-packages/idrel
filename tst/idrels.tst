##############################################################################
##
#W  idrels.tst                   Idrel Package                   Chris Wensley
#W                                                             & Anne Heyworth
#Y  Copyright (C) 1999-2022 Anne Heyworth and Chris Wensley
##

gap> saved_infolevel_idrel := InfoLevel( InfoIdRel );; 
gap> SetInfoLevel( InfoIdRel, 0 );;

## items defined in rws.tst 
gap> F := FreeGroup( 2 );;
gap> f := F.1;;  g := F.2;;
gap> rels3 := [ f^3, g^2, f*g*f*g ];; 
gap> s3 := F/rels3;; 
gap> SetName( s3, "s3" );; 
gap> relq8 := [ f^4, g^4, f*g*f*g^-1, f^2*g^2 ];; 
gap> q8 := F/relq8;; 
gap> SetName( q8, "q8" );;
gap> q8labs := [ "a", "b", "A", "B" ];; 
gap> SetMonoidPresentationLabels( q8, q8labs );; 
gap> mq8 := MonoidPresentationFpGroup( q8 );;
gap> fmq8 := FreeGroupOfPresentation( mq8 );; 
gap> genfmq8 := GeneratorsOfGroup( fmq8 );;
gap> q8R := FreeRelatorGroup( q8 );; 
gap> genq8R := GeneratorsOfGroup( q8R );; 
gap> q8Rlabs := [ "q", "r", "s", "t" ];; 


## Example 6.1.1
gap> roots3 := RootIdentities(s3);
[ [ [ -1, <identity ...> ], [ 1, s3_M1 ] ], 
  [ [ -1, <identity ...> ], [ 1, s3_M3 ] ], 
  [ [ -2, <identity ...> ], [ 2, s3_M2 ] ], 
  [ [ -2, <identity ...> ], [ 2, s3_M4 ] ], 
  [ [ -3, <identity ...> ], [ 3, s3_M1*s3_M2 ] ], 
  [ [ -3, <identity ...> ], [ 3, s3_M4*s3_M3 ] ] ]
gap> RootPositions(s3);
[ true, true, true ]
gap> PrintLnUsingLabels( RootIdentities(q8), genfmq8, q8labs );
[ [ [ -1, id ], [ 1, a ] ], [ [ -1, id ], [ 1, A ] ], [ [ -2, id ], 
[ 2, b ] ], [ [ -2, id ], [ 2, B ] ] ]
gap> RootPositions(q8);
[ true, true, false, false ]

## Example 6.1.2 
gap> ms3 := MonoidPresentationFpGroup( s3 );;
gap> fms3 := FreeGroupOfPresentation( ms3 );;
gap> genfms3 := GeneratorsOfGroup(fms3 );;
gap> s3labs := ["f","g","F","G"];; 
gap> SetMonoidPresentationLabels( ms3, s3labs );; 
gap> idss3 := IdentityRelatorSequences( s3 );;          
gap> lenidss3 := Length( idss3 );                                   
17
gap> List( idss3, L -> Length(L) );
[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 6, 8, 8 ]
gap>  for i in [1..Length(idss3)] do                     
>       PrintLnUsingLabels( idss3[i], genfms3, s3labs );
>     od;
[ [ -3, id ], [ 3, f*g ] ]
[ [ -3, id ], [ 3, G*F ] ]
[ [ -2, id ], [ 2, g ] ]
[ [ -2, id ], [ 2, G ] ]
[ [ -1, id ], [ 1, f ] ]
[ [ -1, id ], [ 1, F ] ]
[ [ 1, id ], [ -1, f ] ]
[ [ 1, id ], [ -1, F ] ]
[ [ 1, G ], [ -1, F*G ] ]
[ [ 2, id ], [ -2, G ] ]
[ [ 2, F ], [ -2, G*F ] ]
[ [ 3, f ], [ -3, G ] ]
[ [ -3, f ], [ 2, F*G ], [ 3, f ], [ -2, f ] ]
[ [ -2, F*G*F ], [ 3, id ], [ 2, id ], [ -3, G*F ] ]
[ [ -2, F*G*F ], [ 3, id ], [ 1, G ], [ -3, id ], [ 2, F*G*F ], 
[ -1, G*F ] ]
[ [ 1, id ], [ -3, f ], [ 2, F*G ], [ 1, G ], [ -3, id ], 
[ 2, F*G*F ], [ 2, F ], [ -3, F ] ]
[ [ 1, G ], [ -3, id ], [ 2, F*G*F ], [ 2, F ], [ 1, id ], 
[ -3, f ], [ 2, F*G ], [ -3, F*G ] ]

## Example 6.1.3 
gap> LogSequenceLessThan( idss3[7], idss3[8] ); 
true

## Example 6.1.4 
gap> ExpandLogSequence( ms3, idss3[17] );
<identity ...>

## Example 6.2.1 
gap> ridss3 := ReduceLogSequences( s3, idss3 );;
gap> lenridss3 := Length( ridss3 );                                   
5
gap> for i in [1..lenridss3] do                                
>        PrintLnUsingLabels( ridss3[i], genfms3, s3labs );   
>    od;
[ [ -3, id ], [ 3, f*g ] ]
[ [ -2, id ], [ 2, g ] ]
[ [ -1, id ], [ 1, f ] ]
[ [ 1, id ], [ -3, f ], [ 2, F*G ], [ 1, G ], [ -3, id ], 
[ 2, F*G*F ], [ 2, F ], [ -3, F ] ]
[ [ 1, id ], [ -3, g ], [ 2, F*G*F*g ], [ 2, F*g ], [ 1, g ], 
[ -3, id ], [ 2, F ], [ -3, F ] ]

## Example 6.2.2 
gap> K4 := ShallowCopy( ridss3[4] );; 
gap> PrintLnUsingLabels( K4, genfms3, s3labs ); 
[ [ 1, id ], [ -3, f ], [ 2, F*G ], [ 1, G ], [ -3, id ], 
[ 2, F*G*F ], [ 2, F ], [ -3, F ] ]
gap> L5 := ShallowCopy( ridss3[5] );; 
gap> K5 := ConjugateByWordLogSequence( ms3, L5, genfms3[4] );; 
gap> PrintLnUsingLabels( K5, genfms3, s3labs ); 
[ [ 1, G ], [ -3, id ], [ 2, F*G*F ], [ 2, F ], [ 1, id ], 
[ -3, f ], [ 2, F*G ], [ -3, F*G ] ]
gap> A := K4{[1..3]};;              
gap> PrintLnUsingLabels( A, genfms3, s3labs ); 
[ [ 1, id ], [ -3, f ], [ 2, F*G ] ]
gap> B := K4{[4..7]};;              
gap> PrintLnUsingLabels( B, genfms3, s3labs ); 
[ [ 1, G ], [ -3, id ], [ 2, F*G*F ], [ 2, F ] ]
gap> PositionSublist( K5, A ); 
5
gap> PositionSublist( K5, B ); 
1

## Example 6.2.3 
gap> J4 := ChangeStartLogSequence( ms3, K4, 4 );;
gap> PrintLnUsingLabels( J4, genfms3, s3labs ); 
[ [ 1, G ], [ -3, id ], [ 2, F*G*F ], [ 2, F ], [ -3, F ], 
[ 1, id ], [ -3, f ], [ 2, F*G ] ]

## Example 6.2.4
gap> J4 := InverseLogSequence( J4 );; 
gap> PrintLnUsingLabels( J4, genfms3, s3labs ); 
[ [ -2, F*G ], [ 3, f ], [ -1, id ], [ 3, F ], [ -2, F ], [ -2, F*G*F ], 
[ 3, id ], [ -1, G ] ]

## Example 6.2.5 
gap> J4K5 := Concatenation( J4, K5 );; 
gap> J4K5 := CancelImmediateInversesLogSequence( J4K5 );; 
gap> PrintLnUsingLabels( J4K5, genfms3, s3labs ); 
[ [ -2, F*G ], [ 3, f ], [ -1, id ], [ 3, F ], [ 1, id ], 
[ -3, f ], [ 2, F*G ], [ -3, F*G ] ]
gap> J4K5 := CancelInversesLogSequence( ms3, J4K5 ); 
[ ]



## Example 6.3 
gap> mq8 := MonoidPresentationFpGroup( q8 );;
gap> fmq8 := FreeGroupOfPresentation( mq8 );;
gap> genfmq8 := GeneratorsOfGroup(fmq8 );;
gap> q8labs := ["a","b","A","B"];; 
gap> SetMonoidPresentationLabels( mq8, q8labs );; 
gap> idsq8 := IdentityRelatorSequences( q8 );;          
gap> lenidsq8 := Length( idsq8 );                                   
28
gap> List( idsq8, L -> Length(L) );
[ 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7, 8, 8, 8, 
  9, 10, 10 ]

## Example 6.3.1  
gap> rulesq8 := LogSequenceRewriteRules( mq8 );;
gap> for i in [1..Length(rulesq8)] do 
>        PrintLnUsingLabels( rulesq8[i], genfmq8, q8labs );
>    od;
[ [ 1, a ], [ 1, id ] ]
[ [ -1, a ], [ -1, id ] ]
[ [ 1, A ], [ 1, id ] ]
[ [ -1, A ], [ -1, id ] ]
[ [ 2, b ], [ 2, id ] ]
[ [ -2, b ], [ -2, id ] ]
[ [ 2, B ], [ 2, id ] ]
[ [ -2, B ], [ -2, id ] ]
[ [ 3, a*b*a*B ], [ 3, id ] ]
[ [ 3, b*A*B*A ], [ 3, id ] ]
[ [ -3, a*b*a*B ], [ -3, id ] ]
[ [ -3, b*A*B*A ], [ -3, id ] ]
[ [ 4, a^2*b^2 ], [ 4, id ] ]
[ [ 4, B^2*A^2 ], [ 4, id ] ]
[ [ -4, a^2*b^2 ], [ -4, id ] ]
[ [ -4, B^2*A^2 ], [ -4, id ] ]

## Example 6.3.2a 
gap> J7 := idsq8[7];
[ [ 1, <identity ...> ], [ -1, q8_M3^2 ] ]
gap> OnePassReduceLogSequence( J7, rulesq8 );
[ [ 1, <identity ...> ], [ -1, <identity ...> ] ]

## Example 6.3.2b
gap> ridsq8 := ReduceLogSequences( q8, idsq8 );;
gap> lenrids := Length( ridsq8 );                                   
15
gap> for i in [1..lenrids] do                                
>        PrintLnUsingLabels( ridsq8[i], genfmq8, q8labs );   
>    od;
[ [ -2, id ], [ 2, b ] ]
[ [ -1, id ], [ 1, a ] ]
[ [ -4, id ], [ 2, A^2 ], [ 1, id ], [ -4, a^2 ] ]
[ [ -4, id ], [ 3, A ], [ 4, a ], [ -3, b ] ]
[ [ 1, id ], [ -4, id ], [ 2, A^2 ], [ -4, A^2 ] ]
[ [ -4, id ], [ 3, A ], [ 3, id ], [ 2, id ], [ -4, b ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A ], [ 1, id ], [ -3, a ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A^2 ], [ 1, id ], [ -3, B ] ]
[ [ -4, id ], [ 3, A ], [ -4, A ], [ 2, A^3 ], [ 1, id ], 
[ -3, b ] ]
[ [ -4, id ], [ 4, B*A^2 ], [ -4, A^2 ], [ 1, id ], [ 2, id ], 
[ -4, b ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A ], [ 3, A^2 ], [ 4, id ], 
[ -4, B ] ]
[ [ -4, id ], [ 3, A ], [ 4, B*A ], [ -4, A ], [ 1, id ], 
[ -3, a ], [ 4, B ], [ -1, b ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A ], [ 3, A^2 ], [ 4, B*A^2 ], 
[ -4, A^2 ], [ 1, id ], [ -1, B ] ]
[ [ 4, id ], [ -4, b ], [ 1, b ], [ -3, a^2*b ], [ 4, B*a*b ], 
[ -4, a*b ], [ 3, b ], [ -1, id ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A ], [ 1, id ], [ -4, a ], 
[ 2, A ], [ 1, id ], [ -4, a^2 ], [ -3, B ] ] 

## Example 6.3.3
gap> J3 := ShallowCopy( ridsq8[3] );;                            
gap> PrintLnUsingLabels( J3, genfmq8, q8labs );   
[ [ -4, id ], [ 2, A^2 ], [ 1, id ], [ -4, a^2 ] ]
gap> K3 := MoveRightLogSequence( mq8, J3, [3], 4 );;
gap> PrintLnUsingLabels( K3, genfmq8, q8labs );    
[ [ -4, id ], [ 2, A^2 ], [ -4, A^2 ], [ 1, id ] ]
gap> J5 := ShallowCopy( ridsq8[5] );; 
gap> PrintLnUsingLabels( J5, genfmq8, q8labs );
[ [ 1, id ], [ -4, id ], [ 2, A^2 ], [ -4, A^2 ] ]
gap> J5 = ChangeStartLogSequence( mq8, K3, 4 );
true

## Example 6.3.4a
gap> K5 := MoveRightLogSequence( mq8, J5, [2], 3 );;
gap> PrintLnUsingLabels( K5, genfmq8, q8labs );       
[ [ 1, id ], [ 2, id ], [ -4, id ], [ -4, A^2 ] ]
gap> K5a := K5{[1..2]};; 
gap> K5b := InverseLogSequence( K5{[3..4]} );;
gap> K5a;K5b;
[ [ 1, <identity ...> ], [ 2, <identity ...> ] ]
[ [ 4, q8_M3^2 ], [ 4, <identity ...> ] ]
gap> J10 := ShallowCopy( ridsq8[10] );;
gap> PrintLnUsingLabels( J10, genfmq8, q8labs );
[ [ -4, id ], [ 4, B*A^2 ], [ -4, A^2 ], [ 1, id ], [ 2, id ], 
[ -4, b ] ]
gap> K10 := SubstituteLogSubsequence( mq8, J10, K5a, K5b );;
gap> PrintLnUsingLabels( K10, genfmq8, q8labs );            
[ [ -4, id ], [ 4, B*A^2 ], [ -4, A^2 ], [ 4, A^2 ], [ 4, id ], 
[ -4, b ] ]
gap> CancelInversesLogSequence( mq8, K10 );
[  ]

## Example 6.3.4b 
gap> J9 := ShallowCopy( ridsq8[9] );; 
gap> PrintLnUsingLabels( J9, genfmq8, q8labs );            
[ [ -4, id ], [ 3, A ], [ -4, A ], [ 2, A^3 ], [ 1, id ], 
[ -3, b ] ]
gap> K9 := MoveLeftLogSequence( mq8, J9, [5], 4 );; 
gap> PrintLnUsingLabels( K9, genfmq8, q8labs );            
[ [ -4, id ], [ 3, A ], [ -4, A ], [ 1, id ], [ 2, a ], [ -3, b ] ]
gap> L9 := ConjugateByWordLogSequence( mq8, K9, genfmq8[3] );;
gap> PrintLnUsingLabels( L9, genfmq8, q8labs );            
[ [ -4, A ], [ 3, A^2 ], [ -4, A^2 ], [ 1, id ], [ 2, id ], 
[ -3, b*A ] ]
gap> M9 := SubstituteLogSubsequence( mq8, L9, K5a, K5b);;
gap> PrintLnUsingLabels( M9, genfmq8, q8labs );            
[ [ -4, A ], [ 3, A^2 ], [ -4, A^2 ], [ 4, A^2 ], [ 4, id ], 
[ -3, b*A ] ]
gap> N9 := CancelInversesLogSequence( mq8, M9 );;
gap> PrintLnUsingLabels( N9, genfmq8, q8labs );            
[ [ -4, A ], [ 3, A^2 ], [ 4, id ], [ -3, b*A ] ]
gap> P9 := ConjugateByWordLogSequence( mq8, N9, genfmq8[1] );;
gap> PrintLnUsingLabels( P9, genfmq8, q8labs );            
[ [ -4, id ], [ 3, A ], [ 4, a ], [ -3, b ] ]
gap> P9 = ridsq8[4];
true

## Example 6.4.1
gap> idrelq8 := IdentitiesAmongRelators( q8 );;
gap> Length( idrelq8 );
14
gap> for i in [1..14] do 
>       PrintLnUsingLabels( idrelq8[i], genfmq8, q8labs ); 
>    od; 
[ [ -1, id ], [ 1, a ] ]
[ [ -2, id ], [ 2, b ] ]
[ [ -4, id ], [ 3, A ], [ 3, id ], [ 2, id ], [ -4, b ] ]
[ [ -4, id ], [ 2, A^2 ], [ 1, id ], [ -4, a^2 ] ]
[ [ 1, id ], [ -4, id ], [ 2, A^2 ], [ -4, A^2 ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A ], [ 1, id ], [ -3, a ] ]
[ [ -4, id ], [ 3, A ], [ 4, a ], [ -3, b ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A^2 ], [ 1, id ], [ -3, B ] ]
[ [ -4, id ], [ 4, B*A^2 ], [ -4, A^2 ], [ 1, id ], [ 2, id ], 
[ -4, b ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A ], [ 3, A^2 ], [ 4, id ], 
[ -4, B ] ]
[ [ -4, id ], [ 3, A ], [ -4, A ], [ 2, A^3 ], [ 1, id ], 
[ -3, b ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A ], [ 1, id ], [ -4, a ], 
[ 2, A ], [ 1, id ], [ -4, a^2 ], [ -3, B ] ]
[ [ -4, id ], [ 3, A ], [ 4, B*A ], [ -4, A ], [ 1, id ], 
[ -3, a ], [ 4, B ], [ -1, b ] ]
[ [ -3, id ], [ 4, B*A ], [ -4, A ], [ 3, A^2 ], [ 4, B*A^2 ], 
[ -4, A^2 ], [ 1, id ], [ -1, B ] ]

## Example 6.4.2
gap> idyseq8 := IdentityYSequences( q8 );; 
gap> for y in idyseq8 do 
>        PrintLnYSequence( y, genfmq8, q8labs, genq8R, q8Rlabs ); 
>    od; 
q8_Y2*(1*A), q^-1*(-1*A) + q*(1*id)) 
q8_Y1*(1*B), r^-1*(-1*B) + r*(1*id)) 
q8_Y6*(-1*id), r*(-1*id) + s*(-1*A + -1*id) + t^-1*(1*b + 1*id)) 
q8_Y3*(-1*a), q*(-1*a) + r*(-1*A) + t^-1*(1*A + 1*a)) 
q8_Y5*(-1*a), q*(-1*a) + r*(-1*A) + t^-1*(1*A + 1*a)) 
q8_Y7*(1*a*b), q*(1*a*b) + s^-1*(-1*a*b + -1*B) + t^-1*(-1*b) + t*(1*id)) 
q8_Y4*(1*A), s^-1*(-1*a*b) + s*(1*a^2) + t^-1*(-1*A) + t*(1*id)) 
q8_Y8*(1*a*b), q*(1*a*b) + s^-1*(-1*a*b + -1*A) + t^-1*(-1*a*B) + t*(1*id)) 
q8_Y10*(1*B), q*(1*B) + r*(1*B) + t^-1*(-1*B + -1*b + -1*id) + t*(1*id)) 
q8_Y11*(1*b), s^-1*(-1*b) + s*(1*B) + t^-1*(-1*a*B + -1*id) + t*(1*b + 1*a)) 
q8_Y9*(-1*a), q*(-1*a) + r*(-1*a^2) + s^-1*(1*a*B) + s*(-1*id) + t^-1*(1*a + 
1*id)) 
q8_Y15*(1*a*b), q*(2*a*b) + r*(1*b) + s^-1*(-1*a*b + -1*A) + t^-1*(-1*a*B + 
-1*B + -1*b) + t*(1*id)) 
q8_Y12*(1*b), q^-1*(-1*a^2) + q*(1*b) + s^-1*(-1*a*b) + s*(1*a*B) + t^-1*(
-1*a*B + -1*b) + t*(1*a + 1*id)) 
q8_Y13*(1*a*b), q^-1*(-1*A) + q*(1*a*b) + s^-1*(-1*a*b) + s*(1*a*B) + t^-1*(
-1*a*B + -1*b) + t*(1*a + 1*id)) 

## Example 6.5.1 
gap> F := FreeGroup(3);;
gap> u := F.1;;  v := F.2;;  w := F.3;;
gap> rels := [ u^3, v^2, w^2, (u*v)^2, (v*w)^2 ];;
gap> q0 := F/rels;;
gap> SetArrangementOfMonoidGenerators( q0, [1,-1,2,-2,3,-3] );
gap> SetName( q0, "q0" );
gap> mq0 := MonoidPresentationFpGroup( q0 );;
gap> fmq0 := FreeGroupOfPresentation( mq0 );;
gap> genfmq0 := GeneratorsOfGroup( fmq0 );;
gap> q0labs := ["u","U","v","V","w","W"];; 
gap> SetMonoidPresentationLabels( mq0, q0labs );; 
gap> lrws := LoggedRewritingSystemFpGroup( q0 );;
gap> pe1 := PartialElementsOfMonoidPresentation( q0, 1 );; 
gap> PrintLnUsingLabels( pe1, genfmq0, q0labs ); 
[ id, u, U, v, w ]
gap> pe2 := PartialElementsOfMonoidPresentation( q0, 2 );;
gap> PrintLnUsingLabels( pe2, genfmq0, q0labs ); 
[ id, u, U, v, w, u*v, u*w, U*v, U*w, v*w, w*u, w*U ]

gap> SetInfoLevel( InfoIdRel, saved_infolevel_idrel );; 

#############################################################################
##
#E  idrels.tst . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

