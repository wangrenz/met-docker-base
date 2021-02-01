FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN apt update && apt install apt-transport-https ca-certificates -y
COPY sources.list /etc/apt/sources.list
# install OS tools

RUN apt update && apt -y install procps less unzip build-essential cmake gcc gfortran g++ \
 vim m4 make perl-base tar tcsh git time wget zlib1g-dev libpng-dev libxrender1 libfontconfig1 lftp curl openssh-server openmpi-bin


# Set environment for interactive container shells
#
RUN echo export CC=gcc >> /etc/profile \ 
 && echo export FC=gfortran >> /etc/profile \
 && echo export CXX=g++ >> /etc/profile \
#  && echo export I_MPI_CC=icc >> /etc/profile \
#  && echo export I_MPI_CXX=icpc >> /etc/profile \
#  && echo export I_MPI_F77=ifort >> /etc/profile \
#  && echo export I_MPI_F90=ifort >> /etc/profile \
 && echo export HDF5=/usr/local >> /etc/profile \
 && echo export NETCDF=/usr/local >> /etc/profile \
 && echo export JASPERINC=/usr/local/include/jasper/ >> /etc/profile \
 && echo export JASPERLIB=/usr/local/lib/ >> /etc/profile \
 && echo export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} >> /etc/profile

# install szip hdf5 netcdf
COPY jasper-1.900.1.zip /opt/src/jasper-1.900.1.zip
COPY szip-2.1.1.tar.gz /opt/src/szip-2.1.1.tar.gz
COPY hdf5-1.12.0.tar.bz2 /opt/src/hdf5-1.12.0.tar.bz2
COPY netcdf-c-4.7.4.tar.gz /opt/src/netcdf-c-4.7.4.tar.gz
COPY netcdf-fortran-4.5.3.tar.gz /opt/src/netcdf-fortran-4.5.3.tar.gz

COPY install_lib.sh /opt/src/install_lib.sh
RUN chmod +x /opt/src/install_lib.sh && /opt/src/install_lib.sh


# install python pack
RUN apt install python3-pip -y && pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
 && alias pip3='pip3 --timeout=1000' \
 && pip3 install numpy \
 && pip3 install pendulum \
 && pip3 install scipy \
 && pip3 install psutil \
 && pip3 install pendulum \
 && pip3 install pexpect \
 && pip3 install pyproj \
 && pip3 install netCDF4 \
 && pip3 install packaging \
 && pip3 install cython \
 && pip3 install requests \
 && pip3 install f90nml \
 && pip3 install jinja2 \
 && pip3 install xarray pandas xlrd wrf-python

# install WRF
COPY WRF-4.2.2.tar.gz /opt/src/WRF-4.2.2.tar.gz
COPY WPS-4.2.tar.gz /opt/src/WPS-4.2.tar.gz
COPY wrf-scripts /opt/wrf-scripts
RUN /bin/bash -c "mkdir /opt/{WPS,WRF,WRFDA,WRFPLUS} && cd /opt/src && tar xvf WRF-4.2.2.tar.gz && tar xvf WPS-4.2.tar.gz \
 && cp -rf /opt/src/WRF-4.2.2/* /opt/WRF/ && cp -rf /opt/src/WRF-4.2.2/* /opt/WRFDA/ && mv /opt/src/WRF-4.2.2/* /opt/WRFPLUS/ \
 && mv /opt/src/WPS-4.2/* /opt/WPS/"

RUN /bin/bash -c "source /etc/profile &&  /opt/wrf-scripts/bin/build_wrf.py -c /opt -g -s gnu"

#RUN mkdir /var/run/sshd && mkdir /root/.ssh
# CMD ["/usr/sbin/sshd", "-D"]

RUN useradd -ms /bin/bash -d /home/arryn arryn
USER arryn
