package com.base.spring.client;

import com.base.spring.client.fallback.CalculateClientFallback;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@FeignClient(
        name = "calculate-server",
        fallback = CalculateClientFallback.class
)
public interface CalculateClient {

    @RequestMapping(value = "/calculate/{id}")
    String calculate(@PathVariable("id") int id);
}
