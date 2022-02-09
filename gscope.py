#!/usr/bin/python3

import os
import sys
import argparse
import glob
import subprocess

extensions = ['.c', '.h', '.ci', '.cc', '.hh']

def do_main(destination, excludes, includes):

    if not os.path.isdir(destination):
        print(f"Invalid destination {destination}")
        sys.exit(1)

    excludes = filter(lambda x:os.path.isdir(os.path.join(os.getcwd(), x)), excludes)
    includes = filter(lambda x:os.path.isdir(os.path.join(os.getcwd(), x)), includes)

    excludes = map(lambda x:os.path.abspath(x), excludes)
    includes = map(lambda x:os.path.abspath(x), includes)

    excludes = list(excludes)
    includes = list(includes)
    print(f"includes {includes}")
    print(f"excludes {excludes}")

    flist = []
    for inc in includes:
        print(f"trying to walk {inc}")
        for root, dirs, files in os.walk(inc):

            # Make dirs a set, we'll be checking over it multiple times
            dirs_full = set(map(lambda x: os.path.join(root, x), dirs))
            for exc in excludes:
                if exc in dirs_full:
                    dirs.remove(os.path.basename(exc))

            for f in files:
                # Skip links
                if not os.path.isfile(os.path.join(root, f)):
                    continue

                base, ext = os.path.splitext(f)
                if ext in extensions:
                    flist.append(os.path.join(root, f))

    #find . \( -name cscope.in.out -o -name cscope.out -o -name cscope.po.out -o -name cscope.files \) -type f -exec rm {} \;
    if not flist:
        print("No files found!\n")
        sys.exit(1)

    cscope_files = {"cscope.in.out", "cscope.out", "cscope.po.out", "cscope.files"}
    for root, dirs, files in os.walk(destination):

        # Make dirs a set, we'll be checking over it multiple times
        dirs_full = set(map(lambda x: os.path.join(root, x), dirs))

        # Only remove cscope files from included subdirectories.
        #
        # e.g.
        #
        # /
        #  a/cscope.files
        #  b/
        #  c/
        #
        # If we're making a cscope base for b & c, but not a, don't blow away
        # the cscope files in a.
        incset = set(includes)
        for d in dirs_full:
            if d not in incset:
                dirs.remove(os.path.basename(d))

        for f in filter(lambda x: x in cscope_files, files):
            print(f"removing {os.path.join(root, f)}")
            os.remove(os.path.join(root, f))

    dst = os.path.join(destination, "cscope.files")
    print(f"Creating {dst}")
    with open(dst, 'w') as cf:
        for f in flist:
            print(f'"{f}"', file=cf)

    #cscope -b -q -k -i ./cscope.files
    os.chdir(destination)
    subprocess.check_output(["cscope", "-b", "-q", "-v", "-k", "-i", "./cscope.files"])


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Generate cscope files")
    parser.add_argument('-d', '--destination', default=".")
    parser.add_argument('-e', '--exclude', action='append', default=[])
    parser.add_argument('include', nargs='*', default=[])
    args = parser.parse_intermixed_args(sys.argv[1:])
    do_main(args.destination, args.exclude, args.include)
