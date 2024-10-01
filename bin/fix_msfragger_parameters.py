#!/usr/bin/env python3

import argparse

def main():
    """
    Script for injecting the database path into the msfragger parameter file

    """
    parser = argparse.ArgumentParser(description="MSFragger Parameter File Database Injection")
    parser.add_argument(
        "-p",
        "--parameter_file",
        dest="parameter_file",
        required=True,
        help="Input msfragger parameter to alter",
        metavar="FILE",
    )
    parser.add_argument(
        "-d",
        "--database",
        dest="database",
        required=True,
        help="Path to the database to inject into the msfragger parameter file",
        metavar="FILE",
    )

    args = parser.parse_args()

    # Read the file and update the database_name line
    with open(args.parameter_file, 'r') as file:
        lines = file.readlines()

    updated_lines = []
    for line in lines:
        if line.startswith('database_name'):
            print("Adding database: {} to msfraggger parameter file".format(args.database))
            updated_lines.append(f'database_name = {args.database}\n')
        else:
            updated_lines.append(line)

    # Write the updated content back to a new file
    with open(args.parameter_file, 'w') as file:
        file.writelines(updated_lines)

    print(f'File has been updated and saved to {args.parameter_file}')

if __name__ == "__main__":
    main()