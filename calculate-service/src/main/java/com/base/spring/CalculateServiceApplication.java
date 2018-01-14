package com.base.spring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.hystrix.EnableHystrix;

@EnableEurekaClient
@EnableCircuitBreaker
@SpringBootApplication
public class CalculateServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(CalculateServiceApplication.class, args);
    }
}
