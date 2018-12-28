## Introduction
--------------------------------------------------------------------------------

Data has been collected at a national level for a long period of time. The size
of the data is unique in terms of size and complexity. It is neither small
enough for desktop processing nor big enough for a cluster. We define this a
medium sized slow data. We develop a minimal, open-source, free toolkit for the
collection, storage, analysis and dissemination of the information. We start by
looking at the size and complexity of our data set. Make a list of requirements.
Choose tools for each requirement and finally integrate all the tools to put
together a complete took kit that suits our needs finally we do some test case
scenarios and evaluate performance of our toolkit.

## Literature on Big data
--------------------------------------------------------------------------------

Big data is defined as data which cannot be handled with traditional methods.
but there are also other definitions/ dimensions of this. The famous one is the
3Vs definition where volume, velocity and variety (Laney 2001). There are more
like cardinality, continuity and complexity as well (suthaharan 2014) and
additional vs are proposed as well. For my research I follow the 5V approach.
 
 - volume
 - variety
 - velocity
 - veracity and
 - visualisation

Need for parallelised tools for data processing. 

We need to think about the development of a tool kit which suits our data set in
all these aspects


## footfall data - Big data?
--------------------------------------------------------------------------------

### volume 

volume of the data in different perspectives. number of records, size on disk vs
yearly, monthly vs location and overall. The data is not trivial amount. but at
the same time it is not in league of big data as well.it is medium in terms of
volume. We are not at GBs but at the same time we are not at PBs we are around
TBs but can grow into PBs if the number of locations scaled or the time period
scaled.

### velocity

The velocity is every 5 minutes. This is close to real-time but not close to
real time as many bigdata systems have it the data also has a strong temporal
regularity as well. the basic unit being daily. we genearte around xx
data/records every minutes. This again in the middle of both stuff it is neither
slow nor fast data. It is somewhere in between.

### variety

The footfall data collected by smart street sensor is does not exhibit much
variability or complexity. It is pretty plain. There are few information we
collect and the strucutre of the data is plain. the underlying standards for the
format deosn't change enough and every data point is almost standardised.

### veracity

This is the dimension at which the data is truly big data. The data is dirty. Is
not complete in lot of ways. It doesn't has full coverage. The vcoverage
changes. The people captured has bias towards ownership. The way phones send
data is varied and changes with time. The data needs a lot of quality control
and processing to get to a point where it can be used with confidence. It also
needs a lot thought in terms of fit for purpose.

### visualisation 

This again falls in the same range as that of the first three.  The spatial
dimension of the data is easily visulaisable, but the temporal granularity is
hard to visualise in smaller scales. aggregation is also a challange because of
the veracity of the data which in turn makes visualisation harder. The temporal
dimension needs more of a dynamic or interactive visualisation techniques.

## Requirements from a toolkit
--------------------------------------------------------------------------------

Things we look to do with the data

Acquisition and recording extraction, cleaning and annotation integration
Aggregation and representation Modeling and analysis Interpretation


### Acquisition and recording

This is the sensor level stuff. We need hardware and software.  hardware -
portable - flexible - wifi - 3G - repurposable - some kind of storage software -
on the fly customisation, software to control the hardware (kernel/OS)
- software to connect to the server - software to collect wifi - software to pre
  process - obfuscate personal data. Need to quickly transfer the data back to
  server.

### Data extraction, Cleaning and Annotation

Get the data from sensor - Asynchronous, scalable way. Parallelised way to get
bulk data from data store. Store data in large containers. transforming data
between format - obfuscation in a large scale, encryption for security.

### Integration Aggregation and Representation

We need systems to standardise and store data. This need to be done quickly and
reliably. This needs to be easily filtered and queried and accessed for various
purposes - further research, presentation etc. The tool kit need to be able to
establish standards and interoperable with other purpose built tools. Need for
interfaces through which the data can be accessed and viewed. Need for systems
to distribute large volumes in a consistent way.

### Modeling and Analysis

This is where we need to keep the balance between both flexibilty and speed. We
need to be able to time series analysis of the data. Aggregate them to time
frames and make meaningful indices out of them. Anamoly detection in the series
of data and finally modelling and predicting flows between locations based on
the volumes reported at them.

### Visualisation and Interpretation

Visualisation need to be simple and legible. There needs to be some form of
interactivity without compromising the performance. Time series, Geographic
element, some of the comparision element. Indcies. some form of flow and change
visualisation. Needs to be easily exportable to various formats. Reading,
interactive.

## Comparison of tools
--------------------------------------------------------------------------------

Base machine - Raspberry pi, custom module, audrino etc
Operating system - Windows integrated machine, Linux (debian, gentoo etc) ARM
based.
Wifi dump - TCPdump, wireshark.
Platform - Nodejs, pm2, forever, screen etc 
3G module - Huawei hardware, 3g modem software.
hashing MAC address - Nodejs, R etc.

data receiving - Azure platform with Blob storage, Postgres with node server
data download - Azure, Custom software to periodically download stuff. Scala,
Spark.
Transforming data - Reading data with R and convert to csv. Using python or
other languages. compiled simple unix tool - jq. Parallelising using gnu
parallel.

On one end we have dekstop tools like R
other end high speed processing like scala and spark.
in the middle we can combine R and Parallel to achieve parallel stuff 

Spatial data could not be handled with either ArcGIS but with base gdal, proj
and geos libraries alogn with PostgreSQL we can solve this too.

The unix philosophy of
 1. Write programs that do one thing and do it well.
 2. Write programs to work together.
 3. Write programs to handle text streams, because that is a universal interface.

Our toolkit shall have programs that do one thing well
R for statistical analysis
azcopy for downloading data
gnupg for advanced encryption
openssl for basic cryptography
jq for filtering and transforming json data
AWK for filtering and transforming tabular data
gdal for spatial data transformation
PostgreSQL for data storage, indexing and retrieval
Shell for combining these programs into pipeline
gnu-parallel for parallelising the computing.
ggplot for static visualisation
python for modelling and prediction
d3 for dynamic interactive visualisation

This is similar to the desktop computing but scales quite well due to the
inherent parallelisability.


## Conclusions
--------------------------------------------------------------------------------

We see what big data is and the challanges in dealing with big data as opposed
to the traditional data. We then define the parameters with which we evaluate
our data set. We evaluate our data set to see that it fits the big data
definition partially. We rationalise that we need to define it as "medium data"
and pick particular aspects of big data tools to get our job done with least
complexity. We design our philosophy for a data toolkit along the lines of go
