import subprocess

def get_newest_tag(image:str, tag:str = "") -> str:
    """
    Parse output of `docker image ls` to get newest tag
    
    Args:
        image (str): image name
        tag (str): tag for given image. If empty, the newest tag is used
    
    Returns:
        string: a concatenated `image`:`tag` string
    """
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

def get_software_version_in_image(command:str, image:str = "", tag:str = "") -> subprocess.CompletedProcess:
    """ 
    Runs the given command in the given docker image:tag. If `tag` is empty,
    the newest tag for `image` is used. If `image` is empty, `command`
    is run on the host, not inside any container.
    
    Args:
        command (str): the command to execute; must not contain quotes
        image (str): name of docker image in which to run `command`. If empty,
            command is run on the host and not within a docker container.
        tag (str): tag of docker image to run `command` in. If empty, use newest tag
    
    Returns:
        subprocess.CompletedProcess: a dict of the executed command, return code,
            stdout and stderr
    """
    if not image:
        version = subprocess.run(
            command,
            capture_output=True,
            shell=True,
            text=True)
    else:
        version = subprocess.run(
            "docker run " + get_newest_tag(image, tag) + " '" + command + "'",
            capture_output=True,
            shell=True,
            text=True)
    return version

def test_docker():
    version = get_software_version_in_image("docker --version")
    print(version.args)
    assert version.stdout.strip() == "Docker version 20.10.17, build 100c701"

def test_mirbase():
    version = get_software_version_in_image("conda -V", "mirbase")
    print(version.args)
    assert version.stdout.strip() == "conda 4.10.3"
    
    version = get_software_version_in_image("bash --version", "mirbase")
    print(version.args)
    assert version.stdout.split("\n")[0].strip() == "GNU bash, version 4.2.46(2)-release (x86_64-koji-linux-gnu)"

def test_mirbclconvert():
    version = get_software_version_in_image("bcl-convert -V", "mirbclconvert")
    print(version.args)
    assert version.stderr.strip().split("\n")[0] == "bcl-convert Version 00.000.000.3.8.2-12-g85770e0b"

def test_mircheckfastq():
    version = get_software_version_in_image("biopet-validatefastq --version", "mircheckfastq")
    print(version.args)
    assert version.stderr.strip() == "Version: 0.1.1"
    
    version = get_software_version_in_image("fq lint --version", "mircheckfastq")
    print(version.args)
    assert version.stdout.strip() == "fq-lint 0.9.1 (2022-02-22)"

def test_mirchecksumdir():
    version = get_software_version_in_image("pip show checksumdir", "mirchecksumdir")
    print(version.args)
    assert version.stdout.split("\n")[1].strip() == "Version: 1.2.0"

def test_mirfastqc():
    version = get_software_version_in_image("fastqc -V", "mirfastqc")
    print(version.args)
    assert version.stdout.strip() == "FastQC v0.11.9"

def test_mirhtseq():
    version = get_software_version_in_image("htseq-count --help | tail -1", "mirhtseq")
    print(version.args)
    assert version.stdout.strip() == "Public License v3. Part of the 'HTSeq' framework, version 0.11.2."

def test_mirmultiqc():
    version = get_software_version_in_image("multiqc --version", "mirmultiqc")
    print(version.args)
    assert version.stdout.strip() == "multiqc, version 1.11"

def test_mirpandas():
    version = get_software_version_in_image("pip show pandas", "mirpandas")
    print(version.args)
    assert version.stdout.split("\n")[1].strip() == "Version: 1.3.2"

def test_mirpicard():
    version = get_software_version_in_image("picard MarkDuplicates --version", "mirpicard")
    print(version.args)
    assert version.stderr.strip() == "Version:2.26.0"
    
    version = get_software_version_in_image("picard CollectRnaSeqMetrics --version", "mirpicard")
    print(version.args)
    assert version.stderr.strip() == "Version:2.26.0"

def test_mirrseqc():
    version = get_software_version_in_image("inner_distance.py --version", "mirrseqc")
    print(version.args)
    assert version.stdout.strip() == "inner_distance.py 4.0.0"

def test_mirsamtools():
    version = get_software_version_in_image("samtools --version | head -1", "mirsamtools")
    print(version.args)
    assert version.stdout.strip() == "samtools 1.9"

def test_mirstar():
    version = get_software_version_in_image("STAR --version", "mirstar")
    print(version.args)
    assert version.stdout.strip() == "STAR_2.6.1a_08-27"

def test_mirtrimmomatic():
    version = get_software_version_in_image("trimmomatic PE -version", "mirtrimmomatic")
    print(version.args)
    assert version.stdout.strip() == "0.39"