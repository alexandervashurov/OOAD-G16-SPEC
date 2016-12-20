%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrTest/1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% msrMetaModel Unit Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%-----------------------------------------------
% CoreTypes
%-----------------------------------------------

msrTest([[messimMetaModel,unit,1,1],
         [[target,isTypeOf],
          [context,Context],
          [inputParameters,InputParameters],
          [outputParameters,OutputParameters],
          [comments,Comments],
          TestResult]
        ]):-
((
%% Context Declaration
%% N.A.

%% Input Parameters Declaration
ATypeNameAtom = _ ,
msrVar(ptBoolean,AptBoolean),

%% Output Parameters Declaration

%% Context Specification
%% N.A.

%% Input Parameters Specification
ATypeNameAtom = ptBoolean ,
AptBoolean = [ptBoolean , true ],

%% Output Parameters Specification

%% Test Case Specification
Target = isTypeOf,
ParametersList = 
[ ATypeNameAtom,
  AptBoolean
],
GoalGet=..[Target | ParametersList],

%% Oracle specification
OracleGet=..[true]
)
->
%% Test Interpretation
((GoalGet,!)
-> ((OracleGet,!)
   -> TestResult = [success]
   ; TestResult = [failedAtOracle])
; TestResult = [failedAtGoal]
)
; TestResult = [failedAtTestDeclarationOrSpecification]
),
%% Test Outcome
Context = [],
InputParameters = [['ATypeNameAtom',ATypeNameAtom],
                   ['AptBoolean',AptBoolean]
                  ],
OutputParameters = [],
Comments = 'test isTypeOf ptBoolean with a known ptBoolean.'
.
%-----------------------------------------------

msrTest([[messimMetaModel,unit,1,2],
         [[target,isTypeOf],
          [context,Context],
          [inputParameters,InputParameters],
          [outputParameters,OutputParameters],
          [comments,Comments],
          TestResult]
        ]):-
((
%% Context Declaration
%% N.A.

%% Input Parameters Declaration
ATypeNameAtom = _ ,
msrVar(ptBoolean,AptBoolean),

%% Output Parameters Declaration

%% Context Specification
%% N.A.

%% Input Parameters Specification
ATypeNameAtom = ptBoolean ,
AptBoolean = [ptBoolean , bonjour ],

%% Output Parameters Specification

%% Test Case Specification
Target = isTypeOf,
ParametersList = 
[ ATypeNameAtom,
  AptBoolean
],
GoalGet=..[Target | ParametersList]
)
->
%% Oracle specification
OracleGet=..[false],

%% Test Interpretation
((GoalGet,!)
-> ((OracleGet,!)
   -> TestResult = [success]
   ; TestResult = [failedAtOracle])
; TestResult = [failedAtGoal]
)
; TestResult = [failedAtTestDeclarationOrSpecification]
),
%% Test Outcome
Context = [],
InputParameters = [['ATypeNameAtom',ATypeNameAtom],
                   ['AptBoolean',AptBoolean]
                  ],
OutputParameters = [],
Comments = 'test isTypeOf ptBoolean with a known ptBoolean.'
.
%-----------------------------------------------
% msrMetaModel::isSubType
%-----------------------------------------------

msrTest([[messimMetaModel,unit,1,1],
         [[target,isSubType],
          [context,Context],
          [inputParameters,InputParameters],
          [outputParameters,OutputParameters],
          [comments,Comments],
          TestResult]
        ]):-
((
%% Context Declaration
%% N.A.

%% Input Parameters Declaration
ATypeNameAtom = _ ,
AsubtypeVariable = _ ,

%% Output Parameters Declaration
ASubTypesList= _ ,

%% Context Specification
%% N.A.

%% Input Parameters Specification
ATypeNameAtom = dtString ,

%% Output Parameters Specification

%% Test Case Specification
Target = isSubType,
ParametersList = 
[ AsubtypeVariable,
  ATypeNameAtom
],
GoalGet=.. [',',
            FirstGoalGet=..[Target|ParametersList],
            findall(AsubtypeVariable,
                    FirstGoalGet,
                    ASubTypesList)
           ],

%% Oracle specification
OracleGet=..[true]
)
->
%% Test Interpretation
((GoalGet,!)
-> ((OracleGet,!)
   -> TestResult = [success]
   ; TestResult = [failedAtOracle])
; TestResult = [failedAtGoal]
)
; TestResult = [failedAtTestDeclarationOrSpecification]
),
%% Test Outcome
Context = [],
InputParameters = [['ATypeNameAtom',ATypeNameAtom],
                   ['AsubtypeVariable','_']
                  ],
OutputParameters = [['ASubTypesList',ASubTypesList]],
Comments = 'Returns all the subtypes of dtString in the current system'
.
%-----------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Messam Simulator Unit Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%-----------------------------------------------

%-----------------------------------------------
