using Dash, DashHtmlComponents, DashCoreComponents

#= |dash| command can be called with no args or we can use a
custom CSS stylesheet to modify the default styles of the elements =#
app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do
    html_h1("Hello Dash"),
    html_div("Dash: A web application framework for Julia"),
    dcc_graph(
        id = "example-graph-1",
        figure = (
            data = [
                (
                    x = ["giraffes", "orangutans", "monkeys"],
                    y = [20, 14, 23],
                    type = "bar",
                    name = "SF"
                ),
                (
                    x = ["giraffes", "orangutans", "monkeys"],
                    y = [12, 18, 29],
                    type = "bar",
                    name = "Montreal"
                ),
            ],
            layout = (title = "Dash Data Visualization", barmode="group")
        )
    )
end

run_server(app, "0.0.0.0", debug=true)
