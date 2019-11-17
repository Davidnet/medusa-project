# The Medusa Project

Welcome to the **Medusa** a programming enviroment writen from scratch to provide a stable and managable code base for the kiwibot rover project.

## Why this project ?
We have been recollecting many old scripts and technically our old-code base (both rover and apollo) has been code smelly for a year. What I wanted to achive is:

  * The base image and requirements on the same repository.
  * Provide a more transparent package requirements.
  * An easy way to contribute and develop packages for kiwibot rover.
  * One click setup for installation of developer tools.

## Architecture

Most of the rover code is included on the folder `rover` folder, it should list the main Dockerfile for dependecies and the required nvidia packages for install.

#### The `rover/packages` folder

It includes a download script that searchs and decompress the nvidia packages for a balena accelerated container.

## Requirements:

A recommendation is to use [VS Code](https://code.visualstudio.com/) as the main IDE for development. Also:

   1. [docker-ce](https://docs.docker.com/install/)
   2. [docker-compose](https://docs.docker.com/compose/install/)

As far for installation requirements, the required secrets should be present in:

   1. `balena_cli_configs/token` --> Token so that `balena-cli` can work without problems. Get it on [balena access-tokens page](https://dashboard.balena-cloud.com/preferences/access-tokens)
   2. `ssh-keys/id_balena` and `ssh-keys/id_balena.pubkey` --> Pair of ssh keys that should be registered in [balena cloud](https://dashboard.balena-cloud.com/preferences/sshkeys)

Please stick to the provided names, otherwise it won't work as out-of-the-box. Also **DO NOT ADD SECRETS TO THE REPO**.

## Add-ons Provided
We are providing the [balena staged-releases](https://github.com/balena-io-projects/staged-releases) as a `git submodule`, you can init the submodule and change the required variables in:

   * `staged-releases/balena.env`

## Support

Contact `david@kiwicampus.com` for any questions and help.