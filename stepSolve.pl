/**
 * stepSolve(LocalDb, Goal)
 *
 * Meta-interpreter printing out every resolution step
 */

stepSolve(_, true) :- !.


stepSolve(LocalDb, (LeftGoal, RightGoal)) :-
  !,
  format("Solving conjunction: (~w),(~w)...~n", [LeftGoal, RightGoal]),
  stepSolve(LocalDb, LeftGoal),
  stepSolve(LocalDb, RightGoal).


stepSolve(LocalDb, LocalGoal) :-
  findRule(LocalDb, LocalGoal, RuleBody),
  !,
  format("Solving local goal: ~w...~n", [LocalGoal]),
  stepSolve(LocalDb, RuleBody).


stepSolve(_, GlobalGoal) :-
  format("Solving global goal: ~w...~n", [GlobalGoal]),
  catch(GlobalGoal, _, fail).



:- begin_tests(stepSolve).

test(solveTrue) :-
  stepSolve(_, true).


test(solveLocalGoal) :-
  stepSolve(
    [
      p(16) :- true
    ],

    p(16)
  ).


test(solveGlobalGoal) :-
  stepSolve(_, 57 =:= 50 + 7).


test(solveAnd) :-
  stepSolve(
    [
      p(16) :- true,
      q(_) :- true
    ],

    (p(16), q(30))
  ).

:- end_tests(stepSolve).
