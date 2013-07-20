-module(fantasy_payroll).

-compile(export_all).

-import(proplists, [get_value/2]).

-define(SOHOH, "SingleOrHeadOfHousehold").

run_payroll(HowMuch) when is_number(HowMuch) ->
  application:start(inets),
  application:start(crypto),
  application:start(public_key),
  application:start(ssl),
  Endpoints = get_endpoints(),
  Found = query_endpoints(Endpoints, HowMuch),
  Found.

urlget(URL) ->
  dourl(get, URL, []).

urlpost(URL, Body) ->
  dourl(post, URL, Body).

dourl(Type, URL, Body) ->
  Request = case Type of
              post -> {URL, [], "application/x-www-form-urlencoded", Body};
               get -> {URL, []}
            end,
  {ok, {{_HTTPVer, _StatusCode, _Reason}, _Headers, ResultBody}} =
    httpc:request(Type, Request, [], [{body_format, binary}]),
  ResultBody.

dejson(JsonBinary) ->
  mochijson2:decode(JsonBinary, [{format, proplist}]).

get_endpoints() ->
  BaseURL = "http://payroll.intuit.com/paycheck_calculators/embed/proxy",
  EndpointsJson = urlget(BaseURL),
  All = dejson(EndpointsJson),
  get_value(<<"statesSupported">>, All).

query_endpoints([], _) ->
  done;
query_endpoints([H|T], HowMuch) ->
  Fields = [{periodsInYear, 26},
            {federalFilingStatus, "Single"},
            {grossPay, HowMuch},
            {residenceFilingStatus, ?SOHOH},
            {workSiteFilingStatus, ?SOHOH},
            {workSiteCounty, ""},
            {workSiteCity, ""},
            {workSiteZip, ""}],
  QueryDo = mochiweb_util:urlencode(Fields),
  spawn(?MODULE, run_query, [HowMuch, H, QueryDo]),
  query_endpoints(T, HowMuch).

run_query(HowMuch, StateEndpoint, Fields) ->
  StateName = get_value(<<"name">>, StateEndpoint),
  StateURL = binary_to_list(get_value(<<"url">>, StateEndpoint)),
  Result = urlpost(StateURL, Fields),
  DecodedResult = dejson(Result),
%  io:format("Decoded is: ~p~n", [DecodedResult]),
  case get_value(<<"status">>, DecodedResult) of
       <<"ok">> -> Taxes = get_value(<<"employeeTaxes">>, DecodedResult),
                   show_results_for_state(StateName, HowMuch, Taxes);
    <<"error">> -> Error = get_value(<<"error">>, DecodedResult),
                   E = get_value(<<"e">>, Error),
                   io:format("\tSkipping ~s because: ~s~n", [StateName, E])
  end.

show_results_for_state(StateName, HowMuch, Taxes) ->
  PTotalTax = lists:foldl(fun(E, Acc) ->
                           Acc + get_value(<<"amount">>, E)
                         end,
                         0,
                         Taxes),
  AfterTax = trunc(HowMuch + PTotalTax),
  TotalTax = trunc(PTotalTax),
  io:format("$~p.00 after $~p.00 in total taxes on $~p.00 in ~s.~n", [AfterTax, TotalTax, HowMuch, StateName]).
