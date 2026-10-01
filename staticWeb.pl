:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).

:- http_handler(root(.), http_reply_from_files("./web", []), [prefix]).

/*
 * startWebSolver(Port)
 *
 * Starts a web server on the given Port of localhost
 */
startWebSolver(Port) :-
  http_server(http_dispatch, [port(Port)]).


/*
 * startWebSolver
 *
 * Starts the server on a default port
 */
 startWebSolver :-
   startWebSolver(7000).
