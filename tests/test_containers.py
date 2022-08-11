import subprocess

def get_newest_tag(image, tag = ""):
    """Parse output of `docker image ls` to get newest tag"""
    if not tag:
        image_tag = subprocess.run(
            "docker image ls | grep " + image +
                " | head -1 | tr -s ' ' | cut -d ' ' -f 1,2 --output-delimiter=':'",
            capture_output=True,
            shell=True,
            text=True).stdout.strip()
    else: 
        image_tag = image + ":" + tag
    return image_tag

def get_version(command, image, tag = ""):
    """ 
    Runs the given command in the given docker image:tag. If tag is empty,
    the newest tag for the image is used.
    """
    version = subprocess.run(
        "docker run " + get_newest_tag(image, tag) + " '" + command + "'",
        capture_output=True,
        shell=True,
        text=True)
    return version
    
def test_mirbase():
    conda_version = get_version("conda -V", "mirbase")
    assert conda_version.stdout.strip() == "conda 4.10.3"

def test_mirbclconvert():
    bclconvert_version = get_version("bcl-convert -V", "mirbclconvert")
    assert bclconvert_version.stderr.strip().split("\n")[0] == "bcl-convert Version 00.000.000.3.8.2-12-g85770e0b"

def test_mirfastqc():
    fastqc_version = get_version("fastqc -V", "mirfastqc")
    assert fastqc_version.stdout.strip() == "FastQC v0.11.9"

def test_mirhtseq():
    htseq_version = get_version("htseq-count --help | tail -1", "mirhtseq")
    assert htseq_version.stdout.strip() == "Public License v3. Part of the 'HTSeq' framework, version 0.11.2."

def test_mirpicard():
    picard_version = get_version("picard MarkDuplicates --version", "mirpicard")
    assert picard_version.stderr.strip() == "Version:2.26.0"

def test_mirrseqc():
    rseqc_version = get_version("inner_distance.py --version", "mirrseqc")
    assert rseqc_version.stdout.strip() == "inner_distance.py 4.0.0"

def test_mirsamtools():
    samtools_version = get_version("samtools --version | head -1", "mirsamtools")
    assert samtools_version.stdout.strip() == "samtools 1.9"

def test_mirstar():
    star_version = get_version("STAR --version", "mirstar")
    assert star_version.stdout.strip() == "STAR_2.6.1a_08-27"

def test_mirtrimmomatic():
    trimmomatic_version = get_version("trimmomatic PE -version", "mirtrimmomatic")
    assert trimmomatic_version.stdout.strip() == "0.39"
