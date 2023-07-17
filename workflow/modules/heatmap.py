from pathlib import Path
import pandas as pd
import plotly.express as px
import argparse
import json
import re


# The function generates a heatmap plot with clustering based on the similarity between pairwise comparisons of biological gene clusters (BGCs).

def generate_heatmap_w_clustering(fp_pw_blast:Path, member_to_cluster:dict): #, genera_tables_dir:Path
    # the blast file that we use here as input is the combined_blast after the python script for symmetrizing

    df_pairwise = pd.read_csv(fp_pw_blast, sep="\t", index_col=0)

    #Genera tables to get genus
    #genera_tables = Path(genera_tables_dir).glob("*_selected.tsv")
    # df_genera = pd.concat(
    #     pd.read_csv(genus_table, sep="\t")[["assembly_accession", "organism_name"]].assign(genus = genus_table.name.rsplit("_",1)[0])
    #     for genus_table in genera_tables
    # )
    # df_genera.sort_values("organism_name")



    # new DataFrame df_sorter_combined that includes information on the BGC,
    # sample name, contig, and cluster ID for each row in the DataFrame.

    df_sorter = pd.DataFrame({"bgc": df_pairwise.index.tolist()})
    df_sorter[["sample_name","contig"]] = df_sorter.bgc.str.split(pat="_",n=1, expand=True)
    df_sorter_combined = df_sorter
    #df_sorter_combined = df_sorter.merge(df_genera, on="assembly_accession")

    #add clustering:
    df_sorter_combined["clusterid"] = [member_to_cluster[bgc] for bgc in df_sorter_combined.bgc]


    # BGCs sorted on clusterid, sample name, and contig
    df_sorter_combined.sort_values(["clusterid","sample_name","bgc"], inplace=True, ascending=True)
    df_sorter_combined.reset_index(drop=True, inplace=True)
    ordered_sample = df_sorter_combined.bgc.values

    df_pairwise_sorted = df_pairwise.loc[ordered_sample,ordered_sample]

    #Generate ticks:
    tick_column = "clusterid" #organism_name, genus
    df_unique = df_sorter_combined[tick_column].drop_duplicates(keep="first")

    tick_boundaries = df_unique.index.tolist()+[len(df_sorter_combined)]
    tick_middle     = [(tick_boundaries[i]+tick_boundaries[i+1])/2 for i in range(len(tick_boundaries)-1)]

    tick_label = df_unique.values.tolist()

    axis_ = dict(
        tickmode = 'array',
        tickvals = tick_middle,
        ticktext = tick_label,
        tickson = "boundaries",
        showgrid=False,
        tickfont=dict(size=12)
    )

    # Generate plot:
    fig = px.imshow(df_pairwise_sorted.values,
            template="simple_white",
            labels= {
            'color':'similarity%',
            },
             )
    fig.update_xaxes(axis_)
    fig.update_yaxes(axis_)
    fig.update_layout(
        plot_bgcolor='rgba(0,0,0,1)',
        height=1000, width=1000,
        title = f'Similarity between BGCs of the input genomes sorted by ({tick_column})<br><sup>Similarity ratio of perfectly aligned bases to maximum possible aligned bases.',
    )
    return fig

if __name__ == "__main__":
    #load cluster results:
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--blast", required=True, type=Path) # path to the tsv file generated as an output of pairwaise blast
    #parser.add_argument("--genera-table-dir", required=True, type=Path)
    parser.add_argument("--mcl-cluster-dir", required=True, type=Path) # path to the mcl results directory
    parser.add_argument("-o", required=True, type=Path) # output directory
    args = parser.parse_args()



    fp_pw_blast = args.blast    #Path("../data/simulated_data_large/blast_pairwise/input_bgc/pairwise_table_symmetric.tsv")
    #genera_tables_dir = args.genera_table_dir   #Path("../data/simulated_data_large/input_genomes/genera_tables")
    cluster_jsons = Path(args.mcl_cluster_dir).glob("*mci.I*.json")   #Path("../data/simulated_data_large/mcl_clustering/").glob("*mci.I*")
    # From this I inderstand that MCL clustering generates json files with th clustering

    # starts with a period, followed by "mci", another period, "I", and one or more digits.
    regex_mcl_name = re.compile(r"\.(mci\.I\d+)")

    outdir = args.o
    outdir.mkdir(parents=True, exist_ok=True) # To create the directory if it does not exist

    for cluster_json in cluster_jsons:

        cluster_to_members = json.loads(cluster_json.read_text()) # creates a python dictionary
        # creates a dictionary, the member is the key, and the values are the cluster to which the member belongs
        member_to_cluster = {
            member:cluster
            for cluster, members in cluster_to_members.items()
            for member in members
        }

        # this creates the heatmap
        out_fig = generate_heatmap_w_clustering(
            fp_pw_blast       = fp_pw_blast,
            #genera_tables_dir = genera_tables_dir,
            member_to_cluster = member_to_cluster)

        # we look for the match in the json file
        regex_res = regex_mcl_name.search(cluster_json.name)
        if regex_res:
            name = regex_res.group(1)
        else:
            name = cluster_json.stem

        # stores the hetmap as png
        outfile = outdir / ("heatmap_"+name+".png")
        out_fig.write_image(outfile, width=1000, height=1000)
