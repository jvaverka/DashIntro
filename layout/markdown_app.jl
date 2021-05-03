#=
While Dash exposes HTML through the DashHtmlComponents package,
it can be tedious to write your copy in HTML.
For writing blocks of text, you can use the dcc_markdown component
in the DashCoreComponents package.
=#
using Dash, DashHtmlComponents, DashCoreComponents


app = dash()
markdown_text = "
### Dash and Markdown

Dash apps can be written in Markdown.
Dash uses the [CommonMark](http://commonmark.org/)
specification of Markdown.
Check out their [60 Second Markdown Tutorial](http://commonmark.org/help/)
if this is your first introduction to Markdown!
"

app.layout = html_div() do
    dcc_markdown(markdown_text)
end

run_server(app, "0.0.0.0", debug=true)
