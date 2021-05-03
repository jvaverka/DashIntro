#=
In this example, the |value| property of the Slider component is the input
of the app and the output of the app is the |figure| property of the Graph
component. When the value of the Slider changes, Dash calls the callback
function with new value. The function filters the dataframe with this new
value, constructs a |figure| object, and returns it to the Dash app.
=#
using DataFrames, Dash, DashHtmlComponents, DashCoreComponents, PlotlyJS, UrlDownload

#=
Loading data into memory can be expensive.
By loading data at the start of the app instead of inside callback functions,
we ensure that this operation is only done with the app server starts. When a
user visits the app or interacts with the app, the data is already in memory. If possible, expensive initialization (like downloading or querying data) should be done in the global scope of the app instead of within callback functions.
=#
df1 = DataFrame(urldownload("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv"))

years = unique(df1[!, :year])

app = dash()

app.layout = html_div() do
    dcc_graph(id = "graph"),
    dcc_slider(
        id = "year-slider-1",
        min = minimum(years),
        max = maximum(years),
        marks = Dict([Symbol(v) => Symbol(v) for v in years]),
        value = minimum(years),
        step=nothing,
    )
end

#=
The callback does not modify the original data, it just creates copies of
the dataframe by filtering.

This is important:
    your callbacks should never mutate variables outside of their scope.
=#
callback!(
    app,
    Output("graph", "figure"),
    Input("year-slider-1", "value"),
) do selected_year
    return Plot(
        df1[df1.year .== selected_year, :],
        Layout(
            xaxis_type = "log",
            xaxis_title = "GDP Per Capita",
            yaxis_title = "Life Expectancy",
            legend_x = 0,
            legend_y = 1,
            hovermode = "closest",
            transition_duration = 500  # allows chart to update state smoothly
        ),
        x = :gdpPercap,
        y = :lifeExp,
        text = :country,
        group = :continent,
        mode = "markers",
        marker_size = 15,
        marker_line_color = "white",
    )
end

run_server(app, "0.0.0.0", debug=true)
