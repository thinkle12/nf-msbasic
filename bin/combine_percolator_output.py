#!/usr/bin/env python3

import argparse
import pandas as pd

def main():
    """
    Script for combining the target and decoy percolator output into one file

    """
    parser = argparse.ArgumentParser(description="Combine Percolator Results")
    parser.add_argument(
        "-t",
        "--target_file",
        dest="target_file",
        required=True,
        help="Target Percolator Result File",
        metavar="FILE",
    )
    parser.add_argument(
        "-d",
        "--decoy_file",
        dest="decoy_file",
        required=True,
        help="Decoy Percolator Result File",
        metavar="FILE",
    )

    parser.add_argument(
        "-o",
        "--output_file",
        dest="output_file",
        required=True,
        help="Combined Target and Decoy Percolator Result File",
        metavar="FILE",
    )

    args = parser.parse_args()

    # Read the target and decoy files with pandas
    target_psms = pd.read_csv(args.target_file, sep="\t")
    decoy_psms = pd.read_csv(args.decoy_file, sep="\t")

    # Stack them
    stacked_df = pd.concat([target_psms, decoy_psms])

    # Sort by the 'score' column in descending order
    sorted_df = stacked_df.sort_values(by='score', ascending=False).reset_index(drop=True)

    # Write back out to tsv
    sorted_df.to_csv(args.output_file, sep="\t", index=False)


if __name__ == "__main__":
    main()