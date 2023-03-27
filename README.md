# view_blt

Run blobtools view from a Docker container image. 

Dependencies: 

1. Nextflow version 22.10.7 build 5853.
2. Docker version 23.0.1, build a5ee5b1. 

This repository is only to show document how to run the [blobtools view](https://github.com/blobtoolkit/blobtoolkit/blob/main/src/blobtools/lib/view.py) script using 
a Docker container image. `BDQP01` folder contains a test dataset and it is also available in [BlobToolKit Viewer repository](https://github.com/blobtoolkit/viewer). 

Problem: The scripts works if run from the Docker image within a Bash script but doesn't work in Nextflow.

## 1. Run using only Docker from a Bash script

Run the script using any of these commands: 

```
bash docker_view.sh
```

```
./docker_view.sh
```

The output should look something like this: 

```
Initializing viewer
Loading http://localhost:8001/view/BDQP01/dataset/BDQP01/blob?staticThreshold=Infinity&nohitThreshold=Infinity&plotGraphics=svg&plotShape=circle&largeFonts=true
Fetching BDQP01.blob.circle.png
 - waiting for element blob_save_png
 - waiting for file '/path/to/BDQP01/BDQP01.blob.circle.png'
 - found /path/to/BDQP01/BDQP01.blob.circle.png
```

And a file called `BDQP01.blob.circle.png` should be generated (see folder `plots`).


## 2. Run using only Nextflow

We used the followed [Docker configuration](https://www.nextflow.io/docs/latest/config.html#scope-docker):

```
docker {
    enabled = true
    temp = 'auto'
    runOptions = '-v $(pwd):$(pwd) -w $(pwd)'
}
```

And then run:

```
nextflow run view.nf
```




