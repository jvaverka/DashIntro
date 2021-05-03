#= Storing Data in the Browser with a Hidden div

This example outlines how you can perform an expensive data processing step in
one callback, serialize the output as JSON, and provide it as an input to the
other callbacks. This example uses standard Dash callbacks and stores the
JSON-ifed data inside a hidden div in the app.
=#
global_df = DataFrame(CSV.File("..."))

app.layout = html_div() do
    dcc_graph(id="graph"),
    html_table(id="table"),
    dcc_dropdown(id="dropdown"),
    html_div(id="intermediate-value", style = (display = "None"))

end

callback!(
    app,
    Output("intermediate-value", "children"),
    Input("dropdown", "value"),
) do value

    dff = your_expensive_clean_or_compute_step(value)
    return JSON.json(dff)
end

callback!(
    app,
    Output("graph", "figure"),
    Input("intermediate-value", "children"),
) do dff

    figure = create_figure(dff)
    return figure
end

callback!(
    app,
    Output("table", "children"),
    Input("intermediate-value", "children"),
) do dff

    table = create_table(dff)
    return table
end
