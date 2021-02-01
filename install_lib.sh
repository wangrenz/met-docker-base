#!/bin/bash
source /etc/profile
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib

cd /opt/src/ && unzip jasper-1.900.1.zip && cd jasper-1.900.1 && ./configure --prefix=/usr/local && make install \
    && cd /opt/src/ && tar xvf szip-2.1.1.tar.gz && cd szip-2.1.1 && ./configure  --prefix=/usr/local && make install \
    && cd /opt/src/ && tar xvf hdf5-1.12.0.tar.bz2 && cd hdf5-1.12.0 && ./configure --enable-fortran --with-szlib=/usr/local --prefix=/usr/local && make -j8 install \
    && cd /opt/src/ && tar xvf netcdf-c-4.7.4.tar.gz && cd netcdf-c-4.7.4 && ./configure --disable-dap --prefix=/usr/local && make -j4 install \
    && cd /opt/src/ && tar xvf netcdf-fortran-4.5.3.tar.gz && cd netcdf-fortran-4.5.3 && ./configure --prefix=/usr/local && make -j4 install
