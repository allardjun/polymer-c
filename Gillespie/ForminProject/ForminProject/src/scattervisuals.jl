using Plots

function scattervisuals(fname, title, saveloc)
    outDict=ForminProject.makeOutputDict(fname)

    data_matrixpr, x1, y1, z1=ForminProject.visualizeStats(outDict, "Prvec0")
    data_matrixpo, x1, y1, z1=ForminProject.visualizeStats(outDict, "POcclude")

    data_matrixpr_self=data_matrixpr[findall(data_matrixpr[:, 5] .== 0),:];
    data_matrixpr_noself=data_matrixpr[findall(data_matrixpr[:, 5] .!= 0),:];
    data_matrixpo_self=data_matrixpo[findall(data_matrixpo[:, 5] .== 0),:];
    data_matrixpo_noself=data_matrixpo[findall(data_matrixpo[:, 5] .!= 0),:];

    makescattervisualplots(data_matrixpr, "Prvec0", title, title, saveloc)
    makescattervisualplots(data_matrixpr_self, "Prvec0", "only self; " * title, title * "_self", saveloc, true)
    makescattervisualplots(data_matrixpr_noself, "Prvec0", "no self; " * title, title * "_no_self",  saveloc)

    makescattervisualplots(data_matrixpo, "POcclude", title, title, saveloc)
    makescattervisualplots(data_matrixpo_self, "POcclude", "only self; " * title, title * "_self", saveloc, true)
    makescattervisualplots(data_matrixpo_noself, "POcclude", "no self; " * title, title * "_no_self", saveloc)


end

function makescattervisualplots(data_matrix, type, title, savetitle, saveloc, onlyself=false)
    p=Plots.plot(data_matrix[:,6],data_matrix[:,1],seriestype=:scatter,zcolor=data_matrix[:,2],color= palette(:tab10),markeralpha=0.6)
    Plots.title!(type * " vs num bound; " * title)
    display(p)
    filename = joinpath([saveloc, type * "_num_bound_vs_" * savetitle * ".png"])
    Plots.savefig(p, filename)

    if onlyself
        return
    end
    p=Plots.plot(data_matrix[:,7],data_matrix[:,1],seriestype=:scatter,zcolor=data_matrix[:,2],color= palette(:tab10),markeralpha=0.6)
    Plots.title!(type * " vs min dist prod; " * title)
    display(p)
    filename = joinpath([saveloc, type * "min_dist_prod" * savetitle * ".png"])
    Plots.savefig(p, filename)

    p=Plots.plot(data_matrix[:,5],data_matrix[:,1],seriestype=:scatter,zcolor=data_matrix[:,2],color= palette(:tab10),markeralpha=0.6)
    Plots.title!(type * " vs min dist; " * title)
    display(p)
    filename = joinpath([saveloc, type * "min_dist" * savetitle * ".png"])
    Plots.savefig(p, filename)
end