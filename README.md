## Usage

to build the docker image use:

```bash
docker build -t jackxxu/scipy-notebook .
```

to run 

```bash
docker run -v $(pwd):/home/jovyan/work -p 8888:8888 jackxxu/scipy-notebook
```
