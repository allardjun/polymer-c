using PlotlyJS

# Sample data
categories = ["A", "B", "C"]  # Categories on x-axis
groups = ["Group 1", "Group 2", "Group 3"]  # Different groups
values = [10 15 20; 12 18 25; 8 10 15]  # Rows represent categories, columns represent groups
colors = ["red", "blue", "green"]  # Different colors for groups

# Create bar traces in a loop
traces = PlotlyJS.AbstractTrace[]  # Ensure it's a vector of PlotlyJS traces
for (i, group) in enumerate(groups)
    push!(traces, PlotlyJS.bar(
        x=categories,
        y=values[:, i],
        name=group,
        marker=attr(color=colors[i])
    ))
end

# Create the layout for grouped bars
layout = Layout(
    barmode="group",  # Grouped bars
    title="Grouped Bar Chart",
    xaxis_title="Category",
    yaxis_title="Value"
)

# Plot
PlotlyJS.plot(traces, layout)  # This should now work

