#= Computing Aggregations Upfront

Sending the computed data over the network can be expensive if the data is
large. In some cases, serializing this data and JSON can also be expensive.

In many cases, your app will only display a subset or an aggregation of the
computed or filtered data. In these cases, you could precompute your
aggregations in your data processing callback and transport these aggregations
to the remaining callbacks.

Here's a simple example of how you might transport filtered or aggregated data
to multiple callbacks.
=#
callback!(
    app,
    Output("intermediate-value", "children"),
    Input("dropdown", "value"),
) do value

    df = your_expensive_clearn_or_compute_step(value)

    # a few filter steps that compute the data
    # as it's needed in the future callback

    df1 = filter(row -> row.Fruit == "apples")
    df2 = filter(row -> row.Fruit == "oranges")
    df3 = filter(row -> row.Fruit == "figs")

    datasets = Dict("df1"=>JSON.json(df1), "df2"=>JSON.json(df2), "df3"=>JSON.json(df3))
    return JSON.json(datasets)
end

callback!(
    app,
    Output("graph", "figure"),
    Input("intermediate-value", "children"),
) do dff

    figure = create_figure_1(dff)
    return figure

end

callback!(
    app,
    Output("graph", "figure"),
    Input("intermediate-value", "children"),
) do dff

    figure = create_figure_2(dff)
    return figure

end

callback!(
    app,
    Output("graph", "figure"),
    Input("intermediate-value", "children"),
) do dff

    figure = create_figure_3(dff)
    return figure

end
