:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).

:- http_handler(root(solve), webSolve, []).


/**
 * webSolve(Request)
 *
 * Handles a meta-interpreter web service request
 */
webSolve(Request) :-
	http_parameters(Request,
	    [
	    	solver(SolverString, [string]),
   			rule(RuleStrings, [list(string)]),
        goal(GoalString, [string])
	    ]
	),

  format("Content-type: text/plain~n~n"),
  format("  Solver: ~w~n  Rules: ~w~n  Goal: ~w~n~n", [SolverString, RuleStrings, GoalString]),

  webSolve(SolverString, RuleStrings, GoalString).



webSolve(SolverString, RuleStrings, GoalString) :-
  name(Solver, SolverString),

  buildLocalDb(RuleStrings, LocalDb),

  term_string(Goal, GoalString),

  printSolution(Solver, LocalDb, Goal).



:- begin_tests(webSolve).


test(basicStepSolveRequest) :-
  webSolve(
	  "stepSolve",

	  [
	    "p(16).",
	    "q(_).",
	    "r(X) :- 0 is (X mod 2).",
	    "z(X, Y) :- (p(X), q(Y), r(X))."
	  ],

	  "z(16,10)"
  ).


test(basicNestedSolveRequest) :-
  webSolve(
	  "nestedSolve",

	  [
	    "p(16).",
	    "q(_).",
	    "r(X) :- 0 is (X mod 2).",
	    "z(X, Y) :- (p(X), q(Y), r(X))."
	  ],

	  "z(16,10)"
  ).


:- end_tests(webSolve).


/**
 * printSolution(Solver, LocalDb, Goal)
 *
 * Calls the Solver function from within the global namespace,
 * passing the instance-specific LocalDb (a list of :- clauses) and the Goal
 */
printSolution(Solver, LocalDb, Goal) :-
  call(Solver, LocalDb, Goal),
  !,
  format("~nTRUE~n").


printSolution(_, _, _) :-
  format("~nFALSE~n").
