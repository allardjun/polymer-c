using PlotlyJS

function plot_kpoly_ratios(dictExp::Dict{String, Vector{Float64}}, dictSim::Dict{String, Vector{Float64}}, savefigsTF::Bool=false, savepath::String="construct")
    # Extract keys from the dictionaries (assumes both have the same keys)
    keys_dict = collect(keys(dictExp))  # Collect keys as an array to preserve order
    
    # Data arrays for plotting
    kpoly_sim_vals = []
    kpoly_sum_sim_vals = []
    kpoly_exp_vals = []
    kpoly_sum_exp_vals = []
    log2_ratios_sim = []
    log2_ratios_exp = []
    
    # Loop through the dictionary keys and collect the data
    for key in keys_dict
        # Simulated Kpoly values
        push!(kpoly_sim_vals, dictSim[key][1])
        push!(kpoly_sum_sim_vals, dictSim[key][2])
        
        # Experimental Kpoly values
        push!(kpoly_exp_vals, dictExp[key][1])
        push!(kpoly_sum_exp_vals, dictExp[key][2])
        
        # Calculate log2 ratios for Simulated and Experimental values
        push!(log2_ratios_sim, log2(dictSim[key][1] / dictSim[key][2]))
        push!(log2_ratios_exp, log2(dictExp[key][1] / dictExp[key][2]))
    end
    

    p = PlotlyJS.plot([
        PlotlyJS.bar(name="Simulated", x=keys_dict, y=log2_ratios_sim),
        PlotlyJS.bar(name="Experimental", x=keys_dict, y=log2_ratios_exp)],
        Layout(
            title="Simulated vs Experimental Log2 Ratios of Kpoly/Kpoly sum"
        )
    )
    relayout!(p, barmode="group")
    p
    if savefigsTF
        PlotlyJS.savefig(p,"$savepath/kpolyratio.png")
        display("saved kpolyratio.png")
    end

    p = PlotlyJS.plot([
        PlotlyJS.bar(name="kpoly", x=keys_dict, y=kpoly_sim_vals),
        PlotlyJS.bar(name="kpoly sum", x=keys_dict, y=kpoly_sum_sim_vals)],
        Layout(
            title="Simulated Kpoly values"
        )
    )
    relayout!(p, barmode="group")
    p
    if savefigsTF
        PlotlyJS.savefig(p,"$savepath/kpolysim.png")
        display("saved kpolysim.png")
    end

end
