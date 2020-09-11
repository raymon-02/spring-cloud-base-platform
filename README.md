# Spring-cloud-example


### Overview

**Spring-cloud-example** is a usage example of Spring Cloud framework

### Architecture
Micro-services: 
* **eureka-service** &#8722; service discovery
* **config-service** &#8722; service to store service configs
* **zuul-service** &#8722; entry-point service with LB
* **calculate-service** &#8722; service to simulate long-running tasks
* **info-service** &#8722; service to proxy information from other services
      
 
### API
#### info-service

* **Hello controller**
    ```
    #Request
    GET /hello
    
    #Response
    HTTP/1.1 200
    Hello from info and github!
    ```  
  
* **Info controller**  
  to get info about instances of specified micro-service
    ```
    #Request
    GET /instances/{applicationName}
    # e.g. /instances/calculate-server
    
    #Response
    HTTP/1.1 200
    [
        {
            "host": "172.20.10.4",
            "instanceInfo": {
                "actionType": "ADDED",
                "app": "CALCULATE-SERVER",
                // other info
            }
            // other info 
        }
    ]
    ```  
    
    
* **Calculate controller**  
  to request calculate-service
    ```
    #Request
    GET /calculate/{id}?timeout=<timeout>&error=<error>
    # where
    # {id}      identificator (task always fails if not equal 0)
    # <timeout> timeout in seconds before run of task (default 0)
    # <error>   error rate of task success (value should be between 0 and 100)
    # e.g. /calculate/0?timeout=2&error=50
    #    means wait 2 seconds before run task, task will complete successful with 50% probability
    
    #Response
    HTTP/1.1 200
    Ok!
    ```  


### Build, start, stop
###### Requirements
* java >= 1.8 (make sure java is added to _$PATH_ environment)
* docker + docker-compose (optional: for convenient start only)

###### Build and start
To build and start services run the following command from the project root:
```bash
# build and start all services
./runAll.sh 

# build and start specified services
./run.sh service_name [other service_names]
 
# e.g.
./run.sh eureka-service config-service
```

to build in start with docker-compose use command:
```bash
# build and start all services in Docker
./runDockerAll.sh 

# build and start specified services in Docker
./runDocker.sh service_name [other service_names]
 
# e.g.
./runDocker.sh eureka-service config-service
```

###### Stop
To stop start services run the following command from the project root:
```bash
# stop all services
./stopAll.sh 

# stop specified services
./stop.sh service_name [other service_names]
 
# e.g.
./stop.sh eureka-service config-service
```

to stop services running in docker use command:
```bash
# stop all services in Docker
./stopDockerAll.sh 

# stop specified services in Docker
./stopDocker.sh service_name [other service_names]
 
# e.g.
./stopDocker.sh eureka-service config-service
```


### Hystrix and dashboard

**info-service** and **calculate-service** support Hystrix circuit breaker
for requests and calculation task respectively
Hystrix dashboard is enabled in **info-service** via `/hystrix` endpoint    
At dashboard url of service with circuit breaker should be specified
```bash
# e.g.
http://localhost:8770/hystrix.stream
```

###### Load
Many requests can be emulated with [_ab_](https://httpd.apache.org/docs/2.4/programs/ab.html) utility:
```bash
ab -n 500 -c 4 'localhost:8763/api/info-service/calculate/0?error=20'
```