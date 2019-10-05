from pathlib import Path

import subprocess
import sys

def panic(message):
    print(f"ERROR: {message}")
    exit()

def load_args():
    if (len(sys.argv) < 2):
        panic("You need to specify the base directory")
    
    config = {}

    config["base_dir"] = sys.argv[1]
    config["src_dir"]  = f"{sys.argv[1]}/src"
    config["out_dir"]  = f"{sys.argv[1]}/bin/debug/cerberus"
    config["compiler"] = "g++"
    config["flags"]    = "-Wall -Wextra"

    return config

def is_cpp_file(filename):
    return filename.split(".")[-1] == "cpp"

def cpp_files(folder_path):
    path         = Path(folder_path)
    files        = []
    nested_files = []

    if (not path.is_dir()):
        panic(f"{folder_path} is not a directory! exiting...")

    files        = [child.resolve().as_posix() for child in path.iterdir() if not child.is_dir() and is_cpp_file(child.name)]
    nested_files = [cpp_files(child) for child in path.iterdir() if child.is_dir()]

    return nested_files + files

def flat(items):
    flattened = []

    for item in items:
        if (isinstance(item, list)):
            flattened += flat(item)
        else:
            flattened.append(item)

    return flattened

def stringify(items, separator=" "):
    return separator.join(items)

def make_cmd(compiler, src, out, flags=""):
    return f"{compiler} {src} -o {out} {flags}"

def run_cmd(cmd):
    subprocess.run(cmd)

config = load_args()
run_cmd(make_cmd(config["compiler"], stringify(flat(cpp_files(config["src_dir"]))), config["out_dir"], config["flags"]))