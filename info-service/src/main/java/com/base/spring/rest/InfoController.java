package com.base.spring.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class InfoController {

    @Autowired
    DiscoveryClient discoveryClient;

    @GetMapping("/instances/{applicationName}")
    public List<ServiceInstance> getInstances(@PathVariable String applicationName) {
        return discoveryClient.getInstances(applicationName);
    }

}
