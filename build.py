import sys
import os
import subprocess
import shutil
from pynt import task

deps = [
    ]


def _compile_fnl(src, dst):
    x = subprocess.run(["fennel", "--compile", src], capture_output=True)
    print("<-> compiling " + str(src) + " => " + str(dst))
    if x.returncode != 0:
        print(x.stderr.decode() or x.stdout.decode())
        sys.exit()
    else:
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        with open(dst, "wb") as handle:
            handle.write(x.stdout)


def _compile_recursive(src_root, dst_root):
    for x, subfolder, files in os.walk(src_root):
        for item in files:
            src_filename = os.path.join(x, item)
            dst_filename = src_filename.replace(src_root, dst_root, 1).replace('.fnl', '.lua')
            _compile_fnl(src_filename, dst_filename)


def _clean_build():
    shutil.rmtree("./build", ignore_errors=True)


def _clean_pycache():
    shutil.rmtree("./__pycache__", ignore_errors=True)


def _clean_depcopy():
    for d in deps:
        shutil.rmtree(os.path.join("./src", d["name"]), ignore_errors=True)


@task()
def clean():
    '''clean build folder and __pycache__'''
    _clean_build()
    _clean_pycache()
    _clean_depcopy()


@task()
def dupdate():
    '''update dependencies'''
    _clean_depcopy()
    os.makedirs(os.path.dirname("./deps"), exist_ok=True)

    for d in deps:
        if d["kind"] == "local":
            pass
        elif d["kind"] == "git":
            print("<-> cloning " + d["location"] + " into " + os.path.join("./deps", d["name"]))
            x = subprocess.run(["git", "clone", d["location"], os.path.join("./deps", d["name"])], capture_output=True)

            print("<-> moving " + os.path.join("./deps", d["name"], "src") + " to " + os.path.join("./src", d["name"]))
            #HACK
            y = subprocess.run(["cp", "-r", os.path.join("./deps", d["name"], "src"), os.path.join("./src", d["name"])], capture_output=True)


@task()
def assets():
    '''copy asset folder'''
    x = subprocess.run(["mkdir", "-p", os.path.join("./build", "assets")], capture_output=True)
    y = subprocess.run(["cp", "-r", os.path.join("./assets"), os.path.join("./build")], capture_output=True)


@task(clean, dupdate, assets)
def build():
    '''build entire project'''
    _compile_recursive("./src", "./build")


@task()
def wipe():
    '''wipe downloaded dependencies'''
    shutil.rmtree(os.path.join("./deps"), ignore_errors=True)

@task(build)
def debug():
    #x = subprocess.run(["love", "./build"], capture_output=True)
    p = subprocess.Popen(["love", "./build"])
    p.wait()

__DEFAULT__=debug
