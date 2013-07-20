fantasy_payroll: calculate your take home pay in most states
============================================================


About
-----
Intuit has a site to determine federal, state, and local income
taxes for every state at http://payroll.intuit.com/paycheck_calculators/ --
but, it turns out that site is just using a REST API to pull down
per-state information.

This project accesses the API for every state at once to show you
that while your take home pay is $74,366 in California, for the
same salary, your take home pay would be $100,467 in any of the
no-state-income-tax states of Alaska, Florida, Nevada, New Hampshire,
South Dakota, Tennessee, Texas, Washington, Wyoming.

Status
------
It works as of this upload.  Intuit reserves the right to block
access or change their API at any given time with no notice.

Usage
-----
Note: the results are all async.  They'll come back jumbled.
If you want to sort anything, I recommend copying the output,
pasting to a file, then using standard command line utilities
from there.  (example: `cat saved-results |colrm 1 1 |sort -n`)

Double note: This procedure has some fatal flaws (like not letting you specify
deductions).  In fact, it assumes no deductions or allowances.
These are worst case scenario numbers.  For more accurate predictions,
visit the intuit paycheck calculator directly (but then you have to
go state-by-state yourself).

    matt@nibonium:~/repos/fantasy_payroll% erl -pa ebin deps/*/ebin
    Erlang R16B (erts-5.10.1) [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]
    
    Eshell V5.10.1  (abort with ^G)
    1> fantasy_payroll:run_payroll(260000).
    done
    $128114.00 after $-131885.00 in total taxes on $260000.00 in Idaho.
    $134615.00 after $-125384.00 in total taxes on $260000.00 in Kansas.
    $147338.00 after $-112661.00 in total taxes on $260000.00 in Wyoming.
    $133798.00 after $-126201.00 in total taxes on $260000.00 in Massachusetts.
    $147338.00 after $-112661.00 in total taxes on $260000.00 in New Hampshire.
    $134338.00 after $-125661.00 in total taxes on $260000.00 in Utah.
    $131113.00 after $-128886.00 in total taxes on $260000.00 in Rhode Island.
    $126703.00 after $-133296.00 in total taxes on $260000.00 in Maine.
            Skipping Alabama because: Cannot complete your request without work site county and work site city.
            Skipping Indiana because: Cannot complete your request without residence county, work site county, residence city, and work site city.
            Skipping West Virginia because: Cannot complete your request without residence county, work site county, residence city, and work site city.
    $132405.00 after $-127594.00 in total taxes on $260000.00 in Virginia.
            Skipping Pennsylvania because: Cannot complete your request without residence county, work site county, residence city, and work site city.
    $127295.00 after $-132704.00 in total taxes on $260000.00 in Wisconsin.
    $133708.00 after $-126291.00 in total taxes on $260000.00 in Oklahoma.
    $147087.00 after $-112912.00 in total taxes on $260000.00 in Alaska.
    $139065.00 after $-120934.00 in total taxes on $260000.00 in North Dakota.
    $134078.00 after $-125921.00 in total taxes on $260000.00 in Arizona.
    $147338.00 after $-112661.00 in total taxes on $260000.00 in Tennessee.
    $126820.00 after $-133179.00 in total taxes on $260000.00 in Hawaii.
            Skipping Maryland because: Cannot complete your request without residence county.
    $134242.00 after $-125757.00 in total taxes on $260000.00 in Louisiana.
            Skipping Missouri because: Cannot complete your request without work site county and work site city.
    $109282.00 after $-150717.00 in total taxes on $260000.00 in California.
    $131751.00 after $-128248.00 in total taxes on $260000.00 in Georgia.
    $134611.00 after $-125388.00 in total taxes on $260000.00 in New Mexico.
            Skipping Michigan because: Cannot complete your request without residence county, work site county, residence city, and work site city.
            Skipping Ohio because: Cannot complete your request without residence county, work site county, residence city, and work site city.
    $134348.00 after $-125651.00 in total taxes on $260000.00 in Mississippi.
    $124249.00 after $-135750.00 in total taxes on $260000.00 in Vermont.
    $134338.00 after $-125661.00 in total taxes on $260000.00 in Illinois.
            Skipping Oregon because: Cannot complete your request without number of hours worked.
    $129150.00 after $-130849.00 in total taxes on $260000.00 in South Carolina.
    $130222.00 after $-129777.00 in total taxes on $260000.00 in Montana.
    $127219.00 after $-132780.00 in total taxes on $260000.00 in North Carolina.
    $122487.00 after $-137512.00 in total taxes on $260000.00 in New York.
    $129309.00 after $-130690.00 in total taxes on $260000.00 in Nebraska.
    $147338.00 after $-112661.00 in total taxes on $260000.00 in Nevada.
    $147338.00 after $-112661.00 in total taxes on $260000.00 in Florida.
    $129169.00 after $-130830.00 in total taxes on $260000.00 in Arkansas.
    $147338.00 after $-112661.00 in total taxes on $260000.00 in Washington.
    $147338.00 after $-112661.00 in total taxes on $260000.00 in South Dakota.
            Skipping Colorado because: Cannot complete your request without work site county and work site city.
    $129918.00 after $-130081.00 in total taxes on $260000.00 in Connecticut.
            Skipping Delaware because: Cannot complete your request without residence county, work site county, residence city, and work site city.
    $133153.00 after $-126846.00 in total taxes on $260000.00 in Iowa.
    $121892.00 after $-138107.00 in total taxes on $260000.00 in Minnesota.
    $124175.00 after $-135824.00 in total taxes on $260000.00 in District Of Columbia.
    $147338.00 after $-112661.00 in total taxes on $260000.00 in Texas.
    $121972.00 after $-138027.00 in total taxes on $260000.00 in New Jersey.
    2>

Building
--------
    rebar get-deps
    rebar compile

Testing
-------
        no tests for you

Next Steps
----------
a fancy web interface would be nice.
long term cached results would be nice.
a pwny would be nice.
