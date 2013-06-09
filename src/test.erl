%% Author: root
%% Created: 2013-6-7
%% Description: TODO: Add description to test
-module(test).

%%
%% Include files
%%
-include("mongo_protocol.hrl").
%%
%% Exported Functions
%%
-compile(export_all).

%%
%% API Functions
%%

a() ->
	application:start(bson),
	application:start(mongodb),
	{ok, Connection} = mongo_connection:start_link({"127.0.0.1", 27017}, []),
	ok = mongo:do(safe, master, Connection, account, fun() ->
%% 		Teams = mongo:insert(fd, {name, <<"Yankees">>, home, {city, <<"New York">>, state, <<"NY">>}, league, <<"American">>}),
%% 		BostonTeam = mongo:find_one(fd, {name, "Yankees"}),
		BostonTeam = mongo:find_one(fd, {home, {city, <<"Boston">>, state, <<"MA">>}}),													 
		io:format("~p  ~n",[BostonTeam]),
		ok
	end).
b() ->
%% 	Test = erlang:atom_to_binary(fd,latin1),
%%     Test2 = erlang:list_to_binary(".files"),
%% 	
%% 	io:format("~p ~n",[Test]),
%% 	io:format("~p ~n",[Test2]),
%% 	
%% 	Temp = <<Test/binary, Test2/binary>>,
%% 	io:format("~p ~n",[Temp]),
	
	Temp = erlang:atom_to_list(fd) ++ ".files",
	io:format("~p ~n",[Temp]),
	ok.
d() ->
	application:start(bson),
	application:start(mongodb),
	{ok, Connection} = mongo_connection:start_link({"127.0.0.1", 27017}, []),
	ok = mongo:do(safe, master, Connection, account, fun() ->
%% 		mongo:delete(fd, {name, <<"Yankees">>})
		File = #gfs_file{filename = <<"test.txt">>},
%% 		File = #gfs_file{docid = <<"000009f0c53fb30b33000001">> },
		mongo:delete_file(fd, File)
	end).

f() ->
	application:start(bson),
	application:start(mongodb),
	{ok, Connection} = mongo_connection:start_link({"127.0.0.1", 27017}, []),
	mongo:do(safe, master, Connection, account, fun() ->
%% 		Cursor = mongo:find(fd.files, {}, {filename, "test.txt"}),
%% 		Result = mongo_cursor:rest(Cursor),
%% 		mongo_cursor:close(Cursor),
		Result = mongo:find_one(fd.files, {}, {filename, "test.txt"}),
		io:format("~p ~n",[Result])
	end),
	ok.


test() ->
	Test = <<134,0,0,0,7,95,105,100,0,0,0,9,153,197,63,179,66,205,0,0,2,2,
               102,105,108,101,110,97,109,101,0,9,0,0,0,116,101,115,116,46,116,
               120,116,0,16,108,101,110,103,116,104,0,4,0,0,0,16,99,104,117,
               110,107,83,105,122,101,0,0,0,4,0,9,117,112,108,111,97,100,68,97,
               116,101,0,59,77,175,29,63,1,0,0,2,109,100,53,0,33,0,0,0,53,99,
               57,53,57,55,102,51,99,56,50,52,53,57,48,55,101,97,55,49,97,56,
               57,100,57,100,51,57,100,48,56,101,0,0>>,
	Temp = bson_binary:get_document(Test),
	bson:lookup('_id',Temp),
	
	Test2 = <<22,0,0,0,7,95,105,100,0,0,0,9,153,197,63,179,66,205,0,0,
                      2,0>>,
	{Temp2,<<>>} = bson_binary:get_document(Test2),
	io:format("~p ~n",[Temp]),
	io:format("~p ~n",[Temp2]),
	
	Doc = {'_id', {<<0,0,9,153,197,63,179,66,205,0,0,2>>}},
	Temp3 = bson_binary:put_document(Doc),
	io:format("~p ~n",[Temp3]),
	
	ok.
%% Local Functions
%%
collection(Case) ->
	Now = now_to_seconds(erlang:now()),
	list_to_atom(atom_to_list(?MODULE) ++ "-" ++ atom_to_list(Case) ++ "-" ++ integer_to_list(Now)).

now_to_seconds({Mega, Sec, _}) ->
	(Mega * 1000000) + Sec.



