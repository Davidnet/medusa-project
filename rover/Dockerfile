FROM balenalib/jetson-tx2-ubuntu:xenial

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget bzip2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Script get all the packages from official nvidia packages.
COPY ./packages/download.sh .

RUN bash download.sh

# Observation: We do not install numpy in a single pip given that it breaks with one dependency of hdf5
RUN \
    dpkg -i cuda-repo-l4t-9-0-local_9.0.252-1_arm64.deb \
    libcudnn7_7.1.5.14-1+cuda9.0_arm64.deb \
    libcudnn7-dev_7.1.5.14-1+cuda9.0_arm64.deb && \
    apt-key add /var/cuda-repo-9-0-local/*.pub && \
    apt-get update && \
    apt-get install cuda-toolkit-9-0 cuda-libraries-dev-9-0 -y && \
    dpkg -i libnvinfer4_4.1.3-1+cuda9.0_arm64.deb \
    libnvinfer-dev_4.1.3-1+cuda9.0_arm64.deb && \
    apt-get install  libnvinfer-dev && \
    rm -rf *.deb && \
    dpkg --remove cuda-repo-l4t-9-0-local && \
    dpkg -P cuda-repo-l4t-9-0-local && \
    ldconfig && \ 
    apt-get install --no-install-recommends libhdf5-serial-dev \
    hdf5-tools \
    libhdf5-dev \
    zlib1g-dev \
    zip \
    libjpeg8-dev \
    python-dev \
    pkg-config -y && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \ 
    rm get-pip.py && \ 
    pip install -U numpy==1.16.1 && \ 
    pip install future==0.17.1 \
    mock==3.0.5 \
    h5py==2.9.0 \
    keras_preprocessing==1.0.5 \
    keras_applications==1.0.6 \
    enum34 \
    futures \
    testresources \
    setuptools \
    protobuf && \
    pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v33 tensorflow-gpu && \
    rm -rf /var/lib/apt/lists/*



# FROM balenalib/jetson-tx2-ubuntu:xenial as final

# COPY --from=buildstep /usr /usr
# WORKDIR /usr/src/app


ENV DEBIAN_FRONTEND noninteractive

# Watch out for the libGL cp, we need a suitable version that cotains grm symbols to develop.
RUN apt-get update && apt-get install --no-install-recommends \
    bzip2 \
    xorg -y && \
    tar xjf nvidia_drivers.tbz2 -C / && \
    tar xjf config.tbz2 -C / --exclude=etc/hosts --exclude=etc/hostname && \
    echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && \
    cp /usr/lib/aarch64-linux-gnu/tegra/libGL.so.1 /usr/lib/aarch64-linux-gnu/mesa/ && \
    ldconfig && \
    tar xvf nv_tools.tbz2 -C / --exclude=/home && \
    tar xvf nvgstapps.tbz2 -C / && \
    bash -c "yes | gst-install --prefix=/usr --version=1.8.3" && \
    tar -C /usr/src/app --strip-components=2 -xvf nv_tools.tbz2 home/nvidia/ && \
    ln -s /etc/nvpmodel/nvpmodel_t186.conf /etc/nvpmodel.conf && \
    rm *.tbz2 && \
    rm -rf /var/lib/apt/lists/*

# These are the requesites of opencv 3.4.1
RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    cmake \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libeigen3-dev \
    libglew-dev \
    libgtk2.0-dev \
    libgtk-3-dev \
    libjasper-dev \
    libjpeg-dev \
    libpng12-dev \
    libpostproc-dev \
    libswscale-dev \
    libtbb-dev \
    libtiff5-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    qt5-default \
    zlib1g-dev \
    pkg-config && \
    wget https://raw.githubusercontent.com/jetsonhacks/buildOpenCVTX2/master/patches/OpenGLHeader.patch && \
    patch -N /usr/local/cuda/include/cuda_gl_interop.h OpenGLHeader.patch && \
    rm OpenGLHeader.patch && \
    pip install py pytest==4.6.6 && \
    apt-get install --no-install-recommends -y git && \
    git clone https://github.com/opencv/opencv.git && \
    cd opencv && git checkout -b v3.4.1 3.4.1 && \
    git merge ec0bb66 && git cherry-pick -n 549b5df && \
    mkdir build && cd build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
    #   -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
      -D WITH_CUDA=ON \
      -D CUDA_ARCH_BIN=6.2 \
      -D CUDA_ARCH_PTX="" \
      -D ENABLE_FAST_MATH=ON \
      -D CUDA_FAST_MATH=ON \
      -D WITH_CUBLAS=ON \
      -D WITH_LIBV4L=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_GSTREAMER_0_10=OFF \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      ../ && \
    make -j && make install && cd /usr/src/app && rm -rf opencv && \
    mkdir nvidia_utils && mv jetson_clocks.sh tegrastats nvidia_utils && \
    rm -rf /var/lib/apt/lists/*

COPY balena_configs/balena_start.sh .

# Add personalized dependencies in here
RUN \
    apt-get update && \
    apt-get install -y \ 
    vim && \
    rm -rf /var/lib/apt/lists/*

# Use this part to add enviroment variables that do not modify the cache
# Start a udev service
ENV UDEV=1


CMD [ "bash", "balena_start.sh" ]