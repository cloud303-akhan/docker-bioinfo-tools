import subprocess
import os
import logging
from datetime import datetime

LOGGER = logging.getLogger(__name__)
logging.basicConfig(
    format="%(asctime)-15s [%(levelname)s] %(funcName)s: %(message)s",
    level=logging.INFO,
    #place log file in user's home dir
    filename=os.path.expanduser('~') + "/docker-bioinfo-tools_test_log.txt",
    filemode='a'
)

def get_git_commit_tag() -> str:
    """
    Attempt to read git commit tag from the path of this script.
    
    Returns:
       string: the git commit tag or "UNKNOWN"
    """
    bashCommand = "git rev-parse HEAD"
    process = subprocess.Popen(
        bashCommand.split(),
        stdout=subprocess.PIPE,
    )
    commit, error = process.communicate()
    if error is None:
        return commit.decode("utf-8").strip("\n")[8:]
    else:
        return "UNKNOWN"

def get_newest_tag(image:str, tag:str = "") -> str:
    """
    Parse output of `docker image ls` to get newest tag for given docker image
    
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

def get_software_version_in_image(command:str, 
                                  image:str, 
                                  tag:str = "") -> subprocess.CompletedProcess:
    """ 
    Runs the given command in the given docker image:tag. If `tag` is empty,
    the newest tag for `image` is used. If `image` is empty, `command`
    is run on the host, not inside any container.
    
    Args:
        command (str): the command to execute; must not contain quotes
        image (str): name of docker image in which to run `command`.
        tag (str): tag of docker image to run `command` in. If empty, use newest tag
    
    Returns:
        subprocess.CompletedProcess: a dict of the executed command, return code,
            stdout and stderr
    """
    version = subprocess.run(
        "docker run " + get_newest_tag(image, tag) + " '" + command + "'",
        capture_output=True,
        shell=True,
        text=True)
    return version

def test_docker():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" +
                get_git_commit_tag() + "]")
    version = subprocess.run(
        "docker --version",
        capture_output=True,
        shell=True,
        text=True)
    assert version.stdout.strip() == "Docker version 20.10.17, build 100c701"

def test_mirbase():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" +
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("conda -V", "mirbase")
    assert version.stdout.strip() == "conda 4.10.3"
    
    version = get_software_version_in_image("bash --version", "mirbase")
    assert version.stdout.split("\n")[0].strip() == \
        "GNU bash, version 4.2.46(2)-release (x86_64-koji-linux-gnu)"

def test_mirbclconvert():
    """
    Reads `stderr` to get `bcl-convert` version
    """
    LOGGER.info(str(datetime.now()) + " starting test on commit [" +
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("bcl-convert -V", "mirbclconvert")
    assert version.stderr.strip().split("\n")[0] == \
        "bcl-convert Version 00.000.000.3.8.2-12-g85770e0b"

def test_mircheckfastq():
    """
    Reads `stderr` for `biopet-validatefastq` version
    """
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("biopet-validatefastq --version",
                                            "mircheckfastq")
    assert version.stderr.strip() == "Version: 0.1.1"
    
    version = get_software_version_in_image("fq lint --version", "mircheckfastq")
    assert version.stdout.strip() == "fq-lint 0.9.1 (2022-02-22)"

def test_mirchecksumdir():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("pip show checksumdir", "mirchecksumdir")
    assert version.stdout.split("\n")[1].strip() == "Version: 1.2.0"

def test_mirfastqc():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("fastqc -V", "mirfastqc")
    assert version.stdout.strip() == "FastQC v0.11.9"

def test_mirhtseq():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("htseq-count --help | tail -1", "mirhtseq")
    assert version.stdout.strip() == \
        "Public License v3. Part of the 'HTSeq' framework, version 0.11.2."

def test_mirmultiqc():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("multiqc --version", "mirmultiqc")
    assert version.stdout.strip() == "multiqc, version 1.11"

def test_mirpandas():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("pip show pandas", "mirpandas")
    assert version.stdout.split("\n")[1].strip() == "Version: 1.3.2"

def test_mirpicard():
    """
    Reads `stderr` to get picard MarkDuplicates and CollectRnaSeqMetrics versions
    """
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("picard MarkDuplicates --version",
                                            "mirpicard")
    assert version.stderr.strip() == "Version:2.26.0"
    
    version = get_software_version_in_image("picard CollectRnaSeqMetrics --version", 
                                            "mirpicard")
    assert version.stderr.strip() == "Version:2.26.0"

def test_mirrseqc():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("inner_distance.py --version", "mirrseqc")
    assert version.stdout.strip() == "inner_distance.py 4.0.0"

def test_mirsamtools():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("samtools --version | head -1",
                                            "mirsamtools")
    assert version.stdout.strip() == "samtools 1.9"

def test_mirstar():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("STAR --version", "mirstar")
    assert version.stdout.strip() == "STAR_2.6.1a_08-27"

def test_mirtrimmomatic():
    LOGGER.info(str(datetime.now()) + " starting test on commit [" + 
                get_git_commit_tag() + "]")
    version = get_software_version_in_image("trimmomatic PE -version", "mirtrimmomatic")
    assert version.stdout.strip() == "0.39"
