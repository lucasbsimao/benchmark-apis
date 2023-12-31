# BENCHMARK API

This project aims to ease the job to test and benchmark simple APIs or POC implementations before following with its development.  

## Prerequisites

Before you begin, ensure you have met the following requirements:
- Docker compose V2
- Python 3

## Running

You can run this project simply with the following command:
```
bash run_benchmark.sh
```

You can choose the requirements for your API in benchmark.yml, in which initally are defined two phases: warm up and spyke. You can change ```arrivalRate``` numbers to see how your API performs with different RPS. Besides, you can modify ```n``` to see how it performs with different CPU usage requirements. 

## Creating your own benchmark

You can create a benchmark with a custom language or framework. You just have to create a directory inside the project folder with a docker-compose definition and the endpoint ```/benchmark?n=123``` defined in your API. You can follow any of the folders here as examples. Once you set everything up, you can just run:

```
bash run_benchmark.sh
```

In case of any errors, you can find the logs for your API inside ```benchmark_logs``` folder. And results are found inside ```benchmark_graphs``` folder. 
