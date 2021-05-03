#=
In some cases, you might have a "form"-type pattern in your appliication. I
n such a situation, you might want to read the value of the input component,
but only when the user is finished entering all of his or her information
in the form.

Attaching a callback to the input values directly can look like this:
=#
using Dash, DashHtmlComponents, DashCoreComponents


app = dash()

app.layout = html_div() do
    dcc_input(id = "input-1", type = "text", value = "Montreal"),
    dcc_input(id = "input-2", type = "text", value = "Canada"),
    html_div(id = "output-keywords")
end

callback!(
    app,
    Output("output-keywords", "children"),
    Input("input-1", "value"),
    Input("input-2", "value"),
) do input_1, input_2
    return "Input 1 is \"$input_1\" and Input 2 is \"$input_2\""
end

run_server(app, "0.0.0.0", debug=true)

#=
In this example, the callback function is fired whenever any of the attributes
described by the |Input| change.
=#
