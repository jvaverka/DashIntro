#=
The |DashCoreComponents| package includes a component called |graph|.
|graph| renders interactive data visualizations using the open source
plotly.js JavaScript graphing library.

Plotly.js supports over 35 chart types and renders charts in both
vector-quality SVG and high-performance WebGL.

The |figure| argument in the |dcc_graph| component is the same
|figure| argument that is used by plotly.py, Plotly's open-source
Python graphing library. Check out the plotly.py documentation and
gallery to learn more.

Here's an example that creates a scatter plot from a |DataFrame|.
=#
using DataFrames, CSV, PlotlyJS, RDatasets
using Dash, DashHtmlComponents, DashCoreComponents


iris = dataset("datasets", "iris")

p1 = Plot(iris,
          x=:SepalLength,
          y=:SepalWidth,
          mode="markers",
          marker_size=8,
          group=:Species)

app = dash()

app.layout = html_div() do
    html_h4("Iris Sepal Length vs Sepal Width"),
    dcc_graph(
        id = "example-graph-3",
        figure = p1,
    )
end

run_server(app, "0.0.0.0", debug=true)
