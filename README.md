
<img width="1378" alt="image" src="https://user-images.githubusercontent.com/2119795/187248731-196fd4ad-36ef-4f81-a8d6-fc00dab73564.png">

# What is Brainlife?

Brainlife is a free and open source platform for neuroscience data management. The project promotes engagement and education in FAIR and reproducible neuroscience.

Brainlife is a single integrative interface to manage, visualize, preprocess and analyze data (fMRI, dMRI, anatomical MRI, EEG and MEG). THe platform also allows to publish all research assets associated with a scientific project (data, preprocessing services and data analysis notebooks) in a single record addressed by a digital-object-identifier (DOI). The platform is unique because of its focus on supporting scientific reproducibility beyond open code and open data, by providing fundamental smart mechanisms for what we refer to as “Open Services.” 

# Running brainlife Development Instance

!! This is still a WIP

## Prerequisite

You will need to have an environment with the following software packages

* docker / docker-compose 
* git

```
apt install docker-compose golang-docker-credential-helpers
```

## Prerequisite for gpu enabled novnc sessions

Not all novnc vis apps require GPU, but if you have nvidia gpu on your local machine, you should be
able to launch it by having these tools installed

* vglserver (run vglserver_config and allow all access)
* nvidia-docker2 (required to run vis app with `--gpus all` option. See https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installing-on-ubuntu-and-debian

The vis/Dockerfile installs specific version of libnvidia drivers. I believe the version must match with the
version of the driver installed on your host or vglrun won't work.

### docker-compose versions

Please make sure that you have the correct docker-compose version installed

```
docker-compose version
docker-compose version 1.29.2, build 5becea4c
docker-py version: 5.0.0
CPython version: 3.9.0
OpenSSL version: OpenSSL 1.1.1h  22 Sep 2020
```

Then git clone this repo and all of its submodules.

```
git clone https://github.com/brainlife/brainlife --recursive 
```

Then launch the dev stack (with auto-code watching) by

```
./dev.sh
```

### populate database with test accounts / data

Once all services starts up, you can open your browser to access the warehouse UI at `https://localhost:8080`. If this is the first time you are running the dev instance, you can insert some database records by running `./populatedb.sh`. This inserts the following collections.

* auth - user/group
* warehouse - datatypes/uis/apps

You can then login as administrator by entering user:admin password:admin123. 
You can also login as guest user by entering user:guest password:guest123

# Funding

This research was supported by NSF OAC-1916518, NSF IIS-1912270, NSF, IIS-1636893, NSF BCS-1734853, NIH 1R01EB029272-01, a Microsoft Research Award, A Microsoft Investigator Fellowship to Franco Pestilli
