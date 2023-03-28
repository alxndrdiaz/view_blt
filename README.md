# view_blt

Run `blobtools view` script from a Docker container image. This script will be integrated as a Nextlow module in the [sanger-tol/blobtoolkit Nextflow pipeline](https://github.com/sanger-tol/blobtoolkit). Design and implementation of the original [BlobToolKit pipeline](https://github.com/blobtoolkit/pipeline): Richard Challis and Sujai Kumar.

Dependencies: 

1. Nextflow version 22.10.7 build 5853.
2. Docker version 23.0.1, build a5ee5b1. 

This repository only to show documents how to run the [blobtools view](https://github.com/blobtoolkit/blobtoolkit/blob/main/src/blobtools/lib/view.py) script using 
a Docker container image. `BDQP01` folder contains a test dataset and it is also available in [BlobToolKit Viewer repository](https://github.com/blobtoolkit/viewer). 

Problem definition: The script works if run from the Docker image within a Bash script but doesn't work in Nextflow using the same Docker image.

## 1. Run using Docker from a Bash script

Run the script using any of these commands: 

```
bash docker_view.sh
```

```
./docker_view.sh
```

The output should look something like this (it should run in about 1 minute or less depending on the CPU): 

```
Initializing viewer
Loading http://localhost:8001/view/BDQP01/dataset/BDQP01/blob?staticThreshold=Infinity&nohitThreshold=Infinity&plotGraphics=svg&plotShape=circle&largeFonts=true
Fetching BDQP01.blob.circle.png
 - waiting for element blob_save_png
 - waiting for file '/path/to/BDQP01/BDQP01.blob.circle.png'
 - found /path/to/BDQP01/BDQP01.blob.circle.png
```

And a file called `BDQP01.blob.circle.png` should be generated (see folder `plots`).


## 2. Run with Nextflow + Docker

We used the following [Docker configuration](https://www.nextflow.io/docs/latest/config.html#scope-docker) (runOptions can be omitted and the result is the same):

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

After ~15 minutes you will see the following error in `.command.err` (use `find -L work/ -type f -name ".command.err"` to find it) 


```
Traceback (most recent call last):
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/blobtools/lib/view.py", line 300, in static_view
    driver, display = firefox_driver(args)
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/blobtools/lib/view.py", line 210, in firefox_driver
    display.start()
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/pyvirtualdisplay/display.py", line 72, in start
    self._obj.start()
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/pyvirtualdisplay/abstractdisplay.py", line 149, in start
    self._start1_has_displayfd()
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/pyvirtualdisplay/abstractdisplay.py", line 197, in _start1_has_displayfd
    self.display = int(self._wait_for_pipe_text(rfd))
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/pyvirtualdisplay/abstractdisplay.py", line 309, in _wait_for_pipe_text
    raise XStartTimeoutError(
pyvirtualdisplay.abstractdisplay.XStartTimeoutError: No reply from program Xvfb. command:['Xvfb', '-br', '-nolisten', 'tcp', '-screen', '0', '800x600x24', '-displayfd', '7']

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/conda/envs/btk_env/bin/blobtools", line 8, in <module>
    sys.exit(cli())
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/blobtools/blobtools.py", line 105, in cli
    sys.exit(subcommand())
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/blobtools/lib/view.py", line 495, in cli
    main(args)
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/blobtools/lib/view.py", line 480, in main
    static_view(args, loc, viewer)
  File "/opt/conda/envs/btk_env/lib/python3.9/site-packages/blobtools/lib/view.py", line 302, in static_view
    format_exc(err)
  File "/opt/conda/envs/btk_env/lib/python3.9/traceback.py", line 167, in format_exc
    return "".join(format_exception(*sys.exc_info(), limit=limit, chain=chain))
  File "/opt/conda/envs/btk_env/lib/python3.9/traceback.py", line 120, in format_exception
    return list(TracebackException(
  File "/opt/conda/envs/btk_env/lib/python3.9/traceback.py", line 517, in __init__
    self.stack = StackSummary.extract(
  File "/opt/conda/envs/btk_env/lib/python3.9/traceback.py", line 340, in extract
    if limit >= 0:
TypeError: '>=' not supported between instances of 'XStartTimeoutError' and 'int'
mv: cannot stat 'BDQP01/*.png': No such file or directory
```
