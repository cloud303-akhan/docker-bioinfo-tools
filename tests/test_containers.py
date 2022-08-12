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
    version = get_version("conda -V", "mirbase")
    print(version.args)
    assert version.stdout.strip() == "conda 4.10.3"

def test_mirbclconvert():
    version = get_version("bcl-convert -V", "mirbclconvert")
    print(version.args)
    assert version.stderr.strip().split("\n")[0] == "bcl-convert Version 00.000.000.3.8.2-12-g85770e0b"

def test_mircheckfastq():
    version = get_version("biopet-validatefastq --version", "mircheckfastq")
    print(version.args)
    assert version.stderr.strip() == "Version: 0.1.1"

def test_mirchecksumdir():
    version = get_version("pip show checksumdir", "mirchecksumdir")
    print(version.args)
    assert version.stdout.split("\n")[1].strip() == "Version: 1.2.0"

def test_mirfastqc():
    version = get_version("fastqc -V", "mirfastqc")
    print(version.args)
    assert version.stdout.strip() == "FastQC v0.11.9"

def test_mirhtseq():
    version = get_version("htseq-count --help | tail -1", "mirhtseq")
    print(version.args)
    assert version.stdout.strip() == "Public License v3. Part of the 'HTSeq' framework, version 0.11.2."

def test_mirmultiqc():
    version = get_version("multiqc --version", "mirmultiqc")
    print(version.args)
    assert version.stdout.strip() == "multiqc, version 1.11"

def test_mirpandas():
    version = get_version("pip show pandas", "mirpandas")
    print(version.args)
    assert version.stdout.split("\n")[1].strip() == "Version: 1.3.2"

def test_mirpicard():
    version = get_version("picard MarkDuplicates --version", "mirpicard")
    print(version.args)
    assert version.stderr.strip() == "Version:2.26.0"

def test_mirrseqc():
    version = get_version("inner_distance.py --version", "mirrseqc")
    print(version.args)
    assert version.stdout.strip() == "inner_distance.py 4.0.0"

def test_mirsamtools():
    version = get_version("samtools --version | head -1", "mirsamtools")
    print(version.args)
    assert version.stdout.strip() == "samtools 1.9"

def test_mirstar():
    version = get_version("STAR --version", "mirstar")
    print(version.args)
    assert version.stdout.strip() == "STAR_2.6.1a_08-27"

def test_mirtrimmomatic():
    version = get_version("trimmomatic PE -version", "mirtrimmomatic")
    print(version.args)
    assert version.stdout.strip() == "0.39"