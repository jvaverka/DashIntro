#=
So far all the callbacks we've written only update a single Output property.
We can also update several at once: put all the properties you want to update
as inputs to the callback, and return that many items from the callback.
This is particularly nice if two outputs depend on the same computationaly
intense itermediate result, such as a slow database query.
=#
using Dash, DashHtmlComponents, DashCoreComponents

app = dash()

app.layout = html_div() do
    dcc_input(id = "input-4", value = "1", type = "text"),
    html_tr((html_td("x^2 ="), html_td(id = "square"))),
    html_tr((html_td("x^3 ="), html_td(id = "cube"))),
    html_tr((html_td("2^x ="), html_td(id = "twos"))),
    html_tr((html_td("3^x ="), html_td(id = "threes"))),
    html_tr((html_td("x^x ="), html_td(id = "xx")))
end

callback!(
    app,
    Output("square", "children"),
    Output("cube", "children"),
    Output("twos", "children"),
    Output("threes", "children"),
    Output("xx", "children"),
    Input("input-4", "value"),
) do x
    if x == "" || x == nothing
        return ("", "", "", "", "")
    end

    x = parse(Int64, x)
    return (x^2, x^3, 2^x, 3^x, x^x)
end

run_server(app, "0.0.0.0", debug=true)

#=
A word of caution: it's not always a good idea to combine Outputs,
even if you can:

 -- If the Outputs depend on some but not all of the same inputs,
    keeping them separate can avoid unneccessary updates.

 -- If they have the same inputs but do independent computations
    with these same inputs, keeping the callbacks separate can allow
    them to run in parallel.
=#
